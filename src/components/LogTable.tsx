import React, { useEffect, useState, Fragment, useRef } from 'react';
import { Edit2, Trash2, Paperclip, ExternalLink, Download, X, Sun, Sunset, Moon, Clock, ChevronDown, Timer, Calendar } from 'lucide-react';
import { LogEntry, ShiftType, SearchFilters, ActiveShift, Attachment, Status } from '../types';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';
import { format, parse, set } from 'date-fns';
import { Dialog, Popover } from '@headlessui/react';
import TimePicker from './TimePicker';
import DateTimePicker from './DateTimePicker';

interface LogTableProps {
  showAllLogs: boolean;
  searchFilters: SearchFilters;
  activeShift: ActiveShift | null;
  setIsEditing: (isEditing: boolean) => void;
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
  value: Status;
  label: string;
  color: string;
}

const STATUS_OPTIONS: StatusOption[] = [
  { value: 'open', label: 'Open', color: 'bg-green-500' },
  { value: 'in_progress', label: 'In Progress', color: 'bg-yellow-500' },
  { value: 'pending', label: 'Pending', color: 'bg-orange-500' },
  { value: 'closed', label: 'Closed', color: 'bg-gray-500' }
];

// At the top of the file, after importing Attachment, add:
type AttachmentWithUrl = Attachment & { url?: string };

const LogTable: React.FC<LogTableProps> = ({ showAllLogs, searchFilters, activeShift, setIsEditing }) => {
  const [rawLogs, setRawLogs] = useState<ShiftGroup[]>([]);
  const [logs, setLogs] = useState<ShiftGroup[]>([]);
  const [loading, setLoading] = useState(true);
  const [editingLog, setEditingLog] = useState<LogEntry | null>(null);
  const [editedDescription, setEditedDescription] = useState('');
  const [criticalEvents, setCriticalEvents] = useState<LogEntry[]>([]);
  const [expandedLogId, setExpandedLogId] = useState<string | null>(null);
  const [activeStatusId, setActiveStatusId] = useState<string | null>(null);
  const [engineerMap, setEngineerMap] = useState<Record<string, string>>({});
  const [editingDowntime, setEditingDowntime] = useState<{
    logId: string;
    startTime: string;
    endTime: string | null;
    initialStartTime: string;
    initialEndTime: string | null;
  } | null>(null);
  const [showDowntimeModal, setShowDowntimeModal] = useState(false);
  const [refreshAfterEditing, setRefreshAfterEditing] = useState(false);

  // Add a ref to track if we're currently editing
  const isEditing = useRef(false);

  useEffect(() => {
    isEditing.current = showDowntimeModal || editingLog !== null;
    
    // Trigger a refresh when editing is completed
    if (refreshAfterEditing && !isEditing.current) {
    fetchLogs();
      fetchCriticalEvents();
      setRefreshAfterEditing(false);
    }
  }, [showDowntimeModal, editingLog, refreshAfterEditing]);

  useEffect(() => {
    setLoading(true);
    fetchLogs();
    fetchCriticalEvents();
  }, [showAllLogs, activeShift, searchFilters]);

  useEffect(() => {
    // Update parent's isEditing state
    setIsEditing(showDowntimeModal || editingLog !== null);
  }, [showDowntimeModal, editingLog, setIsEditing]);

  // Fetch engineers and build engineerMap on mount
  useEffect(() => {
    async function fetchEngineerMap() {
      const { data, error } = await supabase
        .from('engineers')
        .select('id, name');
      if (!error && data) {
        const map: Record<string, string> = {};
        data.forEach((eng: { id: string; name: string }) => {
          map[eng.id] = eng.name;
        });
        setEngineerMap(map);
      }
    }
    fetchEngineerMap();
  }, []);

  // Regular fetch functions with loading state
  const fetchLogs = async () => {
    try {
      // Only show loading indicator if the tab is visible
      if (document.visibilityState === 'visible') {
      setLoading(true);
      }
      
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
        // Always use activeShift.started_at as the lower bound
        let shiftStartTime = activeShift.started_at;
        const { data: shiftStartLogs } = await supabase
          .from('log_entries')
          .select('created_at')
          .eq('category', 'shift')
          .eq('shift_type', activeShift.shift_type)
          .ilike('description', '%shift started%')
          .order('created_at', { ascending: false })
          .limit(1);
        if (shiftStartLogs && shiftStartLogs.length > 0) {
          // Use the earlier of the two times
          const logTime = shiftStartLogs[0].created_at;
          if (new Date(logTime) < new Date(shiftStartTime)) {
            shiftStartTime = logTime;
          }
        }
        query = query.gte('created_at', shiftStartTime);
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
        throw error;
      }

      if (!data) {
        setRawLogs([]);
        setLogs([]);
        return;
      }

      // Add this line:
      const logsWithUrls = await addAttachmentUrlsToLogs(data);

      // Apply keyword filter if present
      let filteredLogs = logsWithUrls;
      if (searchFilters.keyword && searchFilters.keyword.trim() !== '') {
        const keyword = searchFilters.keyword.trim().toLowerCase();
        filteredLogs = filteredLogs.filter(log => {
          // Concatenate all stringifiable values in the log entry
          let concat = '';
          for (const [key, value] of Object.entries(log)) {
            if (typeof value === 'string' || typeof value === 'number') {
              concat += ' ' + value.toString();
            } else if (Array.isArray(value)) {
              concat += ' ' + value.map(v => v?.toString()).join(' ');
            }
          }
          return concat.toLowerCase().includes(keyword);
        });
      }

      // Sort data chronologically
      const sortedData = [...filteredLogs].sort((a, b) => 
        new Date(a.created_at).getTime() - new Date(b.created_at).getTime()
      );

      // Group logs by shift (date + shift_type), even when filtering by category
      const shiftGroupsMap: Record<string, ShiftGroup> = {};
      for (const log of sortedData) {
        if (searchFilters.category && log.category !== searchFilters.category) {
          continue;
        }
        const date = new Date(log.created_at);
        const dateKey = date.toISOString().split('T')[0];
        const shiftKey = `${dateKey}_${log.shift_type}`;
        if (!shiftGroupsMap[shiftKey]) {
          shiftGroupsMap[shiftKey] = {
            shiftType: log.shift_type,
            startTime: log.created_at,
            endTime: null,
            logs: []
          };
        }
        shiftGroupsMap[shiftKey].logs.push(log);
        if (!shiftGroupsMap[shiftKey].startTime || new Date(log.created_at) < new Date(shiftGroupsMap[shiftKey].startTime)) {
          shiftGroupsMap[shiftKey].startTime = log.created_at;
        }
        if (!shiftGroupsMap[shiftKey].endTime || new Date(log.created_at) > new Date(shiftGroupsMap[shiftKey].endTime)) {
          shiftGroupsMap[shiftKey].endTime = log.created_at;
        }
      }
      const groupedLogs = Object.values(shiftGroupsMap).sort((a, b) => new Date(b.startTime).getTime() - new Date(a.startTime).getTime());

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

  // Add new function to handle downtime time updates
  const handleDowntimeUpdate = async (logId: string, startTime: string, endTime: string | null) => {
    try {
      const duration = endTime 
        ? Math.round((new Date(endTime).getTime() - new Date(startTime).getTime()) / (1000 * 60))
        : null;

      // Update both time and status
      const { error } = await supabase
        .from('log_entries')
        .update({
          dt_start_time: startTime,
          dt_end_time: endTime,
          dt_duration: duration,
          case_status: endTime ? 'closed' : 'open' // Set status based on end time
        })
        .eq('id', logId);

      if (error) throw error;

      // Update local state
      setRawLogs(prevLogs =>
        prevLogs.map(group => ({
          ...group,
          logs: group.logs.map(log =>
            log.id === logId
              ? {
                  ...log,
                  dt_start_time: startTime,
                  dt_end_time: endTime,
                  dt_duration: duration,
                  case_status: endTime ? 'closed' : 'open'
                }
              : log
          )
        }))
      );

      toast.success('Downtime times updated successfully');
      setEditingDowntime(null);
      setShowDowntimeModal(false);
    } catch (error) {
      console.error('Error updating downtime:', error);
      toast.error('Failed to update downtime times');
    }
  };

  // Modify handleStatusChange to handle workorders without time tracking
  const handleStatusChange = async (logId: string, newStatus: Status, field: 'case_status' | 'workorder_status') => {
    try {
      const targetLog = rawLogs.flatMap(g => g.logs).find(l => l.id === logId);
      if (!targetLog) return;

      // For workorders, update both log_entries and workorders tables
      if (field === 'workorder_status') {
        // Update log_entries table
        const { error: logError } = await supabase
          .from('log_entries')
          .update({ [field]: newStatus })
          .eq('id', logId);

        if (logError) throw logError;

        // Update workorders table if workorder_number exists
        if (targetLog.workorder_number) {
          const { error: workorderError } = await supabase
            .from('workorders')
            .update({ status: newStatus })
            .eq('workorder_number', targetLog.workorder_number);

          if (workorderError) throw workorderError;
        }

        // Update local state
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

        toast.success('Work order status updated successfully');
        setActiveStatusId(null);
        return;
      }

      // For downtime cases, handle time tracking
      if (newStatus === 'closed' && !targetLog.dt_end_time) {
        setEditingDowntime({
          logId,
          startTime: targetLog.dt_start_time || new Date().toISOString(),
          endTime: new Date().toISOString(),
          initialStartTime: targetLog.dt_start_time || new Date().toISOString(),
          initialEndTime: targetLog.dt_end_time || new Date().toISOString()
        });
        setShowDowntimeModal(true);
        return;
      }

      // If changing from closed to any other status, remove end time
      if (targetLog.case_status === 'closed' && newStatus !== 'closed') {
        // First update the status
        const { error: statusError } = await supabase
          .from('log_entries')
          .update({ [field]: newStatus })
          .eq('id', logId);

        if (statusError) throw statusError;

        // Then remove the end time and duration
        const { error: timeError } = await supabase
          .from('log_entries')
          .update({
            dt_end_time: null,
            dt_duration: null
          })
          .eq('id', logId);

        if (timeError) throw timeError;

        // Update local state
        setRawLogs(prevLogs =>
          prevLogs.map(group => ({
            ...group,
            logs: group.logs.map(log =>
              log.id === logId
                ? {
                    ...log,
                    [field]: newStatus,
                    dt_end_time: null,
                    dt_duration: null
                  }
                : log
            )
          }))
        );

        setCriticalEvents(prevEvents =>
          prevEvents.map(event =>
            event.id === logId
              ? {
                  ...event,
                  [field]: newStatus,
                  dt_end_time: null,
                  dt_duration: null
                }
              : event
          )
        );

        toast.success('Status updated and end time removed');
        setActiveStatusId(null);
        return;
      }

      // Regular status update for downtime cases
      const { error } = await supabase
        .from('log_entries')
        .update({ [field]: newStatus })
        .eq('id', logId);

      if (error) throw error;

      // Update local state
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

  // Add the modal component
  const DowntimeModal = () => {
    if (!editingDowntime || !showDowntimeModal) return null;

    const [timeState, setTimeState] = useState({
      startTime: editingDowntime.startTime,
      endTime: editingDowntime.endTime || null
    });

    const handleTimeChange = (field: 'startTime' | 'endTime', value: string) => {
      setTimeState(prev => ({
        ...prev,
        [field]: value
      }));
    };

    const handleSave = () => {
      handleDowntimeUpdate(
        editingDowntime.logId,
        timeState.startTime,
        timeState.endTime
      );
      handleClose();
    };

    const handleClose = () => {
      setShowDowntimeModal(false);
      setEditingDowntime(null);
    };

    const handleOverlayClick = (e: React.MouseEvent) => {
      if (e.target === e.currentTarget) {
        handleClose();
      }
    };

    return (
      <div 
        className="fixed inset-0 z-50 overflow-y-auto bg-black/50 flex items-center justify-center"
        onClick={handleOverlayClick}
      >
        <div 
          className="relative bg-gray-800 rounded-lg p-6 max-w-md w-full mx-4 space-y-4"
          onClick={e => e.stopPropagation()}
        >
          <div className="text-lg font-medium text-white mb-4">
            Edit Downtime Times
          </div>

          <div className="space-y-6">
            <div>
              <DateTimePicker
                label="Start Time"
                value={timeState.startTime}
                onChange={(value) => handleTimeChange('startTime', value)}
                required
              />
            </div>

            <div>
              <DateTimePicker
                label="End Time"
                value={timeState.endTime || new Date().toISOString()}
                onChange={(value) => handleTimeChange('endTime', value)}
              />
            </div>
          </div>

          <div className="flex justify-end gap-3 mt-6">
            <button
              type="button"
              onClick={handleClose}
              className="px-4 py-2 text-sm font-medium text-gray-300 hover:text-white bg-gray-700 rounded"
            >
              Cancel
            </button>
            <button
              type="button"
              onClick={handleSave}
              className="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded hover:bg-blue-500"
            >
              Save Changes
            </button>
          </div>
        </div>
      </div>
    );
  };

  // Modify the renderDowntimeInfo function
  const renderDowntimeInfo = (log: LogEntry) => {
    if (log.category !== 'downtime') return null;

    // Check if log is from current shift
    const isCurrentShift = activeShift && new Date(log.created_at) >= new Date(activeShift.started_at);

    const handleEditClick = (e: React.MouseEvent) => {
      e.preventDefault();
      e.stopPropagation();
      setEditingDowntime({
        logId: log.id,
        startTime: log.dt_start_time || new Date().toISOString(),
        endTime: log.dt_end_time || null,
        initialStartTime: log.dt_start_time || new Date().toISOString(),
        initialEndTime: log.dt_end_time || null
      });
      setShowDowntimeModal(true);
    };

    return (
      <div className="mt-1 flex items-center gap-4 text-xs">
        <div className="flex items-center gap-1 text-yellow-400">
          <Clock className="h-3 w-3" />
          <span>Start: {format(new Date(log.dt_start_time!), 'HH:mm')}</span>
          {!isCurrentShift && (
            <button
              onClick={handleEditClick}
              className="p-1 text-gray-400 hover:text-white transition-colors hover:bg-white/10 rounded ml-1"
              title="Edit times"
            >
              <Calendar className="h-3 w-3" />
            </button>
          )}
        </div>
        {log.dt_end_time ? (
          <>
            <div className="flex items-center gap-1 text-yellow-400">
              <Timer className="h-3 w-3" />
              <span>End: {format(new Date(log.dt_end_time), 'HH:mm')}</span>
            </div>
            <div className="text-gray-400">
              Duration: {log.dt_duration} min
            </div>
          </>
        ) : (
          <span className="text-yellow-400">Ongoing</span>
        )}
      </div>
    );
  };

  // If not showing all logs and no active shift, show a message and do not fetch logs
  useEffect(() => {
    if (!showAllLogs && !activeShift) {
      setLoading(false);
    }
  }, [showAllLogs, activeShift]);

  // Add a fallback useEffect to always clear loading if logs or criticalEvents are updated but loading is still true
  useEffect(() => {
    if (loading && (logs.length > 0 || criticalEvents.length > 0)) {
      setLoading(false);
    }
  }, [logs, criticalEvents, loading]);

  // Move fetchLogsQuietly and fetchCriticalEventsQuietly above the new useEffect for visibilitychange
  const fetchLogsQuietly = async () => {
    setLoading(true);
    try {
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
      if (!showAllLogs && activeShift) {
        const { data: shiftStartLogs } = await supabase
          .from('log_entries')
          .select('created_at')
          .eq('category', 'shift')
          .eq('shift_type', activeShift.shift_type)
          .ilike('description', '%shift started%')
          .order('created_at', { ascending: false })
          .limit(1);
        let shiftStartTime = activeShift.started_at;
        if (shiftStartLogs && shiftStartLogs.length > 0) {
          shiftStartTime = shiftStartLogs[0].created_at;
        }
        query = query.gte('created_at', shiftStartTime);
      }
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
      if (searchFilters.shiftType) {
        query = query.eq('shift_type', searchFilters.shiftType);
      }
      const { data, error } = await query;
      if (error) throw error;
      if (!data) {
        setRawLogs([]);
        setLogs([]);
        return;
      }
      const logsWithUrls = await addAttachmentUrlsToLogs(data);
      const groupedLogs: ShiftGroup[] = [];
      let currentGroup: ShiftGroup | null = null;
      const sortedData = [...logsWithUrls].sort((a, b) => 
        new Date(a.created_at).getTime() - new Date(b.created_at).getTime()
      );
      for (const log of sortedData) {
        if (searchFilters.category) {
          // If filtering by category, only include logs of that category
          if (log.category !== searchFilters.category) {
            continue;
          }
        }

        if (!searchFilters.category) {
          // Only group by shift if not filtering by category
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
        } else {
          // If filtering by category, just push as individual groups
          groupedLogs.push({
            shiftType: log.shift_type,
            startTime: log.created_at,
            endTime: null,
            logs: [log]
          });
        }
      }
      const reversedGroups = groupedLogs.reverse();
      setRawLogs(reversedGroups);
      setLogs(reversedGroups);
    } catch (error) {
      console.error('Error in fetchLogsQuietly:', error);
    } finally {
      setLoading(false);
    }
  };
  const fetchCriticalEventsQuietly = async () => {
    setLoading(true);
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
      console.error('Error fetching critical events quietly:', error);
    } finally {
      setLoading(false);
    }
  };

  // Add a useEffect to listen for 'visibilitychange' and trigger background fetches
  useEffect(() => {
    const handleVisibilityChange = () => {
      if (document.visibilityState === 'visible') {
        fetchLogsQuietly();
        fetchCriticalEventsQuietly();
      }
    };
    document.addEventListener('visibilitychange', handleVisibilityChange);
    return () => document.removeEventListener('visibilitychange', handleVisibilityChange);
  }, []);

  if (!showAllLogs && !activeShift) {
    return (
      <div className="flex justify-center items-center h-64 text-gray-400 text-lg">
        No active shift. Start a shift to begin logging entries.
      </div>
    );
  }

  // Restore addAttachmentUrlsToLogs helper
  async function addAttachmentUrlsToLogs(logs: (LogEntry & { attachments?: AttachmentWithUrl[] })[]) {
    for (const log of logs) {
      if (log.attachments && log.attachments.length > 0) {
        for (const attachment of log.attachments) {
          // Generate signed URL for each attachment
          const { data, error } = await supabase.storage
            .from('attachments')
            .createSignedUrl(attachment.file_path, 3600);
          if (!error && data?.signedUrl) {
            attachment.url = data.signedUrl;
          } else {
            attachment.url = '#';
          }
        }
      }
    }
    return logs;
  }

  // Restore getPreviousRemovedFilamentCounter helper
  function getPreviousRemovedFilamentCounter(log: LogEntry, logs: LogEntry[]): number | null {
    // Find the previous data-sc log before this one, for the same removed_source_number
    const currentIndex = logs.findIndex(l => l.id === log.id);
    if (currentIndex === -1) return null;
    for (let i = currentIndex - 1; i >= 0; i--) {
      const prev = logs[i];
      if (
        prev.category === 'data-sc' &&
        prev.removed_source_number === log.removed_source_number &&
        typeof prev.removed_filament_counter === 'number'
      ) {
        return prev.removed_filament_counter;
      }
    }
    return null;
  }

  if (!loading && logs.length === 0) {
    return (
      <div className="flex justify-center items-center h-64 text-gray-400 text-lg">
        No logs found for this view.
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Add the modal component */}
      <DowntimeModal />

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
                      log.category === 'data-mc' ? 'bg-purple-400/10 text-purple-400 border border-purple-400/20' :
                      log.category === 'data-sc' ? 'bg-green-400/10 text-green-400 border border-green-400/20' :
                      log.category === 'shift' ? 'bg-green-400/10 text-green-400 border border-green-400/20' :
                      'bg-gray-400/10 text-gray-400 border border-gray-400/20'
                }`}>
                      {log.category === 'data-mc' ? 'Main Coil Tuning' :
                       log.category === 'data-sc' ? 'Source Change' :
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
                        {/* Custom rendering for workorder entries */}
                        {log.category === 'workorder' ? (
                          <>
                            <div className="flex items-center flex-wrap gap-2">
                              <div className="relative status-menu">
                              <button
                                  onClick={(e) => handleStatusClick(e, log.id)}
                                  className={`px-2 py-0.5 rounded-full text-xs font-medium ${getStatusStyle(log.workorder_status || 'open')}`}
                              >
                                  {log.workorder_status || 'open'}
                              </button>
                                {activeStatusId === log.id && (
                                  <div className="absolute z-10 left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2">
                                    <div className="relative w-32 h-32">
                                      {STATUS_OPTIONS.map((option, index) => {
                                        const angle = (index * 360) / STATUS_OPTIONS.length;
                                        const isActive = (log.workorder_status || 'open') === option.value;
                                        
                                        return (
                              <button
                                            key={option.value}
                                            onClick={(e) => {
                                              e.stopPropagation();
                                              handleStatusChange(
                                                log.id,
                                                option.value,
                                                'workorder_status'
                                              );
                                            }}
                                            className={
                                              `absolute w-8 h-8 rounded-full \
                                              transform -translate-x-1/2 -translate-y-1/2\n                                              transition-all duration-300 ease-in-out\n                                              ${option.color} hover:scale-110\n                                              flex items-center justify-center\n                                              text-white text-xs font-medium\n                                              shadow-lg hover:shadow-xl\n                                              ${isActive ? 'scale-110 ring-2 ring-white' : 'opacity-80'}\n                                              ${activeStatusId === log.id ? 'animate-in' : 'animate-out'}\n                                            `
                                            }
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
                              {log.workorder_number && (
                                <span className="text-xs text-gray-400 font-mono bg-gray-700/30 px-2 py-0.5 rounded">
                                  WO #{log.workorder_number}
                                </span>
                              )}
                              {log.workorder_title && (
                                <span className="text-xs text-indigo-300 bg-indigo-900/30 px-2 py-0.5 rounded font-medium">
                                  {log.workorder_title}
                                </span>
                              )}
                            </div>
                            <div className="mt-1">
                              <p className={`text-sm text-white ${expandedLogId === log.id ? 'whitespace-pre-wrap break-words' : 'truncate'}`}>{log.description}</p>
                              {log.attachments && (log.attachments as AttachmentWithUrl[]).length > 0 && (
                                <div className="mt-2 flex flex-col gap-1">
                                  <div className="flex items-center gap-2 text-gray-400 text-xs">
                                    <Paperclip className="h-4 w-4" />
                                    <span>Attachments:</span>
                                  </div>
                                  <div className="flex flex-wrap gap-2">
                                    {(log.attachments as AttachmentWithUrl[]).map((attachment, idx) => (
                                      <a
                                        key={idx}
                                        href={attachment.url}
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        className="text-xs text-indigo-400 hover:text-indigo-300 underline"
                                      >
                                        {attachment.file_name}
                                      </a>
                                    ))}
                                  </div>
                      </div>
                    )}
                            </div>
                          </>
                        ) : (
                          <>
                            <div className="flex items-center flex-wrap gap-2">
                              {/* Status badges for downtime */}
                              {(log.category === 'downtime') && (
                                <div className="relative status-menu">
                                  <button
                                    onClick={(e) => handleStatusClick(e, log.id)}
                                    className={`px-2 py-0.5 rounded-full text-xs font-medium ${getStatusStyle(log.case_status || 'open')}`}
                                  >
                                    {log.case_status || 'open'}
                                  </button>
                                  {activeStatusId === log.id && (
                                    <div className="absolute z-10 left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2">
                                      <div className="relative w-32 h-32">
                                        {STATUS_OPTIONS.map((option, index) => {
                                          const angle = (index * 360) / STATUS_OPTIONS.length;
                                          const isActive = (log.case_status || 'open') === option.value;
                                          
                                          return (
                                            <button
                                              key={option.value}
                                              onClick={(e) => {
                                                e.stopPropagation();
                                                handleStatusChange(
                                                  log.id,
                                                  option.value,
                                                  'case_status'
                                                );
                                              }}
                                              className={
                                                `absolute w-8 h-8 rounded-full \
                                                transform -translate-x-1/2 -translate-y-1/2\n                                                transition-all duration-300 ease-in-out\n                                                ${option.color} hover:scale-110\n                                                flex items-center justify-center\n                                                text-white text-xs font-medium\n                                                shadow-lg hover:shadow-xl\n                                                ${isActive ? 'scale-110 ring-2 ring-white' : 'opacity-80'}\n                                                ${activeStatusId === log.id ? 'animate-in' : 'animate-out'}\n                                              `
                                              }
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
                                          <span>PIE X width: <b>{log.p1e_x_width ?? '—'}</b> mm</span>
                                          <span>PIE Y width: <b>{log.p1e_y_width ?? '—'}</b> mm</span>
                                          <span>P2E X width: <b>{log.p2e_x_width ?? '—'}</b> mm</span>
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
                                        </div>
                                      </div>
                                      <div className="mb-2 flex flex-wrap items-center gap-6">
                                        <div>
                                          <h5 className="text-xs font-bold text-indigo-300 mb-1">Filament Hours</h5>
                                            <span className="text-xs text-gray-200">
                                              {typeof log.filament_hours === 'number'
                                                ? log.filament_hours.toFixed(2)
                                                : (typeof log.removed_filament_counter === 'number'
                                                  ? (() => {
                                                      const prev = getPreviousRemovedFilamentCounter(log, shiftGroup.logs);
                                                      if (typeof prev === 'number' && typeof log.removed_filament_counter === 'number') {
                                                        return (log.removed_filament_counter - prev).toFixed(2);
                                                      }
                                                      return '—';
                                                    })()
                                                  : '—')}
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
                            {/* Description and Details */}
                            <div className="flex-1 min-w-0">
                              {/* Description */}
                              <p className={`text-sm text-white ${expandedLogId === log.id ? 'whitespace-pre-wrap break-words' : 'truncate'}`}>{log.description}</p>
                              {/* If this is a shift start log and has a shift_id, show clickable link */}
                              {log.category === 'shift' && log.description && log.description.toLowerCase().includes('shift started') && log.shift_id && (
                                <a
                                  href={`https://goiba.lightning.force.com/lightning/r/T_Shirt__c/${log.shift_id}/view`}
                                  target="_blank"
                                  rel="noopener noreferrer"
                                  className="text-xs text-blue-400 underline hover:text-blue-300 mt-1 inline-block"
                                  title="Open Shift Report in Salesforce"
                                >
                                  View Shift Report in Salesforce
                                </a>
                              )}
                              {/* Downtime Information */}
                              {log.category === 'downtime' && renderDowntimeInfo(log)}
                              {log.attachments && (log.attachments as AttachmentWithUrl[]).length > 0 && (
                                <div className="mt-2 flex flex-col gap-1">
                                  <div className="flex items-center gap-2 text-gray-400 text-xs">
                                    <Paperclip className="h-4 w-4" />
                                    <span>Attachments:</span>
                                  </div>
                                  <div className="flex flex-wrap gap-2">
                                    {(log.attachments as AttachmentWithUrl[]).map((attachment, idx) => (
                                      <a
                                        key={idx}
                                        href={attachment.url}
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        className="text-xs text-indigo-400 hover:text-indigo-300 underline"
                                      >
                                        {attachment.file_name}
                                      </a>
                                    ))}
                                  </div>
                                </div>
                              )}
                            </div>
                          </>
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