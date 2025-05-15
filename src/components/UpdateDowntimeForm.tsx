import React, { useState } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { Fragment } from 'react';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';
import { X, Calendar, Clock } from 'lucide-react';
import { differenceInMinutes } from 'date-fns';
import { DateTimeInput } from './DateTimeInput';
import { LogEntry } from '../types';

interface UpdateDowntimeFormProps {
  entry: LogEntry;
  onClose: () => void;
  onUpdate: () => void;
}

const UpdateDowntimeForm: React.FC<UpdateDowntimeFormProps> = ({ entry, onClose, onUpdate }) => {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [startTime, setStartTime] = useState<string>(entry.dt_start_time || '');
  const [endTime, setEndTime] = useState<string | null>(entry.dt_end_time || null);
  const [duration, setDuration] = useState<number | null>(entry.dt_duration || null);

  const calculateDuration = (start: string, end: string) => {
    const duration = differenceInMinutes(new Date(end), new Date(start));
    return duration >= 0 ? duration : 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);

    try {
      if (!startTime) {
        throw new Error('Start time is required');
      }

      const updatedData: {
        dt_start_time: string;
        dt_end_time: string | null;
        dt_duration: number | null;
      } = {
        dt_start_time: startTime,
        dt_end_time: endTime,
        dt_duration: endTime ? calculateDuration(startTime, endTime) : null
      };

      const { error } = await supabase
        .from('log_entries')
        .update(updatedData)
        .eq('id', entry.id);

      if (error) throw error;

      toast.success('Downtime updated successfully');
      onUpdate();
      onClose();
    } catch (error) {
      console.error('Error updating downtime:', error);
      toast.error('Failed to update downtime');
    } finally {
      setIsSubmitting(false);
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
              <Dialog.Panel className="w-full max-w-md transform overflow-hidden rounded-2xl bg-gray-800 p-6 shadow-xl transition-all">
                <div className="flex items-center justify-between mb-6">
                  <Dialog.Title className="text-xl font-semibold text-white">
                    Update Downtime
                  </Dialog.Title>
                  <button
                    onClick={onClose}
                    className="text-gray-400 hover:text-white transition-colors p-2 hover:bg-white/10 rounded-lg"
                  >
                    <X className="h-5 w-5" />
                  </button>
                </div>

                <form onSubmit={handleSubmit} className="space-y-6">
                  <div>
                    <label className="block text-sm font-medium text-gray-200 mb-1" htmlFor="dt-start-time">
                      DT Start Time *
                    </label>
                    <div className="relative flex items-center gap-2">
                      <DateTimeInput
                        value={startTime}
                        onChange={(value) => {
                          setStartTime(value);
                          if (endTime) {
                            setDuration(calculateDuration(value, endTime));
                          }
                        }}
                        className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 pr-10"
                        id="dt-start-time"
                      />
                      <button
                        type="button"
                        tabIndex={-1}
                        aria-label="Open date/time picker for start time"
                        className="absolute right-2 text-gray-400 hover:text-indigo-400 focus:outline-none"
                        onClick={() => {
                          const input = document.getElementById('dt-start-time');
                          if (input) (input as HTMLInputElement).focus();
                        }}
                      >
                        <Calendar className="h-5 w-5" />
                      </button>
                    </div>
                    <p className="text-xs text-gray-400 mt-1">You can type or pick a date and time.</p>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-200 mb-1" htmlFor="dt-end-time">
                      DT End Time (Optional)
                    </label>
                    <div className="relative flex items-center gap-2">
                      <DateTimeInput
                        value={endTime || undefined}
                        onChange={(value) => {
                          setEndTime(value);
                          if (value && startTime) {
                            setDuration(calculateDuration(startTime, value));
                          } else {
                            setDuration(null);
                          }
                        }}
                        className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 pr-10"
                        id="dt-end-time"
                      />
                      <button
                        type="button"
                        tabIndex={-1}
                        aria-label="Open date/time picker for end time"
                        className="absolute right-2 text-gray-400 hover:text-indigo-400 focus:outline-none"
                        onClick={() => {
                          const input = document.getElementById('dt-end-time');
                          if (input) (input as HTMLInputElement).focus();
                        }}
                      >
                        <Clock className="h-5 w-5" />
                      </button>
                    </div>
                    <p className="text-xs text-gray-400 mt-1">You can type or pick a date and time.</p>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-200 mb-1">
                      DT Duration (minutes)
                    </label>
                    <input
                      type="number"
                      value={duration || ''}
                      readOnly
                      placeholder="Will be calculated automatically"
                      className="w-full rounded-lg bg-white/5 border-0 text-white px-4 py-2.5"
                    />
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
                      disabled={isSubmitting || !startTime}
                      className={`px-4 py-2 rounded-lg text-white ${
                        isSubmitting || !startTime
                          ? 'bg-indigo-500/50 cursor-not-allowed'
                          : 'bg-indigo-600 hover:bg-indigo-700'
                      } transition-colors`}
                    >
                      {isSubmitting ? 'Updating...' : 'Update'}
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

export default UpdateDowntimeForm; 