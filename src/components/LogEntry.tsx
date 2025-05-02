import React, { useState } from 'react';
import { format } from 'date-fns';
import { LogEntry as LogEntryType } from '../types';
import { AlertCircle, CheckCircle2, Clock, Paperclip, Timer } from 'lucide-react';
import UpdateDowntimeForm from './UpdateDowntimeForm';

interface LogEntryProps {
  entry: LogEntryType;
  onUpdate?: () => void;
}

const LogEntry: React.FC<LogEntryProps> = ({ entry, onUpdate }) => {
  const [showUpdateDowntimeForm, setShowUpdateDowntimeForm] = useState(false);

  const getCategoryColor = (category: string) => {
    switch (category) {
      case 'error': return 'bg-red-500/20 text-red-300 border-red-500/30';
      case 'downtime': return 'bg-yellow-500/20 text-yellow-300 border-yellow-500/30';
      case 'workorder': return 'bg-blue-500/20 text-blue-300 border-blue-500/30';
      case 'data-mc': return 'bg-purple-500/20 text-purple-300 border-purple-500/30';
      case 'data-sc': return 'bg-green-500/20 text-green-300 border-green-500/30';
      default: return 'bg-gray-500/20 text-gray-300 border-gray-500/30';
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'open': return 'text-green-400';
      case 'in_progress': return 'text-yellow-400';
      case 'pending': return 'text-orange-400';
      case 'closed': return 'text-gray-400';
      default: return 'text-gray-400';
    }
  };

  const handleUpdateSuccess = () => {
    setShowUpdateDowntimeForm(false);
    if (onUpdate) {
      onUpdate();
    }
  };

  return (
    <div className="bg-gray-800 rounded-xl p-6 border border-gray-700">
      <div className="flex items-start justify-between">
        <div className="space-y-1 w-full">
          <div className="flex items-center space-x-2">
            <span className={`text-xs px-2 py-0.5 rounded-full border ${getCategoryColor(entry.category)}`}>
              {entry.category.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}
            </span>
            <span className="text-sm text-gray-400">
              {format(new Date(entry.created_at), 'MMM d, yyyy h:mm a')}
            </span>
          </div>
          
          {/* Main content area */}
          <div className="space-y-2">
            <p className="text-white">{entry.description}</p>
            
            {/* Downtime Information - Inline Display */}
            {entry.category === 'downtime' && (
              <div className="mt-2 space-y-2">
                <div className="flex items-center space-x-4">
                  <div className="flex items-center space-x-2">
                    <Clock className="h-4 w-4 text-yellow-400" />
                    <span className="text-sm text-gray-300">
                      Start: <span className="text-white">{format(new Date(entry.dt_start_time!), 'HH:mm')}</span>
                    </span>
                  </div>
                  {entry.dt_end_time && (
                    <>
                      <div className="flex items-center space-x-2">
                        <Timer className="h-4 w-4 text-yellow-400" />
                        <span className="text-sm text-gray-300">
                          End: <span className="text-white">{format(new Date(entry.dt_end_time), 'HH:mm')}</span>
                        </span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <span className="text-sm text-gray-300">
                          Duration: <span className="text-white">{entry.dt_duration} min</span>
                        </span>
                      </div>
                    </>
                  )}
                  <button
                    onClick={() => setShowUpdateDowntimeForm(true)}
                    className="ml-auto text-sm text-indigo-400 hover:text-indigo-300 transition-colors"
                  >
                    {entry.dt_end_time ? 'Update Time' : 'Set End Time'}
                  </button>
                </div>
                {entry.case_number && (
                  <div className="flex items-center space-x-2 text-sm">
                    <span className="text-gray-400">Case:</span>
                    <span className="text-white">#{entry.case_number}</span>
                    {entry.case_status && (
                      <span className={`${getStatusColor(entry.case_status)}`}>
                        ({entry.case_status.replace('_', ' ')})
                      </span>
                    )}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Update Downtime Form Modal */}
      {showUpdateDowntimeForm && (
        <UpdateDowntimeForm
          entry={entry}
          onClose={() => setShowUpdateDowntimeForm(false)}
          onUpdate={handleUpdateSuccess}
        />
      )}

      {/* Attachments Section */}
      {entry.attachments && entry.attachments.length > 0 && (
        <div className="mt-4 pt-4 border-t border-gray-700">
          <div className="flex items-center space-x-2 text-gray-400 mb-2">
            <Paperclip className="h-4 w-4" />
            <span className="text-sm">Attachments</span>
          </div>
          <div className="grid grid-cols-2 gap-2">
            {entry.attachments.map((attachment, index) => (
              <a
                key={index}
                href={attachment.url}
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm text-indigo-400 hover:text-indigo-300 truncate"
              >
                {attachment.name}
              </a>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default LogEntry; 