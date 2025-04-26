export type ShiftType = 'morning' | 'afternoon' | 'night';
export type LogCategory = 'error' | 'general' | 'downtime' | 'workorder' | 'data-collection' | 'shift';
export type Status = 'ongoing' | 'closed' | 'technically-completed';

export interface SearchFilters {
  startDate: string;
  endDate: string;
  keyword: string;
  shiftType?: string;
}

export interface Engineer {
  id: string;
  name: string;
  user_id: string;
  created_at: string;
}

export interface Attachment {
  id: string;
  log_entry_id: string;
  file_name: string;
  file_type: string;
  file_size: number;
  file_path: string;
  created_at: string;
  user_id: string;
}

export interface ActiveShift {
  id: string;
  shift_type: ShiftType;
  started_at: string;
  started_by: string;
  salesforce_number: string;
  created_at: string;
  engineers?: Engineer[];
}

export interface LogEntry {
  id: string;
  created_at: string;
  shift_type: ShiftType;
  category: LogCategory;
  description: string;
  user_id: string;
  attachments?: Attachment[];
  // Optional fields based on category
  case_number?: string;
  case_status?: Status;
  workorder_number?: string;
  workorder_status?: Status;
  // Data collection fields
  mc_setpoint?: number;
  yoke_temperature?: number;
  arc_current?: number;
  filament_current?: number;
  pie_width?: number;
  p2e_width?: number;
}