import React, { useState, useEffect, useRef } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { Fragment } from 'react';
import { LogCategory, ShiftType, Status, ActiveShift, Engineer } from '../types';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';
import FileUpload from './FileUpload';
import { X, AlertCircle, Save, Loader2, CheckCircle2, Paperclip, Send, Settings, RefreshCw } from 'lucide-react';
import { differenceInMinutes, format, parseISO } from 'date-fns';
import { DateTimeInput } from './DateTimeInput';

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

interface ValidationErrors {
  [key: string]: boolean;
}

interface FormState {
  category: LogCategory;
  description: string;
  shift_type: ShiftType;
  case_number?: string;
  case_status?: Status;
  workorder_number?: string;
  workorder_title?: string;
  workorder_status?: Status;
  // Main Coil Tuning Data
  mc_setpoint?: number;
  yoke_temperature?: number;
  arc_current?: number;
  filament_current?: number;
  p1e_x_width?: number;
  p1e_y_width?: number;
  p2e_x_width?: number;
  p2e_y_width?: number;
  // Source Change Data
  removed_source_number?: number;
  removed_filament_current?: number;
  removed_arc_current?: number;
  removed_filament_counter?: number;
  inserted_source_number?: number;
  inserted_filament_current?: number;
  inserted_arc_current?: number;
  inserted_filament_counter?: number;
  filament_hours?: number;
  engineers?: string[];
  dt_start_time?: string;
  dt_end_time?: string | null;
  dt_duration?: number | null;
  workorder_id: string;
  prefered_start_time: string;
  location: string;
  downtime_id?: string;
}

type EngineerListItem = {
  id: string;
  name: string;
  user_id: string;
  created_at: string;
};

const initialState: FormState = {
  category: 'general',
    description: '',
  shift_type: 'morning',
  // Main Coil Tuning Data
  mc_setpoint: 748.40,
  yoke_temperature: 35.75,
  arc_current: 75,
  filament_current: 175,
  p1e_x_width: 1.5,
  p1e_y_width: 1.30,
  p2e_x_width: 14.50,
  p2e_y_width: 17.5,
  // Source Change Data
  removed_source_number: undefined,
  removed_filament_current: undefined,
  removed_arc_current: undefined,
  removed_filament_counter: undefined,
  inserted_source_number: undefined,
  inserted_filament_current: undefined,
  inserted_arc_current: undefined,
  inserted_filament_counter: undefined,
  filament_hours: undefined,
  engineers: [],
  dt_start_time: new Date().toISOString(),
  dt_end_time: null,
  dt_duration: null,
  workorder_title: '',
  workorder_id: '',
  prefered_start_time: '',
  location: '',
  downtime_id: undefined,
};

const LogEntryForm: React.FC<LogEntryFormProps> = ({ onClose, activeShift }) => {
  const [formState, setFormState] = useState<FormState>(initialState);
  const [files, setFiles] = useState<File[]>([]);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [engineerList, setEngineerList] = useState<EngineerListItem[]>([]);
  const [validationErrors, setValidationErrors] = useState<ValidationErrors>({});
  const [showValidationMessage, setShowValidationMessage] = useState(false);
  // Workorder modal state
  const [showWorkorderModal, setShowWorkorderModal] = useState(false);
  const [workorders, setWorkorders] = useState<any[]>([]);
  const [workorderSearch, setWorkorderSearch] = useState('');
  const [workorderMode, setWorkorderMode] = useState<'manual'|'pm'>('manual');
  // Add lastSourceChange state here
  const [lastSourceChange, setLastSourceChange] = useState<any>(null);

  // Add a ref to track if the form is mounted
  const isMounted = useRef(true);
  
  useEffect(() => {
    // Handle visibility change to ensure form inputs stay responsive
    const handleVisibilityChange = () => {
      if (document.visibilityState === 'visible' && isMounted.current) {
        console.log('LogEntryForm: Tab visible, ensuring inputs are working');
        // No need to force blur/focus - let browser handle it naturally
      }
    };
    
    // Handle form focus 
    const handleFormFocus = () => {
      // This helps fix copy-paste issues but more gently
      const focusedElement = document.activeElement;
      if (focusedElement instanceof HTMLInputElement || 
          focusedElement instanceof HTMLTextAreaElement || 
          focusedElement instanceof HTMLSelectElement) {
        // Just log and let the browser handle it naturally
        console.log('Input element focused after tab switch');
      }
    };
    
    document.addEventListener('visibilitychange', handleVisibilityChange);
    window.addEventListener('focus', handleFormFocus);
    
    // Cleanup on unmount
    return () => {
      isMounted.current = false;
      document.removeEventListener('visibilitychange', handleVisibilityChange);
      window.removeEventListener('focus', handleFormFocus);
    };
  }, []);

  // Fetch the most recent source change log when category is set to 'data-sc'
  useEffect(() => {
    if (formState.category === 'data-sc') {
      (async () => {
        const { data, error } = await supabase
          .from('log_entries')
          .select('*')
          .eq('category', 'data-sc')
          .order('created_at', { ascending: false })
          .limit(1)
          .single();
        if (!error && data) {
          setLastSourceChange(data);
          // Only set defaults if not already set (i.e., on first switch to data-sc)
          setFormState(prev => ({
            ...prev,
            removed_source_number: prev.removed_source_number || data.inserted_source_number,
            removed_filament_counter: prev.removed_filament_counter || data.inserted_filament_counter
          }));
        }
      })();
    }
  }, [formState.category]);

  // Add this useEffect after the other useEffects in LogEntryForm:
  useEffect(() => {
    if (showWorkorderModal) {
      (async () => {
        const { data, error } = await supabase
          .from('workorders')
          .select('*')
          .order('prefered_start_time', { ascending: true });
        if (!error && data) {
          setWorkorders(data);
        } else {
          setWorkorders([]);
        }
      })();
    }
  }, [showWorkorderModal]);

  // Add this useEffect after the other useEffects in LogEntryForm:
  useEffect(() => {
    async function fetchEngineers() {
        const { data, error } = await supabase
        .from('engineers')
        .select('id, name, user_id, created_at')
        .order('name');
      if (!error && data) {
        setEngineerList(data);
      }
    }
    fetchEngineers();
  }, []);

  // Add this useEffect after lastSourceChange and formState are defined:
  useEffect(() => {
    if (
      formState.category === 'data-sc' &&
      typeof formState.removed_filament_counter === 'number' &&
      lastSourceChange && typeof lastSourceChange.removed_filament_counter === 'number'
    ) {
      setFormState(prev => ({
        ...prev,
        filament_hours: formState.removed_filament_counter! - lastSourceChange.removed_filament_counter!
      }));
    } else if (formState.category === 'data-sc') {
      setFormState(prev => ({
        ...prev,
        filament_hours: undefined
      }));
    }
  }, [formState.category, formState.removed_filament_counter, lastSourceChange]);

  const validateSourceChangeData = (formState: FormState): ValidationErrors => {
    const errors: ValidationErrors = {};
    if (formState.category === 'data-sc') {
      errors.removed_source_number = formState.removed_source_number == null;
      errors.removed_filament_current = formState.removed_filament_current == null;
      errors.removed_arc_current = formState.removed_arc_current == null;
      errors.removed_filament_counter = formState.removed_filament_counter == null;
      errors.inserted_source_number = formState.inserted_source_number == null;
      errors.inserted_filament_current = formState.inserted_filament_current == null;
      errors.inserted_arc_current = formState.inserted_arc_current == null;
      errors.engineers = !formState.engineers || formState.engineers.length === 0;
      errors.workorder_number = !formState.workorder_number;
      // case_number is optional
    }
    return errors;
  };

  const validateMainCoilData = (formState: FormState): ValidationErrors => {
    const errors: ValidationErrors = {};
    
    if (formState.category === 'data-mc') {
      errors.mc_setpoint = !formState.mc_setpoint;
      errors.yoke_temperature = !formState.yoke_temperature;
      errors.arc_current = !formState.arc_current;
      errors.filament_current = !formState.filament_current;
      errors.p1e_x_width = !formState.p1e_x_width;
      errors.p1e_y_width = !formState.p1e_y_width;
      errors.p2e_x_width = !formState.p2e_x_width;
      errors.p2e_y_width = !formState.p2e_y_width;
    }
  
    return errors;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (isSubmitting) return;
    setIsSubmitting(true);
    
    // Clear previous validation state
    setValidationErrors({});
    setShowValidationMessage(false);
    
    // Validate the form based on the selected category
    let errors: ValidationErrors = {};
    if (formState.category === 'data-sc') {
      errors = validateSourceChangeData(formState);
    } else if (formState.category === 'data-mc') {
      errors = validateMainCoilData(formState);
    } else if (formState.category === 'downtime') {
      // Only validate start time for downtime entries
      errors.dt_start_time = !formState.dt_start_time;
    }

    // Check if there are any errors
    const hasErrors = Object.values(errors).some(error => error);
    setValidationErrors(errors);
    
    if (hasErrors) {
      setShowValidationMessage(true);
      toast.error('Please fill in all required fields');
      setIsSubmitting(false);
      return;
    }

    try {
      // Get current user session with retry mechanism
      let session = null;
      let retryCount = 0;
      const maxRetries = 2;
      
      while (!session && retryCount <= maxRetries) {
        try {
          const { data, error } = await supabase.auth.getSession();
          if (error) throw error;
          session = data.session;
        } catch (sessionError) {
          console.error(`Session error (attempt ${retryCount + 1}):`, sessionError);
          
          if (retryCount < maxRetries) {
            // Wait before retrying
            await new Promise(resolve => setTimeout(resolve, 500));
            retryCount++;
            // Try to refresh the session
            await supabase.auth.refreshSession();
          } else {
            throw sessionError;
          }
        }
      }
      
      if (!session?.user) {
        toast.error('You must be logged in to create entries');
        setIsSubmitting(false);
        return;
      }

      // 1. Prepare the log entry data (do NOT include attachments)
      // Only include fields that exist in log_entries table
      const {
        category, description, shift_type, case_number, case_status, workorder_number, workorder_title, workorder_status,
        mc_setpoint, yoke_temperature, arc_current, filament_current, p1e_x_width, p1e_y_width, p2e_x_width, p2e_y_width,
        removed_source_number, removed_filament_current, removed_arc_current, removed_filament_counter,
        inserted_source_number, inserted_filament_current, inserted_arc_current, inserted_filament_counter,
        filament_hours, engineers, dt_start_time, dt_end_time, dt_duration
      } = formState;

      const data = {
        category, description, shift_type, case_number, case_status, workorder_number, workorder_title, workorder_status,
        mc_setpoint: mc_setpoint ? Number(mc_setpoint) : null,
        yoke_temperature: yoke_temperature ? Number(yoke_temperature) : null,
        arc_current: arc_current ? Number(arc_current) : null,
        filament_current: filament_current ? Number(filament_current) : null,
        p1e_x_width: p1e_x_width ? Number(p1e_x_width) : null,
        p1e_y_width: p1e_y_width ? Number(p1e_y_width) : null,
        p2e_x_width: p2e_x_width ? Number(p2e_x_width) : null,
        p2e_y_width: p2e_y_width ? Number(p2e_y_width) : null,
        removed_source_number: removed_source_number ? Number(removed_source_number) : null,
        removed_filament_current: removed_filament_current ? Number(removed_filament_current) : null,
        removed_arc_current: removed_arc_current ? Number(removed_arc_current) : null,
        removed_filament_counter: removed_filament_counter ? Number(removed_filament_counter) : null,
        inserted_source_number: inserted_source_number ? Number(inserted_source_number) : null,
        inserted_filament_current: inserted_filament_current ? Number(inserted_filament_current) : null,
        inserted_arc_current: inserted_arc_current ? Number(inserted_arc_current) : null,
        inserted_filament_counter: inserted_filament_counter ? Number(inserted_filament_counter) : null,
        filament_hours: filament_hours ? Number(filament_hours) : null,
        engineers,
        dt_start_time: category === 'downtime' ? dt_start_time : null,
        dt_end_time: category === 'downtime' ? dt_end_time : null,
        dt_duration: category === 'downtime' ? dt_duration : null,
        user_id: session.user.id,
        downtime_id: category === 'downtime' ? formState.downtime_id : null,
      };

      // 2. Insert the log entry and get the new ID
      const { data: insertedLog, error: logError } = await supabase
        .from('log_entries')
        .insert([data])
        .select()
        .single();

      if (logError) throw logError;

      // 3. If this is a workorder entry, update or create the workorder record
      if (formState.category === 'workorder' && formState.workorder_number) {
        // Calculate days_between_today_and_pst
        let days_between_today_and_pst = null;
        if (formState.prefered_start_time) {
          const today = new Date();
          today.setHours(0,0,0,0);
          const pst = new Date(formState.prefered_start_time);
          pst.setHours(0,0,0,0);
          days_between_today_and_pst = Math.floor((pst.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
        }
        // Check if workorder already exists
        const { data: existingWorkorder } = await supabase
          .from('workorders')
          .select('*')
          .eq('workorder_number', formState.workorder_number)
          .single();

        if (existingWorkorder) {
          // Update existing workorder
          const { error: updateError } = await supabase
            .from('workorders')
            .update({
              status: formState.workorder_status,
              workorder_title: formState.workorder_title,
              updated_at: new Date().toISOString(),
              prefered_start_time: formState.prefered_start_time || null,
              workorder_id: formState.workorder_id || null,
              location: workorderMode === 'manual' ? 'SAT.125 - Chennai' : existingWorkorder.location,
              days_between_today_and_pst,
              workorder_category: workorderMode === 'manual' ? 'manual' : null
            })
            .eq('workorder_number', formState.workorder_number);

          if (updateError) throw updateError;
        } else {
          // Create new workorder
          const { error: insertError } = await supabase
            .from('workorders')
            .insert([{
              workorder_number: formState.workorder_number,
              workorder_title: formState.workorder_title,
              status: formState.workorder_status || 'open',
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
              prefered_start_time: formState.prefered_start_time || null,
              workorder_id: formState.workorder_id || null,
              location: 'SAT.125 - Chennai',
              days_between_today_and_pst,
              workorder_category: workorderMode === 'manual' ? 'manual' : null
            }]);

          if (insertError) throw insertError;
        }
      }

      // 4. Upload files and create attachment records with log_entry_id
      if (files.length > 0) {
        for (const file of files) {
          const fileExt = file.name.split('.').pop();
          const fileName = `${Math.random().toString(36).substring(2)}_${Date.now()}.${fileExt}`;
          const filePath = `${session.user.id}/${fileName}`;

          // Upload file to storage
          const { error: uploadError } = await supabase.storage
            .from('attachments')
            .upload(filePath, file);

          if (uploadError) {
            console.error('Error uploading file:', uploadError);
            toast.error(`Failed to upload ${file.name}`);
            continue;
          }

          // Create attachment record with log_entry_id
          const { error: attachmentError } = await supabase
            .from('attachments')
            .insert({
              file_name: file.name,
              file_type: file.type,
              file_size: file.size,
              file_path: filePath,
              user_id: session.user.id,
              log_entry_id: insertedLog.id,
            });

          if (attachmentError) {
            console.error('Error creating attachment record:', attachmentError);
            toast.error(`Failed to save attachment record for ${file.name}`);
            continue;
          }
        }
      }

      // Reset form and show success message
      setFormState(initialState);
      setFiles([]);
      toast.success('Log entry created successfully');
      if (formState.category === 'workorder') {
        toast.success('Workorder entry added successfully');
        onClose();
        return;
      }
      onClose();
    } catch (error) {
      console.error('Error creating log entry:', error);
      toast.error('Failed to create log entry');
    } finally {
      setIsSubmitting(false);
    }
  };

  const getCategoryColor = (category: LogCategory) => {
    switch (category) {
      case 'error': return 'bg-red-500/20 text-red-300 border-red-500/30';
      case 'downtime': return 'bg-yellow-500/20 text-yellow-300 border-yellow-500/30';
      case 'workorder': return 'bg-blue-500/20 text-blue-300 border-blue-500/30';
      case 'data-mc': return 'bg-purple-500/20 text-purple-300 border-purple-500/30';
      case 'data-sc': return 'bg-green-500/20 text-green-300 border-green-500/30';
      default: return 'bg-gray-500/20 text-gray-300 border-gray-500/30';
    }
  };

  const getInputStyle = (fieldName: string) => {
    const baseStyle = "w-full rounded-lg border-0 px-4 py-2.5 focus:ring-2 focus:ring-indigo-500";
    const errorStyle = validationErrors[fieldName] 
      ? "bg-red-500/10 border-red-500 text-red-300 focus:ring-red-500" 
      : "bg-white/5 text-white";
    return `${baseStyle} ${errorStyle}`;
  };

  const getSelectStyle = (fieldName: string) => {
    const baseStyle = "w-full rounded-lg border px-4 py-2.5 focus:ring-2 focus:ring-indigo-500";
    const errorStyle = validationErrors[fieldName]
      ? "bg-gray-800/50 border-red-500 text-red-300 focus:ring-red-500"
      : "bg-gray-800/50 border-gray-700 text-white";
    return `${baseStyle} ${errorStyle}`;
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
                      <div className="space-y-6">
                        {showValidationMessage && Object.keys(validationErrors).some(key => validationErrors[key]) && (
                          <div className="bg-red-900/20 border border-red-500/30 rounded-lg p-4">
                            <p className="text-red-400 text-sm">Please fill in all required fields marked in red</p>
                          </div>
                        )}

                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">Case Number (Optional)</label>
                          <input
                            type="text"
                            value={formState.case_number || ''}
                            onChange={e => setFormState({ ...formState, case_number: e.target.value })}
                            placeholder="Enter case number..."
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                          />
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">Downtime ID *</label>
                          <input
                            type="text"
                            value={formState.downtime_id || ''}
                            onChange={e => setFormState({ ...formState, downtime_id: e.target.value })}
                            placeholder="Enter downtime ID..."
                            className={`w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 ${validationErrors.downtime_id ? 'border-red-500' : ''}`}
                            required={formState.category === 'downtime'}
                          />
                          {validationErrors.downtime_id && <p className="text-xs text-red-400 mt-1">Downtime ID is required</p>}
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              DT Start Time *
                              <span className="text-red-400 ml-1">{validationErrors.dt_start_time ? '(Required)' : ''}</span>
                            </label>
                            <DateTimeInput
                              value={formState.dt_start_time || new Date().toISOString()}
                              onChange={(value) => {
                                setFormState(prev => {
                                  const newState = {
                                    ...prev,
                                    dt_start_time: value
                                  };
                                  
                                  // Recalculate duration if both start and end times exist
                                  if (value && prev.dt_end_time) {
                                    const duration = differenceInMinutes(new Date(prev.dt_end_time), new Date(value));
                                    newState.dt_duration = duration >= 0 ? duration : 0;
                                  }
                                  
                                  return newState;
                                });
                              }}
                              className={getInputStyle('dt_start_time')}
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">DT End Time (Optional)</label>
                            <DateTimeInput
                              value={formState.dt_end_time || undefined}
                              onChange={(value) => {
                                setFormState(prev => {
                                  const newState = {
                                    ...prev,
                                    dt_end_time: value
                                  };
                                  
                                  // Recalculate duration if both start and end times exist
                                  if (prev.dt_start_time && value) {
                                    const duration = differenceInMinutes(new Date(value), new Date(prev.dt_start_time));
                                    newState.dt_duration = duration >= 0 ? duration : 0;
                                  }
                                  
                                  return newState;
                                });
                              }}
                              className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                            />
                          </div>
                        </div>

                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">DT Duration (minutes)</label>
                          <input
                            type="number"
                            value={formState.dt_duration || ''}
                            readOnly
                            placeholder="Will be calculated automatically"
                            className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5"
                          />
                        </div>
                      </div>
                    )}

                    {formState.category === 'workorder' && (
                      <div className="space-y-2">
                        <div className="flex gap-2 mb-2">
                          <button
                            type="button"
                            className={`px-3 py-1 rounded-lg text-xs font-semibold border transition-all ${workorderMode === 'pm' ? 'bg-indigo-600 text-white' : 'bg-gray-800 text-gray-300 border-gray-700 hover:bg-gray-700/40'}`}
                            onClick={() => { setWorkorderMode('pm'); setShowWorkorderModal(true); }}
                          >
                            PM
                          </button>
                          <button
                            type="button"
                            className={`px-3 py-1 rounded-lg text-xs font-semibold border transition-all ${workorderMode === 'manual' ? 'bg-indigo-600 text-white' : 'bg-gray-800 text-gray-300 border-gray-700 hover:bg-gray-700/40'}`}
                            onClick={() => setWorkorderMode('manual')}
                          >
                            Manual
                          </button>
                        </div>
                        <div className="grid grid-cols-3 gap-4">
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Work Order Number</label>
                            <input
                              type="text"
                              value={formState.workorder_number || ''}
                              onChange={e => setFormState({ ...formState, workorder_number: e.target.value })}
                              placeholder="Enter work order number..."
                              className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                              disabled={workorderMode === 'pm'}
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Work Order Title</label>
                            <input
                              type="text"
                              value={formState.workorder_title || ''}
                              onChange={e => setFormState({ ...formState, workorder_title: e.target.value })}
                              placeholder="Enter work order title..."
                              className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                              disabled={workorderMode === 'pm'}
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Status</label>
                            <div className="flex gap-2 mt-1">
                              {['open', 'in_progress', 'pending', 'closed'].map(status => (
                                <button
                                  key={status}
                                  type="button"
                                  onClick={() => setFormState({ ...formState, workorder_status: status as Status })}
                                  className={`px-3 py-1 rounded-full text-xs font-semibold border transition-all
                                    ${formState.workorder_status === status ?
                                      (status === 'open' ? 'bg-green-500/20 text-green-300 border-green-500/30' :
                                       status === 'in_progress' ? 'bg-yellow-500/20 text-yellow-300 border-yellow-500/30' :
                                       status === 'pending' ? 'bg-orange-500/20 text-orange-300 border-orange-500/30' :
                                       'bg-gray-500/20 text-gray-300 border-gray-500/30')
                                      : 'bg-gray-800/40 text-gray-400 border-gray-700 hover:bg-gray-700/40'}`}
                                  disabled={workorderMode === 'pm'}
                                >
                                  {status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}
                                </button>
                              ))}
                        </div>
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Workorder ID</label>
                            <input
                              type="text"
                              value={formState.workorder_id || ''}
                              onChange={e => setFormState({ ...formState, workorder_id: e.target.value })}
                              placeholder="Enter workorder ID..."
                              className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                              disabled={workorderMode === 'pm'}
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">Preferred Start Time</label>
                            <input
                              type="datetime-local"
                              value={formState.prefered_start_time ? formState.prefered_start_time.substring(0, 16) : ''}
                              onChange={e => setFormState({ ...formState, prefered_start_time: e.target.value })}
                              className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
                              disabled={workorderMode === 'pm'}
                            />
                          </div>
                        </div>
                        {/* Hidden location for manual */}
                        {workorderMode === 'manual' && (
                          <input type="hidden" value="SAT.125 - Chennai" readOnly />
                        )}
                        {/* Workorder PM Modal */}
                        <Transition appear show={showWorkorderModal} as={Fragment}>
                          <Dialog as="div" className="relative z-50" onClose={() => setShowWorkorderModal(false)}>
                            <Transition.Child as={Fragment} enter="ease-out duration-300" enterFrom="opacity-0" enterTo="opacity-100" leave="ease-in duration-200" leaveFrom="opacity-100" leaveTo="opacity-0">
                              <div className="fixed inset-0 bg-black/70 backdrop-blur-sm" />
                            </Transition.Child>
                            <div className="fixed inset-0 overflow-y-auto">
                              <div className="flex min-h-full items-center justify-center p-4">
                                <Transition.Child as={Fragment} enter="ease-out duration-300" enterFrom="opacity-0 scale-95" enterTo="opacity-100 scale-100" leave="ease-in duration-200" leaveFrom="opacity-100 scale-100" leaveTo="opacity-0 scale-95">
                                  <Dialog.Panel className="w-full max-w-3xl max-h-[90vh] overflow-y-auto bg-gray-900/95 backdrop-blur-xl rounded-xl shadow-xl border border-gray-700">
                                    <div className="p-6">
                                      <div className="flex items-center justify-between mb-4">
                                        <Dialog.Title className="text-xl font-semibold text-white">Select Preventive Maintenance Work Order</Dialog.Title>
                                        <button onClick={() => setShowWorkorderModal(false)} className="text-gray-400 hover:text-white transition-colors p-2 hover:bg-white/10 rounded-lg"><X className="h-6 w-6" /></button>
                                      </div>
                                      <input
                                        type="text"
                                        placeholder="Search by WO number or title..."
                                        value={workorderSearch}
                                        onChange={e => setWorkorderSearch(e.target.value)}
                                        className="w-full mb-4 px-4 py-2 rounded-lg bg-gray-800 border border-gray-700 text-white placeholder-gray-400 focus:outline-none focus:border-indigo-500"
                                      />
                                      <div className="overflow-x-auto">
                                        <table className="min-w-full text-sm text-gray-200">
                                          <thead>
                                            <tr className="bg-gray-800">
                                              <th className="px-4 py-2 text-left">WO Number</th>
                                              <th className="px-4 py-2 text-left">Title</th>
                                              <th className="px-4 py-2 text-left">Preferred Start</th>
                                              <th className="px-4 py-2 text-left">Status</th>
                                              <th></th>
                                            </tr>
                                          </thead>
                                          <tbody>
                                            {workorders
                                              .filter(wo =>
                                                wo.workorder_number?.toLowerCase().includes(workorderSearch.toLowerCase()) ||
                                                wo.workorder_title?.toLowerCase().includes(workorderSearch.toLowerCase())
                                              )
                                              .sort((a, b) => {
                                                const aTime = a.prefered_start_time ? new Date(a.prefered_start_time).getTime() : 0;
                                                const bTime = b.prefered_start_time ? new Date(b.prefered_start_time).getTime() : 0;
                                                return aTime - bTime;
                                              })
                                              .map(wo => (
                                                <tr key={wo.id} className="hover:bg-indigo-900/20 cursor-pointer">
                                                  <td className="px-4 py-2 font-mono">{wo.workorder_number}</td>
                                                  <td className="px-4 py-2">{wo.workorder_title}</td>
                                                  <td className="px-4 py-2">{wo.prefered_start_time ? new Date(wo.prefered_start_time).toLocaleString() : ''}</td>
                                                  <td className="px-4 py-2">{wo.status}</td>
                                                  <td className="px-4 py-2">
                                                    <button
                                                      className="px-3 py-1 bg-indigo-600 text-white rounded hover:bg-indigo-700 text-xs"
                                                      onClick={() => {
                                                        setFormState({
                                                          ...formState,
                                                          workorder_number: wo.workorder_number,
                                                          workorder_title: wo.workorder_title,
                                                          workorder_status: wo.status,
                                                          prefered_start_time: wo.prefered_start_time,
                                                          workorder_id: wo.workorder_id,
                                                        });
                                                        setShowWorkorderModal(false);
                                                        setWorkorderMode('pm');
                                                      }}
                                                    >
                                                      Select
                                                    </button>
                                                  </td>
                                                </tr>
                                              ))}
                                          </tbody>
                                        </table>
                                      </div>
                                    </div>
                                  </Dialog.Panel>
                                </Transition.Child>
                              </div>
                            </div>
                          </Dialog>
                        </Transition>
                      </div>
                    )}

                    {formState.category === 'data-mc' && (
                      <div className="space-y-6">
                        {showValidationMessage && Object.keys(validationErrors).some(key => validationErrors[key]) && (
                          <div className="bg-red-900/20 border border-red-500/30 rounded-lg p-4">
                            <p className="text-red-400 text-sm">Please fill in all required fields marked in red</p>
                          </div>
                        )}
                        
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                            <label htmlFor="mc_setpoint" className="block text-sm font-medium text-gray-200 mb-1">
                              Main Coil Setpoint (A)
                            </label>
                            <input
                              type="number"
                              step="0.01"
                              id="mc_setpoint"
                              name="mc_setpoint"
                              value={formState.mc_setpoint || ''}
                              onChange={(e) => setFormState({ ...formState, mc_setpoint: e.target.value ? Number(e.target.value) : undefined })}
                              className={getInputStyle('mc_setpoint')}
                            />
                          </div>
                          <div>
                            <label htmlFor="yoke_temperature" className="block text-sm font-medium text-gray-200 mb-1">
                              Yoke Temperature (°C)
                            </label>
                            <input
                              type="number"
                              step="0.01"
                              id="yoke_temperature"
                              name="yoke_temperature"
                              value={formState.yoke_temperature || ''}
                              onChange={(e) => setFormState({ ...formState, yoke_temperature: e.target.value ? Number(e.target.value) : undefined })}
                              className={getInputStyle('yoke_temperature')}
                            />
                          </div>
                        </div>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                            <label htmlFor="arc_current" className="block text-sm font-medium text-gray-200 mb-1">
                              Arc Current (mA)
                            </label>
                            <input
                              type="number"
                              step="1"
                              id="arc_current"
                              name="arc_current"
                              value={formState.arc_current || ''}
                              onChange={(e) => setFormState({ ...formState, arc_current: e.target.value ? Number(e.target.value) : undefined })}
                              className={getInputStyle('arc_current')}
                            />
                          </div>
                          <div>
                            <label htmlFor="filament_current" className="block text-sm font-medium text-gray-200 mb-1">
                              Filament Current (A)
                            </label>
                            <input
                              type="number"
                              step="1"
                              id="filament_current"
                              name="filament_current"
                              value={formState.filament_current || ''}
                              onChange={(e) => setFormState({ ...formState, filament_current: e.target.value ? Number(e.target.value) : undefined })}
                              className={getInputStyle('filament_current')}
                            />
                          </div>
                        </div>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                            <label htmlFor="p1e_x_width" className="block text-sm font-medium text-gray-200 mb-1">
                              P1E X Width (mm)
                            </label>
                            <input
                              type="number"
                              step="0.01"
                              id="p1e_x_width"
                              name="p1e_x_width"
                              value={formState.p1e_x_width || ''}
                              onChange={(e) => setFormState({ ...formState, p1e_x_width: e.target.value ? Number(e.target.value) : undefined })}
                              className={getInputStyle('p1e_x_width')}
                            />
                          </div>
                          <div>
                            <label htmlFor="p1e_y_width" className="block text-sm font-medium text-gray-200 mb-1">
                              P1E Y Width (mm)
                            </label>
                            <input
                              type="number"
                              step="0.01"
                              id="p1e_y_width"
                              name="p1e_y_width"
                              value={formState.p1e_y_width || ''}
                              onChange={(e) => setFormState({ ...formState, p1e_y_width: e.target.value ? Number(e.target.value) : undefined })}
                              className={getInputStyle('p1e_y_width')}
                            />
                          </div>
                        </div>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                            <label htmlFor="p2e_x_width" className="block text-sm font-medium text-gray-200 mb-1">
                              P2E X Width (mm)
                            </label>
                            <input
                              type="number"
                              step="0.01"
                              id="p2e_x_width"
                              name="p2e_x_width"
                              value={formState.p2e_x_width || ''}
                              onChange={(e) => setFormState({ ...formState, p2e_x_width: e.target.value ? Number(e.target.value) : undefined })}
                              className={getInputStyle('p2e_x_width')}
                            />
                          </div>
                          <div>
                            <label htmlFor="p2e_y_width" className="block text-sm font-medium text-gray-200 mb-1">
                              P2E Y Width (mm)
                            </label>
                            <input
                              type="number"
                              step="0.1"
                              id="p2e_y_width"
                              name="p2e_y_width"
                              value={formState.p2e_y_width || ''}
                              onChange={(e) => setFormState({ ...formState, p2e_y_width: e.target.value ? Number(e.target.value) : undefined })}
                              className={getInputStyle('p2e_y_width')}
                            />
                          </div>
                        </div>
                      </div>
                    )}

                    {formState.category === 'data-sc' && (
                      <div className="space-y-6">
                        {showValidationMessage && Object.keys(validationErrors).some(key => validationErrors[key]) && (
                          <div className="bg-red-900/20 border border-red-500/30 rounded-lg p-4">
                            <p className="text-red-400 text-sm">Please fill in all required fields marked in red</p>
                          </div>
                        )}
                        
                        <div className="flex items-center text-md font-semibold text-indigo-300 mb-2">
                          <RefreshCw className="mr-2 text-green-400 w-6 h-6" /> Removed Source Data
                        </div>
                        <div className="bg-red-900/20 border border-red-700/30 rounded-lg p-4 mb-2">
                          <div className="grid grid-cols-2 gap-4">
                    <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.removed_source_number ? 'text-red-400' : 'text-gray-200'}`}>
                                Source Number *
                      </label>
                              <select 
                                value={formState.removed_source_number || ''} 
                                onChange={e => setFormState({ ...formState, removed_source_number: e.target.value ? Number(e.target.value) : undefined })}
                                className={getSelectStyle('removed_source_number')}
                              >
                                <option value="">Select source</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                              </select>
                    </div>
                            <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.removed_filament_current ? 'text-red-400' : 'text-gray-200'}`}>
                                Filament Current (A) *
                              </label>
                              <input type="number" step="1" value={formState.removed_filament_current || ''} onChange={e => setFormState({ ...formState, removed_filament_current: e.target.value ? Number(e.target.value) : undefined })} className={getInputStyle('removed_filament_current')} />
                  </div>
                            <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.removed_arc_current ? 'text-red-400' : 'text-gray-200'}`}>
                                Arc Current (mA) *
                              </label>
                              <input type="number" step="1" value={formState.removed_arc_current || ''} onChange={e => setFormState({ ...formState, removed_arc_current: e.target.value ? Number(e.target.value) : undefined })} className={getInputStyle('removed_arc_current')} />
                            </div>
                            <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.removed_filament_counter ? 'text-red-400' : 'text-gray-200'}`}>
                                Filament Counter *
                              </label>
                              <input type="number" step="1" value={formState.removed_filament_counter || ''} onChange={e => setFormState({ ...formState, removed_filament_counter: e.target.value ? Number(e.target.value) : undefined })} className={getInputStyle('removed_filament_counter')} />
                            </div>
                          </div>
                        </div>
                        <div className="flex items-center text-md font-semibold text-indigo-300 mb-2">
                          <RefreshCw className="mr-2 text-green-400 w-6 h-6" /> Inserted Source Data
                        </div>
                        <div className="bg-green-900/20 border border-green-700/30 rounded-lg p-4 mb-2">
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.inserted_source_number ? 'text-red-400' : 'text-gray-200'}`}>
                                Source Number *
                              </label>
                              <select 
                                value={formState.inserted_source_number || ''} 
                                onChange={e => setFormState({ ...formState, inserted_source_number: e.target.value ? Number(e.target.value) : undefined })}
                                className={getSelectStyle('inserted_source_number')}
                              >
                                <option value="">Select source</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                              </select>
                            </div>
                            <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.inserted_filament_current ? 'text-red-400' : 'text-gray-200'}`}>
                                Filament Current (A) *
                              </label>
                              <input type="number" step="1" value={formState.inserted_filament_current || ''} onChange={e => setFormState({ ...formState, inserted_filament_current: e.target.value ? Number(e.target.value) : undefined })} className={getInputStyle('inserted_filament_current')} />
                            </div>
                            <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.inserted_arc_current ? 'text-red-400' : 'text-gray-200'}`}>
                                Arc Current (mA) *
                              </label>
                              <input type="number" step="1" value={formState.inserted_arc_current || ''} onChange={e => setFormState({ ...formState, inserted_arc_current: e.target.value ? Number(e.target.value) : undefined })} className={getInputStyle('inserted_arc_current')} />
                            </div>
                          </div>
                        </div>
                        <div>
                          <h4 className="text-md font-semibold text-indigo-300 mb-2">Filament Hours</h4>
                          <p className="text-sm text-gray-300">
                            {typeof formState.filament_hours === 'number' ? formState.filament_hours.toFixed(2) : '—'}
                          </p>
                        </div>
                        <div className="mb-2 grid grid-cols-2 gap-4">
                          <div>
                            <label className={`block text-sm font-medium mb-1 ${validationErrors.engineers ? 'text-red-400' : 'text-gray-200'}`}>
                              Engineer 1 *
                            </label>
                            <select
                              value={formState.engineers?.[0] || ''}
                              onChange={e => {
                                const newEngineers = [...(formState.engineers || [])];
                                newEngineers[0] = e.target.value;
                                setFormState({ ...formState, engineers: newEngineers.filter(Boolean) });
                              }}
                              className={getSelectStyle('engineers')}
                            >
                              <option value="">Select engineer</option>
                              {engineerList.map(e => (
                                <option key={e.id} value={e.id}>{e.name}</option>
                              ))}
                            </select>
                          </div>
                          <div>
                            <label className={`block text-sm font-medium mb-1 ${validationErrors.engineers ? 'text-red-400' : 'text-gray-200'}`}>
                              Engineer 2 *
                            </label>
                            <select
                              value={formState.engineers?.[1] || ''}
                              onChange={e => {
                                const newEngineers = [...(formState.engineers || [])];
                                if (newEngineers.length === 0 && e.target.value) {
                                  newEngineers[0] = '';  // Add empty first engineer if none exists
                                }
                                newEngineers[1] = e.target.value;
                                setFormState({ ...formState, engineers: newEngineers.filter(Boolean) });
                              }}
                              className={getSelectStyle('engineers')}
                            >
                              <option value="">Select engineer</option>
                              {engineerList.map(e => (
                                <option key={e.id} value={e.id}>{e.name}</option>
                              ))}
                            </select>
                          </div>
                        </div>
                        <div className="grid grid-cols-2 gap-4">
                          <div>
                            <label className="block text-sm font-medium mb-1 text-gray-200">Work Order Number *</label>
                            <input
                              type="text"
                              value={formState.workorder_number || ''}
                              onChange={e => setFormState({ ...formState, workorder_number: e.target.value })}
                              placeholder="Enter work order number..."
                              className={getInputStyle('workorder_number')}
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium mb-1 text-gray-200">Case Number</label>
                            <input
                              type="text"
                              value={formState.case_number || ''}
                              onChange={e => setFormState({ ...formState, case_number: e.target.value })}
                              placeholder="Enter case number..."
                              className={getInputStyle('case_number')}
                            />
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