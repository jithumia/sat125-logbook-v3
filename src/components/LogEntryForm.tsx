import React, { useState, useEffect, useRef } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { Fragment } from 'react';
import { LogCategory, ShiftType, Status, ActiveShift } from '../types';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';
import FileUpload from './FileUpload';
import { X, AlertCircle, Save, Loader2, CheckCircle2, Paperclip, Send } from 'lucide-react';

interface LogEntryFormProps {
  onClose: () => void;
  activeShift: ActiveShift | null;
}

interface Suggestion {
  id: string;
  category: LogCategory;
  description: string;
  usage_count: number;
}

interface SuggestionCache {
  [key: string]: {
    data: Suggestion[];
    timestamp: number;
  };
}

interface FormState {
  category: LogCategory;
  description: string;
  caseNumber: string;
  caseStatus: Status;
  workorderNumber: string;
  workorderStatus: Status;
  mcSetpoint: string;
  yokeTemperature: string;
  arcCurrent: string;
  filamentCurrent: string;
  pieWidth: string;
  p2eWidth: string;
}

const LogEntryForm: React.FC<LogEntryFormProps> = ({ onClose, activeShift }) => {
  const [formState, setFormState] = useState<FormState>({
    category: 'general',
    description: '',
    caseNumber: '',
    caseStatus: 'open',
    workorderNumber: '',
    workorderStatus: 'open',
    mcSetpoint: '',
    yokeTemperature: '',
    arcCurrent: '',
    filamentCurrent: '',
    pieWidth: '',
    p2eWidth: ''
  });

  const [files, setFiles] = useState<File[]>([]);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!formState.description.trim()) {
      toast.error('Please enter a description');
      return;
    }

    if (!activeShift) {
      toast.error('No active shift found');
      return;
    }

    setIsSubmitting(true);

    try {
      const { data: { session }, error: sessionError } = await supabase.auth.getSession();
      
      if (sessionError) throw sessionError;
      if (!session) {
        toast.error('No active session found');
        setIsSubmitting(false);
        return;
      }

      // Create the log entry
      const logEntry = {
        shift_type: activeShift.shift_type,
        category: formState.category,
        description: formState.description.trim(),
        user_id: session.user.id,
        ...(formState.category === 'downtime' ? {
          case_number: formState.caseNumber.trim(),
          case_status: formState.caseStatus
        } : {}),
        ...(formState.category === 'workorder' ? {
          workorder_number: formState.workorderNumber.trim(),
          workorder_status: formState.workorderStatus
        } : {}),
        ...(formState.category === 'data-collection' ? {
          mc_setpoint: formState.mcSetpoint ? parseFloat(formState.mcSetpoint) : null,
          yoke_temperature: formState.yokeTemperature ? parseFloat(formState.yokeTemperature) : null,
          arc_current: formState.arcCurrent ? parseFloat(formState.arcCurrent) : null,
          filament_current: formState.filamentCurrent ? parseFloat(formState.filamentCurrent) : null,
          pie_width: formState.pieWidth ? parseFloat(formState.pieWidth) : null,
          p2e_width: formState.p2eWidth ? parseFloat(formState.p2eWidth) : null
        } : {})
      };

      console.log('Creating log entry:', logEntry);

      // Insert log entry and get the result
      const { data: newLog, error: logError } = await supabase
        .from('log_entries')
        .insert([logEntry])
        .select('*')
        .single();

      if (logError) {
        console.error('Error creating log entry:', logError);
        throw new Error(`Failed to create log entry: ${logError.message}`);
      }

      if (!newLog) {
        throw new Error('Failed to create log entry: No data returned');
      }

      // Upload attachments if any
      if (files.length > 0) {
        const uploadPromises = files.map(async (file) => {
          try {
          const fileExt = file.name.split('.').pop();
            const fileName = `${newLog.id}_${Date.now()}.${fileExt}`;
            const filePath = fileName; // Simplified path structure

            console.log('Attempting to upload file:', {
              fileName,
              fileType: file.type,
              fileSize: file.size
            });

            // Upload file to storage
            const { data: uploadData, error: uploadError } = await supabase.storage
            .from('attachments')
              .upload(filePath, file, {
                cacheControl: '3600',
                upsert: true
              });

            if (uploadError) {
              console.error('Upload error:', uploadError);
              throw new Error(`Failed to upload file: ${uploadError.message}`);
            }

            console.log('File uploaded successfully:', uploadData);

            // Get the public URL
            const { data } = supabase.storage
              .from('attachments')
              .getPublicUrl(filePath);

            // Create attachment record
          const { error: attachmentError } = await supabase
            .from('attachments')
              .insert({
                log_entry_id: newLog.id,
              file_name: file.name,
              file_type: file.type,
              file_size: file.size,
              file_path: filePath,
                public_url: data.publicUrl,
                user_id: session.user.id
              });

            if (attachmentError) {
              console.error('Attachment record error:', attachmentError);
              // If attachment record fails, delete the uploaded file
              await supabase.storage
                .from('attachments')
                .remove([filePath]);
              throw new Error(`Failed to create attachment record: ${attachmentError.message}`);
            }

            return { filePath, fileName: file.name };
          } catch (error) {
            console.error('Error processing file:', error);
            throw error;
          }
        });

        try {
          await Promise.all(uploadPromises);
          toast.success('Files uploaded successfully');
        } catch (error) {
          console.error('File upload process error:', error);
          toast.error(error instanceof Error ? error.message : 'Failed to upload files');
          throw error;
        }
      }

      // Success - reset form and close
      toast.success('Entry added successfully');
      setFormState({
        category: 'general',
        description: '',
        caseNumber: '',
        caseStatus: 'open',
        workorderNumber: '',
        workorderStatus: 'open',
        mcSetpoint: '',
        yokeTemperature: '',
        arcCurrent: '',
        filamentCurrent: '',
        pieWidth: '',
        p2eWidth: ''
      });
      setFiles([]);
        onClose();
    } catch (error) {
      console.error('Error adding entry:', error);
      toast.error(error instanceof Error ? error.message : 'Failed to add entry');
    } finally {
      setIsSubmitting(false);
    }
  };

  const getCategoryColor = (category: LogCategory) => {
    switch (category) {
      case 'error': return 'bg-red-500/20 text-red-300 border-red-500/30';
      case 'downtime': return 'bg-yellow-500/20 text-yellow-300 border-yellow-500/30';
      case 'workorder': return 'bg-blue-500/20 text-blue-300 border-blue-500/30';
      case 'data-collection': return 'bg-purple-500/20 text-purple-300 border-purple-500/30';
      default: return 'bg-gray-500/20 text-gray-300 border-gray-500/30';
    }
  };

  return (
    <Transition appear show={true} as={Fragment}>
      <Dialog as="div" className="relative z-50" onClose={onClose}>
        <Transition.Child
          as={Fragment}
          enter="ease-out duration-300"
          enterFrom="opacity-0"
          enterTo="opacity-100"
          leave="ease-in duration-200"
          leaveFrom="opacity-100"
          leaveTo="opacity-0"
        >
          <div className="fixed inset-0 bg-black/70 backdrop-blur-sm" />
        </Transition.Child>

        <div className="fixed inset-0 overflow-y-auto">
          <div className="flex min-h-full items-center justify-center p-4">
            <Transition.Child
              as={Fragment}
              enter="ease-out duration-300"
              enterFrom="opacity-0 scale-95"
              enterTo="opacity-100 scale-100"
              leave="ease-in duration-200"
              leaveFrom="opacity-100 scale-100"
              leaveTo="opacity-0 scale-95"
            >
              <Dialog.Panel className="w-full max-w-2xl max-h-[90vh] overflow-y-auto bg-gray-900/95 backdrop-blur-xl rounded-xl shadow-xl border border-gray-700">
                <div className="p-6">
                  <div className="flex items-center justify-between mb-6">
                    <Dialog.Title className="text-2xl font-semibold text-white flex items-center space-x-3">
                      <span>New Log Entry</span>
                      <span className={`text-sm px-3 py-1 rounded-full border ${getCategoryColor(formState.category)}`}>
                        {formState.category.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}
                      </span>
                    </Dialog.Title>
                    <button
                      onClick={onClose}
                      className="text-gray-400 hover:text-white transition-colors p-2 hover:bg-white/10 rounded-lg"
                    >
                      <X className="h-6 w-6" />
                    </button>
                  </div>

                  <form onSubmit={handleSubmit} className="space-y-6">
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-200 mb-2">
                          Category
                        </label>
                      <select
                        value={formState.category}
                        onChange={(e) => setFormState({ ...formState, category: e.target.value as LogCategory })}
                        className="w-full rounded-lg bg-gray-800/50 border border-gray-700 text-white px-4 py-3 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all hover:bg-gray-800/70 [&>option]:bg-gray-800 [&>option]:text-white cursor-pointer appearance-none bg-[url('data:image/svg+xml;charset=utf-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2224%22%20height%3D%2224%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpolyline%20points%3D%226%209%2012%2015%2018%209%22%3E%3C%2Fpolyline%3E%3C%2Fsvg%3E')] bg-no-repeat bg-right-4 bg-[length:20px] pr-12 [&>option]:py-2 [&>option]:px-4 [&>option]:cursor-pointer [&>option:hover]:bg-gray-700"
                        aria-label="Select log entry category"
                      >
                          <option value="general">📝 General Entry</option>
                          <option value="error">⚠️ Error Report</option>
                          <option value="downtime">🔄 Downtime Record</option>
                          <option value="workorder">📋 Work Order</option>
                          <option value="data-collection">📊 Data Collection</option>
                      </select>
                    </div>
                    </div>

                    {formState.category === 'downtime' && (
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">
                            Case Number
                          </label>
                          <input
                            type="text"
                            value={formState.caseNumber}
                            onChange={(e) => setFormState({ ...formState, caseNumber: e.target.value })}
                            placeholder="Enter case number..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                          />
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">
                            Status
                          </label>
                          <select
                            value={formState.caseStatus}
                            onChange={(e) => setFormState({ ...formState, caseStatus: e.target.value as Status })}
                            className="w-full rounded-lg bg-gray-800/50 border border-gray-700 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all hover:bg-gray-800/70 [&>option]:bg-gray-800 [&>option]:text-white cursor-pointer appearance-none bg-[url('data:image/svg+xml;charset=utf-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2224%22%20height%3D%2224%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpolyline%20points%3D%226%209%2012%2015%2018%209%22%3E%3C%2Fpolyline%3E%3C%2Fsvg%3E')] bg-no-repeat bg-right-4 bg-[length:20px] pr-12"
                          >
                            <option value="open" className="text-white bg-gray-800 hover:bg-gray-700">🟢 Open</option>
                            <option value="in_progress" className="text-white bg-gray-800 hover:bg-gray-700">🔄 In Progress</option>
                            <option value="closed" className="text-white bg-gray-800 hover:bg-gray-700">✅ Closed</option>
                            <option value="pending" className="text-white bg-gray-800 hover:bg-gray-700">⏳ Pending</option>
                          </select>
                        </div>
                      </div>
                    )}

                    {formState.category === 'workorder' && (
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">
                            Work Order Number
                          </label>
                          <input
                            type="text"
                            value={formState.workorderNumber}
                            onChange={(e) => setFormState({ ...formState, workorderNumber: e.target.value })}
                            placeholder="Enter work order number..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                          />
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">
                            Status
                          </label>
                          <select
                            value={formState.workorderStatus}
                            onChange={(e) => setFormState({ ...formState, workorderStatus: e.target.value as Status })}
                            className="w-full rounded-lg bg-gray-800/50 border border-gray-700 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all hover:bg-gray-800/70 [&>option]:bg-gray-800 [&>option]:text-white cursor-pointer appearance-none bg-[url('data:image/svg+xml;charset=utf-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2224%22%20height%3D%2224%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpolyline%20points%3D%226%209%2012%2015%2018%209%22%3E%3C%2Fpolyline%3E%3C%2Fsvg%3E')] bg-no-repeat bg-right-4 bg-[length:20px] pr-12"
                          >
                            <option value="open" className="text-white bg-gray-800 hover:bg-gray-700">🟢 Open</option>
                            <option value="in_progress" className="text-white bg-gray-800 hover:bg-gray-700">🔄 In Progress</option>
                            <option value="closed" className="text-white bg-gray-800 hover:bg-gray-700">✅ Closed</option>
                            <option value="pending" className="text-white bg-gray-800 hover:bg-gray-700">⏳ Pending</option>
                          </select>
                        </div>
                      </div>
                    )}

                    {formState.category === 'data-collection' && (
                        <div className="grid grid-cols-2 gap-4">
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              MC Setpoint
                            </label>
                            <input
                              type="number"
                            step="0.01"
                              value={formState.mcSetpoint}
                            onChange={(e) => setFormState({ ...formState, mcSetpoint: e.target.value })}
                              placeholder="Enter MC setpoint..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                            Yoke Temperature (°C)
                            </label>
                            <input
                              type="number"
                            step="0.1"
                              value={formState.yokeTemperature}
                            onChange={(e) => setFormState({ ...formState, yokeTemperature: e.target.value })}
                              placeholder="Enter yoke temperature..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                            Arc Current (A)
                            </label>
                            <input
                              type="number"
                            step="0.1"
                              value={formState.arcCurrent}
                            onChange={(e) => setFormState({ ...formState, arcCurrent: e.target.value })}
                              placeholder="Enter arc current..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                            Filament Current (A)
                            </label>
                            <input
                              type="number"
                            step="0.1"
                              value={formState.filamentCurrent}
                            onChange={(e) => setFormState({ ...formState, filamentCurrent: e.target.value })}
                              placeholder="Enter filament current..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              PIE Width
                            </label>
                            <input
                              type="number"
                            step="0.1"
                              value={formState.pieWidth}
                            onChange={(e) => setFormState({ ...formState, pieWidth: e.target.value })}
                              placeholder="Enter PIE width..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              P2E Width
                            </label>
                            <input
                              type="number"
                            step="0.1"
                              value={formState.p2eWidth}
                            onChange={(e) => setFormState({ ...formState, p2eWidth: e.target.value })}
                              placeholder="Enter P2E width..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                            />
                        </div>
                      </div>
                    )}

                    <div>
                      <label className="block text-sm font-medium text-gray-200 mb-1">
                        Description
                      </label>
                      <textarea
                        value={formState.description}
                        onChange={(e) => setFormState({ ...formState, description: e.target.value })}
                        rows={3}
                        placeholder="Enter log description..."
                        className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-200 mb-1">
                        Attachments
                      </label>
                      <FileUpload files={files} onFilesChange={setFiles} />
                  </div>

                    <div className="flex justify-end space-x-3 pt-6 border-t border-gray-700">
                    <button
                      type="button"
                      onClick={onClose}
                        className="px-4 py-2 text-gray-300 hover:text-white transition-colors hover:bg-white/10 rounded-lg"
                    >
                        Cancel
                    </button>
                    <button
                      type="submit"
                        disabled={isSubmitting}
                        className="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 disabled:bg-gray-600 disabled:cursor-not-allowed transition-all transform hover:scale-105 flex items-center space-x-2"
                    >
                        {isSubmitting ? (
                        <>
                            <div className="h-5 w-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                            <span>Adding...</span>
                        </>
                      ) : (
                        <>
                            <Send className="h-5 w-5" />
                            <span>Add Entry</span>
                        </>
                      )}
                    </button>
                  </div>
                </form>
                </div>
              </Dialog.Panel>
            </Transition.Child>
          </div>
        </div>
      </Dialog>
    </Transition>
  );
};

export default LogEntryForm;