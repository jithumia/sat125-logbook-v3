import React, { useState, useEffect, useRef } from 'react';
import { ChevronUp, ChevronDown, Calendar, Clock } from 'lucide-react';
import { format, parse, addDays, subDays, isSameDay } from 'date-fns';

interface DateTimePickerProps {
  value: string;
  onChange: (value: string) => void;
  className?: string;
  label?: string;
  required?: boolean;
}

const DateTimePicker: React.FC<DateTimePickerProps> = ({
  value,
  onChange,
  className = '',
  label,
  required = false
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [selectedDate, setSelectedDate] = useState<Date>(new Date(value));
  const [selectedTime, setSelectedTime] = useState<{ hours: number; minutes: number }>({
    hours: new Date(value).getHours(),
    minutes: new Date(value).getMinutes()
  });
  const containerRef = useRef<HTMLDivElement>(null);

  // Add state to track last selected field
  const [lastSelected, setLastSelected] = useState<'date' | 'hours' | 'minutes' | null>(null);

  useEffect(() => {
    if (value) {
      const date = new Date(value);
      setSelectedDate(date);
      setSelectedTime({
        hours: date.getHours(),
        minutes: date.getMinutes()
      });
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

  const handleDateChange = (date: Date) => {
    setSelectedDate(date);
    const newDate = new Date(date);
    newDate.setHours(selectedTime.hours, selectedTime.minutes);
    onChange(newDate.toISOString());
  };

  const handleTimeChange = (type: 'hours' | 'minutes', value: number) => {
    const newTime = {
      ...selectedTime,
      [type]: value
    };
    setSelectedTime(newTime);
    const newDate = new Date(selectedDate);
    newDate.setHours(newTime.hours, newTime.minutes);
    onChange(newDate.toISOString());

    // Track if both hours and minutes have been changed
    if (type === 'minutes') {
      setIsOpen(false); // Close the popup after selecting minutes
    }
  };

  const generateDates = () => {
    const dates = [];
    const today = new Date();
    const startDate = subDays(today, 7);
    const endDate = addDays(today, 7);

    for (let date = startDate; date <= endDate; date = addDays(date, 1)) {
      dates.push(date);
    }
    return dates;
  };

  const formatTime = (value: number) => value.toString().padStart(2, '0');

  const generateTimeOptions = (type: 'hours' | 'minutes') => {
    const count = type === 'hours' ? 24 : 60;
    const step = type === 'hours' ? 1 : 5;
    const options = [];
    
    for (let i = 0; i < count; i += step) {
      options.push(i);
    }
    
    return options;
  };

  return (
    <div ref={containerRef} className={`relative ${className}`}>
      {label && (
        <label className="block text-sm font-medium text-gray-300 mb-1">
          {label}
          {required && <span className="text-red-500 ml-1">*</span>}
        </label>
      )}
      
      <div
        className="flex items-center gap-2 bg-gray-700 px-3 py-2 rounded border border-gray-600 cursor-pointer hover:border-indigo-500 transition-colors"
        onClick={() => setIsOpen(!isOpen)}
      >
        <Calendar className="h-4 w-4 text-gray-400" />
        <span className="text-white">
          {format(selectedDate, 'MMM d, yyyy')}
        </span>
        <span className="text-gray-400">|</span>
        <Clock className="h-4 w-4 text-gray-400" />
        <span className="text-white">
          {formatTime(selectedTime.hours)}:{formatTime(selectedTime.minutes)}
        </span>
      </div>

      {isOpen && (
        <div className="absolute z-10 mt-1 w-full bg-gray-800 rounded-lg border border-gray-700 shadow-lg">
          <div className="p-4 space-y-4">
            {/* Date Selection */}
            <div>
              <h3 className="text-sm font-medium text-gray-300 mb-2">Select Date</h3>
              <div className="grid grid-cols-7 gap-1">
                {generateDates().map((date) => (
                  <button
                    key={date.toISOString()}
                    onClick={() => {
                      handleDateChange(date);
                      setLastSelected('date');
                    }}
                    className={`p-2 rounded text-sm ${
                      isSameDay(date, selectedDate)
                        ? 'bg-indigo-600 text-white'
                        : 'text-gray-300 hover:bg-gray-700'
                    }`}
                  >
                    {format(date, 'd')}
                    <div className="text-xs opacity-50">
                      {format(date, 'EEE')}
                    </div>
                  </button>
                ))}
              </div>
            </div>

            {/* Time Selection */}
            <div>
              <h3 className="text-sm font-medium text-gray-300 mb-2">Select Time</h3>
              <div className="flex gap-4">
                {/* Hours */}
                <div className="flex-1">
                  <label className="block text-xs text-gray-400 mb-1">Hours</label>
                  <div className="relative">
                    <select
                      value={selectedTime.hours}
                      onChange={(e) => {
                        handleTimeChange('hours', parseInt(e.target.value));
                        setLastSelected('hours');
                      }}
                      onFocus={() => setLastSelected('hours')}
                      className="w-full bg-gray-700 border border-gray-600 rounded px-2 py-1.5 text-white text-sm appearance-none cursor-pointer hover:border-indigo-500 focus:outline-none focus:border-indigo-500"
                    >
                      {generateTimeOptions('hours').map((hour) => (
                        <option key={hour} value={hour}>
                          {formatTime(hour)}
                        </option>
                      ))}
                    </select>
                    <ChevronDown className="absolute right-2 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
                  </div>
                </div>

                {/* Minutes */}
                <div className="flex-1">
                  <label className="block text-xs text-gray-400 mb-1">Minutes</label>
                  <div className="relative">
                    <select
                      value={selectedTime.minutes}
                      onChange={(e) => {
                        handleTimeChange('minutes', parseInt(e.target.value));
                        setLastSelected('minutes');
                      }}
                      onFocus={() => setLastSelected('minutes')}
                      className="w-full bg-gray-700 border border-gray-600 rounded px-2 py-1.5 text-white text-sm appearance-none cursor-pointer hover:border-indigo-500 focus:outline-none focus:border-indigo-500"
                    >
                      {generateTimeOptions('minutes').map((minute) => (
                        <option key={minute} value={minute}>
                          {formatTime(minute)}
                        </option>
                      ))}
                    </select>
                    <ChevronDown className="absolute right-2 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default DateTimePicker; 