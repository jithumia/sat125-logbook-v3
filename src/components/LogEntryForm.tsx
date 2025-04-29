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
}

const initialState: FormState = {
  category: 'general',
    description: '',
  shift_type: 'morning',
  // Main Coil Tuning Data
  mc_setpoint: undefined,
  yoke_temperature: undefined,
  arc_current: undefined,
  filament_current: undefined,
  p1e_x_width: undefined,
  p1e_y_width: undefined,
  p2e_x_width: undefined,
  p2e_y_width: undefined,
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
};

const validateSourceChangeData = (formState: FormState): ValidationErrors => {
  const errors: ValidationErrors = {};
  
  if (formState.category === 'data-sc') {
    // Removed source data validation
    errors.removed_source_number = !formState.removed_source_number;
    errors.removed_filament_current = !formState.removed_filament_current;
    errors.removed_arc_current = !formState.removed_arc_current;
    errors.removed_filament_counter = !formState.removed_filament_counter;
    
    // Inserted source data validation
    errors.inserted_source_number = !formState.inserted_source_number;
    errors.inserted_filament_current = !formState.inserted_filament_current;
    errors.inserted_arc_current = !formState.inserted_arc_current;
    errors.inserted_filament_counter = !formState.inserted_filament_counter;
    
    // Engineers validation
    errors.engineers = !formState.engineers || formState.engineers.length === 0;
    
    // Work order and case number validation
    errors.workorder_number = !formState.workorder_number;
    errors.case_number = !formState.case_number;
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

const LogEntryForm: React.FC<LogEntryFormProps> = ({ onClose, activeShift }) => {
  const [formState, setFormState] = useState<FormState>(initialState);
  const [files, setFiles] = useState<File[]>([]);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [engineerList, setEngineerList] = useState<Engineer[]>([]);
  const [validationErrors, setValidationErrors] = useState<ValidationErrors>({});
  const [showValidationMessage, setShowValidationMessage] = useState(false);

  useEffect(() => {
    if (formState.category === 'data-mc' || formState.category === 'data-sc') {
      supabase.from('engineers').select('*').then(({ data }) => {
        if (data) setEngineerList(data);
      });
    }
  }, [formState.category]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate based on category
    let errors: ValidationErrors = {};
    if (formState.category === 'data-sc') {
      errors = validateSourceChangeData(formState);
    } else if (formState.category === 'data-mc') {
      errors = validateMainCoilData(formState);
    }

    // Check if there are any errors
    const hasErrors = Object.values(errors).some(error => error);
    setValidationErrors(errors);
    
    if (hasErrors) {
      setShowValidationMessage(true);
      toast.error('Please fill in all required fields');
      return;
    }

    setIsSubmitting(true);

    try {
      // Get current user session
      const { data: { session } } = await supabase.auth.getSession();
      
      if (!session?.user) {
        toast.error('You must be logged in to create entries');
        return;
      }

      const { data, error } = await supabase
        .from('log_entries')
        .insert([
          {
            ...formState,
            user_id: session.user.id,
            // Convert string inputs to numbers for numeric fields
            mc_setpoint: formState.mc_setpoint ? Number(formState.mc_setpoint) : null,
            yoke_temperature: formState.yoke_temperature ? Number(formState.yoke_temperature) : null,
            arc_current: formState.arc_current ? Number(formState.arc_current) : null,
            filament_current: formState.filament_current ? Number(formState.filament_current) : null,
            p1e_x_width: formState.p1e_x_width ? Number(formState.p1e_x_width) : null,
            p1e_y_width: formState.p1e_y_width ? Number(formState.p1e_y_width) : null,
            p2e_x_width: formState.p2e_x_width ? Number(formState.p2e_x_width) : null,
            p2e_y_width: formState.p2e_y_width ? Number(formState.p2e_y_width) : null,
            removed_source_number: formState.removed_source_number ? Number(formState.removed_source_number) : null,
            removed_filament_current: formState.removed_filament_current ? Number(formState.removed_filament_current) : null,
            removed_arc_current: formState.removed_arc_current ? Number(formState.removed_arc_current) : null,
            removed_filament_counter: formState.removed_filament_counter ? Number(formState.removed_filament_counter) : null,
            inserted_source_number: formState.inserted_source_number ? Number(formState.inserted_source_number) : null,
            inserted_filament_current: formState.inserted_filament_current ? Number(formState.inserted_filament_current) : null,
            inserted_arc_current: formState.inserted_arc_current ? Number(formState.inserted_arc_current) : null,
            inserted_filament_counter: formState.inserted_filament_counter ? Number(formState.inserted_filament_counter) : null,
            filament_hours: formState.filament_hours ? Number(formState.filament_hours) : null,
          },
        ])
        .select();

      if (error) throw error;

      // Reset form and show success message
      setFormState(initialState);
      toast.success('Log entry created successfully');
      onClose();
      window.location.reload();
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
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">Case Number</label>
                          <input
                            type="text"
                            value={formState.case_number}
                            onChange={e => setFormState({ ...formState, case_number: e.target.value })}
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
                                onClick={() => setFormState({ ...formState, case_status: status as Status })}
                                className={`px-3 py-1 rounded-full text-xs font-semibold border transition-all
                                  ${formState.case_status === status ?
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
                            value={formState.workorder_number}
                            onChange={e => setFormState({ ...formState, workorder_number: e.target.value })}
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
                                onClick={() => setFormState({ ...formState, workorder_status: status as Status })}
                                className={`px-3 py-1 rounded-full text-xs font-semibold border transition-all
                                  ${formState.workorder_status === status ?
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
                        <div className="flex items-center text-md font-semibold text-indigo-300 mb-2">
                          <Settings className="mr-2 text-indigo-400 w-6 h-6" /> Main Coil Tuning
                        </div>
                        <div className="space-y-4">
                          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                              <label htmlFor="mc_setpoint" className="block text-sm font-medium text-gray-200 mb-1">
                                Main Coil Setpoint (A)
                            </label>
                            <input
                              type="number"
                                step="0.001"
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
                              step="0.1"
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
                              step="0.1"
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
                              step="0.1"
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
                                step="0.001"
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
                                step="0.001"
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
                                step="0.001"
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
                                step="0.001"
                                id="p2e_y_width"
                                name="p2e_y_width"
                                value={formState.p2e_y_width || ''}
                                onChange={(e) => setFormState({ ...formState, p2e_y_width: e.target.value ? Number(e.target.value) : undefined })}
                                className={getInputStyle('p2e_y_width')}
                            />
                            </div>
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
                            <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.inserted_filament_counter ? 'text-red-400' : 'text-gray-200'}`}>
                                Filament Counter *
                              </label>
                              <input type="number" step="1" value={formState.inserted_filament_counter || ''} onChange={e => setFormState({ ...formState, inserted_filament_counter: e.target.value ? Number(e.target.value) : undefined })} className={getInputStyle('inserted_filament_counter')} />
                            </div>
                          </div>
                        </div>
                        <div>
                          <h4 className="text-md font-semibold text-indigo-300 mb-2">Svmx / Pridex</h4>
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.workorder_number ? 'text-red-400' : 'text-gray-200'}`}>
                                Work Order Number *
                              </label>
                              <input type="text" value={formState.workorder_number || ''} onChange={e => setFormState({ ...formState, workorder_number: e.target.value })} className={getInputStyle('workorder_number')} />
                            </div>
                            <div>
                              <label className={`block text-sm font-medium mb-1 ${validationErrors.case_number ? 'text-red-400' : 'text-gray-200'}`}>
                                Svmx Case Number *
                              </label>
                              <input type="text" value={formState.case_number || ''} onChange={e => setFormState({ ...formState, case_number: e.target.value })} className={getInputStyle('case_number')} />
                            </div>
                          </div>
                        </div>
                        <div>
                          <h4 className="text-md font-semibold text-indigo-300 mb-2">Filament Hours</h4>
                          <p className="text-sm text-gray-300">
                            {formState.inserted_filament_counter && formState.removed_filament_counter
                              ? (formState.inserted_filament_counter - formState.removed_filament_counter).toFixed(2)
                              : '—'}
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