import React, { useEffect, useState } from 'react';
import { Edit2, Trash2, Paperclip, ExternalLink, Download, X } from 'lucide-react';
import { LogEntry, ShiftType, SearchFilters, ActiveShift } from '../types';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';

interface LogTableProps {
  showAllLogs: boolean;
  searchFilters: SearchFilters;
  activeShift: ActiveShift | null;
}

interface ShiftInfo {
  started_at: string;
  ended_at: string | null;
  shift_type: ShiftType;
}

interface GroupedLogs {
  [key: string]: {
    shift_type: ShiftType;
    started_at: string;
    ended_at: string | null;
    logs: LogEntry[];
  };
}

interface ShiftGroup {
  shiftType: ShiftType;
  startTime: string;
  endTime: string | null;
  logs: LogEntry[];
}

const LogTable: React.FC<LogTableProps> = ({ showAllLogs, searchFilters, activeShift }) => {
  const [rawLogs, setRawLogs] = useState<ShiftGroup[]>([]);
  const [logs, setLogs] = useState<ShiftGroup[]>([]);
  const [loading, setLoading] = useState(true);
  const [editingLog, setEditingLog] = useState<LogEntry | null>(null);
  const [criticalEvents, setCriticalEvents] = useState<LogEntry[]>([]);

  useEffect(() => {
    fetchLogs();
    fetchCriticalEvents();

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
          if (payload.eventType === 'INSERT' || payload.eventType === 'UPDATE' || payload.eventType === 'DELETE') {
            await fetchLogs();
            await fetchCriticalEvents();
          }
        }
      )
      .subscribe();

    const shiftSubscription = shiftChannel
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'active_shifts'
        },
        async () => {
          await fetchLogs();
          await fetchCriticalEvents();
        }
      )
      .subscribe();

    return () => {
      logChannel.unsubscribe();
      shiftChannel.unsubscribe();
    };
  }, [showAllLogs, searchFilters, activeShift]);

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

      // Apply filters based on showAllLogs
      if (!showAllLogs && activeShift) {
        // If showing current shift only, filter by active shift
        query = query
          .eq('shift_type', activeShift.shift_type)
          .gte('created_at', activeShift.started_at);
      }

      // Handle date filters
      if (searchFilters.startDate) {
        const startDate = new Date(searchFilters.startDate);
        if (!isNaN(startDate.getTime())) {
          query = query.gte('created_at', startDate.toISOString());
        }
      }

      if (searchFilters.endDate) {
        const endDate = new Date(searchFilters.endDate);
        if (!isNaN(endDate.getTime())) {
          query = query.lte('created_at', endDate.toISOString());
        }
      }

      // Handle shift type filter
      if (searchFilters.shiftType !== undefined) {
        query = query.eq('shift_type', searchFilters.shiftType);
      }

      // Execute the query
      const { data, error } = await query;

      if (error) {
        console.error('Supabase query error:', error);
        throw error;
      }

      if (!data) {
        setRawLogs([]);
        setLogs([]);
        return;
      }

      // Process the results
      const groupedLogs: ShiftGroup[] = [];
      let currentGroup: ShiftGroup | null = null;

      // Sort data chronologically
      const sortedData = [...data].sort((a, b) => 
        new Date(a.created_at).getTime() - new Date(b.created_at).getTime()
      );

      // Group logs by shift
      for (const log of sortedData) {
        // Skip if category filter is active and doesn't match
        if (searchFilters.category && 
            log.category !== searchFilters.category && 
            log.category !== 'shift') {
          continue;
        }

        if (log.category === 'shift') {
          if (log.description.includes('shift started')) {
            // Close previous group if exists
            if (currentGroup && !currentGroup.endTime) {
              currentGroup.endTime = log.created_at;
            }
            // Start new group
            currentGroup = {
              shiftType: log.shift_type,
              startTime: log.created_at,
              endTime: null,
              logs: [log]
            };
            groupedLogs.push(currentGroup);
          } else if (log.description.includes('shift ended') && currentGroup) {
            if (currentGroup.shiftType === log.shift_type) {
              currentGroup.endTime = log.created_at;
              currentGroup.logs.push(log);
              currentGroup = null;
            }
          }
        } else if (currentGroup) {
          currentGroup.logs.push(log);
        }
      }

      // Only reverse once here
      const reversedGroups = groupedLogs.reverse();
      setRawLogs(reversedGroups);
      setLogs(reversedGroups);
    } catch (error) {
      console.error('Error in fetchLogs:', error);
      toast.error('Failed to fetch logs. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  // Client-side filtering for the search bar keyword and category
  useEffect(() => {
    let filteredGroups = rawLogs;

    // Filter by keyword
    if (searchFilters.keyword && searchFilters.keyword.trim() !== '') {
      const keyword = searchFilters.keyword.trim().toLowerCase();
      filteredGroups = filteredGroups.map(group => ({
        ...group,
        logs: group.logs.filter(log =>
          log.category !== 'shift' &&
          (
            (log.description && log.description.toLowerCase().includes(keyword)) ||
            (log.category && log.category.toLowerCase().includes(keyword))
          )
        )
      })).filter(group => group.logs.length > 0);
    }

    // Filter by category
    if (searchFilters.category) {
      filteredGroups = filteredGroups.map(group => ({
        ...group,
        logs: group.logs.filter(log =>
          log.category === searchFilters.category
        )
      })).filter(group => group.logs.length > 0);
    }

    setLogs(filteredGroups);
  }, [searchFilters.keyword, searchFilters.category, rawLogs]);

  const fetchCriticalEvents = async () => {
    try {
      const { data, error } = await supabase
        .from('log_entries')
        .select('*')
        .in('category', ['error', 'downtime'])
        .order('created_at', { ascending: false })
        .limit(2);

      if (error) throw error;
      setCriticalEvents(data || []);
    } catch (error) {
      console.error('Error fetching critical events:', error);
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
      const { data, error } = await supabase.storage
        .from('attachments')
        .createSignedUrl(filePath, 3600);

      if (error) throw error;
      if (!data?.signedUrl) throw new Error('Failed to generate signed URL');

      // Open in new tab
      window.open(data.signedUrl, '_blank');
    } catch (error) {
      console.error('Error viewing file:', error);
      toast.error('Failed to view file');
    }
  };

  const exportAllLogsToText = () => {
    let textContent = 'Logbook Export\n';
    textContent += 'Generated on: ' + new Date().toLocaleString() + '\n\n';

    logs.forEach((shiftGroup, index) => {
      textContent += `=== ${shiftGroup.shiftType.toUpperCase()} SHIFT ===\n`;
      textContent += `Start: ${new Date(shiftGroup.startTime).toLocaleString()}\n`;
      textContent += `End: ${shiftGroup.endTime ? new Date(shiftGroup.endTime).toLocaleString() : 'Ongoing'}\n\n`;

      shiftGroup.logs.forEach((log) => {
        textContent += `[${new Date(log.created_at).toLocaleString()}] ${log.category.toUpperCase()}\n`;
        textContent += `Description: ${log.description}\n`;
        
        // Add additional details if they exist
        if (log.case_number || log.workorder_number || log.mc_setpoint) {
          textContent += 'Details:\n';
          if (log.case_number) textContent += `- Case: ${log.case_number} (${log.case_status || 'N/A'})\n`;
          if (log.workorder_number) textContent += `- Work Order: ${log.workorder_number} (${log.workorder_status || 'N/A'})\n`;
          if (log.mc_setpoint) {
            textContent += '- Machine Parameters:\n';
            textContent += `  * MC Setpoint: ${log.mc_setpoint}\n`;
            textContent += `  * Yoke Temp: ${log.yoke_temperature}°C\n`;
            textContent += `  * Arc Current: ${log.arc_current}A\n`;
            textContent += `  * Filament: ${log.filament_current}A\n`;
            textContent += `  * PIE Width: ${log.pie_width}\n`;
            textContent += `  * P2E Width: ${log.p2e_width}\n`;
          }
        }

        // Add attachments if they exist
        if (log.attachments && log.attachments.length > 0) {
          textContent += 'Attachments:\n';
          log.attachments.forEach(attachment => {
            textContent += `- ${attachment.file_name} (${formatFileSize(attachment.file_size)})\n`;
          });
        }

        textContent += '\n';
      });

      textContent += '='.repeat(50) + '\n\n';
    });

    // Create and trigger download
    const blob = new Blob([textContent], { type: 'text/plain;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', `logbook_export_${new Date().toISOString().split('T')[0]}.txt`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-400"></div>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="flex justify-end mb-4">
        <button 
          className="px-4 py-2 bg-gray-700 hover:bg-gray-600 text-white rounded-lg text-sm font-medium transition-colors shadow-md"
          onClick={exportAllLogsToText}
        >
          Export All Logs
        </button>
      </div>
      <div className="space-y-8">
        {logs.map((shiftGroup, index) => (
          <div 
            key={shiftGroup.startTime} 
            className="bg-gray-800/50 backdrop-blur-sm rounded-xl border border-gray-700/50 overflow-hidden shadow-lg transform transition-all hover:shadow-xl"
          >
            <div className="bg-gray-900/50 p-4 border-b border-gray-700/50">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-lg font-semibold text-white flex items-center">
                    <span className={`w-2 h-2 rounded-full mr-2 ${
                      shiftGroup.shiftType === 'morning' ? 'bg-blue-500' :
                      shiftGroup.shiftType === 'afternoon' ? 'bg-yellow-500' :
                      'bg-purple-500'
                    }`}></span>
                    {shiftGroup.shiftType.charAt(0).toUpperCase() + shiftGroup.shiftType.slice(1)} Shift
                  </h3>
                  <p className="text-sm text-gray-400 mt-1">
                    {new Date(shiftGroup.startTime).toLocaleString()} - 
                    {shiftGroup.endTime ? new Date(shiftGroup.endTime).toLocaleString() : 'Ongoing'}
                  </p>
                </div>
              </div>
            </div>
            
            <div className="p-4 space-y-4">
              {shiftGroup.logs.map((log) => (
                <div
                  key={log.id}
                  className={`p-4 rounded-lg border transition-all hover:transform hover:scale-[1.01] shadow-md ${
                    log.category === 'error' ? 'bg-red-900/20 border-red-700/50' :
                    log.category === 'downtime' ? 'bg-yellow-900/20 border-yellow-700/50' :
                    log.category === 'workorder' ? 'bg-blue-900/20 border-blue-700/50' :
                    log.category === 'data-collection' ? 'bg-purple-900/20 border-purple-700/50' :
                    log.category === 'shift' ? 'bg-green-900/20 border-green-700/50' :
                    'bg-white/5 border-white/10'
                  }`}
                >
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center space-x-3 mb-2">
                        <span className={`px-2 py-1 text-xs font-semibold rounded-full ${
                  log.category === 'error' ? 'bg-red-900 text-red-200' :
                  log.category === 'downtime' ? 'bg-yellow-900 text-yellow-200' :
                  log.category === 'workorder' ? 'bg-blue-900 text-blue-200' :
                  log.category === 'data-collection' ? 'bg-purple-900 text-purple-200' :
                        log.category === 'shift' ? 'bg-green-900 text-green-200' :
                        'bg-gray-700 text-gray-200'
                }`}>
                  {log.category}
                </span>
                        <span className="text-sm text-gray-400">
                          {formatDateTime(log.created_at)}
                        </span>
                      </div>
                      
                {editingLog?.id === log.id ? (
                  <div className="flex items-center space-x-2">
                    <input
                      type="text"
                      defaultValue={log.description}
                            className="flex-1 rounded-lg bg-white/5 border-0 text-white px-4 py-2 focus:ring-2 focus:ring-indigo-500"
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
                            className="text-gray-400 hover:text-white transition-colors"
                    >
                            <X className="h-4 w-4" />
                    </button>
                  </div>
                ) : (
                        <p className="text-white">{log.description}</p>
                      )}

                      {/* Attachments */}
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
                                  className="text-blue-400 hover:text-blue-300 transition-colors"
                                title="View"
                              >
                                <ExternalLink className="h-4 w-4" />
                              </button>
                              <button
                                onClick={() => handleDownload(attachment.file_path, attachment.file_name)}
                                  className="text-green-400 hover:text-green-300 transition-colors"
                                title="Download"
                              >
                                <Download className="h-4 w-4" />
                              </button>
                            </div>
                          </div>
                        ))}
                      </div>
                    )}

                      {/* Additional Details */}
                      {(log.case_number || log.workorder_number || log.mc_setpoint) && (
                        <div className="mt-3 grid grid-cols-2 md:grid-cols-3 gap-2 text-sm">
                          {log.case_number && (
                            <div className="bg-white/5 rounded-lg p-2">
                              <span className="text-gray-400">Case:</span>
                              <div className="text-white">{log.case_number}</div>
                              <div className="text-gray-400">{log.case_status}</div>
                  </div>
                )}
                {log.workorder_number && (
                            <div className="bg-white/5 rounded-lg p-2">
                              <span className="text-gray-400">Work Order:</span>
                              <div className="text-white">{log.workorder_number}</div>
                              <div className="text-gray-400">{log.workorder_status}</div>
                            </div>
                )}
                {log.mc_setpoint && (
                            <>
                              <div className="bg-white/5 rounded-lg p-2">
                                <span className="text-gray-400">MC Setpoint:</span>
                                <div className="text-white">{log.mc_setpoint}</div>
                              </div>
                              <div className="bg-white/5 rounded-lg p-2">
                                <span className="text-gray-400">Yoke Temp:</span>
                                <div className="text-white">{log.yoke_temperature}°C</div>
                              </div>
                              <div className="bg-white/5 rounded-lg p-2">
                                <span className="text-gray-400">Arc Current:</span>
                                <div className="text-white">{log.arc_current}A</div>
                              </div>
                              <div className="bg-white/5 rounded-lg p-2">
                                <span className="text-gray-400">Filament:</span>
                                <div className="text-white">{log.filament_current}A</div>
                              </div>
                              <div className="bg-white/5 rounded-lg p-2">
                                <span className="text-gray-400">PIE Width:</span>
                                <div className="text-white">{log.pie_width}</div>
                              </div>
                              <div className="bg-white/5 rounded-lg p-2">
                                <span className="text-gray-400">P2E Width:</span>
                                <div className="text-white">{log.p2e_width}</div>
                              </div>
                            </>
                          )}
                  </div>
                )}
                    </div>

                    <div className="flex items-center space-x-2">
                <button 
                        className="p-2 bg-gray-700 hover:bg-gray-600 text-white rounded-lg transition-colors"
                  onClick={() => handleEdit(log)}
                        title="Edit"
                >
                  <Edit2 className="h-4 w-4" />
                </button>
                <button 
                        className="p-2 bg-red-600 hover:bg-red-500 text-white rounded-lg transition-colors"
                  onClick={() => handleDelete(log)}
                        title="Delete"
                >
                  <Trash2 className="h-4 w-4" />
                </button>
                    </div>
                  </div>
                </div>
          ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default LogTable;