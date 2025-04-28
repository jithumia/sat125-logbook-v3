import React, { useEffect, useState } from 'react';
import { Edit2, Trash2, Paperclip, ExternalLink, Download, X, Sun, Sunset, Moon, Clock, ChevronDown } from 'lucide-react';
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

type CategoryType = 'maintenance' | 'incident' | 'operation' | 'safety' | 'other';
type StatusType = 'open' | 'in_progress' | 'pending' | 'closed';

// Add new interfaces for status types
interface StatusOption {
  value: string;
  label: string;
  color: string;
}

const STATUS_OPTIONS: StatusOption[] = [
  { value: 'open', label: 'Open', color: 'bg-green-500' },
  { value: 'in_progress', label: 'In Progress', color: 'bg-yellow-500' },
  { value: 'pending', label: 'Pending', color: 'bg-orange-500' },
  { value: 'closed', label: 'Closed', color: 'bg-gray-500' }
];

const LogTable: React.FC<LogTableProps> = ({ showAllLogs, searchFilters, activeShift }) => {
  const [rawLogs, setRawLogs] = useState<ShiftGroup[]>([]);
  const [logs, setLogs] = useState<ShiftGroup[]>([]);
  const [loading, setLoading] = useState(true);
  const [editingLog, setEditingLog] = useState<LogEntry | null>(null);
  const [editedDescription, setEditedDescription] = useState('');
  const [criticalEvents, setCriticalEvents] = useState<LogEntry[]>([]);
  const [expandedLogId, setExpandedLogId] = useState<string | null>(null);
  const [activeStatusId, setActiveStatusId] = useState<string | null>(null);
  const [engineerMap, setEngineerMap] = useState<Record<string, string>>({});

  useEffect(() => {
    fetchLogs();
    fetchCriticalEvents();
    supabase.from('engineers').select('id, name').then(({ data }) => {
      if (data) {
        const map: Record<string, string> = {};
        data.forEach(e => { map[e.id] = e.name; });
        setEngineerMap(map);
      }
    });

    // Subscribe to real-time changes
    const channel = supabase.channel('log-updates');
    
    const subscription = channel
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'log_entries'
        },
        async () => {
          // Fetch both logs and critical events on any change
          await Promise.all([
            fetchLogs(),
            fetchCriticalEvents()
          ]);
        }
      )
      .subscribe();

    return () => {
      subscription.unsubscribe();
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
        startDate.setHours(0, 0, 0, 0);
        query = query.gte('created_at', startDate.toISOString());
      }

      if (searchFilters.endDate) {
        const endDate = new Date(searchFilters.endDate);
        endDate.setHours(23, 59, 59, 999);
        query = query.lte('created_at', endDate.toISOString());
      }

      // Handle shift type filter
      if (searchFilters.shiftType) {
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

      // Debug log to verify the data
      console.log('Fetched logs:', {
        count: data.length,
        filters: searchFilters,
        firstLog: data[0],
        lastLog: data[data.length - 1]
      });

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
        logs: group.logs.filter(log => {
          // Include shift entries and check for engineer name in shift entries
          if (log.category === 'shift') {
            const shiftDesc = log.description.toLowerCase();
            return shiftDesc.includes(keyword) || // Match shift description
                   (shiftDesc.includes('shift started by') && shiftDesc.includes(keyword)) || // Match engineer name in start entry
                   (shiftDesc.includes('shift ended by') && shiftDesc.includes(keyword)); // Match engineer name in end entry
          }

          // For Main Coil Tuning (data-mc), search all relevant fields
          if ((log.category as string) === 'data-mc') {
            return [
              log.description,
              log.mc_setpoint,
              log.yoke_temperature,
              log.arc_current,
              log.filament_current,
              log.pie_width,
              log.p2e_width,
              log.pie_x_width,
              log.p2e_y_width
            ].some(val => val !== undefined && val !== null && val.toString().toLowerCase().includes(keyword));
          }

          // For Source Change (data-sc), search all relevant fields
          if ((log.category as string) === 'data-sc') {
            // Engineer names
            const engineerNames = log.engineers && Array.isArray(log.engineers) && engineerMap
              ? log.engineers.map(id => engineerMap[id] || id).join(', ').toLowerCase()
              : '';
            return [
              log.description,
              log.removed_source_number,
              log.removed_filament_current,
              log.removed_arc_current,
              log.removed_filament_counter,
              log.inserted_source_number,
              log.inserted_filament_current,
              log.inserted_arc_current,
              log.inserted_filament_counter,
              log.workorder_number,
              log.case_number,
              engineerNames,
              // Filament hours (calculated)
              (typeof log.inserted_filament_counter === 'number' && typeof log.removed_filament_counter === 'number')
                ? (log.inserted_filament_counter - log.removed_filament_counter).toFixed(2)
                : ''
            ].some(val => val !== undefined && val !== null && val.toString().toLowerCase().includes(keyword));
          }

          // For other entries, check description and category
          return (log.description && log.description.toLowerCase().includes(keyword)) ||
                 (log.category && log.category.toLowerCase().includes(keyword));
        })
      })).filter(group => group.logs.length > 0);
    }

    // Filter by category
    if (searchFilters.category) {
      filteredGroups = filteredGroups.map(group => ({
        ...group,
        logs: group.logs.filter(log =>
          log.category === searchFilters.category || 
          (searchFilters.category === 'shift' && log.category === 'shift')
        )
      })).filter(group => group.logs.length > 0);
    }

    setLogs(filteredGroups);
  }, [searchFilters.keyword, searchFilters.category, rawLogs, engineerMap]);

  const fetchCriticalEvents = async () => {
    try {
      const { data, error } = await supabase
        .from('log_entries')
        .select('*')
        .in('category', ['error', 'downtime'])
        .order('created_at', { ascending: false })
        .limit(5);

      if (error) throw error;
      setCriticalEvents(data || []);
    } catch (error) {
      console.error('Error fetching critical events:', error);
    }
  };

  const formatDateTime = (dateString: string): string => {
    const date = new Date(dateString);
    const time = date.toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: true
    });
    return time;
  };

  const formatDateForGroup = (dateString: string): string => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  };

  const formatFileSize = (bytes: number): string => {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return `${parseFloat((bytes / Math.pow(k, i)).toFixed(1))} ${sizes[i]}`;
  };

  const getCategoryStyle = (category: string): string => {
    const styles: Record<CategoryType, string> = {
      'maintenance': 'bg-blue-500/20 text-blue-400 border-blue-500/30',
      'incident': 'bg-red-500/20 text-red-400 border-red-500/30',
      'operation': 'bg-green-500/20 text-green-400 border-green-500/30',
      'safety': 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30',
      'other': 'bg-purple-500/20 text-purple-400 border-purple-500/30'
    };
    return styles[category.toLowerCase() as CategoryType] || styles['other'];
  };

  const getStatusStyle = (status: string): string => {
    const styles: Record<StatusType, string> = {
      'open': 'bg-green-500/20 text-green-400',
      'in_progress': 'bg-yellow-500/20 text-yellow-400',
      'pending': 'bg-orange-500/20 text-orange-400',
      'closed': 'bg-gray-500/20 text-gray-400'
    };
    return styles[status.toLowerCase() as StatusType] || styles['open'];
  };

  const handleEdit = (log: LogEntry, e: React.MouseEvent) => {
    e.stopPropagation();
    setEditingLog(log);
    setEditedDescription(log.description);
  };

  const handleSaveEdit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingLog) return;

    try {
      const { error } = await supabase
        .from('log_entries')
        .update({ description: editedDescription.trim() })
        .eq('id', editingLog.id);

      if (error) throw error;

      // Optimistically update the UI
      setRawLogs(prevLogs =>
        prevLogs.map(group => ({
          ...group,
          logs: group.logs.map(log =>
            log.id === editingLog.id
              ? { ...log, description: editedDescription.trim() }
              : log
          )
        }))
      );

      setCriticalEvents(prevEvents =>
        prevEvents.map(event =>
          event.id === editingLog.id
            ? { ...event, description: editedDescription.trim() }
            : event
        )
      );

      toast.success('Log entry updated');
      setEditingLog(null);
      setEditedDescription('');
    } catch (error) {
      console.error('Error updating log:', error);
      toast.error('Failed to update log entry');
    }
  };

  const handleCancelEdit = (e: React.MouseEvent) => {
    e.stopPropagation();
    setEditingLog(null);
    setEditedDescription('');
  };

  const handleDelete = async (logId: string) => {
    try {
      // First, get all attachments for this log entry
      const { data: attachments, error: fetchError } = await supabase
        .from('attachments')
        .select('*')
        .eq('log_entry_id', logId);

      if (fetchError) {
        console.error('Error fetching attachments:', fetchError);
        toast.error('Failed to fetch attachments');
        return;
          }

      // Delete files from storage if there are any attachments
      if (attachments && attachments.length > 0) {
        // Delete files from storage
        const filePaths = attachments.map(attachment => attachment.file_path);
        const { error: storageError } = await supabase.storage
          .from('attachments')
          .remove(filePaths);

        if (storageError) {
          console.error('Error deleting files from storage:', storageError);
          toast.error('Failed to delete files from storage');
          return;
        }

        // Delete attachment records from database
        const { error: attachmentDeleteError } = await supabase
          .from('attachments')
          .delete()
          .eq('log_entry_id', logId);

        if (attachmentDeleteError) {
          console.error('Error deleting attachment records:', attachmentDeleteError);
          toast.error('Failed to delete attachment records');
          return;
        }
      }

      // Finally delete the log entry
      const { error: logDeleteError } = await supabase
        .from('log_entries')
        .delete()
        .eq('id', logId);

      if (logDeleteError) {
        console.error('Error deleting log:', logDeleteError);
        toast.error('Failed to delete log entry');
        return;
      }

      toast.success('Log entry and attachments deleted successfully');
      // Refresh the logs list
      fetchLogs();
    } catch (error) {
      console.error('Error in delete process:', error);
      toast.error('Failed to delete log entry and attachments');
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
      
      toast.success('File downloaded successfully');
    } catch (error) {
      console.error('Error downloading file:', error);
      toast.error('Failed to download file');
    }
  };

  const handleView = async (filePath: string) => {
    try {
      const { data, error } = await supabase.storage
        .from('attachments')
        .createSignedUrl(filePath, 3600);

      if (error) throw error;
      if (!data?.signedUrl) throw new Error('Failed to generate signed URL');

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
        if (log.case_number && (log.category as string) !== 'data-sc' && log.case_number) {
          textContent += 'Details:\n';
          textContent += `- Case: ${log.case_number} (${log.case_status || 'N/A'})\n`;
        }
        if (log.workorder_number && (log.category as string) !== 'data-sc' && log.workorder_number) {
          textContent += `- Work Order: ${log.workorder_number} (${log.workorder_status || 'N/A'})\n`;
        }
        if (log.mc_setpoint && (log.category as string) === 'data-mc') {
          textContent += '- Machine Parameters:\n';
          textContent += `  * MC Setpoint: ${log.mc_setpoint}\n`;
          textContent += `  * Yoke Temp: ${log.yoke_temperature}°C\n`;
          textContent += `  * Arc Current: ${log.arc_current}A\n`;
          textContent += `  * Filament: ${log.filament_current}A\n`;
          textContent += `  * PIE Width: ${log.pie_width}\n`;
          textContent += `  * P2E Width: ${log.p2e_width}\n`;
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

  const toggleLogExpansion = (logId: string) => {
    setExpandedLogId(expandedLogId === logId ? null : logId);
  };

  const shouldShowExpand = (log: LogEntry): boolean => {
    return Boolean(log.description.length > 100 || 
           (log.attachments && log.attachments.length > 0));
  };

  // Handle new entry
  const handleNewEntry = async (newEntry: LogEntry) => {
    // Fetch the complete entry with attachments
    const { data: entryWithAttachments, error } = await supabase
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
      .eq('id', newEntry.id)
      .single();

    if (error) {
      console.error('Error fetching new entry details:', error);
      return;
    }

    // Update the state with the new entry
    setRawLogs(prevLogs => {
      const updatedLogs = [...prevLogs];
      
      // Find the appropriate shift group or create a new one
      let targetGroup = updatedLogs.find(group => 
        group.shiftType === entryWithAttachments.shift_type &&
        isSameShift(group.startTime, entryWithAttachments.created_at)
      );

      if (!targetGroup) {
        // Create a new shift group if needed
        targetGroup = {
          shiftType: entryWithAttachments.shift_type,
          startTime: entryWithAttachments.created_at,
          endTime: null,
          logs: []
        };
        updatedLogs.unshift(targetGroup);
      }

      // Add the new entry to the group
      targetGroup.logs.unshift(entryWithAttachments);
      
      return updatedLogs;
    });
  };

  // Handle entry update
  const handleEntryUpdate = async (updatedEntry: LogEntry) => {
    // Fetch the complete updated entry with attachments
    const { data: entryWithAttachments, error } = await supabase
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
      .eq('id', updatedEntry.id)
      .single();

    if (error) {
      console.error('Error fetching updated entry details:', error);
      return;
    }

    setRawLogs(prevLogs => {
      return prevLogs.map(group => ({
        ...group,
        logs: group.logs.map(log => 
          log.id === entryWithAttachments.id ? entryWithAttachments : log
        )
      }));
    });
  };

  // Handle entry deletion
  const handleEntryDeletion = (deletedEntryId: string) => {
    setRawLogs(prevLogs => {
      return prevLogs.map(group => ({
        ...group,
        logs: group.logs.filter(log => log.id !== deletedEntryId)
      })).filter(group => group.logs.length > 0);
    });
  };

  // Helper function to check if two dates are in the same shift
  const isSameShift = (date1: string, date2: string) => {
    const d1 = new Date(date1);
    const d2 = new Date(date2);
    
    // Check if dates are on the same day
    const isSameDay = d1.toDateString() === d2.toDateString();
    
    if (!isSameDay) return false;
    
    // Get hours for both dates
    const hours1 = d1.getHours();
    const hours2 = d2.getHours();
    
    // Define shift ranges (adjust these according to your shift timings)
    const isFirstShift = (h: number) => h >= 6 && h < 14;
    const isSecondShift = (h: number) => h >= 14 && h < 22;
    const isThirdShift = (h: number) => h >= 22 || h < 6;
    
    // Check if both times fall in the same shift
    return (
      (isFirstShift(hours1) && isFirstShift(hours2)) ||
      (isSecondShift(hours1) && isSecondShift(hours2)) ||
      (isThirdShift(hours1) && isThirdShift(hours2))
    );
  };

  // Update the handleStatusChange function to not wait for subscription
  const handleStatusChange = async (logId: string, newStatus: string, field: 'case_status' | 'workorder_status') => {
    try {
      // Optimistically update both rawLogs and criticalEvents
      setRawLogs(prevLogs => 
        prevLogs.map(group => ({
          ...group,
          logs: group.logs.map(log => 
            log.id === logId 
              ? { ...log, [field]: newStatus }
              : log
          )
        }))
      );

      setCriticalEvents(prevEvents =>
        prevEvents.map(event =>
          event.id === logId
            ? { ...event, [field]: newStatus }
            : event
        )
      );

      // Send update to server
      const { error } = await supabase
        .from('log_entries')
        .update({ [field]: newStatus })
        .eq('id', logId);

      if (error) {
        throw error;
      }

      toast.success('Status updated successfully');
      setActiveStatusId(null);

      // Fetch fresh data to ensure consistency
      await Promise.all([
        fetchLogs(),
        fetchCriticalEvents()
      ]);
    } catch (error) {
      console.error('Error updating status:', error);
      toast.error('Failed to update status');
      // Revert both optimistic updates on error
      await Promise.all([
        fetchLogs(),
        fetchCriticalEvents()
      ]);
    }
  };

  // Add click handler to prevent event propagation
  const handleStatusClick = (e: React.MouseEvent, logId: string) => {
    e.stopPropagation();
    setActiveStatusId(activeStatusId === logId ? null : logId);
  };

  // Add click handler to close menu when clicking outside
  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (activeStatusId && !(e.target as Element).closest('.status-menu')) {
        setActiveStatusId(null);
      }
    };

    document.addEventListener('click', handleClickOutside);
    return () => document.removeEventListener('click', handleClickOutside);
  }, [activeStatusId]);

  // Add these styles at the top of your file or in your global CSS
  const styles = `
    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translate(-50%, -50%) scale(0.5);
      }
      to {
        opacity: 1;
        transform: translate(-50%, -50%) scale(1);
      }
    }

    @keyframes fadeOut {
      from {
        opacity: 1;
        transform: translate(-50%, -50%) scale(1);
      }
      to {
        opacity: 0;
        transform: translate(-50%, -50%) scale(0.5);
      }
    }

    .animate-in {
      animation: fadeIn 0.3s ease-in-out forwards;
    }

    .animate-out {
      animation: fadeOut 0.3s ease-in-out forwards;
    }
  `;

  // Add the styles to the document head
  useEffect(() => {
    const styleElement = document.createElement('style');
    styleElement.innerHTML = styles;
    document.head.appendChild(styleElement);
    return () => {
      document.head.removeChild(styleElement);
    };
  }, []);

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-400"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {logs.map((shiftGroup, groupIndex) => (
        <div key={groupIndex} className="bg-gray-800/50 backdrop-blur-lg rounded-lg overflow-hidden border border-white/10">
          {/* Shift Header with Icon */}
          <div className="p-4 bg-gray-800/80 border-b border-white/10">
            <div className="flex items-center justify-between">
              <div className="space-y-1">
                <div className="flex items-center gap-3">
                  <span className={`flex items-center gap-2 text-lg font-bold ${
                    shiftGroup.shiftType === 'morning' ? 'text-yellow-400' :
                    shiftGroup.shiftType === 'afternoon' ? 'text-orange-400' :
                    'text-blue-400'
                  }`}>
                    {shiftGroup.shiftType === 'morning' && <Sun className="h-5 w-5" />}
                    {shiftGroup.shiftType === 'afternoon' && <Sunset className="h-5 w-5" />}
                    {shiftGroup.shiftType === 'night' && <Moon className="h-5 w-5" />}
                    {shiftGroup.shiftType.charAt(0).toUpperCase() + shiftGroup.shiftType.slice(1)} Shift
                  </span>
                  <span className="text-sm text-gray-400 font-medium">
                    {formatDateForGroup(shiftGroup.startTime)}
                  </span>
                </div>
                <div className="text-sm text-gray-500 flex items-center gap-2">
                  <Clock className="h-4 w-4" />
                  <span className="font-mono">
                    {new Date(shiftGroup.startTime).toLocaleTimeString()} - {shiftGroup.endTime ? new Date(shiftGroup.endTime).toLocaleTimeString() : 'Ongoing'}
                  </span>
                </div>
              </div>
            </div>
          </div>

          {/* Log Entries */}
          <div className="divide-y divide-gray-700/50">
            {shiftGroup.logs.map((log) => (
              <div 
                key={log.id} 
                className={`p-3 hover:bg-gray-700/30 transition-colors ${shouldShowExpand(log) ? 'cursor-pointer' : ''} ${expandedLogId === log.id ? 'bg-gray-700/30' : ''}`}
                onClick={() => shouldShowExpand(log) ? toggleLogExpansion(log.id) : undefined}
              >
                <div className="flex items-start gap-4">
                  {/* Time Column */}
                  <div className="w-20 shrink-0 pt-1">
                    <span className="text-sm font-mono text-gray-400">
                {formatDateTime(log.created_at)}
                    </span>
                  </div>

                  {/* Category Badge */}
                  <div className="w-28 shrink-0 pt-1">
                    <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium ${
                      log.category === 'error' ? 'bg-red-400/10 text-red-400 border border-red-400/20' :
                      log.category === 'downtime' ? 'bg-yellow-400/10 text-yellow-400 border border-yellow-400/20' :
                      log.category === 'workorder' ? 'bg-blue-400/10 text-blue-400 border border-blue-400/20' :
                      (log.category as string) === 'data-mc' ? 'bg-purple-400/10 text-purple-400 border border-purple-400/20' :
                      (log.category as string) === 'data-sc' ? 'bg-purple-400/10 text-purple-400 border border-purple-400/20' :
                      (log.category as string) === 'data-collection' ? 'bg-purple-400/10 text-purple-400 border border-purple-400/20' :
                      log.category === 'shift' ? 'bg-green-400/10 text-green-400 border border-green-400/20' :
                      'bg-gray-400/10 text-gray-400 border border-gray-400/20'
                }`}>
                      {log.category === 'data-collection' ? 'Data' :
                       (log.category as string) === 'data-mc' ? 'Main Coil Tuning' :
                       (log.category as string) === 'data-sc' ? 'Source Change' :
                       log.category.charAt(0).toUpperCase() + log.category.slice(1)}
                </span>
                  </div>

                  {/* Main Content */}
                  <div className="flex-1 min-w-0 space-y-1">
                {editingLog?.id === log.id ? (
                      <form onSubmit={handleSaveEdit} className="space-y-2" onClick={e => e.stopPropagation()}>
                        <textarea
                          value={editedDescription}
                          onChange={(e) => setEditedDescription(e.target.value)}
                          className="w-full px-3 py-2 bg-gray-900/50 border border-gray-700 rounded-lg text-sm text-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          rows={3}
                      autoFocus
                    />
                        <div className="flex items-center gap-2">
                          <button
                            type="submit"
                            className="px-3 py-1 bg-blue-500 hover:bg-blue-600 text-white text-sm font-medium rounded transition-colors"
                          >
                            Save
                          </button>
                    <button
                            type="button"
                            onClick={handleCancelEdit}
                            className="px-3 py-1 bg-gray-700 hover:bg-gray-600 text-white text-sm font-medium rounded transition-colors"
                    >
                      Cancel
                    </button>
                  </div>
                      </form>
                ) : (
                      <>
                        {/* Status badges and machine parameters row */}
                        <div className="flex items-center flex-wrap gap-2">
                          {/* Status badges for downtime and workorder */}
                          {(log.category === 'downtime' || log.category === 'workorder') && (
                            <div className="relative status-menu">
                              <button
                                onClick={(e) => handleStatusClick(e, log.id)}
                                className={`px-2 py-0.5 rounded-full text-xs font-medium ${
                                  getStatusStyle(log.category === 'downtime' 
                                    ? (log.case_status || 'open')
                                    : (log.workorder_status || 'open'))
                                }`}
                              >
                                {log.category === 'downtime' 
                                  ? (log.case_status || 'open')
                                  : (log.workorder_status || 'open')}
                              </button>
                              
                              {activeStatusId === log.id && (
                                <div className="absolute z-10 left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2">
                                  <div className="relative w-32 h-32">
                                    {STATUS_OPTIONS.map((option, index) => {
                                      const angle = (index * 360) / STATUS_OPTIONS.length;
                                      const isActive = (log.category === 'downtime' 
                                        ? (log.case_status || 'open')
                                        : (log.workorder_status || 'open')) === option.value;
                                      
                                      return (
                                        <button
                                          key={option.value}
                                          onClick={(e) => {
                                            e.stopPropagation();
                                            handleStatusChange(
                                              log.id,
                                              option.value,
                                              log.category === 'downtime' ? 'case_status' : 'workorder_status'
                                            );
                                          }}
                                          className={`
                                            absolute w-8 h-8 rounded-full 
                                            transform -translate-x-1/2 -translate-y-1/2
                                            transition-all duration-300 ease-in-out
                                            ${option.color} hover:scale-110
                                            flex items-center justify-center
                                            text-white text-xs font-medium
                                            shadow-lg hover:shadow-xl
                                            ${isActive ? 'scale-110 ring-2 ring-white' : 'opacity-80'}
                                            ${activeStatusId === log.id ? 'animate-in' : 'animate-out'}
                                          `}
                                          style={{
                                            left: `${Math.cos((angle - 90) * (Math.PI / 180)) * 48 + 64}px`,
                                            top: `${Math.sin((angle - 90) * (Math.PI / 180)) * 48 + 64}px`,
                                            animation: `${activeStatusId === log.id ? 'fadeIn' : 'fadeOut'} 0.3s ease-in-out`,
                                            animationDelay: `${index * 0.1}s`
                                          }}
                                        >
                                          {option.label.split(' ')[0]}
                                        </button>
                                      );
                                    })}
                                  </div>
                                </div>
                              )}
                            </div>
                          )}
                          
                          {/* Case/Workorder numbers */}
                          {log.case_number && (log.category as string) !== 'data-sc' && (
                            <span className="text-xs text-gray-400 font-mono bg-gray-700/30 px-2 py-0.5 rounded">
                              Case #{log.case_number}
                            </span>
                          )}
                          {log.workorder_number && (log.category as string) !== 'data-sc' && (
                            <span className="text-xs text-gray-400 font-mono bg-gray-700/30 px-2 py-0.5 rounded">
                              WO #{log.workorder_number}
                            </span>
                          )}
                          
                          {/* Machine parameters for data collection */}
                          {((log.category as string) === 'data-mc' || (log.category as string) === 'data-sc') && (
                            <div className="bg-gray-800/60 rounded-lg p-3 mt-2 w-fit min-w-[320px]">
                              {(log.category as string) === 'data-mc' && (
                                <>
                                  <div className="mb-2">
                                    <h5 className="text-xs font-bold text-indigo-300 mb-1">Main Coil Tuning Data</h5>
                                    <div className="flex flex-wrap gap-4 text-xs text-gray-200">
                                      <span>Main coil setpoint: <b>{log.mc_setpoint ?? '—'}</b> A</span>
                                      <span>Yoke Temp: <b>{log.yoke_temperature ?? '—'}</b> °C</span>
                                      <span>Filament Current: <b>{log.filament_current ?? '—'}</b> A</span>
                                      <span>Arc Current: <b>{log.arc_current ?? '—'}</b> mA</span>
                                    </div>
                                  </div>
                                  <div>
                                    <h5 className="text-xs font-bold text-indigo-300 mb-1">Beam Data</h5>
                                    <div className="flex flex-wrap gap-4 text-xs text-gray-200">
                                      <span>PIE X width: <b>{log.pie_width ?? '—'}</b> mm</span>
                                      <span>PIE Y width: <b>{log.p2e_width ?? '—'}</b> mm</span>
                                      <span>P2E X width: <b>{log.pie_x_width ?? '—'}</b> mm</span>
                                      <span>P2E Y width: <b>{log.p2e_y_width ?? '—'}</b> mm</span>
                                    </div>
                                  </div>
                                </>
                              )}
                              {(log.category as string) === 'data-sc' && (
                                <>
                                  <div className="mb-2">
                                    <h5 className="text-xs font-bold text-indigo-300 mb-1">Removed Source Data</h5>
                                    <div className="flex flex-wrap gap-4 text-xs text-gray-200">
                                      <span>Source #: <b>{log.removed_source_number ?? '—'}</b></span>
                                      <span>Filament Current: <b>{log.removed_filament_current ?? '—'}</b> A</span>
                                      <span>Arc Current: <b>{log.removed_arc_current ?? '—'}</b> mA</span>
                                      <span>Filament Counter: <b>{log.removed_filament_counter ?? '—'}</b></span>
                                    </div>
                                  </div>
                                  <div className="mb-2">
                                    <h5 className="text-xs font-bold text-indigo-300 mb-1">Inserted Source Data</h5>
                                    <div className="flex flex-wrap gap-4 text-xs text-gray-200">
                                      <span>Source #: <b>{log.inserted_source_number ?? '—'}</b></span>
                                      <span>Filament Current: <b>{log.inserted_filament_current ?? '—'}</b> A</span>
                                      <span>Arc Current: <b>{log.inserted_arc_current ?? '—'}</b> mA</span>
                                      <span>Filament Counter: <b>{log.inserted_filament_counter ?? '—'}</b></span>
                                    </div>
                                  </div>
                                  <div className="mb-2 flex flex-wrap items-center gap-6">
                                    <div>
                                      <h5 className="text-xs font-bold text-indigo-300 mb-1">Filament Hours</h5>
                                      <span className="text-xs text-gray-200">
                                        {typeof log.inserted_filament_counter === 'number' && typeof log.removed_filament_counter === 'number'
                                          ? (log.inserted_filament_counter - log.removed_filament_counter).toFixed(2)
                                          : '—'}
                                      </span>
                                    </div>
                                    <div>
                                      <h5 className="text-xs font-bold text-indigo-300 mb-1">Svmx / Pridex</h5>
                                      <div className="flex flex-wrap gap-4 text-xs text-gray-200">
                                        {log.workorder_number && <span>WO #: <b>{log.workorder_number}</b></span>}
                                        {log.case_number && <span>Case #: <b>{log.case_number}</b></span>}
                                      </div>
                                    </div>
                                    {log.engineers && log.engineers.length > 0 && (
                                      <div>
                                        <h5 className="text-xs font-bold text-indigo-300 mb-1">Engineers</h5>
                                        <span className="text-xs text-gray-200">
                                          {log.engineers.map(id => engineerMap[id] || id).slice(0,2).join(', ')}
                                        </span>
                                      </div>
                                    )}
                                  </div>
                                </>
                              )}
                            </div>
                          )}
                        </div>

                        {/* Description */}
                        <p className={`text-sm text-white ${expandedLogId === log.id ? 'whitespace-pre-wrap break-words' : 'truncate'}`}>
                          {log.description}
                        </p>

                        {/* Expand indicator */}
                        {shouldShowExpand(log) && !expandedLogId && (
                          <span className="text-xs text-gray-500">Click to expand</span>
                        )}
                        
                        {/* Attachments in expanded view */}
                        {expandedLogId === log.id && log.attachments && log.attachments.length > 0 && (
                          <div className="mt-2 space-y-1">
                            {log.attachments.map((attachment) => (
                              <div key={attachment.id} className="flex items-center gap-2 text-sm bg-gray-700/30 p-2 rounded">
                                <Paperclip className="h-4 w-4 text-gray-400" />
                                <span className="text-gray-300 truncate">{attachment.file_name}</span>
                                <span className="text-gray-500 shrink-0">({formatFileSize(attachment.file_size)})</span>
                                <div className="flex items-center gap-1 ml-auto">
                                  <button
                                    onClick={(e) => {
                                      e.stopPropagation();
                                      handleView(attachment.file_path);
                                    }}
                                    className="p-1 text-gray-400 hover:text-white transition-colors hover:bg-white/10 rounded"
                                    title="View"
                              >
                                <ExternalLink className="h-4 w-4" />
                              </button>
                              <button
                                    onClick={(e) => {
                                      e.stopPropagation();
                                      handleDownload(attachment.file_path, attachment.file_name);
                                    }}
                                    className="p-1 text-gray-400 hover:text-white transition-colors hover:bg-white/10 rounded"
                                title="Download"
                              >
                                <Download className="h-4 w-4" />
                              </button>
                            </div>
                          </div>
                        ))}
                      </div>
                    )}
                      </>
                )}
                  </div>

                  {/* Actions */}
                  <div className="flex items-center gap-2 shrink-0" onClick={(e) => e.stopPropagation()}>
                <button 
                      onClick={(e) => handleEdit(log, e)}
                      className="p-1 text-gray-400 hover:text-white transition-colors hover:bg-white/10 rounded"
                >
                  <Edit2 className="h-4 w-4" />
                </button>
                {/* Only show delete button if not a shift end entry */}
                {!(log.category === 'shift' && log.description && log.description.toLowerCase().includes('shift ended')) && (
                  <button 
                    onClick={(e) => {
                      e.stopPropagation();
                      handleDelete(log.id);
                    }}
                    className="p-1 text-gray-400 hover:text-red-400 transition-colors hover:bg-white/10 rounded"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                )}
                  </div>
                </div>
              </div>
          ))}
          </div>
        </div>
      ))}
    </div>
  );
};

export default LogTable;