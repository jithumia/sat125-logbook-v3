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

  const pad = (str: string, len: number) => (str || '').toString().padEnd(len, ' ');

  const formatShiftSummary = (summary: ShiftSummary): string => {
    const sections: string[] = [];
    const dateStr = format(new Date(summary.startTime), 'MMMM d, yyyy');

    // Greeting and intro
    sections.push('Dear Team,');
    sections.push('');
    sections.push(`Please find the following report summarizing the ${summary.shiftType} Shift activities and events for SVMX No: ${summary.svmxNumber} on ${dateStr}:`);
    sections.push('');
    if (summary.engineers.length > 0) {
      sections.push(`Engineers: ${summary.engineers.join(', ')}`);
      sections.push('');
    }

    // General
    if (summary.general.length > 0) {
      sections.push('');
      sections.push('GENERAL:');
      summary.general.forEach(note => {
        sections.push(note.description);
      });
    }

    // Main Coil Tuning Entries
    if (summary.mainCoilTuning.length > 0) {
      sections.push('');
      sections.push('MAIN COIL TUNING ENTRIES:');
      sections.push(`Sessions: ${summary.mainCoilTuning.length}`);
      summary.mainCoilTuning.forEach(entry => {
        sections.push(
          `MC Current setpoint: ${entry.mc_setpoint} A | Filament Current: ${entry.filament_current} A | Arc Current: ${entry.arc_current} mA | Yoke Temperature: ${entry.yoke_temperature} c | P1E Width: X: ${entry.p1e_x_width}mm,  Y: ${entry.p1e_y_width}mm | P2E Width: X: ${entry.p2e_x_width}mm,  Y: ${entry.p2e_y_width}mm`
        );
      });
    }

    // Errors
    if (summary.errors.length > 0) {
      sections.push('');
      sections.push('ERRORS:');
      summary.errors.forEach(error => {
        sections.push(error.description);
      });
    }

    // Source changes
    let latestSourceChange = summary.sourceChange.length > 0 ? summary.sourceChange[summary.sourceChange.length - 1] : null;
    let latestMainCoil = summary.mainCoilTuning.length > 0 ? summary.mainCoilTuning[summary.mainCoilTuning.length - 1] : null;
    let currentSourceLine = '';
    if (latestSourceChange && latestMainCoil) {
      currentSourceLine = `Current installed source: #${latestSourceChange.inserted_source_number} | Filament current: ${latestMainCoil.filament_current} A | Arc current: ${latestMainCoil.arc_current} mA`;
    } else if (latestSourceChange) {
      currentSourceLine = `Current installed source: #${latestSourceChange.inserted_source_number}`;
    } else if (latestMainCoil) {
      currentSourceLine = `Current installed source: (unknown) | Filament current: ${latestMainCoil.filament_current} A | Arc current: ${latestMainCoil.arc_current} mA`;
    } else {
      currentSourceLine = `Current installed source: (unknown)`;
    }
    sections.push('');
    sections.push('SOURCE CHANGES:');
    sections.push(currentSourceLine);
    if (summary.sourceChange.length === 0) {
      sections.push('no source change happened in this shift');
    } else {
      sections.push(`Source changes: ${summary.sourceChange.length}`);
      summary.sourceChange.forEach(sc => {
        sections.push(
          `Removed Source: #${sc.removed_source_number} Filament current ${sc.removed_filament_current}A Arc current ${sc.removed_arc_current}mA, Inserted Source : #${sc.inserted_source_number} Filament current ${sc.inserted_filament_current}A Arc current ${sc.inserted_arc_current}mA`
        );
      });
    }

    // Downtime
    if (summary.downtime.length > 0) {
      sections.push('');
      sections.push('DOWNTIME:');
      sections.push(`${pad('Case', 10)}${pad('Status', 14)}${pad('Duration', 10)}Description`);
      summary.downtime.forEach(dt => {
        const duration = dt.dt_duration ? `${Math.floor(dt.dt_duration / 60)}h ${dt.dt_duration % 60}m` : 'Ongoing';
        sections.push(
          `${pad(dt.case_number || '', 10)}${pad((dt.case_status || '').toUpperCase(), 14)}${pad(duration, 10)}${dt.description}`
        );
      });
    }

    // Workorder
    if (summary.workorders.length > 0) {
      sections.push('');
      sections.push('WORKORDER:');
      sections.push(`${pad('WO Number', 10)}${pad('Status', 14)}Description`);
      summary.workorders.forEach(wo => {
        sections.push(
          `${pad(wo.workorder_number || '', 10)}${pad((wo.workorder_status || '').toUpperCase(), 14)}${wo.description}`
        );
      });
    }

    // Notes for Next Shift
    let notesForNextShift = summary.notesForNextShift || '';
    let filamentArcNote = '';
    const shiftEndEntry = currentShift?.logs.find(log => log.category === 'shift' && log.description.toLowerCase().includes('shift ended'));
    if (shiftEndEntry) {
      // Try to extract filament and arc current from the description
      // Example: '...Filament: 182.54A, Arc: 133.30mA ...'
      const filamentMatch = shiftEndEntry.description.match(/filament[:=]?\s*([\d.]+)\s*a/i);
      const arcMatch = shiftEndEntry.description.match(/arc[:=]?\s*([\d.]+)\s*m?a/i);
      if (filamentMatch || arcMatch) {
        filamentArcNote = `Filament: ${filamentMatch ? filamentMatch[1] + 'A' : ''}${filamentMatch && arcMatch ? ', ' : ''}${arcMatch ? 'Arc: ' + arcMatch[1] + 'mA' : ''}`;
      }
      // If the note is in the description after 'Note:'
      const noteMatch = shiftEndEntry.description.match(/note[:=]?\s*(.*)$/i);
      if (noteMatch && noteMatch[1]) {
        notesForNextShift = noteMatch[1].trim();
      }
    }
    if (filamentArcNote || notesForNextShift) {
      sections.push('');
      sections.push('NOTES FOR NEXT SHIFT:');
      if (filamentArcNote) sections.push(filamentArcNote);
      if (notesForNextShift && (!filamentArcNote || notesForNextShift !== filamentArcNote)) sections.push(notesForNextShift);
    }

    // Closing
    sections.push('');
    sections.push('Thank you,');
    sections.push(`${summary.shiftType} Shift Team`);

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
      const response = await fetch('http://10.2.70.221:5000/send_shift_report', {
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