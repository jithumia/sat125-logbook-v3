import React from 'react';
import { ShiftType } from '../types';

interface ShiftSelectorProps {
  currentShift: ShiftType;
  onShiftChange: (shift: ShiftType) => void;
}

const ShiftSelector: React.FC<ShiftSelectorProps> = ({ currentShift, onShiftChange }) => {
  return (
    <div className="flex space-x-2">
      <button
        onClick={() => onShiftChange('morning')}
        className={`px-4 py-2 rounded-md ${
          currentShift === 'morning'
            ? 'bg-blue-600 text-white'
            : 'bg-gray-700 text-gray-200 hover:bg-gray-600'
        }`}
      >
        Morning (6AM-2PM)
      </button>
      <button
        onClick={() => onShiftChange('afternoon')}
        className={`px-4 py-2 rounded-md ${
          currentShift === 'afternoon'
            ? 'bg-blue-600 text-white'
            : 'bg-gray-700 text-gray-200 hover:bg-gray-600'
        }`}
      >
        Afternoon (2PM-11PM)
      </button>
      <button
        onClick={() => onShiftChange('night')}
        className={`px-4 py-2 rounded-md ${
          currentShift === 'night'
            ? 'bg-blue-600 text-white'
            : 'bg-gray-700 text-gray-200 hover:bg-gray-600'
        }`}
      >
        Night (11PM-6AM)
      </button>
    </div>
  );
};

export default ShiftSelector;