import React, { useState, useEffect, useRef } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { Fragment } from 'react';
import { LogCategory, ShiftType, Status, ActiveShift, Engineer } from '../types';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';
import FileUpload from './FileUpload';
import { X, AlertCircle, Save, Loader2, CheckCircle2, Paperclip, Send, Settings, RefreshCw } from 'lucide-react';

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
  mcSetpoint: string;
  yokeTemperature: string;
  arcCurrent: string;
  filamentCurrent: string;
  pieWidth: string;
  p2eWidth: string;
  pieXWidth: string;
  p2eYWidth: string;
  removedSourceNumber: string;
  removedFilamentCurrent: string;
  removedArcCurrent: string;
  removedFilamentCounter: string;
  insertedSourceNumber: string;
  insertedFilamentCurrent: string;
  insertedArcCurrent: string;
  insertedFilamentCounter: string;
  workorderNumber: string;
  caseNumber: string;
  caseStatus?: Status;
  workorderStatus?: Status;
  engineers: string[];
}

const LogEntryForm: React.FC<LogEntryFormProps> = ({ onClose, activeShift }) => {
  const [formState, setFormState] = useState<FormState>({
    category: 'general',
    description: '',
    mcSetpoint: '748.40',
    yokeTemperature: '35.70',
    arcCurrent: '75',
    filamentCurrent: '175',
    pieWidth: '1.50',
    p2eWidth: '1.35',
    pieXWidth: '14.50',
    p2eYWidth: '18.00',
    removedSourceNumber: '1',
    removedFilamentCurrent: '175',
    removedArcCurrent: '70',
    removedFilamentCounter: '',
    insertedSourceNumber: '1',
    insertedFilamentCurrent: '175',
    insertedArcCurrent: '70',
    insertedFilamentCounter: '',
    workorderNumber: '',
    caseNumber: '',
    caseStatus: 'open',
    workorderStatus: 'open',
    engineers: [],
  });

  const [files, setFiles] = useState<File[]>([]);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [engineerList, setEngineerList] = useState<Engineer[]>([]);

  useEffect(() => {
    if (formState.category === 'data-collection' || (formState.category as string) === 'data-mc' || (formState.category as string) === 'data-sc') {
      supabase.from('engineers').select('*').then(({ data }) => {
        if (data) setEngineerList(data);
      });
    }
  }, [formState.category]);

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
          case_status: formState.caseStatus,
        } : {}),
        ...(formState.category === 'workorder' ? {
          workorder_number: formState.workorderNumber.trim(),
          workorder_status: formState.workorderStatus,
        } : {}),
        ...(formState.category === 'data-collection' ? {
          mc_setpoint: formState.mcSetpoint ? parseFloat(formState.mcSetpoint) : null,
          yoke_temperature: formState.yokeTemperature ? parseFloat(formState.yokeTemperature) : null,
          arc_current: formState.arcCurrent ? parseFloat(formState.arcCurrent) : null,
          filament_current: formState.filamentCurrent ? parseFloat(formState.filamentCurrent) : null,
          pie_width: formState.pieWidth ? parseFloat(formState.pieWidth) : null,
          p2e_width: formState.p2eWidth ? parseFloat(formState.p2eWidth) : null
        } : {}),
        ...(formState.category === 'data-mc' ? {
          mc_setpoint: formState.mcSetpoint ? parseFloat(formState.mcSetpoint) : null,
          yoke_temperature: formState.yokeTemperature ? parseFloat(formState.yokeTemperature) : null,
          arc_current: formState.arcCurrent ? parseFloat(formState.arcCurrent) : null,
          filament_current: formState.filamentCurrent ? parseFloat(formState.filamentCurrent) : null,
          pie_width: formState.pieWidth ? parseFloat(formState.pieWidth) : null,
          p2e_width: formState.p2eWidth ? parseFloat(formState.p2eWidth) : null,
          pie_x_width: formState.pieXWidth ? parseFloat(formState.pieXWidth) : null,
          p2e_y_width: formState.p2eYWidth ? parseFloat(formState.p2eYWidth) : null
        } : {}),
        ...(formState.category === 'data-sc' ? {
          removed_source_number: formState.removedSourceNumber ? parseInt(formState.removedSourceNumber) : null,
          removed_filament_current: formState.removedFilamentCurrent ? parseFloat(formState.removedFilamentCurrent) : null,
          removed_arc_current: formState.removedArcCurrent ? parseFloat(formState.removedArcCurrent) : null,
          removed_filament_counter: formState.removedFilamentCounter ? parseFloat(formState.removedFilamentCounter) : null,
          inserted_source_number: formState.insertedSourceNumber ? parseInt(formState.insertedSourceNumber) : null,
          inserted_filament_current: formState.insertedFilamentCurrent ? parseFloat(formState.insertedFilamentCurrent) : null,
          inserted_arc_current: formState.insertedArcCurrent ? parseFloat(formState.insertedArcCurrent) : null,
          inserted_filament_counter: formState.insertedFilamentCounter ? parseFloat(formState.insertedFilamentCounter) : null,
          workorder_number: formState.workorderNumber.trim(),
          case_number: formState.caseNumber.trim(),
          filament_hours: (formState.insertedFilamentCounter && formState.removedFilamentCounter)
            ? parseFloat(formState.insertedFilamentCounter) - parseFloat(formState.removedFilamentCounter)
            : null,
          engineers: formState.engineers,
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
        mcSetpoint: '748.40',
        yokeTemperature: '35.70',
        arcCurrent: '75',
        filamentCurrent: '175',
        pieWidth: '1.50',
        p2eWidth: '1.35',
        pieXWidth: '14.50',
        p2eYWidth: '18.00',
        removedSourceNumber: '1',
        removedFilamentCurrent: '175',
        removedArcCurrent: '70',
        removedFilamentCounter: '',
        insertedSourceNumber: '1',
        insertedFilamentCurrent: '175',
        insertedArcCurrent: '70',
        insertedFilamentCounter: '',
        workorderNumber: '',
        caseNumber: '',
        caseStatus: 'open',
        workorderStatus: 'open',
        engineers: [],
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
                    <div>
                      <label className="block text-sm font-medium text-gray-200 mb-1">
                        Description
                      </label>
                      <textarea
                        value={formState.description}
                        onChange={(e) => setFormState({ ...formState, description: e.target.value })}
                        rows={3}
                        placeholder="Enter log description..."
                        className={`w-full rounded-lg bg-white/5 border-0 px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 ${formState.category === 'error' ? 'text-red-400 placeholder-red-300' : 'text-white'}`}
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-200 mb-2">
                        Data Collection Type
                      </label>
                      <select
                        value={formState.category}
                        onChange={e => setFormState({ ...formState, category: e.target.value as LogCategory })}
                        className="w-full rounded-lg bg-gray-800/50 border border-gray-700 text-white px-4 py-3 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all hover:bg-gray-800/70"
                      >
                        <option value="general">📝 General Entry</option>
                        <option value="error">⚠️ Error Report</option>
                        <option value="downtime">🛠️ Downtime Record</option>
                        <option value="workorder">📋 Work Order</option>
                        <option value="data-mc">🔧 Main Coil Tuning</option>
                        <option value="data-sc">🔄 Source Change</option>
                      </select>
                    </div>

                    {formState.category === 'downtime' && (
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">Case Number</label>
                          <input
                            type="text"
                            value={formState.caseNumber}
                            onChange={e => setFormState({ ...formState, caseNumber: e.target.value })}
                            placeholder="Enter case number..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                          />
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">Status</label>
                          <div className="flex gap-2 mt-1">
                            {['open', 'in_progress', 'pending', 'closed'].map(status => (
                              <button
                                key={status}
                                type="button"
                                onClick={() => setFormState({ ...formState, caseStatus: status as Status })}
                                className={`px-3 py-1 rounded-full text-xs font-semibold border transition-all
                                  ${formState.caseStatus === status ?
                                    (status === 'open' ? 'bg-green-500/20 text-green-300 border-green-500/30' :
                                     status === 'in_progress' ? 'bg-yellow-500/20 text-yellow-300 border-yellow-500/30' :
                                     status === 'pending' ? 'bg-orange-500/20 text-orange-300 border-orange-500/30' :
                                     'bg-gray-500/20 text-gray-300 border-gray-500/30')
                                    : 'bg-gray-800/40 text-gray-400 border-gray-700 hover:bg-gray-700/40'}`}
                              >
                                {status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}
                              </button>
                            ))}
                          </div>
                        </div>
                      </div>
                    )}

                    {formState.category === 'workorder' && (
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">Work Order Number</label>
                          <input
                            type="text"
                            value={formState.workorderNumber}
                            onChange={e => setFormState({ ...formState, workorderNumber: e.target.value })}
                            placeholder="Enter work order number..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                          />
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">Status</label>
                          <div className="flex gap-2 mt-1">
                            {['open', 'in_progress', 'pending', 'closed'].map(status => (
                              <button
                                key={status}
                                type="button"
                                onClick={() => setFormState({ ...formState, workorderStatus: status as Status })}
                                className={`px-3 py-1 rounded-full text-xs font-semibold border transition-all
                                  ${formState.workorderStatus === status ?
                                    (status === 'open' ? 'bg-green-500/20 text-green-300 border-green-500/30' :
                                     status === 'in_progress' ? 'bg-yellow-500/20 text-yellow-300 border-yellow-500/30' :
                                     status === 'pending' ? 'bg-orange-500/20 text-orange-300 border-orange-500/30' :
                                     'bg-gray-500/20 text-gray-300 border-gray-500/30')
                                    : 'bg-gray-800/40 text-gray-400 border-gray-700 hover:bg-gray-700/40'}`}
                              >
                                {status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}
                              </button>
                            ))}
                          </div>
                        </div>
                      </div>
                    )}

                    {formState.category === 'data-mc' && (
                      <div className="space-y-6">
                        <div className="flex items-center text-md font-semibold text-indigo-300 mb-2"><Settings className="mr-2 text-indigo-400 w-6 h-6" /> Main Coil Tuning</div>
                        <div className="grid grid-cols-2 gap-4">
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Main coil setpoint (A)</label>
                            <input type="number" step="0.01" min="0" value={formState.mcSetpoint} onChange={e => setFormState({ ...formState, mcSetpoint: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Yoke Temperature (°C)</label>
                            <input type="number" step="0.01" min="0" value={formState.yokeTemperature} onChange={e => setFormState({ ...formState, yokeTemperature: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Filament Current (A)</label>
                            <input type="number" step="1" value={formState.filamentCurrent} onChange={e => setFormState({ ...formState, filamentCurrent: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Arc Current (mA)</label>
                            <input type="number" step="1" value={formState.arcCurrent} onChange={e => setFormState({ ...formState, arcCurrent: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">PIE X width (mm)</label>
                            <input type="number" step="0.1" value={formState.pieWidth} onChange={e => setFormState({ ...formState, pieWidth: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">PIE Y width (mm)</label>
                            <input type="number" step="0.1" value={formState.p2eWidth} onChange={e => setFormState({ ...formState, p2eWidth: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">P2E X width (mm)</label>
                            <input type="number" step="0.1" value={formState.pieXWidth} onChange={e => setFormState({ ...formState, pieXWidth: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">P2E Y width (mm)</label>
                            <input type="number" step="0.1" value={formState.p2eYWidth} onChange={e => setFormState({ ...formState, p2eYWidth: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                          </div>
                        </div>
                      </div>
                    )}

                    {formState.category === 'data-sc' && (
                      <div className="space-y-6">
                        <div className="flex items-center text-md font-semibold text-indigo-300 mb-2"><RefreshCw className="mr-2 text-green-400 w-6 h-6" /> Removed Source Data</div>
                        <div className="bg-red-900/20 border border-red-700/30 rounded-lg p-4 mb-2">
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Source Number</label>
                              <select value={formState.removedSourceNumber} onChange={e => setFormState({ ...formState, removedSourceNumber: e.target.value })} className="w-full rounded-lg bg-gray-800/50 border border-gray-700 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 [&>option]:bg-gray-800 [&>option]:text-white">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                              </select>
                            </div>
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Filament Current (A)</label>
                              <input type="number" step="1" value={formState.removedFilamentCurrent} onChange={e => setFormState({ ...formState, removedFilamentCurrent: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                            </div>
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Arc Current (mA)</label>
                              <input type="number" step="1" value={formState.removedArcCurrent} onChange={e => setFormState({ ...formState, removedArcCurrent: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                            </div>
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Filament Counter</label>
                              <input type="number" step="1" value={formState.removedFilamentCounter} onChange={e => setFormState({ ...formState, removedFilamentCounter: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                            </div>
                          </div>
                        </div>
                        <div className="flex items-center text-md font-semibold text-indigo-300 mb-2"><RefreshCw className="mr-2 text-green-400 w-6 h-6" /> Inserted Source Data</div>
                        <div className="bg-green-900/20 border border-green-700/30 rounded-lg p-4 mb-2">
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Source Number</label>
                              <select value={formState.insertedSourceNumber} onChange={e => setFormState({ ...formState, insertedSourceNumber: e.target.value })} className="w-full rounded-lg bg-gray-800/50 border border-gray-700 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 [&>option]:bg-gray-800 [&>option]:text-white">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                              </select>
                            </div>
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Filament Current (A)</label>
                              <input type="number" step="1" value={formState.insertedFilamentCurrent} onChange={e => setFormState({ ...formState, insertedFilamentCurrent: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                            </div>
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Arc Current (mA)</label>
                              <input type="number" step="1" value={formState.insertedArcCurrent} onChange={e => setFormState({ ...formState, insertedArcCurrent: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                            </div>
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Filament Counter</label>
                              <input type="number" step="1" value={formState.insertedFilamentCounter} onChange={e => setFormState({ ...formState, insertedFilamentCounter: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                            </div>
                          </div>
                        </div>
                        <div>
                          <h4 className="text-md font-semibold text-indigo-300 mb-2">Svmx / Pridex</h4>
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Work Order Number</label>
                              <input type="text" value={formState.workorderNumber} onChange={e => setFormState({ ...formState, workorderNumber: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                            </div>
                            <div>
                              <label className="block text-sm font-medium text-gray-200 mb-1">Svmx Case Number</label>
                              <input type="text" value={formState.caseNumber} onChange={e => setFormState({ ...formState, caseNumber: e.target.value })} className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500" />
                            </div>
                          </div>
                        </div>
                        <div>
                          <h4 className="text-md font-semibold text-indigo-300 mb-2">Filament Hours</h4>
                          <p className="text-sm text-gray-300">
                            {formState.insertedFilamentCounter && formState.removedFilamentCounter
                              ? (parseFloat(formState.insertedFilamentCounter) - parseFloat(formState.removedFilamentCounter)).toFixed(2)
                              : '—'}
                          </p>
                        </div>
                        <div className="mb-2 grid grid-cols-2 gap-4">
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Engineer 1</label>
                            <select
                              value={formState.engineers[0] || ''}
                              onChange={e => {
                                const newEngineers = [...formState.engineers];
                                newEngineers[0] = e.target.value;
                                setFormState({ ...formState, engineers: newEngineers.filter(Boolean) });
                              }}
                              className="w-full rounded-lg bg-gray-800/50 border border-gray-700 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                            >
                              <option value="">Select engineer</option>
                              {engineerList.map(e => (
                                <option key={e.id} value={e.id}>{e.name}</option>
                              ))}
                            </select>
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Engineer 2</label>
                            <select
                              value={formState.engineers[1] || ''}
                              onChange={e => {
                                const newEngineers = [...formState.engineers];
                                newEngineers[1] = e.target.value;
                                setFormState({ ...formState, engineers: newEngineers.filter(Boolean) });
                              }}
                              className="w-full rounded-lg bg-gray-800/50 border border-gray-700 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                            >
                              <option value="">Select engineer</option>
                              {engineerList.map(e => (
                                <option key={e.id} value={e.id}>{e.name}</option>
                              ))}
                            </select>
                          </div>
                        </div>
                      </div>
                    )}

                    <div className="flex flex-col items-start mt-2 mb-2">
                      <label className="block text-xs font-medium text-gray-400 mb-1">Attachments</label>
                      <div className="max-w-xs w-full"><FileUpload files={files} onFilesChange={setFiles} /></div>
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
                        className="px-6 py-2 bg-indigo-600 text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 disabled:bg-gray-600 disabled:cursor-not-allowed transition-all transform hover:scale-105 hover:bg-indigo-700 hover:shadow-lg flex items-center space-x-2"
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