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

export type ShiftType = 'morning' | 'afternoon' | 'night';

export interface SearchFilters {
  startDate: string;
  endDate: string;
  keyword: string;
  shiftType?: ShiftType;
  category?: LogCategory;
}

export interface LogEntry {
  id: string;
  shift_type: ShiftType;
  category: LogCategory;
  description: string;
  created_at: string;
  user_id: string;
  case_number?: string;
  case_status?: Status;
  workorder_number?: string;
  workorder_status?: Status;
  mc_setpoint?: number;
  yoke_temperature?: number;
  arc_current?: number;
  filament_current?: number;
  pie_width?: number;
  p2e_width?: number;
  attachments?: Attachment[];
}

export type LogCategory = 'general' | 'error' | 'downtime' | 'workorder' | 'data-collection' | 'shift';

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