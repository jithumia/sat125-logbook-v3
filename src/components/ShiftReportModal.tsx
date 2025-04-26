import React, { useState, useEffect } from 'react';
import { X, Send, Loader2 } from 'lucide-react';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';
import { LogEntry, ActiveShift } from '../types';

interface ShiftReportModalProps {
  onClose: () => void;
}

const ShiftReportModal: React.FC<ShiftReportModalProps> = ({ onClose }) => {
  const [loading, setLoading] = useState(true);
  const [sending, setSending] = useState(false);
  const [reportData, setReportData] = useState<{
    shift: ActiveShift | null;
    logs: LogEntry[];
    engineers: string[];
    endTime: string | null;
  }>({
    shift: null,
    logs: [],
    engineers: [],
    endTime: null,
  });

  useEffect(() => {
    fetchShiftData();
  }, []);

  const fetchShiftData = async () => {
    try {
      setLoading(true);

      // Find the last shift end log entry
      const { data: endLog, error: endLogError } = await supabase
        .from('log_entries')
        .select('*')
        .eq('category', 'shift')
        .ilike('description', '%shift ended%')
        .order('created_at', { ascending: false })
        .limit(1)
        .single();

      if (endLogError || !endLog) {
        toast.error('No completed shift found');
        onClose();
        return;
      }

      // Find the corresponding shift start log
      const { data: startLog, error: startLogError } = await supabase
        .from('log_entries')
        .select('*')
        .eq('category', 'shift')
        .eq('shift_type', endLog.shift_type)
        .lt('created_at', endLog.created_at)
        .ilike('description', '%shift started%')
        .order('created_at', { ascending: false })
        .limit(1)
        .single();

      if (startLogError || !startLog) {
        toast.error('Could not find shift start record');
        onClose();
        return;
      }

      // Extract shift details from the start log description
      const shiftDetails = startLog.description.match(/shift started by (.*?) \(SF#: (.*?)\)/);
      if (!shiftDetails) {
        toast.error('Invalid shift start record format');
        onClose();
        return;
      }

      const [, engineerNames, salesforceNumber] = shiftDetails;

      // Create a pseudo shift record
      const shift: ActiveShift = {
        id: startLog.id,
        shift_type: startLog.shift_type,
        started_at: startLog.created_at,
        started_by: startLog.user_id,
        salesforce_number: salesforceNumber,
        created_at: startLog.created_at,
        engineers: engineerNames.split(', ').map(name => ({
          engineer: { name, id: '', user_id: '', created_at: '' }
        }))
      };

      // Get all logs between start and end time
      const { data: logs, error: logsError } = await supabase
        .from('log_entries')
        .select(`
          *,
          attachments (*)
        `)
        .eq('shift_type', shift.shift_type)
        .gte('created_at', startLog.created_at)
        .lte('created_at', endLog.created_at)
        .order('created_at', { ascending: true });

      if (logsError) throw logsError;

      setReportData({
        shift,
        logs: logs || [],
        engineers: engineerNames.split(', '),
        endTime: endLog.created_at,
      });
    } catch (error) {
      console.error('Error fetching shift data:', error);
      toast.error('Failed to fetch shift data');
      onClose();
    } finally {
      setLoading(false);
    }
  };

  const formatReport = () => {
    if (!reportData.shift || !reportData.endTime) return '';

    const { shift, logs, engineers } = reportData;
    const shiftDate = new Date(shift.started_at);

    // Group logs by category
    const groupedLogs = logs.reduce((acc, log) => {
      if (!acc[log.category]) {
        acc[log.category] = [];
      }
      acc[log.category].push(log);
      return acc;
    }, {} as Record<string, LogEntry[]>);

    let report = 'Dear Team,\n\n';
    report += `Please find the following report summarizing the ${
      shift.shift_type.charAt(0).toUpperCase() + shift.shift_type.slice(1)
    } Shift activities and events for SVMX No: ${shift.salesforce_number}\n\n`;

    report += `Date: ${shiftDate.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })}\n`;
    report += `Engineers: ${engineers.join(', ')}\n\n`;

    // Add Main Coil Tuning Entries if available
    const dataCollectionLogs = groupedLogs['data-collection'] || [];
    if (dataCollectionLogs.length > 0) {
      report += 'Main Coil Tuning Entries:\n';
      const latestData = dataCollectionLogs[dataCollectionLogs.length - 1];
      if (latestData.mc_setpoint) {
        report += `MC Current setpoint: ${latestData.mc_setpoint} | `;
        report += `Filament Current: ${latestData.filament_current} | `;
        report += `Arc Current: ${latestData.arc_current} | `;
        report += `Yoke Temperature: ${latestData.yoke_temperature} | `;
        report += `P1E Width: ${latestData.pie_width} | `;
        report += `P2E Width: ${latestData.p2e_width}\n\n`;
      }
    }

    // Add General entries
    const generalLogs = groupedLogs['general'] || [];
    if (generalLogs.length > 0) {
      report += 'General:\n';
      generalLogs.forEach(log => {
        report += `• ${log.description}\n`;
      });
      report += '\n';
    }

    // Add Error entries
    const errorLogs = groupedLogs['error'] || [];
    if (errorLogs.length > 0) {
      report += 'Errors:\n';
      errorLogs.forEach(log => {
        report += `• ${log.description}\n`;
      });
      report += '\n';
    }

    // Add Downtime entries
    const downtimeLogs = groupedLogs['downtime'] || [];
    if (downtimeLogs.length > 0) {
      report += 'Downtime:\n';
      downtimeLogs.forEach(log => {
        report += `• [${log.case_number}] ${log.description}`;
        if (log.case_status) {
          report += ` (Status: ${log.case_status})`;
        }
        report += '\n';
      });
      report += '\n';
    }

    // Add Workorder entries
    const workorderLogs = groupedLogs['workorder'] || [];
    if (workorderLogs.length > 0) {
      report += 'Workorder:\n';
      workorderLogs.forEach(log => {
        report += `• ${log.description}`;
        if (log.workorder_number) {
          report += ` | WO: ${log.workorder_number}`;
          if (log.workorder_status) {
            report += ` (${log.workorder_status})`;
          }
        }
        report += '\n';
      });
      report += '\n';
    }

    // Add Notes for Next Shift
    const shiftLogs = groupedLogs['shift'] || [];
    const endShiftLog = shiftLogs.find(log => log.description.includes('shift ended'));
    if (endShiftLog) {
      report += 'Notes for Next Shift:\n';
      report += `${endShiftLog.description.split('Note:')[1]?.trim() || 'NIL'}\n\n`;
    }

    report += 'Thank you,\n';
    report += `${shift.shift_type.charAt(0).toUpperCase() + shift.shift_type.slice(1)} Shift Team`;

    return report;
  };

  const handleSendReport = async () => {
    if (!reportData.shift) return;

    try {
      setSending(true);

      const report = formatReport();
      const subject = `${reportData.shift.shift_type.charAt(0).toUpperCase() + reportData.shift.shift_type.slice(1)} Shift Report (${
        new Date(reportData.shift.started_at).toLocaleDateString('en-US', {
          month: 'long',
          day: 'numeric',
          year: 'numeric'
        })
      }) - SVMX No: ${reportData.shift.salesforce_number}`;

      // Collect all attachments from logs
      const attachments = [];
      for (const log of reportData.logs) {
        if (log.attachments && log.attachments.length > 0) {
          for (const attachment of log.attachments) {
            try {
              // Download the file from storage
              const { data, error } = await supabase.storage
                .from('attachments')
                .download(attachment.file_path);

              if (error) throw error;

              // Convert blob to base64
              const buffer = await data.arrayBuffer();
              const base64Content = btoa(
                new Uint8Array(buffer).reduce((data, byte) => data + String.fromCharCode(byte), '')
              );

              attachments.push({
                filename: attachment.file_name,
                content: base64Content,
                contentType: attachment.file_type,
              });
            } catch (error) {
              console.error(`Error downloading attachment ${attachment.file_name}:`, error);
              toast.error(`Failed to attach ${attachment.file_name}`);
            }
          }
        }
      }

      // Send report with attachments
      const { data, error } = await supabase.functions.invoke('send-report', {
        body: {
          subject,
          body: report,
          attachments,
        },
      });

      if (error) {
        throw new Error(error.message || 'Failed to send report');
      }

      if (!data?.success) {
        throw new Error(data?.details || 'Failed to send report');
      }

      toast.success('Shift report sent successfully');
      onClose();
    } catch (error) {
      console.error('Error sending report:', error);
      toast.error(error.message || 'Failed to send shift report');
    } finally {
      setSending(false);
    }
  };

  if (loading) {
    return (
      <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50">
        <div className="bg-gray-800 rounded-lg p-6 w-full max-w-4xl mx-4">
          <div className="flex justify-center items-center h-64">
            <Loader2 className="h-8 w-8 animate-spin text-blue-500" />
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50">
      <div className="bg-gray-800 rounded-lg p-6 w-full max-w-4xl mx-4">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-semibold text-white">Shift Report Preview</h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-white transition-colors"
          >
            <X className="h-6 w-6" />
          </button>
        </div>

        <div className="bg-gray-900 rounded-lg p-4 mb-4 h-[60vh] overflow-y-auto">
          <pre className="text-gray-300 whitespace-pre-wrap font-mono text-sm">
            {formatReport()}
          </pre>
        </div>

        <div className="flex justify-end space-x-3">
          <button
            onClick={onClose}
            disabled={sending}
            className="px-4 py-2 bg-gray-700 text-white rounded-md hover:bg-gray-600 transition-colors"
          >
            Cancel
          </button>
          <button
            onClick={handleSendReport}
            disabled={sending}
            className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors flex items-center space-x-2"
          >
            {sending ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" />
                <span>Sending...</span>
              </>
            ) : (
              <>
                <Send className="h-4 w-4" />
                <span>Send Report</span>
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default ShiftReportModal;