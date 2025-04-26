import React, { useState, useEffect, useRef } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { Fragment } from 'react';
import { LogCategory, ShiftType, Status } from '../types';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';
import FileUpload from './FileUpload';
import { X, AlertCircle, Save, Loader2, CheckCircle2 } from 'lucide-react';

interface LogEntryFormProps {
  onClose: () => void;
  shift: ShiftType;
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

const LogEntryForm: React.FC<LogEntryFormProps> = ({ onClose, shift }) => {
  // Form state
  const [formState, setFormState] = useState({
    category: 'general' as LogCategory,
    description: '',
    caseNumber: '',
    caseStatus: 'ongoing' as Status,
    workorderNumber: '',
    workorderStatus: 'ongoing' as Status,
    mcSetpoint: '',
    yokeTemperature: '',
    arcCurrent: '',
    filamentCurrent: '',
    pieWidth: '',
    p2eWidth: '',
  });

  // Other state
  const [submitting, setSubmitting] = useState(false);
  const [files, setFiles] = useState<File[]>([]);
  const [suggestions, setSuggestions] = useState<Suggestion[]>([]);
  const [showSuggestions, setShowSuggestions] = useState(false);
  const [activeSuggestionField, setActiveSuggestionField] = useState<'description' | 'caseNumber' | 'workorderNumber' | null>(null);
  const [showSuccessAnimation, setShowSuccessAnimation] = useState(false);

  // Refs
  const suggestionsRef = useRef<HTMLDivElement>(null);
  const formRef = useRef<HTMLFormElement>(null);
  const suggestionCacheRef = useRef<SuggestionCache>({});
  const suggestionTimeoutRef = useRef<NodeJS.Timeout>();

  // Handle click outside suggestions
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (suggestionsRef.current && !suggestionsRef.current.contains(event.target as Node)) {
        setShowSuggestions(false);
        setActiveSuggestionField(null);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      if (suggestionTimeoutRef.current) {
        clearTimeout(suggestionTimeoutRef.current);
      }
    };
  }, []);

  // Optimized form state update
  const updateFormState = (field: keyof typeof formState, value: string) => {
    setFormState(prev => ({ ...prev, [field]: value }));
  };

  // Debounced suggestion fetch
  const fetchSuggestions = async (searchTerm: string, field: 'description' | 'caseNumber' | 'workorderNumber') => {
    if (!searchTerm.trim() || searchTerm.length < 2) {
      setShowSuggestions(false);
      setActiveSuggestionField(null);
      return;
    }

    const category = field === 'description' ? formState.category : 
                    field === 'caseNumber' ? 'downtime' : 'workorder';
    
    const cacheKey = `${category}:${searchTerm}`;
    const cachedData = suggestionCacheRef.current[cacheKey];
    const now = Date.now();

    // Use cached data if it's less than 5 minutes old
    if (cachedData && (now - cachedData.timestamp) < 300000) {
      setSuggestions(cachedData.data);
      setShowSuggestions(cachedData.data.length > 0);
      setActiveSuggestionField(field);
      return;
    }

    if (suggestionTimeoutRef.current) {
      clearTimeout(suggestionTimeoutRef.current);
    }

    suggestionTimeoutRef.current = setTimeout(async () => {
      try {
        const { data, error } = await supabase
          .from('log_suggestions')
          .select('*')
          .eq('category', category)
          .ilike('description', `%${searchTerm}%`)
          .order('usage_count', { ascending: false })
          .order('last_used', { ascending: false })
          .limit(5);

        if (error) throw error;

        // Cache the results
        suggestionCacheRef.current[cacheKey] = {
          data: data || [],
          timestamp: now
        };

        setSuggestions(data || []);
        setShowSuggestions(data && data.length > 0);
        setActiveSuggestionField(field);
      } catch (error) {
        console.error('Error fetching suggestions:', error);
        toast.error('Failed to fetch suggestions');
      }
    }, 300); // 300ms debounce
  };

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>,
    field: 'description' | 'caseNumber' | 'workorderNumber'
  ) => {
    const value = e.target.value;
    updateFormState(field, value);
    fetchSuggestions(value, field);
  };

  const handleSuggestionClick = async (suggestion: Suggestion) => {
    if (!activeSuggestionField) return;

    updateFormState(activeSuggestionField, suggestion.description);

    try {
      await supabase.rpc('upsert_log_suggestion', {
        p_category: suggestion.category,
        p_description: suggestion.description
      });

      // Update cache
      const cacheKey = `${suggestion.category}:${suggestion.description}`;
      if (suggestionCacheRef.current[cacheKey]) {
        suggestionCacheRef.current[cacheKey].data = suggestionCacheRef.current[cacheKey].data.map(s =>
          s.id === suggestion.id ? { ...s, usage_count: s.usage_count + 1 } : s
        );
      }
    } catch (error) {
      console.error('Error updating suggestion usage:', error);
    }

    setShowSuggestions(false);
    setActiveSuggestionField(null);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    try {
      setSubmitting(true);

      const { data: { user } } = await supabase.auth.getUser();
      
      if (!user) {
        throw new Error('No user found');
      }

      const entry = {
        shift_type: shift,
        category: formState.category,
        description: formState.description.trim(),
        user_id: user.id,
        ...(formState.category === 'downtime' && {
          case_number: formState.caseNumber.trim(),
          case_status: formState.caseStatus,
        }),
        ...(formState.category === 'workorder' && {
          workorder_number: formState.workorderNumber.trim(),
          workorder_status: formState.workorderStatus,
        }),
        ...(formState.category === 'data-collection' && {
          mc_setpoint: formState.mcSetpoint ? parseFloat(formState.mcSetpoint) : null,
          yoke_temperature: formState.yokeTemperature ? parseFloat(formState.yokeTemperature) : null,
          arc_current: formState.arcCurrent ? parseFloat(formState.arcCurrent) : null,
          filament_current: formState.filamentCurrent ? parseFloat(formState.filamentCurrent) : null,
          pie_width: formState.pieWidth ? parseFloat(formState.pieWidth) : null,
          p2e_width: formState.p2eWidth ? parseFloat(formState.p2eWidth) : null,
        }),
      };

      // Insert log entry
      const { data: logEntry, error: logError } = await supabase
        .from('log_entries')
        .insert([entry])
        .select()
        .single();

      if (logError) throw logError;

      // Update suggestions for all text fields
      await Promise.all([
        // Always update description suggestion
        supabase.rpc('upsert_log_suggestion', {
          p_category: formState.category,
          p_description: formState.description.trim()
        }),
        // Update case number suggestion if present
        formState.category === 'downtime' && formState.caseNumber ? 
          supabase.rpc('upsert_log_suggestion', {
            p_category: 'downtime',
            p_description: formState.caseNumber.trim()
          }) : Promise.resolve(),
        // Update workorder number suggestion if present
        formState.category === 'workorder' && formState.workorderNumber ?
          supabase.rpc('upsert_log_suggestion', {
            p_category: 'workorder',
            p_description: formState.workorderNumber.trim()
          }) : Promise.resolve()
      ]);

      // Upload files if any
      if (files.length > 0) {
        for (const file of files) {
          const fileExt = file.name.split('.').pop();
          const fileName = `${Math.random().toString(36).substring(2)}.${fileExt}`;
          const filePath = `${user.id}/${logEntry.id}/${fileName}`;

          const { error: uploadError } = await supabase.storage
            .from('attachments')
            .upload(filePath, file);

          if (uploadError) throw uploadError;

          const { error: attachmentError } = await supabase
            .from('attachments')
            .insert([{
              log_entry_id: logEntry.id,
              file_name: file.name,
              file_type: file.type,
              file_size: file.size,
              file_path: filePath,
              user_id: user.id
            }]);

          if (attachmentError) throw attachmentError;
        }
      }

      // Show success animation
      setShowSuccessAnimation(true);
      setTimeout(() => {
        toast.success('Log entry added successfully');
        onClose();
      }, 1000);

    } catch (error) {
      console.error('Error adding log entry:', error);
      toast.error('Failed to add log entry');
      setSubmitting(false);
    }
  };

  const renderSuggestionsDropdown = () => {
    if (!showSuggestions) return null;

    return (
      <div 
        ref={suggestionsRef}
        className="absolute z-10 w-full mt-1 bg-gray-800 border border-gray-700 rounded-md shadow-lg overflow-hidden"
      >
        {suggestions.map((suggestion) => (
          <button
            key={suggestion.id}
            type="button"
            onClick={() => handleSuggestionClick(suggestion)}
            className="w-full px-4 py-2 text-left text-gray-200 hover:bg-gray-700 focus:outline-none focus:bg-gray-700 transition-colors"
          >
            <div className="flex justify-between items-center">
              <span className="truncate">{suggestion.description}</span>
              <span className="text-xs text-gray-400 ml-2 whitespace-nowrap">Used {suggestion.usage_count} times</span>
            </div>
          </button>
        ))}
      </div>
    );
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
          <div className="fixed inset-0 bg-black bg-opacity-75" />
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
              <Dialog.Panel className="w-full max-w-2xl transform overflow-hidden rounded-2xl bg-gray-800 p-6 shadow-xl transition-all">
                <form ref={formRef} onSubmit={handleSubmit} className="space-y-6">
                  <div className="flex justify-between items-center">
                    <Dialog.Title className="text-xl font-semibold text-white flex items-center space-x-2">
                      <span>New Log Entry</span>
                      <span className="px-2 py-1 text-sm rounded-md bg-blue-900 text-blue-200">
                        {shift.charAt(0).toUpperCase() + shift.slice(1)} Shift
                      </span>
                    </Dialog.Title>
                    <button
                      type="button"
                      onClick={onClose}
                      className="text-gray-400 hover:text-white transition-colors rounded-full hover:bg-gray-700 p-1"
                    >
                      <X className="h-6 w-6" />
                    </button>
                  </div>

                  <div className="space-y-4">
                    <div className="relative">
                      <label className="block text-sm font-medium text-gray-200 mb-1">Category</label>
                      <select
                        value={formState.category}
                        onChange={(e) => {
                          const newCategory = e.target.value as LogCategory;
                          updateFormState('category', newCategory);
                          setShowSuggestions(false);
                          setActiveSuggestionField(null);
                          Object.keys(suggestionCacheRef.current)
                            .filter(key => key.startsWith(`${formState.category}:`))
                            .forEach(key => delete suggestionCacheRef.current[key]);
                        }}
                        className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                      >
                        <option value="error">Error</option>
                        <option value="general">General Info</option>
                        <option value="downtime">Downtime</option>
                        <option value="workorder">Workorder</option>
                        <option value="data-collection">Data Collection</option>
                      </select>
                    </div>

                    <div className="relative">
                      <label className="block text-sm font-medium text-gray-200 mb-1">Description</label>
                      <textarea
                        value={formState.description}
                        onChange={(e) => handleInputChange(e, 'description')}
                        onFocus={() => formState.description.length >= 2 && fetchSuggestions(formState.description, 'description')}
                        rows={3}
                        required
                        placeholder="Enter log description..."
                        className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors resize-none"
                      />
                      {activeSuggestionField === 'description' && renderSuggestionsDropdown()}
                    </div>

                    {formState.category === 'downtime' && (
                      <div className="space-y-4 bg-gray-700/50 p-4 rounded-lg border border-gray-600">
                        <div className="relative">
                          <label className="block text-sm font-medium text-gray-200 mb-1">
                            Salesforce Case Number
                          </label>
                          <input
                            type="text"
                            value={formState.caseNumber}
                            onChange={(e) => handleInputChange(e, 'caseNumber')}
                            onFocus={() => formState.caseNumber.length >= 2 && fetchSuggestions(formState.caseNumber, 'caseNumber')}
                            required
                            placeholder="Enter case number..."
                            className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                          />
                          {activeSuggestionField === 'caseNumber' && renderSuggestionsDropdown()}
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">Status</label>
                          <select
                            value={formState.caseStatus}
                            onChange={(e) => updateFormState('caseStatus', e.target.value)}
                            className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                          >
                            <option value="ongoing">Ongoing</option>
                            <option value="closed">Closed</option>
                          </select>
                        </div>
                      </div>
                    )}

                    {formState.category === 'workorder' && (
                      <div className="space-y-4 bg-gray-700/50 p-4 rounded-lg border border-gray-600">
                        <div className="relative">
                          <label className="block text-sm font-medium text-gray-200 mb-1">
                            Salesforce Workorder Number
                          </label>
                          <input
                            type="text"
                            value={formState.workorderNumber}
                            onChange={(e) => handleInputChange(e, 'workorderNumber')}
                            onFocus={() => formState.workorderNumber.length >= 2 && fetchSuggestions(formState.workorderNumber, 'workorderNumber')}
                            required
                            placeholder="Enter workorder number..."
                            className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                          />
                          {activeSuggestionField === 'workorderNumber' && renderSuggestionsDropdown()}
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-200 mb-1">Status</label>
                          <select
                            value={formState.workorderStatus}
                            onChange={(e) => updateFormState('workorderStatus', e.target.value)}
                            className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                          >
                            <option value="ongoing">Ongoing</option>
                            <option value="technically-completed">Technically Completed</option>
                          </select>
                        </div>
                      </div>
                    )}

                    {formState.category === 'data-collection' && (
                      <div className="bg-gray-700/50 p-4 rounded-lg border border-gray-600">
                        <div className="grid grid-cols-2 gap-4">
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              MC Setpoint
                            </label>
                            <input
                              type="number"
                              value={formState.mcSetpoint}
                              onChange={(e) => updateFormState('mcSetpoint', e.target.value)}
                              required
                              step="0.01"
                              placeholder="Enter MC setpoint..."
                              className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              Yoke Temperature
                            </label>
                            <input
                              type="number"
                              value={formState.yokeTemperature}
                              onChange={(e) => updateFormState('yokeTemperature', e.target.value)}
                              required
                              step="0.1"
                              placeholder="Enter yoke temperature..."
                              className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              Arc Current
                            </label>
                            <input
                              type="number"
                              value={formState.arcCurrent}
                              onChange={(e) => updateFormState('arcCurrent', e.target.value)}
                              required
                              step="0.1"
                              placeholder="Enter arc current..."
                              className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              Filament Current
                            </label>
                            <input
                              type="number"
                              value={formState.filamentCurrent}
                              onChange={(e) => updateFormState('filamentCurrent', e.target.value)}
                              required
                              step="0.1"
                              placeholder="Enter filament current..."
                              className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              PIE Width
                            </label>
                            <input
                              type="number"
                              value={formState.pieWidth}
                              onChange={(e) => updateFormState('pieWidth', e.target.value)}
                              required
                              step="0.01"
                              placeholder="Enter PIE width..."
                              className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-200 mb-1">
                              P2E Width
                            </label>
                            <input
                              type="number"
                              value={formState.p2eWidth}
                              onChange={(e) => updateFormState('p2eWidth', e.target.value)}
                              required
                              step="0.01"
                              placeholder="Enter P2E width..."
                              className="mt-1 block w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500 transition-colors"
                            />
                          </div>
                        </div>
                      </div>
                    )}

                    <div>
                      <label className="block text-sm font-medium text-gray-200 mb-2">
                        Attachments
                      </label>
                      <FileUpload files={files} onFilesChange={setFiles} />
                    </div>
                  </div>

                  <div className="flex justify-end space-x-3 pt-4 border-t border-gray-700">
                    <button
                      type="button"
                      onClick={onClose}
                      disabled={submitting}
                      className="px-4 py-2 bg-gray-700 text-white rounded-md hover:bg-gray-600 transition-colors flex items-center space-x-2"
                    >
                      <X className="h-4 w-4" />
                      <span>Cancel</span>
                    </button>
                    <button
                      type="submit"
                      disabled={submitting}
                      className={`px-4 py-2 ${
                        showSuccessAnimation 
                          ? 'bg-green-600 hover:bg-green-700' 
                          : 'bg-blue-600 hover:bg-blue-700'
                      } text-white rounded-md transition-colors flex items-center space-x-2`}
                    >
                      {showSuccessAnimation ? (
                        <>
                          <CheckCircle2 className="h-4 w-4" />
                          <span>Saved!</span>
                        </>
                      ) : submitting ? (
                        <>
                          <Loader2 className="h-4 w-4 animate-spin" />
                          <span>Saving...</span>
                        </>
                      ) : (
                        <>
                          <Save className="h-4 w-4" />
                          <span>Save Entry</span>
                        </>
                      )}
                    </button>
                  </div>
                </form>
              </Dialog.Panel>
            </Transition.Child>
          </div>
        </div>
      </Dialog>
    </Transition>
  );
};

export default LogEntryForm;