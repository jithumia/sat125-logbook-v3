import React, { useState } from 'react';
import { X } from 'lucide-react';
import { ActiveShift } from '../types';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';

interface EndShiftModalProps {
  onClose: () => void;
  onSuccess: () => void;
  activeShift: ActiveShift | null;
}

const EndShiftModal: React.FC<EndShiftModalProps> = ({ onClose, onSuccess, activeShift }) => {
  const [note, setNote] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!note.trim()) {
      toast.error('Please enter a shift note');
      return;
    }

    if (!activeShift) {
      toast.error('No active shift found');
      onClose();
      return;
    }

    try {
      setLoading(true);

      const { data: { user } } = await supabase.auth.getUser();
      
      if (!user) {
        throw new Error('No user found');
      }

      // Step 1: Create shift note
      const { error: noteError } = await supabase
        .from('shift_notes')
        .insert([{
          shift_type: activeShift.shift_type,
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
          shift_type: activeShift.shift_type,
          category: 'shift',
          description: `${activeShift.shift_type} shift ended. Note: ${note.trim()}`,
          user_id: user.id
        }]);

      if (logError) {
        console.error('Error creating log entry:', logError);
        throw new Error('Failed to create log entry');
      }

      // Step 3: Delete active shift using stored procedure
      const { error: deleteError } = await supabase.rpc('cleanup_shifts', {
        shift_ids: [activeShift.id]
      });

      if (deleteError) {
        console.error('Error calling cleanup_shifts:', deleteError);
        throw new Error('Failed to delete active shift');
      }

      toast.success('Shift ended successfully');
      await onSuccess();
      onClose();
    } catch (error) {
      console.error('Error ending shift:', error);
      toast.error(error instanceof Error ? error.message : 'Failed to end shift');
    } finally {
      setLoading(false);
    }
  };

  if (!activeShift) {
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
              disabled={loading}
              className="px-4 py-2 bg-gray-700 text-white rounded-md hover:bg-gray-600 transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors flex items-center"
            >
              {loading ? (
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