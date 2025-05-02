import React, { useState, useEffect, useRef } from 'react';
import { ChevronUp, ChevronDown } from 'lucide-react';

interface TimePickerProps {
  value: string;
  onChange: (value: string) => void;
  className?: string;
}

const TimePicker: React.FC<TimePickerProps> = ({ value, onChange, className = '' }) => {
  const [hours, setHours] = useState<number>(0);
  const [minutes, setMinutes] = useState<number>(0);
  const [isOpen, setIsOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (value) {
      const date = new Date(value);
      setHours(date.getHours());
      setMinutes(date.getMinutes());
    }
  }, [value]);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleHoursChange = (newHours: number) => {
    setHours(newHours);
    const date = new Date(value);
    date.setHours(newHours);
    onChange(date.toISOString());
  };

  const handleMinutesChange = (newMinutes: number) => {
    setMinutes(newMinutes);
    const date = new Date(value);
    date.setMinutes(newMinutes);
    onChange(date.toISOString());
  };

  const formatTime = (value: number) => value.toString().padStart(2, '0');

  return (
    <div ref={containerRef} className={`relative ${className}`}>
      <div
        className="flex items-center gap-1 bg-gray-700 px-3 py-2 rounded border border-gray-600 cursor-pointer"
        onClick={() => setIsOpen(!isOpen)}
      >
        <span className="text-white">{formatTime(hours)}</span>
        <span className="text-gray-400">:</span>
        <span className="text-white">{formatTime(minutes)}</span>
      </div>

      {isOpen && (
        <div className="absolute z-10 mt-1 w-full bg-gray-800 rounded-lg border border-gray-700 shadow-lg">
          <div className="flex p-2 gap-4">
            {/* Hours Picker */}
            <div className="flex-1">
              <div className="flex justify-center items-center gap-2 mb-2">
                <button
                  onClick={() => handleHoursChange((hours + 1) % 24)}
                  className="p-1 text-gray-400 hover:text-white"
                >
                  <ChevronUp className="h-4 w-4" />
                </button>
              </div>
              <div className="h-32 overflow-y-auto scrollbar-hide">
                {Array.from({ length: 24 }, (_, i) => (
                  <div
                    key={i}
                    className={`text-center py-1 cursor-pointer ${
                      hours === i
                        ? 'bg-indigo-600 text-white'
                        : 'text-gray-300 hover:bg-gray-700'
                    }`}
                    onClick={() => handleHoursChange(i)}
                  >
                    {formatTime(i)}
                  </div>
                ))}
              </div>
              <div className="flex justify-center items-center gap-2 mt-2">
                <button
                  onClick={() => handleHoursChange((hours - 1 + 24) % 24)}
                  className="p-1 text-gray-400 hover:text-white"
                >
                  <ChevronDown className="h-4 w-4" />
                </button>
              </div>
            </div>

            {/* Minutes Picker */}
            <div className="flex-1">
              <div className="flex justify-center items-center gap-2 mb-2">
                <button
                  onClick={() => handleMinutesChange((minutes + 1) % 60)}
                  className="p-1 text-gray-400 hover:text-white"
                >
                  <ChevronUp className="h-4 w-4" />
                </button>
              </div>
              <div className="h-32 overflow-y-auto scrollbar-hide">
                {Array.from({ length: 60 }, (_, i) => (
                  <div
                    key={i}
                    className={`text-center py-1 cursor-pointer ${
                      minutes === i
                        ? 'bg-indigo-600 text-white'
                        : 'text-gray-300 hover:bg-gray-700'
                    }`}
                    onClick={() => handleMinutesChange(i)}
                  >
                    {formatTime(i)}
                  </div>
                ))}
              </div>
              <div className="flex justify-center items-center gap-2 mt-2">
                <button
                  onClick={() => handleMinutesChange((minutes - 1 + 60) % 60)}
                  className="p-1 text-gray-400 hover:text-white"
                >
                  <ChevronDown className="h-4 w-4" />
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default TimePicker; 