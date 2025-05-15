import React, { useEffect, useState, useRef, useCallback } from 'react';
import { Line } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  ArcElement,
  TimeScale,
} from 'chart.js';
import { supabase } from '../lib/supabase';
import { differenceInDays, format, subDays, subMonths, startOfDay, endOfDay, isWithinInterval, startOfWeek, endOfWeek, startOfMonth, endOfMonth } from 'date-fns';
import 'chartjs-adapter-date-fns';
import toast from 'react-hot-toast';
import { X, Mail, Eye, EyeOff, RefreshCw } from 'lucide-react';
import ShiftReport from './ShiftReport';
import { ShiftType } from '../types';
import { FaTasks, FaClock, FaBolt, FaNetworkWired, FaExclamationTriangle, FaCheckCircle } from 'react-icons/fa';
import CountUp from 'react-countup';
import { Sparklines, SparklinesLine } from 'react-sparklines';

// Register ChartJS components
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  ArcElement,
  TimeScale
);

interface DashboardProps {
  onEntryClick: (date: string, shiftType: string) => void;
  visible?: boolean;
}

interface LogEntry {
  id: string;
  created_at: string;
  category: string;
  description: string;
  shift_type: string;
  mc_setpoint?: number;
  yoke_temperature?: number;
  arc_current?: number;
  filament_current?: number;
  p1e_x_width?: number;
  p1e_y_width?: number;
  p2e_x_width?: number;
  p2e_y_width?: number;
  inserted_source_number?: string;
  workorder_status?: string;
  workorder_number?: string;
  case_status?: string;
  case_number?: string;
  dt_start_time?: string;
  dt_end_time?: string;
  dt_duration?: number;
  prefered_start_time?: string;
  workorder_title?: string;
  workorder_category?: string;
  downtime_id?: string;
}

const MAX_RETRIES = 3;
const RETRY_DELAY = 2000;
const MAX_VISIBLE_CASES = 5; // Maximum number of cases to show before scrolling

type DateRange = 'all' | 'week' | 'month' | 'custom';

const Dashboard: React.FC<DashboardProps> = ({ onEntryClick, visible = true }) => {
  // Move all useState and useRef hooks to the top level
  const [sourceData, setSourceData] = useState<{
    currentSource: string;
    daysRunning: number;
    filamentCurrent: number;
    arcCurrent: number;
    lastUpdated: string;
  } | null>(null);
  
  const [mainCoilData, setMainCoilData] = useState({
    dates: [] as string[],
    mcSetpoint: [] as number[],
    p1eXWidth: [] as number[],
    p1eYWidth: [] as number[],
    p2eXWidth: [] as number[],
    p2eYWidth: [] as number[],
  });

  const [workOrderSummary, setWorkOrderSummary] = useState({
    open: 0,
    in_progress: 0,
    pending: 0,
    closed: 0
  });

  const [downtimeSummary, setDowntimeSummary] = useState({
    open: 0,
    in_progress: 0,
    pending: 0,
    closed: 0,
    total_duration: 0,
    cases: [] as Array<{
      number: string;
      status: string;
      description: string;
      created_at: string;
      shift_type: string;
      duration?: number;
      downtime_id?: string;
    }>,
  });

  const [loading, setLoading] = useState(true);
  const [dateRange, setDateRange] = useState<DateRange>('all');
  const [customRange, setCustomRange] = useState({
    startDate: '',
    endDate: ''
  });
  const [showCustomRange, setShowCustomRange] = useState(false);
  const [showShiftReport, setShowShiftReport] = useState(false);
  const [shiftData, setShiftData] = useState<{
    shiftType: string;
    startTime: string;
    endTime: string | null;
    logs: LogEntry[];
  }[]>([]);
  
  const retryCountRef = useRef(0);
  const subscriptionRef = useRef<any>(null);
  const mounted = useRef(true);

  // Add state for selected workorder status
  const [selectedWOStatus, setSelectedWOStatus] = useState<string | null>(null);
  const [allWorkorders, setAllWorkorders] = useState<any[]>([]);

  // Add state for showDueOnly
  const [showDueOnly, setShowDueOnly] = useState(false);

  // Add state for downtime status filter and date range
  const [selectedDTStatus, setSelectedDTStatus] = useState<string | null>(null);
  const [dtDateRange, setDTDateRange] = useState<DateRange>('all');
  const [dtCustomRange, setDTCustomRange] = useState({ startDate: '', endDate: '' });
  const [showDTCustomRange, setShowDTCustomRange] = useState(false);

  // Add state for workorder category filter
  const [woCategoryFilter, setWOCategoryFilter] = useState<'all' | 'pm' | 'manual'>('all');

  // Add state for workorder search
  const [workorderSearch, setWorkorderSearch] = useState('');

  // Add state for filter visibility
  const [showWOFilters, setShowWOFilters] = useState(true);
  const [showDTFilters, setShowDTFilters] = useState(true);

  // Add state for due status refresh
  const [refreshingDue, setRefreshingDue] = useState(false);

  const fetchDashboardData = useCallback(async (showLoading = true) => {
    if (!mounted.current) return;

    try {
      // Only show loading indicator if tab is visible and loading is requested
      if (showLoading && document.visibilityState === 'visible') {
        setLoading(true);
      }
      retryCountRef.current = 0;

      // Use Promise.allSettled to fetch data in parallel and continue even if some requests fail
      const [sourceChangeResult, mainCoilResult, workordersResult, downtimesResult] = await Promise.allSettled([
        // Fetch latest source change data
        fetchWithRetry(async () => {
          const { data, error } = await supabase
            .from('log_entries')
            .select('*')
            .eq('category', 'data-sc')
            .order('created_at', { ascending: false })
            .limit(1)
            .single();

          if (error) throw error;
          return data;
        }),
        
        // Fetch latest main coil tuning data
        fetchWithRetry(async () => {
          const { data, error } = await supabase
            .from('log_entries')
            .select('*')
            .eq('category', 'data-mc')
            .order('created_at', { ascending: false })
            .limit(1)
            .single();

          if (error) throw error;
          return data;
        }),
        
        // Fetch workorders
        fetchWithRetry(async () => {
          let query = supabase
            .from('workorders')
            .select('*')
            .order('created_at', { ascending: false });
          const { data, error } = await query;
          if (error) throw error;
          return data;
        }),
        
        // Fetch downtime summary
        fetchWithRetry(async () => {
          const { data, error } = await supabase
            .from('log_entries')
            .select('*')
            .eq('category', 'downtime')
            .order('created_at', { ascending: false });

          if (error) throw error;
          return data;
        })
      ]);

      // Process source change data
      if (sourceChangeResult.status === 'fulfilled' && sourceChangeResult.value) {
        const sourceChangeData = sourceChangeResult.value;
        
        // Process main coil data
        let mainCoilData = null;
        if (mainCoilResult.status === 'fulfilled') {
          mainCoilData = mainCoilResult.value;
        }
        
        if (mounted.current) {
          setSourceData({
            currentSource: sourceChangeData.inserted_source_number,
            daysRunning: differenceInDays(new Date(), new Date(sourceChangeData.created_at)),
            filamentCurrent: mainCoilData?.filament_current || 0,
            arcCurrent: mainCoilData?.arc_current || 0,
            lastUpdated: mainCoilData?.created_at || sourceChangeData.created_at,
          });
        }
      }

      // Process main coil tuning data for graph
      const fetchMCGraphData = async () => {
        try {
          const { data, error } = await supabase
            .from('log_entries')
            .select('*')
            .eq('category', 'data-mc')
            .order('created_at', { ascending: true });

          if (error) throw error;
          return data;
        } catch (error) {
          console.error('Error fetching MC graph data:', error);
          return [];
        }
      };

      const mcData = await fetchMCGraphData();

      if (mcData && mcData.length > 0 && mounted.current) {
        const validData = mcData.filter((d: LogEntry) => 
          d.p1e_x_width !== null && 
          d.p1e_y_width !== null && 
          d.mc_setpoint !== null &&
          typeof d.p1e_x_width === 'number' &&
          typeof d.p1e_y_width === 'number' &&
          typeof d.mc_setpoint === 'number'
        );

        setMainCoilData({
          dates: validData.map((d: LogEntry) => new Date(d.created_at).toLocaleDateString()),
          mcSetpoint: validData.map((d: LogEntry) => Number(d.mc_setpoint)),
          p1eXWidth: validData.map((d: LogEntry) => Number(d.p1e_x_width)),
          p1eYWidth: validData.map((d: LogEntry) => Number(d.p1e_y_width)),
          p2eXWidth: validData.map((d: LogEntry) => Number(d.p2e_x_width)),
          p2eYWidth: validData.map((d: LogEntry) => Number(d.p2e_y_width)),
        });
      }

      // Process workorder data
      if (workordersResult.status === 'fulfilled' && workordersResult.value && mounted.current) {
        const workorders = workordersResult.value;
        // Filter by prefered_start_time for date range
        const filteredWorkorders = filterDataByDateRange(workorders, 'prefered_start_time');
        setAllWorkorders(filteredWorkorders);
        setWorkOrderSummary({
          open: filteredWorkorders.filter((w: any) => w.status === 'open').length,
          in_progress: filteredWorkorders.filter((w: any) => w.status === 'in_progress').length,
          pending: filteredWorkorders.filter((w: any) => w.status === 'pending').length,
          closed: filteredWorkorders.filter((w: any) => w.status === 'closed').length
        });
      }

      // Process downtime data
      if (downtimesResult.status === 'fulfilled' && downtimesResult.value && mounted.current) {
        const downtimes = downtimesResult.value;
        // Use the correct downtime date filter for all status counts and cases
        const filteredDowntimes = filterDowntimeByDateRange(downtimes);
        const closedCases = filteredDowntimes.filter((d: LogEntry) => d.case_status === 'closed');
        const totalDuration = closedCases.reduce((sum: number, d: LogEntry) => sum + (d.dt_duration || 0), 0);
        setDowntimeSummary({
          open: filteredDowntimes.filter((d: LogEntry) => d.case_status === 'open').length,
          in_progress: filteredDowntimes.filter((d: LogEntry) => d.case_status === 'in_progress').length,
          pending: filteredDowntimes.filter((d: LogEntry) => d.case_status === 'pending').length,
          closed: closedCases.length,
          total_duration: totalDuration,
          cases: filteredDowntimes.map((d: LogEntry) => ({
            number: d.case_number || '',
            status: d.case_status || 'open',
            description: d.description,
            created_at: d.created_at,
            shift_type: d.shift_type,
            duration: d.dt_duration,
            downtime_id: d.downtime_id
          }))
        });
      }
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
      if (showLoading) {
        toast.error('Failed to load dashboard data');
      }
    } finally {
      if (mounted.current && showLoading) {
        setLoading(false);
      }
    }
  }, [dateRange, customRange]);

  const fetchShiftData = useCallback(async () => {
    try {
      const { data, error } = await supabase
        .from('log_entries')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;

      // Group logs by shift
      const shifts: typeof shiftData = [];
      let currentShift: (typeof shiftData)[0] | null = null;

      // Sort data chronologically
      const sortedData = [...(data || [])].sort((a, b) => 
        new Date(a.created_at).getTime() - new Date(b.created_at).getTime()
      );

      for (const log of sortedData) {
        if (log.category === 'shift') {
          if (log.description.includes('shift started')) {
            // Close previous shift if exists
            if (currentShift && !currentShift.endTime) {
              currentShift.endTime = log.created_at;
            }
            // Start new shift
            const validShiftTypes: ShiftType[] = ['morning', 'afternoon', 'night'];
            const shiftType: ShiftType = validShiftTypes.includes(log.shift_type as ShiftType)
              ? (log.shift_type as ShiftType)
              : 'morning';
            currentShift = {
              shiftType,
              startTime: log.created_at,
              endTime: null,
              logs: [log]
            };
            shifts.push(currentShift);
          } else if (log.description.includes('shift ended') && currentShift) {
            if (currentShift.shiftType === log.shift_type) {
              currentShift.endTime = log.created_at;
              currentShift.logs.push(log);
              currentShift = null;
            }
          }
        } else if (currentShift) {
          currentShift.logs.push(log);
        }
      }

      setShiftData(shifts.reverse());
    } catch (error) {
      console.error('Error fetching shift data:', error);
      toast.error('Failed to fetch shift data');
    }
  }, []);

  const setupRealtimeSubscription = useCallback(() => {
    if (subscriptionRef.current) {
      subscriptionRef.current.unsubscribe();
    }

    let debounceTimeout: NodeJS.Timeout | null = null;
    let isSubscribed = true;
    const debouncedFetch = () => {
      if (debounceTimeout) clearTimeout(debounceTimeout);
      debounceTimeout = setTimeout(() => {
        if (isSubscribed) fetchDashboardData();
      }, 400);
    };

    const channel = supabase.channel('dashboard-updates');
    channel.on(
      'postgres_changes',
      { event: '*', schema: 'public', table: 'log_entries' },
      debouncedFetch
    );
    channel.on(
      'postgres_changes',
      { event: '*', schema: 'public', table: 'workorders' },
      debouncedFetch
    );
    
    subscriptionRef.current = channel.subscribe();
    
    // Return the channel object for proper cleanup
    return channel;
  }, [fetchDashboardData]);

  // Effect for cleanup
  useEffect(() => {
    mounted.current = true;
    return () => {
      mounted.current = false;
      if (subscriptionRef.current) {
        subscriptionRef.current.unsubscribe();
      }
    };
  }, []);

  // Effect for initial data fetch and subscription
  useEffect(() => {
    if (!visible) return;
    let isSubscribed = true;
    const subscription = setupRealtimeSubscription();
    fetchDashboardData();
    fetchShiftData();
    // Set up periodic session refresh
    const sessionRefreshInterval = setInterval(async () => {
      if (mounted.current) {
        await refreshSession();
      }
    }, 5 * 60 * 1000); // Refresh every 5 minutes
    return () => {
      isSubscribed = false;
      clearInterval(sessionRefreshInterval);
      subscription.unsubscribe();
    };
  }, [visible, fetchDashboardData, setupRealtimeSubscription, fetchShiftData]);

  // Effect for date range changes
  useEffect(() => {
    fetchDashboardData();
  }, [dateRange, customRange, fetchDashboardData]);

  // Helper function to refresh session
  const refreshSession = async () => {
    try {
      const { data: { session }, error } = await supabase.auth.getSession();
      if (error) throw error;
      if (!session) {
        toast.error('Session expired. Please log in again.');
        window.location.reload();
        return;
      }
      return session;
    } catch (error) {
      console.error('Error refreshing session:', error);
      toast.error('Failed to refresh session');
      return null;
    }
  };

  const fetchWithRetry = async (fetchFn: () => Promise<any>, retryCount = 0): Promise<any> => {
    try {
      const session = await refreshSession();
      if (!session) return null;
      
      return await fetchFn();
    } catch (error) {
      console.error('Fetch error:', error);
      if (retryCount < MAX_RETRIES) {
        toast.error(`Retrying... (${retryCount + 1}/${MAX_RETRIES})`);
        await new Promise(resolve => setTimeout(resolve, RETRY_DELAY));
        return fetchWithRetry(fetchFn, retryCount + 1);
      }
      throw error;
    }
  };

  const getDateRange = () => {
    const now = new Date();
    switch (dateRange) {
      case 'week':
        return {
          start: startOfWeek(now, { weekStartsOn: 1 }), // Monday as first day
          end: endOfWeek(now, { weekStartsOn: 1 })
        };
      case 'month':
        return {
          start: startOfMonth(now),
          end: endOfMonth(now)
        };
      case 'custom':
        return {
          start: startOfDay(new Date(customRange.startDate)),
          end: endOfDay(new Date(customRange.endDate))
        };
      default:
        return null;
    }
  };

  const filterDataByDateRange = (data: any[], dateField: string = 'created_at') => {
    // For workorders, use 'prefered_start_time' as the date field
    if (dateRange === 'all') return data;
    const range = getDateRange();
    if (!range) return data;
    return data.filter(item => {
      // Use 'prefered_start_time' if present, else fallback to dateField
      const itemDate = new Date(item.prefered_start_time || item[dateField]);
      return isWithinInterval(itemDate, range);
    });
  };

  // Helper for downtime date range
  const getDTDateRange = () => {
    const now = new Date();
    switch (dtDateRange) {
      case 'week':
        return {
          start: startOfWeek(now, { weekStartsOn: 1 }),
          end: endOfWeek(now, { weekStartsOn: 1 })
        };
      case 'month':
        return {
          start: startOfMonth(now),
          end: endOfMonth(now)
        };
      case 'custom':
        return {
          start: startOfDay(new Date(dtCustomRange.startDate)),
          end: endOfDay(new Date(dtCustomRange.endDate))
        };
      default:
        return null;
    }
  };
  const filterDowntimeByDateRange = (data: any[]) => {
    if (dtDateRange === 'all') return data;
    const range = getDTDateRange();
    if (!range) return data;
    return data.filter(item => {
      const itemDate = new Date(item.dt_start_time || item.created_at);
      return isWithinInterval(itemDate, range);
    });
  };

  // Helper: update days_between_today_and_pst in DB (batch update)
  const updateDaysBetweenTodayAndPST = async () => {
    const today = new Date();
    today.setHours(0,0,0,0);
    if (!allWorkorders.length) return;
    // Prepare updates
    const updates = allWorkorders
      .map(wo => {
        if (!wo.prefered_start_time) return null;
        const pst = new Date(wo.prefered_start_time);
        pst.setHours(0,0,0,0);
        const diff = Math.floor((pst.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
        return { id: wo.id, days_between_today_and_pst: diff };
      })
      .filter((u): u is { id: string; days_between_today_and_pst: number } => u !== null);
    if (!updates.length) return;
    // Batch update using Promise.all
    await Promise.all(updates.map(u =>
      supabase.from('workorders').update({ days_between_today_and_pst: u.days_between_today_and_pst }).eq('id', u.id)
    ));
  };

  // Helper: isDue (days_between_today_and_pst <= 0 and status is open)
  const isDue = (wo: any) => {
    return wo.days_between_today_and_pst !== undefined && wo.days_between_today_and_pst <= 0 && wo.status === 'open';
  };

  // Update days_between_today_and_pst when dashboard loads or refresh is clicked
  useEffect(() => {
    updateDaysBetweenTodayAndPST();
    // eslint-disable-next-line
  }, []);

  // Helper: Router/System Status Indicator
  const getRouterStatus = () => {
    if (downtimeSummary.open > 0) return { status: 'down', color: 'red', icon: <FaExclamationTriangle className="text-red-500 animate-pulse" />, text: 'System Down (Downtime Active)' };
    return { status: 'up', color: 'green', icon: <FaCheckCircle className="text-green-400 animate-bounce-in" />, text: 'System Up' };
  };

  // Add logic above JSX to compute filteredWorkOrderSummary based on type filter
  const filteredWorkorders = allWorkorders.filter((wo: any) => {
    if (woCategoryFilter === 'pm') return wo.workorder_category !== 'manual';
    if (woCategoryFilter === 'manual') return wo.workorder_category === 'manual';
    return true;
  });
  const filteredWorkOrderSummary = {
    open: filteredWorkorders.filter((w: any) => w.status === 'open').length,
    in_progress: filteredWorkorders.filter((w: any) => w.status === 'in_progress').length,
    pending: filteredWorkorders.filter((w: any) => w.status === 'pending').length,
    closed: filteredWorkorders.filter((w: any) => w.status === 'closed').length
  };
  // Add due count
  const dueCount = filteredWorkorders.filter(isDue).length;

  // Add a fallback useEffect to always clear loading if any dashboard data is updated but loading is still true
  useEffect(() => {
    if (loading && (sourceData || mainCoilData.dates.length > 0 || allWorkorders.length > 0 || downtimeSummary.cases.length > 0)) {
      setLoading(false);
    }
  }, [sourceData, mainCoilData, allWorkorders, downtimeSummary, loading]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center">
        <div className="flex flex-col items-center space-y-4">
          <div className="w-3 h-3 bg-blue-500 rounded-full animate-bounce [animation-delay:-0.3s]"></div>
          <div className="w-3 h-3 bg-blue-500 rounded-full animate-bounce [animation-delay:-0.15s]"></div>
          <div className="w-3 h-3 bg-blue-500 rounded-full animate-bounce"></div>
        </div>
      </div>
    );
  }

  if (!sourceData) {
    return (
      <div className="min-h-screen bg-gray-900 p-6">
        <div className="text-center text-gray-400">No data available</div>
      </div>
    );
  }

  return (
    <div className="h-screen w-full bg-gradient-to-br from-gray-900 via-gray-950 to-gray-800 flex flex-col">
      {/* Main area: Work Orders & Downtime Cases side by side */}
      <div className="flex-1 flex flex-col sm:flex-row gap-6 px-4 sm:px-8 pb-2 overflow-hidden">
        {/* Work Orders Box */}
        <div className="w-full sm:w-1/2 min-w-0 flex flex-col glass-card animate-fade-in shadow-2xl border border-indigo-700/30 relative mb-6 sm:mb-0">
          <div className="flex items-center gap-2 mb-2 pt-6 px-6">
            <FaTasks className="text-indigo-400 text-2xl animate-bounce-in" />
            <h2 className="text-2xl font-bold text-white tracking-wide flex-1 cursor-pointer hover:underline" onClick={() => window.open('https://goiba.lightning.force.com/lightning/r/Report/00O1o000005JbzSEAS/view?queryScope=userFolders', '_blank')} title="View all Work Orders in Salesforce">Work Orders</h2>
            <span className="h-1 w-12 bg-indigo-500 rounded-full ml-2" />
            <button className="ml-2 px-3 py-1 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 text-xs font-semibold shadow transition" title="View All Work Orders" onClick={() => window.open('https://goiba.lightning.force.com/lightning/r/Report/00O1o000005JbzSEAS/view?queryScope=userFolders', '_blank')}>View All</button>
          </div>
          {/* First line: Type and Date filters */}
          <div className="flex flex-nowrap overflow-x-auto gap-2 mb-2 px-4 sm:px-6 items-center min-w-0 text-sm whitespace-nowrap">
            {showWOFilters && <>
              <span className="text-xs text-gray-400">Type:</span>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${woCategoryFilter === 'pm' ? 'bg-indigo-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => setWOCategoryFilter('pm')}>PM</button>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${woCategoryFilter === 'manual' ? 'bg-indigo-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => setWOCategoryFilter('manual')}>Manual</button>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${woCategoryFilter === 'all' ? 'bg-indigo-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => setWOCategoryFilter('all')} title="Clear all filters"><span role="img" aria-label="reset">🧹</span></button>
              <span className="ml-4 text-xs text-gray-400">Date:</span>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${dateRange === 'week' ? 'bg-indigo-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => { setDateRange('week'); setShowCustomRange(false); }}>Current Week</button>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${dateRange === 'month' ? 'bg-indigo-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => { setDateRange('month'); setShowCustomRange(false); }}>Current Month</button>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${dateRange === 'all' ? 'bg-indigo-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => { setDateRange('all'); setShowCustomRange(false); }}>All</button>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${dateRange === 'custom' ? 'bg-indigo-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => { setDateRange('custom'); setShowCustomRange(true); }}>Custom</button>
              {showCustomRange && (
                <>
                  <input type="date" className="ml-2 px-2 py-1 rounded bg-gray-800 text-gray-100 border border-gray-600" value={customRange.startDate} onChange={e => setCustomRange({ ...customRange, startDate: e.target.value })} />
                  <span className="text-xs text-gray-400">to</span>
                  <input type="date" className="px-2 py-1 rounded bg-gray-800 text-gray-100 border border-gray-600" value={customRange.endDate} onChange={e => setCustomRange({ ...customRange, endDate: e.target.value })} />
                </>
              )}
            </>}
            <span className="flex-1" />
            <button onClick={() => setShowWOFilters(v => !v)} className="ml-2 p-1 rounded hover:bg-gray-700 transition" title={showWOFilters ? 'Hide Filters' : 'Show Filters'}>
              {showWOFilters ? <EyeOff className="w-5 h-5 text-gray-400" /> : <Eye className="w-5 h-5 text-gray-400" />}
            </button>
            <input type="text" placeholder="Search..." value={workorderSearch} onChange={e => setWorkorderSearch(e.target.value)} className="px-2 py-1 rounded bg-gray-800 text-gray-100 border border-gray-600 text-xs w-full sm:w-40 focus:outline-none focus:border-indigo-500 mt-2 sm:mt-0" />
          </div>
          {/* Second line: Status filters and Due button, with dynamic counts based on filtered workorders */}
          <div className="flex flex-nowrap overflow-x-auto gap-2 mb-2 px-4 sm:px-6 items-center min-w-0 text-sm whitespace-nowrap">
            <span className="text-xs text-gray-400">Status:</span>
            {['open', 'in_progress', 'pending', 'closed'].map((status) => (
              <div key={status} className={`px-3 py-1 rounded-lg text-center cursor-pointer select-none font-semibold text-xs transition-all shadow-sm border border-transparent ${selectedWOStatus === status ? 'bg-indigo-600 text-white border-indigo-400' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => { setSelectedWOStatus(selectedWOStatus === status ? null : status); setShowDueOnly(false); }} title={`Show ${status.replace('_', ' ')} work orders`}>
                <div className={`text-base font-bold flex items-center justify-center gap-1 ${status === 'open' ? 'text-green-400' : status === 'in_progress' ? 'text-yellow-400' : status === 'pending' ? 'text-orange-400' : 'text-gray-400'}`}>{filteredWorkOrderSummary[status as keyof typeof filteredWorkOrderSummary]}</div>
                <div>{status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}</div>
              </div>
            ))}
            {/* Due button styled to match others, with count */}
            <div className={`px-3 py-1 rounded-lg text-center cursor-pointer select-none font-semibold text-xs transition-all shadow-sm border border-transparent ${showDueOnly ? 'bg-pink-600 text-white border-pink-400' : 'bg-gray-700 text-pink-400 hover:bg-pink-600 hover:text-white'}`} onClick={() => { setShowDueOnly(!showDueOnly); setSelectedWOStatus(null); }} title="Show Due work orders">
              <div className="text-base font-bold flex items-center justify-center gap-1">
                <span className="text-pink-400">{dueCount}</span>
                <button
                  type="button"
                  className="ml-1 p-1 rounded-full bg-gray-800 hover:bg-indigo-600 text-indigo-400 hover:text-white transition flex items-center justify-center"
                  title="Refresh Due Status"
                  disabled={refreshingDue}
                  onClick={async (e) => {
                    e.stopPropagation();
                    setRefreshingDue(true);
                    try {
                      await updateDaysBetweenTodayAndPST();
                      toast.success('Due status updated for all workorders');
                      // Optionally refetch dashboard data
                      await fetchDashboardData();
                    } catch (err) {
                      toast.error('Failed to update due status');
                    } finally {
                      setRefreshingDue(false);
                    }
                  }}
                >
                  {refreshingDue ? <RefreshCw className="h-4 w-4 animate-spin" /> : <RefreshCw className="h-4 w-4" />}
                </button>
              </div>
              <div>Due</div>
            </div>
          </div>
          {/* Workorder List Rendering (with improved card visuals) */}
          <div className="space-y-2 overflow-y-auto flex-1 max-h-full px-6 pb-4 scrollbar-thin scrollbar-thumb-gray-700 scrollbar-track-transparent">
            {loading ? (
              <div className="flex flex-col items-center justify-center h-full animate-pulse">
                <div className="w-2/3 h-8 bg-gray-700 rounded mb-2" />
                <div className="w-1/2 h-8 bg-gray-700 rounded mb-2" />
              </div>
            ) : (
              <>
                {(selectedWOStatus
                  ? allWorkorders.filter((wo: any) => wo.status === selectedWOStatus)
                  : allWorkorders.filter((wo: any) => wo.status !== 'closed')
                )
                  .filter((wo: any) => !showDueOnly || isDue(wo))
                  .filter((wo: any) => {
                    if (woCategoryFilter === 'pm') return wo.workorder_category !== 'manual';
                    if (woCategoryFilter === 'manual') return wo.workorder_category === 'manual';
                    return true;
                  })
                  .filter((wo: any) =>
                    workorderSearch === '' ||
                    wo.workorder_number?.toLowerCase().includes(workorderSearch.toLowerCase()) ||
                    wo.workorder_title?.toLowerCase().includes(workorderSearch.toLowerCase())
                  )
                  .sort((a: any, b: any) => {
                    const aTime = a.prefered_start_time ? new Date(a.prefered_start_time).getTime() : 0;
                    const bTime = b.prefered_start_time ? new Date(b.prefered_start_time).getTime() : 0;
                    return aTime - bTime;
                  })
                  .map((wo: any, index: number) => (
                    <div
                      key={wo.id || index}
                      className={`p-3 rounded-xl flex flex-row items-center gap-4 cursor-pointer hover:bg-indigo-700/30 transition-colors border-l-4 shadow-md ${isDue(wo) ? 'border-pink-500 bg-pink-900/10' : 'border-transparent bg-gray-800'} group relative`}
                      onClick={() => {
                        if (wo.workorder_id) {
                          const link = `https://goiba.lightning.force.com/lightning/r/SVMXC__Service_Order__c/${wo.workorder_id}/view`;
                          window.open(link, '_blank');
                        }
                      }}
                      title="Click to view in Salesforce"
                    >
                      {/* Status Icon */}
                      <span className={`w-4 h-4 rounded-full inline-block ${wo.status === 'open' ? 'bg-green-400' : wo.status === 'in_progress' ? 'bg-yellow-400' : wo.status === 'pending' ? 'bg-orange-400' : 'bg-gray-400'} border-2 border-white shadow`} />
                      <div className="flex-1 min-w-0">
                        <div className="flex justify-between items-center">
                          <span className="text-white font-mono font-bold text-lg truncate">#{wo.workorder_number}</span>
                          <span className={`ml-2 px-2 py-0.5 rounded-full text-xs font-bold ${isDue(wo) ? 'bg-pink-600 text-white animate-pulse' : 'bg-gray-700 text-gray-300'}`}>{wo.status}</span>
                          {isDue(wo) && <span className="ml-2 px-2 py-0.5 rounded-full bg-pink-600 text-white text-xs font-bold animate-pulse">DUE</span>}
                        </div>
                        <div className="flex justify-between items-center mt-1">
                          <span className="text-xs text-gray-300 truncate">{wo.workorder_title}</span>
                          {wo.prefered_start_time && <span className="text-xs text-gray-400 ml-2">{new Date(wo.prefered_start_time).toLocaleString()}</span>}
                        </div>
                      </div>
                      {/* Quick Actions removed as per requirements */}
                    </div>
                  ))}
                {/* Empty state */}
                {((selectedWOStatus
                  ? allWorkorders.filter((wo: any) => wo.status === selectedWOStatus).filter((wo: any) => !showDueOnly || isDue(wo)).length === 0
                  : allWorkorders.filter((wo: any) => wo.status !== 'closed').filter((wo: any) => !showDueOnly || isDue(wo)).length === 0
                )) && (
                  <div className="flex flex-col items-center justify-center h-full text-gray-400 animate-fade-in">
                    <FaTasks className="text-4xl mb-2 opacity-60" />
                    <span>No work orders with status "{selectedWOStatus ? selectedWOStatus.replace('_', ' ') : 'open'}"</span>
                  </div>
                )}
              </>
            )}
          </div>
        </div>
        {/* Downtime Cases Box (match Work Orders layout) */}
        <div className="w-full sm:w-1/2 min-w-0 flex flex-col glass-card animate-fade-in shadow-2xl border border-pink-700/30 relative">
          <div className="flex items-center gap-2 mb-2 pt-6 px-6">
            <FaClock className="text-pink-400 text-2xl animate-bounce-in" />
            <h2
              className="text-2xl font-bold text-white tracking-wide flex-1 cursor-pointer hover:underline"
              onClick={() => window.open('https://goiba.lightning.force.com/lightning/r/SVMXC__Site__c/a1c24000007SUChAAO/related/SVMXC__Cases__r/view', '_blank')}
              title="View all Downtime Cases in Salesforce"
            >
              Downtime Cases
            </h2>
            <span className="h-1 w-12 bg-pink-500 rounded-full ml-2" />
          </div>
          {/* Date Filter for Downtime */}
          <div className="flex flex-nowrap overflow-x-auto gap-2 mb-2 px-6 items-center min-w-0 text-sm whitespace-nowrap">
            {showDTFilters && <>
              <span className="text-xs text-gray-400">Filter:</span>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${dtDateRange === 'week' ? 'bg-pink-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => { setDTDateRange('week'); setShowDTCustomRange(false); }}>Current Week</button>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${dtDateRange === 'month' ? 'bg-pink-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => { setDTDateRange('month'); setShowDTCustomRange(false); }}>Current Month</button>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${dtDateRange === 'all' ? 'bg-pink-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => { setDTDateRange('all'); setShowDTCustomRange(false); }}>All</button>
              <button className={`px-2 py-1 rounded text-xs font-semibold transition ${dtDateRange === 'custom' ? 'bg-pink-600 text-white' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => { setDTDateRange('custom'); setShowDTCustomRange(true); }}>Custom</button>
              {showDTCustomRange && (
                <>
                  <input type="date" className="ml-2 px-2 py-1 rounded bg-gray-800 text-gray-100 border border-gray-600" value={dtCustomRange.startDate} onChange={e => setDTCustomRange({ ...dtCustomRange, startDate: e.target.value })} />
                  <span className="text-xs text-gray-400">to</span>
                  <input type="date" className="px-2 py-1 rounded bg-gray-800 text-gray-100 border border-gray-600" value={dtCustomRange.endDate} onChange={e => setDTCustomRange({ ...dtCustomRange, endDate: e.target.value })} />
                </>
              )}
            </>}
            <span className="flex-1" />
            <button onClick={() => setShowDTFilters(v => !v)} className="ml-2 p-1 rounded hover:bg-gray-700 transition" title={showDTFilters ? 'Hide Filters' : 'Show Filters'}>
              {showDTFilters ? <EyeOff className="w-5 h-5 text-gray-400" /> : <Eye className="w-5 h-5 text-gray-400" />}
            </button>
          </div>
          {/* Status Filter for Downtime */}
          <div className="flex flex-nowrap overflow-x-auto gap-2 mb-2 px-6 items-center min-w-0 text-sm whitespace-nowrap">
            {['open', 'in_progress', 'pending', 'closed'].map((status) => {
              const value = downtimeSummary[status as keyof typeof downtimeSummary];
              return (
                <div key={status} className={`px-3 py-1 rounded-lg text-center cursor-pointer select-none font-semibold text-xs transition-all shadow-sm border border-transparent ${selectedDTStatus === status ? 'bg-pink-600 text-white border-pink-400' : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}`} onClick={() => setSelectedDTStatus(selectedDTStatus === status ? null : status)}>
                  <div className={`text-base font-bold flex items-center justify-center gap-1 ${status === 'open' ? 'text-green-400' : status === 'in_progress' ? 'text-yellow-400' : status === 'pending' ? 'text-orange-400' : 'text-gray-400'}`}>{
                    typeof value === 'number' ? value : ''
                  }</div>
                  <div>{status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}</div>
                </div>
              );
            })}
          </div>
          {/* Total Downtime for filtered range */}
          <div className="text-xs text-gray-400 mb-2 px-6 mt-2">Total Downtime: {
            (() => {
              const filtered = filterDowntimeByDateRange(downtimeSummary.cases).filter((c: any) => !selectedDTStatus || c.status === selectedDTStatus);
              const total = filtered.reduce((sum: number, c: any) => sum + (c.duration || 0), 0);
              return `${Math.floor(total / 60)}h ${total % 60}m`;
            })()
          }</div>
          {/* Downtime List (no sparkline, with round status icon) */}
          <div className="space-y-2 overflow-y-auto flex-1 max-h-full px-6 pb-4 scrollbar-thin scrollbar-thumb-gray-700 scrollbar-track-transparent">
            {loading ? (
              <div className="flex flex-col items-center justify-center h-full animate-pulse">
                <div className="w-2/3 h-8 bg-gray-700 rounded mb-2" />
                <div className="w-1/2 h-8 bg-gray-700 rounded mb-2" />
              </div>
            ) : (
              <>
                {filterDowntimeByDateRange(downtimeSummary.cases)
                  .filter((c) => !selectedDTStatus || c.status === selectedDTStatus)
                  .map((c, index) => {
                    // Move color/status logic here for each case
                    const isOpen = c.status === 'open';
                    const isInProgress = c.status === 'in_progress';
                    const isPending = c.status === 'pending';
                    const isClosed = c.status === 'closed';
                    const borderColor = isOpen ? 'border-green-500' : isInProgress ? 'border-yellow-500' : isPending ? 'border-orange-500' : 'border-gray-600';
                    const bgColor = isOpen ? 'bg-gray-800' : isClosed ? 'bg-gray-900/80' : isInProgress ? 'bg-yellow-900/10' : isPending ? 'bg-orange-900/10' : 'bg-gray-800';
                    return (
                      <div
                        key={index}
                        className={`p-3 rounded-xl flex flex-row items-center gap-4 cursor-pointer hover:bg-pink-700/30 transition-colors border-l-4 shadow-md group relative ${borderColor} ${bgColor}`}
                        onClick={() => {
                          if (c.downtime_id) {
                            const link = `https://goiba.lightning.force.com/lightning/r/Case/${c.downtime_id}/view`;
                            window.open(link, '_blank');
                          } else if (onEntryClick) {
                            const date = new Date(c.created_at).toISOString().split('T')[0];
                            onEntryClick(date, c.shift_type);
                          }
                        }}
                        title="Click to view downtime details"
                      >
                        {/* Status Icon */}
                        <span className={`w-4 h-4 rounded-full inline-block border-2 border-white shadow ${isOpen ? 'bg-green-400' : isInProgress ? 'bg-yellow-400' : isPending ? 'bg-orange-400' : 'bg-gray-400'}`} />
                        <div className="flex-1 min-w-0">
                          <div className="flex justify-between items-center">
                            <span className="text-white font-mono font-bold text-lg truncate">#{c.number}</span>
                            {/* Animated status badge */}
                            <span className={`ml-2 px-2 py-0.5 rounded-full text-xs font-bold ${isOpen ? 'bg-green-600 text-white animate-pulse' : isInProgress ? 'bg-yellow-600 text-white animate-pulse' : isPending ? 'bg-orange-600 text-white' : 'bg-gray-700 text-gray-300'}`}>{c.status}</span>
                          </div>
                          <div className="flex justify-between items-center mt-1">
                            <span className="text-xs text-gray-300 truncate">{c.description}</span>
                            {c.duration && (<span className="text-xs text-gray-400 ml-2">{Math.floor(c.duration / 60)}h {c.duration % 60}m</span>)}
                          </div>
                        </div>
                        {/* Quick Actions removed as per requirements */}
                      </div>
                    );
                  })
                }
                {/* Empty state */}
                {filterDowntimeByDateRange(downtimeSummary.cases).filter((c: any) => !selectedDTStatus || c.status === selectedDTStatus).length === 0 && (
                  <div className="flex flex-col items-center justify-center h-full text-gray-400 animate-fade-in">
                    <FaClock className="text-4xl mb-2 opacity-60" />
                    <span>No downtime cases in this range</span>
                  </div>
                )}
              </>
            )}
          </div>
        </div>
      </div>
      {/* Bottom row: Source Status (compact) and Graphs (wide) */}
      <div className="flex flex-col lg:flex-row gap-6 px-4 md:px-8 pb-6 pt-2 h-auto lg:h-[28%] min-h-[180px] max-h-[260px]">
        {/* Source Status Box */}
        <div className="w-full lg:w-1/3 min-w-[220px] max-w-[340px] flex flex-col glass-card animate-fade-in shadow-2xl border border-yellow-700/30 relative justify-between mb-6 lg:mb-0">
          <div className="flex items-center gap-2 mb-2 pt-4 px-6">
            <FaBolt className="text-yellow-400 text-2xl animate-bounce-in" />
            <h2 className="text-lg font-bold text-white tracking-wide flex-1">Source Status</h2>
            <span className="h-1 w-6 bg-yellow-500 rounded-full ml-2" />
          </div>
          <div className="space-y-2 text-sm px-6">
            <div className="flex justify-between items-center"><span className="text-gray-400">Current Source</span><span className="text-white font-medium">{sourceData.currentSource}</span></div>
            <div className="flex justify-between items-center"><span className="text-gray-400">Days Running</span><span className="text-white font-medium"><CountUp end={sourceData.daysRunning} duration={0.8} /> days</span></div>
            <div className="flex justify-between items-center"><span className="text-gray-400">Filament Current</span><span className="text-white font-medium">{sourceData.filamentCurrent} A</span></div>
            <div className="flex justify-between items-center"><span className="text-gray-400">Arc Current</span><span className="text-white font-medium">{sourceData.arcCurrent} mA</span></div>
          </div>
          {/* Sparkline for source status (dummy data for now) */}
          <div className="px-6 mt-2"><Sparklines data={[sourceData.filamentCurrent, sourceData.arcCurrent]} limit={10} height={18} width={80} margin={2}><SparklinesLine color="#facc15" style={{ fill: 'none' }} /></Sparklines></div>
          <div className="text-xs text-gray-500 mt-2 px-6 pb-4">Last updated: {new Date(sourceData.lastUpdated).toLocaleString()}</div>
          {/* Empty state */}
          {!loading && !sourceData && (<div className="flex flex-col items-center justify-center h-full text-gray-400 animate-fade-in"><FaBolt className="text-4xl mb-2 opacity-60" /><span>No source data available</span></div>)}
        </div>
        {/* Graphs Box */}
        <div className="flex-1 min-w-0 flex flex-col glass-card animate-fade-in shadow-2xl border border-blue-700/30 relative">
          <div className="flex items-center gap-2 mb-2 pt-4 px-6"><FaBolt className="text-blue-400 text-xl animate-bounce-in" /><h2 className="text-lg font-bold text-white tracking-wide flex-1">Trends & Graphs</h2><span className="h-1 w-8 bg-blue-500 rounded-full ml-2" /></div>
          <div className="flex-1 flex flex-row gap-4 px-6 pb-4">
            {/* MC Setpoint Chart with X and Y axes */}
            <div className="flex-1 min-w-0 flex flex-col">
              <h3 className="text-xs font-semibold text-white mb-1">Main Coil Setpoint</h3>
              <div className="h-[90px]">
                {mainCoilData.dates.length > 0 && (
                  <Line
                    options={{
                      responsive: true,
                      maintainAspectRatio: false,
                      plugins: { legend: { display: false } },
                      scales: {
                        x: {
                          display: true,
                          grid: { color: 'rgba(255,255,255,0.08)' },
                          ticks: { color: '#fff', font: { size: 10 } }
                        },
                        y: {
                          display: true,
                          grid: { color: 'rgba(255,255,255,0.08)' },
                          ticks: { color: '#fff', font: { size: 10 } }
                        }
                      }
                    }}
                    data={{
                      labels: mainCoilData.dates,
                      datasets: [
                        {
                          label: 'MC Setpoint (A)',
                          data: mainCoilData.mcSetpoint,
                          borderColor: 'rgb(255, 206, 86)',
                          backgroundColor: 'rgba(255, 206, 86, 0.2)',
                          tension: 0.3,
                          pointRadius: 0
                        }
                      ]
                    }}
                  />
                )}
              </div>
            </div>
            {/* Beam Profile Chart with X and Y axes */}
            <div className="flex-1 min-w-0 flex flex-col">
              <h3 className="text-xs font-semibold text-white mb-1">Beam Profile</h3>
              <div className="h-[90px]">
                {mainCoilData.dates.length > 0 && (
                  <Line
                    options={{
                      responsive: true,
                      maintainAspectRatio: false,
                      plugins: { legend: { display: false } },
                      scales: {
                        x: {
                          display: true,
                          grid: { color: 'rgba(255,255,255,0.08)' },
                          ticks: { color: '#fff', font: { size: 10 } }
                        },
                        y: {
                          display: true,
                          grid: { color: 'rgba(255,255,255,0.08)' },
                          ticks: { color: '#fff', font: { size: 10 } }
                        }
                      }
                    }}
                    data={{
                      labels: mainCoilData.dates,
                      datasets: [
                        {
                          label: 'P1E X Width (mm)',
                          data: mainCoilData.p1eXWidth,
                          borderColor: 'rgb(75, 192, 192)',
                          backgroundColor: 'rgba(75, 192, 192, 0.2)',
                          tension: 0.3,
                          pointRadius: 0
                        },
                        {
                          label: 'P1E Y Width (mm)',
                          data: mainCoilData.p1eYWidth,
                          borderColor: 'rgb(54, 162, 235)',
                          backgroundColor: 'rgba(54, 162, 235, 0.2)',
                          tension: 0.3,
                          pointRadius: 0
                        }
                      ]
                    }}
                  />
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
      {/* Glassmorphism and animation styles */}
      <style>{`
        .glass-card {
          background: rgba(30, 41, 59, 0.7);
          backdrop-filter: blur(12px) saturate(120%);
          border-radius: 1.5rem;
          box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18);
          transition: box-shadow 0.3s cubic-bezier(.4,2,.3,1), transform 0.2s;
          border: 1px solid rgba(255, 255, 255, 0.1);
          position: relative;
          overflow: hidden;
        }
        .glass-card::before {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0));
          pointer-events: none;
        }
        .glass-card:hover {
          box-shadow: 0 12px 40px 0 rgba(99, 102, 241, 0.25);
          transform: translateY(-2px) scale(1.01);
        }
        .animate-fade-in {
          animation: fadeIn 0.7s cubic-bezier(.4,2,.3,1);
        }
        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(16px); }
          to { opacity: 1; transform: none; }
        }
        .animate-bounce-in {
          animation: bounceIn 0.7s cubic-bezier(.4,2,.3,1);
        }
        @keyframes bounceIn {
          0% { opacity: 0; transform: scale(0.7); }
          60% { opacity: 1; transform: scale(1.1); }
          100% { opacity: 1; transform: scale(1); }
        }
        .bg-red-600 {
          background-color: #dc2626 !important;
        }
      `}</style>
    </div>
  );
};

export default Dashboard; 