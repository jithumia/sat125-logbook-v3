import React, { useEffect, useState } from 'react';
import { Edit2, Trash2, Paperclip, ExternalLink, Download } from 'lucide-react';
import { LogEntry, ShiftType, SearchFilters } from '../types';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';

interface LogTableProps {
  shift?: ShiftType;
  searchFilters: SearchFilters;
  onShiftChange?: () => void;
}

const LogTable: React.FC<LogTableProps> = ({ shift, searchFilters, onShiftChange }) => {
  const [logs, setLogs] = useState<LogEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [editingLog, setEditingLog] = useState<LogEntry | null>(null);

  useEffect(() => {
    fetchLogs();

    // Subscribe to real-time changes
    const logChannel = supabase.channel('log_entries_changes');
    const shiftChannel = supabase.channel('active_shifts_changes');
    
    const logSubscription = logChannel
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'log_entries'
        },
        async (payload) => {
          // For any change, fetch the complete log entry with attachments
          if (payload.eventType === 'INSERT' || payload.eventType === 'UPDATE') {
            const { data: updatedLog, error } = await supabase
              .from('log_entries')
              .select(`
                *,
                attachments (
                  id,
                  file_name,
                  file_type,
                  file_size,
                  file_path,
                  created_at
                )
              `)
              .eq('id', payload.new.id)
              .single();

            if (error) {
              console.error('Error fetching updated log:', error);
              return;
            }

            if (payload.eventType === 'INSERT') {
              if (matchesFilters(updatedLog)) {
                setLogs(currentLogs => [updatedLog, ...currentLogs]);
              }
            } else if (payload.eventType === 'UPDATE') {
              setLogs(currentLogs => 
                currentLogs.map(log => 
                  log.id === updatedLog.id ? updatedLog : log
                )
              );
            }
          } else if (payload.eventType === 'DELETE') {
            setLogs(currentLogs => 
              currentLogs.filter(log => log.id !== payload.old.id)
            );
          }
        }
      )
      .subscribe();

    // Subscribe to active_shifts changes
    const shiftSubscription = shiftChannel
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'active_shifts'
        },
        () => {
          // Notify parent component to refresh shift status
          if (onShiftChange) {
            onShiftChange();
          }
        }
      )
      .subscribe();

    return () => {
      logChannel.unsubscribe();
      shiftChannel.unsubscribe();
    };
  }, [shift, searchFilters, onShiftChange]);

  const matchesFilters = (log: LogEntry): boolean => {
    if (shift && log.shift_type !== shift) return false;
    
    if (searchFilters.keyword && !log.description.toLowerCase().includes(searchFilters.keyword.toLowerCase())) {
      return false;
    }

    const logDate = new Date(log.created_at).getTime();
    
    if (searchFilters.startDate) {
      const startDate = new Date(searchFilters.startDate).getTime();
      if (logDate < startDate) return false;
    }
    
    if (searchFilters.endDate) {
      const endDate = new Date(searchFilters.endDate).getTime();
      if (logDate > endDate) return false;
    }

    return true;
  };

  const fetchLogs = async () => {
    try {
      setLoading(true);
      let query = supabase
        .from('log_entries')
        .select(`
          *,
          attachments (
            id,
            file_name,
            file_type,
            file_size,
            file_path,
            created_at
          )
        `)
        .order('created_at', { ascending: false });

      if (shift) {
        query = query.eq('shift_type', shift);
      }

      if (searchFilters.keyword) {
        query = query.ilike('description', `%${searchFilters.keyword}%`);
      }

      if (searchFilters.startDate) {
        const startDate = new Date(searchFilters.startDate);
        startDate.setSeconds(0, 0); // Reset seconds and milliseconds
        query = query.gte('created_at', startDate.toISOString());
      }

      if (searchFilters.endDate) {
        const endDate = new Date(searchFilters.endDate);
        endDate.setSeconds(59, 999); // Set to end of the minute
        query = query.lte('created_at', endDate.toISOString());
      }

      const { data, error } = await query;

      if (error) {
        throw error;
      }

      // Double-check the date filters on the client side
      const filteredData = data?.filter(log => matchesFilters(log)) || [];
      setLogs(filteredData);
    } catch (error) {
      console.error('Error fetching logs:', error);
      toast.error('Failed to fetch logs');
    } finally {
      setLoading(false);
    }
  };

  const formatDateTime = (dateString: string): string => {
    const options: Intl.DateTimeFormatOptions = {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hour12: true
    };
    return new Date(dateString).toLocaleString(undefined, options);
  };

  const formatFileSize = (bytes: number): string => {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return `${parseFloat((bytes / Math.pow(k, i)).toFixed(1))} ${sizes[i]}`;
  };

  const handleEdit = async (log: LogEntry) => {
    setEditingLog(log);
  };

  const handleSaveEdit = async (log: LogEntry, newDescription: string) => {
    try {
      const { error } = await supabase
        .from('log_entries')
        .update({ description: newDescription.trim() })
        .eq('id', log.id);

      if (error) {
        throw error;
      }

      toast.success('Log entry updated');
      setEditingLog(null);
    } catch (error) {
      console.error('Error updating log:', error);
      toast.error('Failed to update log entry');
    }
  };

  const handleDelete = async (log: LogEntry) => {
    try {
      if (log.category === 'shift') {
        // Handle shift start log deletion
        if (log.description.includes('shift started')) {
          // Get the active shift ID if it exists
          const { data: activeShift, error: shiftError } = await supabase
            .from('active_shifts')
            .select('id')
            .eq('shift_type', log.shift_type)
            .maybeSingle();

          if (shiftError) throw shiftError;

          // If there's an active shift, clean it up
          if (activeShift) {
            const { error: cleanupError } = await supabase.rpc('cleanup_shifts', {
              shift_ids: [activeShift.id]
            });

            if (cleanupError) throw cleanupError;
          }
        }
        // Handle shift end log deletion
        else if (log.description.includes('shift ended')) {
          // Find the corresponding start log
          const { data: startLog, error: startLogError } = await supabase
            .from('log_entries')
            .select('*')
            .eq('category', 'shift')
            .eq('shift_type', log.shift_type)
            .lt('created_at', log.created_at)
            .ilike('description', '%shift started%')
            .order('created_at', { ascending: false })
            .limit(1)
            .single();

          if (startLogError) throw startLogError;

          if (startLog) {
            // Extract shift details from the start log description
            const shiftDetails = startLog.description.match(/shift started by (.*?) \(SF#: (.*?)\)/);
            if (!shiftDetails) {
              throw new Error('Invalid shift start record format');
            }

            const [, engineerNames, salesforceNumber] = shiftDetails;
            const engineers = engineerNames.split(', ');

            // Get engineer IDs
            const { data: engineerData, error: engineerError } = await supabase
              .from('engineers')
              .select('id, name')
              .in('name', engineers);

            if (engineerError) throw engineerError;

            // Create new active shift
            const { data: newShift, error: shiftError } = await supabase
              .from('active_shifts')
              .insert({
                shift_type: log.shift_type,
                started_at: startLog.created_at,
                started_by: startLog.user_id,
                salesforce_number: salesforceNumber
              })
              .select()
              .single();

            if (shiftError) throw shiftError;

            // Add engineers to shift
            const { error: engineersError } = await supabase
              .from('shift_engineers')
              .insert(
                engineerData.map(eng => ({
                  shift_id: newShift.id,
                  engineer_id: eng.id
                }))
              );

            if (engineersError) throw engineersError;
          }
        }
      }

      // Delete the log entry
      const { error: deleteError } = await supabase
        .from('log_entries')
        .delete()
        .eq('id', log.id);

      if (deleteError) throw deleteError;

      toast.success('Log entry deleted');
      
      // Refresh logs and notify parent of shift change
      await fetchLogs();
      if (onShiftChange) {
        onShiftChange();
      }
    } catch (error) {
      console.error('Error deleting log:', error);
      toast.error('Failed to delete log entry');
    }
  };

  const handleDownload = async (filePath: string, fileName: string) => {
    try {
      const { data, error } = await supabase.storage
        .from('attachments')
        .download(filePath);

      if (error) throw error;

      // Create a download link
      const url = window.URL.createObjectURL(data);
      const link = document.createElement('a');
      link.href = url;
      link.download = fileName;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);
    } catch (error) {
      console.error('Error downloading file:', error);
      toast.error('Failed to download file');
    }
  };

  const handleView = async (filePath: string) => {
    try {
      // Get a signed URL that expires in 1 hour
      const { data: { signedUrl }, error } = await supabase.storage
        .from('attachments')
        .createSignedUrl(filePath, 3600);

      if (error) throw error;
      if (!signedUrl) throw new Error('Failed to generate signed URL');

      // Open in new tab
      window.open(signedUrl, '_blank');
    } catch (error) {
      console.error('Error viewing file:', error);
      toast.error('Failed to view file');
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-400"></div>
      </div>
    );
  }

  return (
    <div className="bg-gray-800 shadow-xl rounded-lg overflow-hidden border border-gray-700">
      <table className="min-w-full divide-y divide-gray-700">
        <thead className="bg-gray-900">
          <tr>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">
              Date & Time
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">
              Category
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">
              Description
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">
              Details
            </th>
            <th className="px-6 py-3 text-right text-xs font-medium text-gray-300 uppercase tracking-wider">
              Actions
            </th>
          </tr>
        </thead>
        <tbody className="bg-gray-800 divide-y divide-gray-700">
          {logs.map((log) => (
            <tr key={log.id} className="hover:bg-gray-700">
              <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                {formatDateTime(log.created_at)}
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                  log.category === 'error' ? 'bg-red-900 text-red-200' :
                  log.category === 'downtime' ? 'bg-yellow-900 text-yellow-200' :
                  log.category === 'workorder' ? 'bg-blue-900 text-blue-200' :
                  log.category === 'data-collection' ? 'bg-purple-900 text-purple-200' :
                  'bg-green-900 text-green-200'
                }`}>
                  {log.category}
                </span>
              </td>
              <td className="px-6 py-4 text-sm text-gray-200">
                {editingLog?.id === log.id ? (
                  <div className="flex items-center space-x-2">
                    <input
                      type="text"
                      defaultValue={log.description}
                      className="flex-1 rounded-md bg-gray-700 border-gray-600 text-white"
                      onKeyDown={(e) => {
                        if (e.key === 'Enter') {
                          handleSaveEdit(log, e.currentTarget.value);
                        } else if (e.key === 'Escape') {
                          setEditingLog(null);
                        }
                      }}
                      autoFocus
                    />
                    <button
                      onClick={() => setEditingLog(null)}
                      className="text-gray-400 hover:text-white"
                    >
                      Cancel
                    </button>
                  </div>
                ) : (
                  <div>
                    <p>{log.description}</p>
                    {log.attachments && log.attachments.length > 0 && (
                      <div className="mt-2 space-y-1">
                        {log.attachments.map((attachment) => (
                          <div key={attachment.id} className="flex items-center space-x-2 text-sm">
                            <Paperclip className="h-4 w-4 text-gray-400" />
                            <span className="text-gray-400">{attachment.file_name}</span>
                            <span className="text-gray-500">({formatFileSize(attachment.file_size)})</span>
                            <div className="flex items-center space-x-2">
                              <button
                                onClick={() => handleView(attachment.file_path)}
                                className="text-blue-400 hover:text-blue-300"
                                title="View"
                              >
                                <ExternalLink className="h-4 w-4" />
                              </button>
                              <button
                                onClick={() => handleDownload(attachment.file_path, attachment.file_name)}
                                className="text-green-400 hover:text-green-300"
                                title="Download"
                              >
                                <Download className="h-4 w-4" />
                              </button>
                            </div>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                )}
              </td>
              <td className="px-6 py-4 text-sm text-gray-300">
                {log.case_number && (
                  <div>Case: {log.case_number} ({log.case_status})</div>
                )}
                {log.workorder_number && (
                  <div>WO: {log.workorder_number} ({log.workorder_status})</div>
                )}
                {log.mc_setpoint && (
                  <div className="space-y-1">
                    <div>MC: {log.mc_setpoint}</div>
                    <div>Yoke: {log.yoke_temperature}°C</div>
                    <div>Arc: {log.arc_current}A</div>
                    <div>Fil: {log.filament_current}A</div>
                    <div>PIE: {log.pie_width}</div>
                    <div>P2E: {log.p2e_width}</div>
                  </div>
                )}
              </td>
              <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <button 
                  className="text-blue-400 hover:text-blue-300 mr-3"
                  onClick={() => handleEdit(log)}
                >
                  <Edit2 className="h-4 w-4" />
                </button>
                <button 
                  className="text-red-400 hover:text-red-300"
                  onClick={() => handleDelete(log)}
                >
                  <Trash2 className="h-4 w-4" />
                </button>
              </td>
            </tr>
          ))}
          {logs.length === 0 && (
            <tr>
              <td colSpan={5} className="px-6 py-4 text-center text-gray-400">
                No logs found
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default LogTable;