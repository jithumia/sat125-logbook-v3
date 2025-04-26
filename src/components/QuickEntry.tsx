import { useState, KeyboardEvent } from 'react';
import { supabase } from '../lib/supabase.ts';
import { toast } from 'react-hot-toast';
import { ActiveShift } from '../types';
import { Send, Plus } from 'lucide-react';

interface QuickEntryProps {
  activeShift: ActiveShift | null;
  onEntryAdded: () => void;
  onFullFormClick: () => void;
}

export default function QuickEntry({ activeShift, onEntryAdded, onFullFormClick }: QuickEntryProps) {
  const [description, setDescription] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e?: React.FormEvent) => {
    e?.preventDefault();
    
    if (!description.trim()) {
      toast.error('Please enter a description');
      return;
    }

    if (!activeShift) {
      toast.error('No active shift found');
      return;
    }

    setIsSubmitting(true);

    try {
      const {
        data: { session },
      } = await supabase.auth.getSession();

      if (!session) {
        toast.error('No active session found');
        return;
      }

      const { error } = await supabase.from('log_entries').insert({
        shift_type: activeShift.shift_type,
        category: 'general',
        description: description.trim(),
        user_id: session.user.id,
      });

      if (error) throw error;

      toast.success('Entry added successfully');
      setDescription('');
      onEntryAdded();
    } catch (error) {
      console.error('Error adding entry:', error);
      toast.error('Failed to add entry');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleKeyPress = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSubmit();
    }
  };

  return (
    <div className="mt-4">
      <div className="flex items-center justify-between mb-2">
        <h4 className="text-lg font-medium text-white">Quick Entry</h4>
        <button
          onClick={onFullFormClick}
          className="flex items-center space-x-2 text-sm text-indigo-400 hover:text-indigo-300 transition-colors"
        >
          <Plus className="h-4 w-4" />
          <span>Advanced Entry</span>
        </button>
      </div>
      <form onSubmit={handleSubmit} className="flex space-x-2">
        <input
          type="text"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          onKeyPress={handleKeyPress}
          placeholder="Type a quick entry and press Enter..."
          className="flex-1 bg-white/5 text-white rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition-colors"
          disabled={isSubmitting}
        />
        <button
          type="submit"
          disabled={isSubmitting}
          className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 disabled:bg-gray-600 disabled:cursor-not-allowed transition-colors"
        >
          {isSubmitting ? (
            <div className="h-5 w-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
          ) : (
            <Send className="h-5 w-5" />
          )}
        </button>
      </form>
    </div>
  );
} 