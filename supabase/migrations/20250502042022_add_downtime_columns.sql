-- Add downtime columns to log_entries table
ALTER TABLE log_entries
ADD COLUMN IF NOT EXISTS dt_start_time timestamp with time zone,
ADD COLUMN IF NOT EXISTS dt_end_time timestamp with time zone,
ADD COLUMN IF NOT EXISTS dt_duration integer;
