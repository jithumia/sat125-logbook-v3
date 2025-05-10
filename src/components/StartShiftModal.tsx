import React, { useEffect, useState } from 'react';
import { X } from 'lucide-react';
import { Engineer, ShiftType } from '../types';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';

interface StartShiftModalProps {
  onClose: () => void;
  onSuccess: () => void;
}

const StartShiftModal: React.FC<StartShiftModalProps> = ({ onClose, onSuccess }) => {
  const [engineers, setEngineers] = useState<Engineer[]>([]);
  const [selectedEngineers, setSelectedEngineers] = useState<string[]>([]);
  const [salesforceNumber, setSalesforceNumber] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [loading, setLoading] = useState(true);
  const [shiftType, setShiftType] = useState<ShiftType>('morning');
  const [shiftId, setShiftId] = useState('');

  useEffect(() => {
    fetchEngineers();
  }, []);

  const fetchEngineers = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('engineers')
        .select('*')
        .order('name');

      if (error) throw error;
      setEngineers(data || []);
    } catch (error) {
      console.error('Error fetching engineers:', error);
      toast.error('Failed to load engineers');
    } finally {
      setLoading(false);
    }
  };

  const getCurrentShiftType = (): ShiftType => {
    const now = new Date();
    const hour = now.getHours();
    
    if (hour >= 6 && hour < 14) return 'morning';
    if (hour >= 14 && hour < 23) return 'afternoon';
    return 'night';
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (selectedEngineers.length === 0) {
      toast.error('Please select at least one engineer');
      return;
    }

    if (!salesforceNumber.trim()) {
      toast.error('Please enter the Salesforce shift report number');
      return;
    }

    if (!shiftId.trim()) {
      toast.error('Please enter the Shift ID (Salesforce Shift Report ID)');
      return;
    }

    try {
      setSubmitting(true);

      // First check if we have a valid session
      const { data: sessionData, error: sessionError } = await supabase.auth.getSession();
      
      if (sessionError) {
        throw new Error('Failed to get session');
      }

      if (!sessionData.session) {
        toast.error('Your session has expired. Please sign in again.');
        await supabase.auth.signOut();
        // You might want to add a callback here to redirect to the login page
        return;
      }

      const { data: { user }, error: userError } = await supabase.auth.getUser();
      
      if (userError || !user) {
        toast.error('Authentication error. Please sign in again.');
        await supabase.auth.signOut();
        return;
      }

      const shiftType = getCurrentShiftType();
      const engineerNames = engineers
        .filter(eng => selectedEngineers.includes(eng.id))
        .map(eng => eng.name)
        .join(', ');

      // Step 1: Create the active shift
      const { data: newShift, error: shiftError } = await supabase
        .from('active_shifts')
        .insert([{
          shift_type: shiftType,
          started_by: user.id,
          salesforce_number: salesforceNumber.trim(),
          started_at: new Date().toISOString()
        }])
        .select()
        .single();

      if (shiftError) {
        if (shiftError.message.includes('Another shift is already active')) {
          toast.error('Another shift is already active');
          onClose();
          return;
        }
        throw shiftError;
      }

      if (!newShift) throw new Error('Failed to create shift');

      // Step 2: Add engineers to the shift
      const shiftEngineers = selectedEngineers.map(engineerId => ({
        shift_id: newShift.id,
        engineer_id: engineerId
      }));

      const { error: engineersError } = await supabase
        .from('shift_engineers')
        .insert(shiftEngineers);

      if (engineersError) {
        // Rollback: Delete the active shift if engineer assignment fails
        await supabase
          .from('active_shifts')
          .delete()
          .eq('id', newShift.id);
        throw engineersError;
      }

      // Step 3: Create the shift log entry
      const { error: logError } = await supabase
        .from('log_entries')
        .insert([{
          shift_type: shiftType,
          category: 'shift',
          description: `${shiftType} shift started by ${engineerNames} (SF#: ${salesforceNumber.trim()})`,
          user_id: user.id,
          shift_id: shiftId.trim(),
        }]);

      if (logError) {
        // Rollback: Delete everything if log creation fails
        await supabase
          .from('active_shifts')
          .delete()
          .eq('id', newShift.id);
        throw logError;
      }

      // Success! Update the UI
      console.log('Shift created successfully, calling onSuccess');
      onSuccess();
      console.log('onSuccess called, showing toast and closing modal');
      toast.success('Shift started successfully');
      onClose();
      console.log('onClose called, modal should close');
    } catch (error) {
      console.error('Error starting shift:', error);
      toast.error('Failed to start shift. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50">
        <div className="bg-gray-800 rounded-lg p-6 w-full max-w-md">
          <div className="flex justify-center items-center h-32">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50">
      <div className="bg-gray-800 rounded-lg p-6 w-full max-w-md">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-semibold text-white">Start New Shift</h2>
          <button
            type="button"
            onClick={onClose}
            className="text-gray-400 hover:text-white transition-colors"
          >
            <X className="h-6 w-6" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-200 mb-2">
              Select Engineers
            </label>
            <div className="grid grid-cols-2 gap-2 max-h-48 overflow-y-auto bg-gray-700 p-3 rounded-md">
              {engineers.map((engineer) => (
                <label key={engineer.id} className="flex items-center space-x-2 p-2 hover:bg-gray-600 rounded cursor-pointer">
                  <input
                    type="checkbox"
                    checked={selectedEngineers.includes(engineer.id)}
                    onChange={(e) => {
                      setSelectedEngineers(prev =>
                        e.target.checked
                          ? [...prev, engineer.id]
                          : prev.filter(id => id !== engineer.id)
                      );
                    }}
                    className="rounded bg-gray-600 border-gray-500 text-blue-500 focus:ring-blue-500 focus:ring-offset-gray-700"
                  />
                  <span className="text-gray-200">{engineer.name}</span>
                </label>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-200 mb-2">
              Salesforce Shift Report Number
            </label>
            <input
              type="text"
              value={salesforceNumber}
              onChange={(e) => setSalesforceNumber(e.target.value)}
              required
              className="w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500"
              placeholder="Enter Salesforce number"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-200 mb-2">
              Shift ID (Salesforce Shift Report ID)
            </label>
            <input
              type="text"
              value={shiftId}
              onChange={e => setShiftId(e.target.value)}
              placeholder="e.g. a44TX00001YB6jbYAD"
              className="w-full rounded-lg bg-gray-700 border border-gray-600 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500"
              required
            />
          </div>

          <div className="flex justify-end space-x-3 mt-6">
            <button
              type="button"
              onClick={onClose}
              disabled={submitting}
              className="px-4 py-2 bg-gray-700 text-white rounded-md hover:bg-gray-600 transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={submitting}
              className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors flex items-center"
            >
              {submitting ? (
                <>
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                  Starting...
                </>
              ) : (
                'Start Shift'
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default StartShiftModal;