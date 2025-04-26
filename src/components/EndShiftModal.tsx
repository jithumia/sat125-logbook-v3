import React, { useState, useEffect } from 'react';
import { X } from 'lucide-react';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';

interface EndShiftModalProps {
  onClose: () => void;
  currentShift: string;
  onShiftEnded: () => void;
}

const EndShiftModal: React.FC<EndShiftModalProps> = ({ onClose, currentShift, onShiftEnded }) => {
  const [note, setNote] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [activeShiftId, setActiveShiftId] = useState<string | null>(null);

  useEffect(() => {
    fetchActiveShift();
  }, [currentShift]);

  const fetchActiveShift = async () => {
    try {
      const { data: activeShifts, error } = await supabase
        .from('active_shifts')
        .select('id, shift_type')
        .eq('shift_type', currentShift)
        .maybeSingle();

      if (error) {
        console.error('Error fetching active shift:', error);
        toast.error('Failed to verify active shift');
        onClose();
        return;
      }

      if (!activeShifts) {
        console.error('No active shift found');
        toast.error('No active shift found');
        onClose();
        return;
      }

      setActiveShiftId(activeShifts.id);
    } catch (error) {
      console.error('Error in fetchActiveShift:', error);
      toast.error('Failed to verify active shift');
      onClose();
    }
  };

  const deleteActiveShift = async (shiftId: string): Promise<boolean> => {
    try {
      // Call the cleanup_shifts stored procedure
      const { error } = await supabase.rpc('cleanup_shifts', {
        shift_ids: [shiftId]
      });

      if (error) {
        console.error('Error calling cleanup_shifts:', error);
        return false;
      }

      // Verify the deletion
      const { data: shift, error: verifyError } = await supabase
        .from('active_shifts')
        .select('id')
        .eq('id', shiftId)
        .maybeSingle();

      if (verifyError) {
        console.error('Error verifying shift deletion:', verifyError);
        return false;
      }

      // If shift is null, it means it was successfully deleted
      return shift === null;
    } catch (error) {
      console.error('Error in deleteActiveShift:', error);
      return false;
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!note.trim()) {
      toast.error('Please enter a shift note');
      return;
    }

    if (!activeShiftId) {
      toast.error('No active shift found');
      onClose();
      return;
    }

    try {
      setSubmitting(true);

      const { data: { user } } = await supabase.auth.getUser();
      
      if (!user) {
        throw new Error('No user found');
      }

      // Step 1: Create shift note
      const { error: noteError } = await supabase
        .from('shift_notes')
        .insert([{
          shift_type: currentShift,
          note: note.trim(),
          user_id: user.id
        }]);

      if (noteError) {
        console.error('Error creating shift note:', noteError);
        throw new Error('Failed to create shift note');
      }

      // Step 2: Create log entry
      const { error: logError } = await supabase
        .from('log_entries')
        .insert([{
          shift_type: currentShift,
          category: 'shift',
          description: `${currentShift} shift ended. Note: ${note.trim()}`,
          user_id: user.id
        }]);

      if (logError) {
        console.error('Error creating log entry:', logError);
        throw new Error('Failed to create log entry');
      }

      // Step 3: Delete active shift using stored procedure
      const deleted = await deleteActiveShift(activeShiftId);

      if (!deleted) {
        throw new Error(`Failed to delete active shift (ID: ${activeShiftId})`);
      }

      toast.success('Shift ended successfully');
      await onShiftEnded();
      onClose();
    } catch (error) {
      console.error('Error ending shift:', error);
      toast.error(error instanceof Error ? error.message : 'Failed to end shift');
    } finally {
      setSubmitting(false);
    }
  };

  if (!activeShiftId) {
    return null;
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50">
      <div className="bg-gray-800 rounded-lg p-6 w-full max-w-md">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-semibold text-white">End Shift</h2>
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
              Shift Note (pending tasks, handover information)
            </label>
            <textarea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              required
              rows={4}
              className="w-full rounded-md bg-gray-700 border-gray-600 text-white shadow-sm focus:border-blue-500 focus:ring-blue-500"
              placeholder="Enter shift note..."
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
              className="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors flex items-center"
            >
              {submitting ? (
                <>
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                  Ending...
                </>
              ) : (
                'End Shift'
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default EndShiftModal;