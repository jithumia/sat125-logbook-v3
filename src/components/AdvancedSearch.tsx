import React from 'react';
import { Search, Calendar, X, Filter } from 'lucide-react';
import { SearchFilters, ShiftType, LogCategory } from '../types';

interface AdvancedSearchProps {
  filters: SearchFilters;
  onFiltersChange: (filters: SearchFilters) => void;
  onReset: () => void;
}

const categories: LogCategory[] = ['error', 'downtime', 'workorder', 'data-mc', 'data-sc', 'general'];

const AdvancedSearch: React.FC<AdvancedSearchProps> = ({
  filters,
  onFiltersChange,
  onReset,
}) => {
  return (
    <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl border border-gray-700/50 p-4">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-semibold text-white flex items-center">
          <Filter className="h-5 w-5 mr-2" />
          Advanced Search
        </h3>
        <button
          onClick={onReset}
          className="text-gray-400 hover:text-white transition-colors p-2 hover:bg-white/10 rounded-lg"
          title="Reset filters"
        >
          <X className="h-5 w-5" />
        </button>
      </div>

      <div className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-gray-300 mb-2">
            Search
          </label>
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
            <input
              type="text"
              value={filters.keyword}
              onChange={(e) =>
                onFiltersChange({
                  ...filters,
                  keyword: e.target.value,
                })
              }
              placeholder="Search in descriptions and categories..."
              className="w-full pl-10 pr-4 py-2 bg-gray-700/50 text-white rounded-lg border border-gray-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
            />
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-300 mb-2">
              Start Date
            </label>
            <div className="relative">
              <Calendar className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
              <input
                type="datetime-local"
                value={filters.startDate}
                onChange={(e) =>
                  onFiltersChange({
                    ...filters,
                    startDate: e.target.value,
                  })
                }
                className="w-full pl-10 pr-4 py-2 bg-gray-700/50 text-white rounded-lg border border-gray-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-300 mb-2">
              End Date
            </label>
            <div className="relative">
              <Calendar className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
              <input
                type="datetime-local"
                value={filters.endDate}
                onChange={(e) =>
                  onFiltersChange({
                    ...filters,
                    endDate: e.target.value,
                  })
                }
                className="w-full pl-10 pr-4 py-2 bg-gray-700/50 text-white rounded-lg border border-gray-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              />
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-300 mb-2">
              Shift Type
            </label>
            <select
              value={filters.shiftType || ''}
              onChange={(e) =>
                onFiltersChange({
                  ...filters,
                  shiftType: e.target.value as ShiftType || undefined,
                })
              }
              className="w-full bg-gray-700/50 text-white rounded-lg px-4 py-2 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent [&>option]:bg-gray-800"
            >
              <option value="">All Shifts</option>
              <option value="morning">Morning</option>
              <option value="afternoon">Afternoon</option>
              <option value="night">Night</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-300 mb-2">
              Category
            </label>
            <select
              value={filters.category || ''}
              onChange={(e) => {
                const selectedCategory = e.target.value as LogCategory;
                onFiltersChange({
                  ...filters,
                  category: selectedCategory || undefined,
                });
              }}
              className="w-full bg-gray-700/50 text-white rounded-lg px-4 py-2 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent [&>option]:bg-gray-800"
            >
              <option value="">All Categories</option>
              {categories.map((category) => (
                <option key={category} value={category}>
                  {category.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}
                </option>
              ))}
            </select>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdvancedSearch; 