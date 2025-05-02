import React from 'react';

interface DateTimeInputProps {
  value: string | undefined;
  onChange: (value: string) => void;
  className?: string;
}

export const DateTimeInput: React.FC<DateTimeInputProps> = ({ value, onChange, className }) => {
  // Convert ISO string to local datetime-local format
  const toLocalDateTimeValue = (isoString: string | undefined) => {
    if (!isoString) return '';
    const date = new Date(isoString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`;
  };

  // Convert local datetime to ISO string
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const date = new Date(e.target.value);
    onChange(date.toISOString());
  };

  return (
    <input
      type="datetime-local"
      value={toLocalDateTimeValue(value)}
      onChange={handleChange}
      className={className}
    />
  );
}; 