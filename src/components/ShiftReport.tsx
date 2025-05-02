import React, { useState } from 'react';
import { Dialog } from '@headlessui/react';
import { X, Mail, Calendar } from 'lucide-react';
import { format } from 'date-fns';
import { LogEntry, ShiftType } from '../types';

interface ShiftReportProps {
  isOpen: boolean;
  onClose: () => void;
  shifts: {
    shiftType: ShiftType;
    startTime: string;
    endTime: string | null;
    logs: LogEntry[];
  }[];
}

interface ShiftSummary {
  shiftType: ShiftType;
  startTime: string;
  endTime: string | null;
  engineers: string[];
  svmxNumber: string;
  mainCoilTuning: LogEntry[];
  sourceChange: LogEntry[];
  errors: LogEntry[];
  downtime: LogEntry[];
  workorders: LogEntry[];
  general: LogEntry[];
  notesForNextShift?: string;
}

const ShiftReport: React.FC<ShiftReportProps> = ({ isOpen, onClose, shifts }) => {
  const [selectedShift, setSelectedShift] = useState<'last' | 'custom'>('last');
  const [customShiftIndex, setCustomShiftIndex] = useState<number>(0);
  const [showPreview, setShowPreview] = useState(false);
  const [sending, setSending] = useState(false);

  // Get the last closed shift
  const getLastClosedShift = () => {
    return shifts.find(shift => shift.endTime !== null);
  };

  // Process shift data into a summary
  const processShiftData = (shift: typeof shifts[0]): ShiftSummary => {
    // Find the shift start entry
    const shiftStartEntry = shift.logs.find(log => 
      log.category === 'shift' && 
      log.description.toLowerCase().includes('shift start')
    );

    // Extract engineers and SVMX number from shift start entry
    let engineers: string[] = [];
    let svmxNumber = '';

    if (shiftStartEntry) {
      const description = shiftStartEntry.description;
      // Extract engineers: names before the parenthesis
      const engineerMatch = description.match(/^.*started by ([^\(]+)\s*\(/i);
      if (engineerMatch) {
        engineers = engineerMatch[1].split(',').map(name => name.trim()).filter(Boolean);
      }
      // Extract SVMX: value after 'SF#:' inside parentheses
      const svmxMatch = description.match(/SF#:\s*([A-Za-z0-9-]+)/i);
      if (svmxMatch) {
        svmxNumber = svmxMatch[1];
      }
    }

    // Categorize logs
    const mainCoilTuning = shift.logs.filter(log => log.category === 'data-mc');
    const sourceChange = shift.logs.filter(log => log.category === 'data-sc');
    const errors = shift.logs.filter(log => log.category === 'error');
    const downtime = shift.logs.filter(log => log.category === 'downtime');
    const workorders = shift.logs.filter(log => log.category === 'workorder');
    const general = shift.logs.filter(log => log.category === 'general');

    // Find notes for next shift
    const notesForNextShift = shift.logs.find(log => 
      log.category === 'general' && 
      log.description.toLowerCase().includes('notes for next shift')
    )?.description;

    return {
      shiftType: shift.shiftType,
      startTime: shift.startTime,
      endTime: shift.endTime,
      engineers,
      svmxNumber,
      mainCoilTuning,
      sourceChange,
      errors,
      downtime,
      workorders,
      general,
      notesForNextShift
    };
  };

  const formatShiftSummary = (summary: ShiftSummary): string => {
    const sections: string[] = [];
    const dateStr = format(new Date(summary.startTime), 'MMMM d, yyyy');
    const startTimeStr = format(new Date(summary.startTime), 'HH:mm');
    const endTimeStr = summary.endTime ? format(new Date(summary.endTime), 'HH:mm') : 'Ongoing';

    // Greeting
    sections.push('Dear Team,');
    sections.push('');

    // Header
    sections.push('='.repeat(60));
    sections.push(`${summary.shiftType.toUpperCase()} SHIFT REPORT`.padStart(35 + summary.shiftType.length / 2));
    sections.push('='.repeat(60));
    sections.push(`Date: ${dateStr}   Time: ${startTimeStr} - ${endTimeStr}`);
    sections.push(`SVMX: ${summary.svmxNumber}   Engineers: ${summary.engineers.join(', ')}`);
    sections.push('-'.repeat(60));

    // Critical Issues
    if (summary.errors.length > 0) {
      sections.push('CRITICAL ISSUES:');
      summary.errors.forEach(error => {
        sections.push(`- ${error.description}`);
      });
      sections.push('');
    }

    // Downtime Cases (tabular)
    if (summary.downtime.length > 0) {
      sections.push('DOWNTIME CASES:');
      sections.push('Case      Status     Duration   Description');
      summary.downtime.forEach(dt => {
        const duration = dt.dt_duration ? `${Math.floor(dt.dt_duration / 60)}h ${dt.dt_duration % 60}m` : 'Ongoing';
        sections.push(`${(dt.case_number || '').padEnd(10)} ${(dt.case_status || '').toUpperCase().padEnd(10)} ${duration.padEnd(9)} ${dt.description}`);
      });
      sections.push('');
    }

    // Work Orders (tabular)
    if (summary.workorders.length > 0) {
      sections.push('WORK ORDERS:');
      sections.push('WO Number   Status        Description');
      summary.workorders.forEach(wo => {
        sections.push(`${(wo.workorder_number || '').padEnd(11)} ${(wo.workorder_status || '').toUpperCase().padEnd(12)} ${wo.description}`);
      });
      sections.push('');
    }

    // Source Changes (concise)
    if (summary.sourceChange.length > 0) {
      sections.push('SOURCE CHANGES:');
      summary.sourceChange.forEach(sc => {
        sections.push(`- Removed: #${sc.removed_source_number} (${sc.removed_filament_current}A/${sc.removed_arc_current}mA), Inserted: #${sc.inserted_source_number} (${sc.inserted_filament_current}A/${sc.inserted_arc_current}mA)`);
      });
      sections.push('');
    }

    // Main Coil Tuning (summary)
    if (summary.mainCoilTuning.length > 0) {
      sections.push('MAIN COIL TUNING:');
      sections.push(`Sessions: ${summary.mainCoilTuning.length}`);
      const latest = summary.mainCoilTuning[0];
      sections.push(`Latest: MC=${latest.mc_setpoint}A, Yoke=${latest.yoke_temperature}°C, Fil=${latest.filament_current}A, Arc=${latest.arc_current}mA`);
      sections.push(`P1E: ${latest.p1e_x_width}/${latest.p1e_y_width}mm, P2E: ${latest.p2e_x_width}/${latest.p2e_y_width}mm`);
      sections.push('');
    }

    // General Notes
    if (summary.general.length > 0) {
      sections.push('GENERAL NOTES:');
      summary.general.forEach(note => {
        sections.push(`- ${note.description}`);
      });
      sections.push('');
    }

    // Notes for Next Shift
    if (summary.notesForNextShift) {
      sections.push('NOTES FOR NEXT SHIFT:');
      sections.push(summary.notesForNextShift);
      sections.push('');
    }

    // Closing
    sections.push('-'.repeat(60));
    sections.push('Best regards,');
    sections.push('SAT.125 Logbook System');
    sections.push('='.repeat(60));
    return sections.join('\n');
  };

  const handleSendReport = async () => {
    try {
      setSending(true);
      const shift = selectedShift === 'last' ? getLastClosedShift() : shifts[customShiftIndex];
      if (!shift) {
        throw new Error('No shift selected');
      }

      const summary = processShiftData(shift);
      const emailBody = formatShiftSummary(summary);
      const dateStr = format(new Date(summary.startTime), 'MMMM d, yyyy');
      const emailSubject = `${summary.shiftType} Report (${dateStr}) - SVMX No: ${summary.svmxNumber}`;

      // Send email using your backend API
      const response = await fetch('/api/send-shift-report', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          subject: emailSubject,
          body: emailBody,
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to send report');
      }

      onClose();
    } catch (error) {
      console.error('Error sending shift report:', error);
    } finally {
      setSending(false);
    }
  };

  const currentShift = selectedShift === 'last' ? getLastClosedShift() : shifts[customShiftIndex];
  const summary = currentShift ? processShiftData(currentShift) : null;

  return (
    <Dialog open={isOpen} onClose={onClose} className="relative z-50">
      <div className="fixed inset-0 bg-black/50" aria-hidden="true" />
      
      <div className="fixed inset-0 flex items-center justify-center p-4">
        <Dialog.Panel className="w-full max-w-4xl bg-gray-900 rounded-xl shadow-xl">
          <div className="flex items-center justify-between p-6 border-b border-gray-800">
            <Dialog.Title className="text-xl font-semibold text-white">
              Send Shift Report
            </Dialog.Title>
            <button
              onClick={onClose}
              className="text-gray-400 hover:text-white transition-colors"
            >
              <X className="h-5 w-5" />
            </button>
          </div>

          <div className="p-6 space-y-6">
            {/* Shift Selection */}
            {!showPreview && (
              <div className="space-y-4">
                <h3 className="text-lg font-medium text-white">Select Shift</h3>
                <div className="flex gap-4">
                  <button
                    onClick={() => setSelectedShift('last')}
                    className={`px-4 py-2 rounded-lg flex items-center gap-2 ${
                      selectedShift === 'last'
                        ? 'bg-blue-600 text-white'
                        : 'bg-gray-800 text-gray-300 hover:bg-gray-700'
                    }`}
                  >
                    <Mail className="h-4 w-4" />
                    Last Closed Shift
                  </button>
                  <button
                    onClick={() => setSelectedShift('custom')}
                    className={`px-4 py-2 rounded-lg flex items-center gap-2 ${
                      selectedShift === 'custom'
                        ? 'bg-blue-600 text-white'
                        : 'bg-gray-800 text-gray-300 hover:bg-gray-700'
                    }`}
                  >
                    <Calendar className="h-4 w-4" />
                    Choose Shift
                  </button>
                </div>

                {selectedShift === 'custom' && (
                  <div className="mt-4 space-y-4">
                    <h4 className="text-sm font-medium text-gray-400">Available Shifts</h4>
                    <div className="space-y-2 max-h-60 overflow-y-auto">
                      {shifts.map((shift, index) => (
                        <button
                          key={index}
                          onClick={() => setCustomShiftIndex(index)}
                          className={`w-full px-4 py-3 rounded-lg text-left ${
                            customShiftIndex === index
                              ? 'bg-blue-600 text-white'
                              : 'bg-gray-800 text-gray-300 hover:bg-gray-700'
                          }`}
                        >
                          <div className="font-medium">
                            {shift.shiftType} - {format(new Date(shift.startTime), 'MMMM d, yyyy')}
                          </div>
                          <div className="text-sm opacity-80">
                            {format(new Date(shift.startTime), 'h:mm a')} - 
                            {shift.endTime 
                              ? format(new Date(shift.endTime), ' h:mm a')
                              : ' Ongoing'}
                          </div>
                        </button>
                      ))}
                    </div>
                  </div>
                )}

                <div className="flex justify-end pt-4">
                  <button
                    onClick={() => setShowPreview(true)}
                    disabled={!currentShift}
                    className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Preview Report
                  </button>
                </div>
              </div>
            )}

            {/* Report Preview */}
            {showPreview && summary && (
              <div className="space-y-4">
                <div className="flex justify-between items-center">
                  <h3 className="text-lg font-medium text-white">Report Preview</h3>
                  <button
                    onClick={() => setShowPreview(false)}
                    className="text-sm text-gray-400 hover:text-white"
                  >
                    ← Back to Selection
                  </button>
                </div>

                <div className="bg-gray-800 rounded-lg p-4 max-h-[60vh] overflow-y-auto">
                  <pre className="whitespace-pre-wrap font-mono text-sm text-gray-300">
                    {formatShiftSummary(summary)}
                  </pre>
                </div>

                <div className="flex justify-end gap-4 pt-4">
                  <button
                    onClick={() => setShowPreview(false)}
                    className="px-4 py-2 bg-gray-800 text-white rounded-lg hover:bg-gray-700"
                  >
                    Edit
                  </button>
                  <button
                    onClick={handleSendReport}
                    disabled={sending}
                    className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-500 disabled:opacity-50"
                  >
                    {sending ? 'Sending...' : 'Send Report'}
                  </button>
                </div>
              </div>
            )}
          </div>
        </Dialog.Panel>
      </div>
    </Dialog>
  );
};

export default ShiftReport; 