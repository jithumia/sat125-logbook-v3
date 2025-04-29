export interface Engineer {
  id: string;
  name: string;
  email: string;
  engineer: string;
}

export interface ShiftEngineer {
  engineer: Engineer;
}

export interface ActiveShift {
  id: string;
  shift_type: ShiftType;
  started_at: string;
  ended_at: string | null;
  user_id: string;
  engineers: ShiftEngineer[];
  salesforce_number: string;
}

export type ShiftType = 'morning' | 'afternoon' | 'night' | 'data-mc' | 'data-sc';

export interface SearchFilters {
  startDate: string;
  endDate: string;
  keyword: string;
  shiftType?: ShiftType;
  category?: LogCategory;
}

export interface LogEntry {
  id: string;
  created_at: string;
  description: string;
  category: LogCategory;
  shift_type: ShiftType;
  case_number?: string;
  case_status?: Status;
  workorder_number?: string;
  workorder_status?: Status;
  // Main Coil Tuning Data
  mc_setpoint?: number;
  yoke_temperature?: number;
  arc_current?: number;
  filament_current?: number;
  p1e_x_width?: number;
  p1e_y_width?: number;
  p2e_x_width?: number;
  p2e_y_width?: number;
  // Source Change Data
  removed_source_number?: number;
  removed_filament_current?: number;
  removed_arc_current?: number;
  removed_filament_counter?: number;
  inserted_source_number?: number;
  inserted_filament_current?: number;
  inserted_arc_current?: number;
  inserted_filament_counter?: number;
  filament_hours?: number;
  // Additional fields
  svmx_number?: string;
  pridex_number?: string;
  engineers?: string[];
  attachments?: Attachment[];
  user_id?: string;
}

export type LogCategory = 'general' | 'error' | 'downtime' | 'workorder' | 'data-mc' | 'data-sc' | 'shift';

export type Status = 'open' | 'in_progress' | 'closed' | 'pending';

export interface Attachment {
  id: string;
  file_name: string;
  file_type: string;
  file_size: number;
  file_path: string;
  created_at: string;
}

export interface RecentLog {
  id: string;
  shift_type: ShiftType;
  started_at: string;
  ended_at: string;
  user_id: string;
  engineer: Engineer;
  entries: LogEntry[];
} 