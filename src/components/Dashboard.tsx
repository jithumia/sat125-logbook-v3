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
import { differenceInDays, format, subDays, subMonths, startOfDay, endOfDay, isWithinInterval } from 'date-fns';
import 'chartjs-adapter-date-fns';
import toast from 'react-hot-toast';
import { X, Mail } from 'lucide-react';
import ShiftReport from './ShiftReport';

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
}

const MAX_RETRIES = 3;
const RETRY_DELAY = 2000;
const MAX_VISIBLE_CASES = 5; // Maximum number of cases to show before scrolling

type DateRange = 'all' | 'week' | 'month' | 'custom';

const Dashboard: React.FC<DashboardProps> = ({ onEntryClick }) => {
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
    closed: 0,
    workorders: [] as Array<{
      number: string;
      status: string;
      description: string;
      created_at: string;
      shift_type: string;
    }>,
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

  const fetchDashboardData = useCallback(async () => {
    if (!mounted.current) return;

    try {
      setLoading(true);
      retryCountRef.current = 0;

      // Fetch latest source change data
      const sourceChangeData = await fetchWithRetry(async () => {
        const { data, error } = await supabase
          .from('log_entries')
          .select('*')
          .eq('category', 'data-sc')
          .order('created_at', { ascending: false })
          .limit(1)
          .single();

        if (error) throw error;
        return data;
      });

      if (sourceChangeData) {
        // Fetch latest main coil tuning data
        const mainCoilData = await fetchWithRetry(async () => {
          const { data, error } = await supabase
            .from('log_entries')
            .select('*')
            .eq('category', 'data-mc')
            .order('created_at', { ascending: false })
            .limit(1)
            .single();

          if (error) throw error;
          return data;
        });

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

      // Fetch main coil tuning data for graph
      const mcData = await fetchWithRetry(async () => {
        const { data, error } = await supabase
          .from('log_entries')
          .select('*')
          .eq('category', 'data-mc')
          .order('created_at', { ascending: true });

        if (error) throw error;
        return data;
      });

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

      // Fetch workorder summary
      const workorders = await fetchWithRetry(async () => {
        const { data, error } = await supabase
          .from('log_entries')
          .select('*')
          .eq('category', 'workorder')
          .order('created_at', { ascending: false });

        if (error) throw error;
        return data;
      });

      if (workorders && mounted.current) {
        const filteredWorkorders = filterDataByDateRange(workorders);
        setWorkOrderSummary({
          open: filteredWorkorders.filter((w: LogEntry) => w.workorder_status === 'open').length,
          in_progress: filteredWorkorders.filter((w: LogEntry) => w.workorder_status === 'in_progress').length,
          pending: filteredWorkorders.filter((w: LogEntry) => w.workorder_status === 'pending').length,
          closed: filteredWorkorders.filter((w: LogEntry) => w.workorder_status === 'closed').length,
          workorders: filteredWorkorders
            .filter((w: LogEntry) => w.workorder_number && w.workorder_status)
            .map((w: LogEntry) => ({
              number: w.workorder_number!,
              status: w.workorder_status!,
              description: w.description,
              created_at: w.created_at,
              shift_type: w.shift_type,
            })),
        });
      }

      // Fetch downtime summary
      const downtimes = await fetchWithRetry(async () => {
        const { data, error } = await supabase
          .from('log_entries')
          .select('*')
          .eq('category', 'downtime')
          .order('created_at', { ascending: false });

        if (error) throw error;
        return data;
      });

      if (downtimes && mounted.current) {
        const filteredDowntimes = filterDataByDateRange(downtimes);
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
            duration: d.dt_duration
          }))
        });
      }
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
      toast.error('Failed to load dashboard data');
    } finally {
      if (mounted.current) {
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
            currentShift = {
              shiftType: log.shift_type,
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

    const channel = supabase.channel('dashboard-updates');
    const subscription = channel
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'log_entries'
        },
        async () => {
          if (mounted.current) {
            await fetchDashboardData();
          }
        }
      )
      .subscribe((status: string) => {
        if (status === 'SUBSCRIBED') {
          console.log('Realtime subscription established');
        } else if (status === 'CHANNEL_ERROR') {
          console.error('Realtime subscription error');
          toast.error('Connection lost. Retrying...');
          setTimeout(setupRealtimeSubscription, RETRY_DELAY);
        }
      });

    subscriptionRef.current = subscription;
    return subscription;
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
      clearInterval(sessionRefreshInterval);
      subscription.unsubscribe();
    };
  }, [fetchDashboardData, setupRealtimeSubscription, fetchShiftData]);

  // Effect for date range changes
  useEffect(() => {
    fetchDashboardData();
  }, [dateRange, customRange, fetchDashboardData]);

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
          start: startOfDay(subDays(now, 7)),
          end: endOfDay(now)
        };
      case 'month':
        return {
          start: startOfDay(subMonths(now, 1)),
          end: endOfDay(now)
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
    if (dateRange === 'all') return data;
    
    const range = getDateRange();
    if (!range) return data;

    return data.filter(item => {
      const itemDate = new Date(item[dateField]);
      return isWithinInterval(itemDate, range);
    });
  };

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
    <div className="min-h-screen bg-gray-900 p-6">
      {/* Date Range Filter */}
      <div className="mb-6 flex items-center justify-between bg-gray-800 p-4 rounded-xl border border-gray-700">
        <div className="flex items-center gap-4">
          <h2 className="text-lg font-semibold text-white">Date Range:</h2>
          <div className="flex gap-2">
            <button
              onClick={() => setDateRange('all')}
              className={`px-3 py-1.5 rounded ${
                dateRange === 'all'
                  ? 'bg-indigo-600 text-white'
                  : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
              }`}
            >
              All Time
            </button>
            <button
              onClick={() => setDateRange('week')}
              className={`px-3 py-1.5 rounded ${
                dateRange === 'week'
                  ? 'bg-indigo-600 text-white'
                  : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
              }`}
            >
              Last Week
            </button>
            <button
              onClick={() => setDateRange('month')}
              className={`px-3 py-1.5 rounded ${
                dateRange === 'month'
                  ? 'bg-indigo-600 text-white'
                  : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
              }`}
            >
              Last Month
            </button>
            <button
              onClick={() => {
                setDateRange('custom');
                setShowCustomRange(true);
              }}
              className={`px-3 py-1.5 rounded ${
                dateRange === 'custom'
                  ? 'bg-indigo-600 text-white'
                  : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
              }`}
            >
              Custom Range
            </button>
          </div>
        </div>

        <button
          onClick={() => setShowShiftReport(true)}
          className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-500 flex items-center gap-2"
        >
          <Mail className="h-4 w-4" />
          Send Shift Report
        </button>
      </div>

      {showCustomRange && (
        <div className="flex items-center gap-2">
          <input
            type="date"
            value={customRange.startDate}
            onChange={(e) => setCustomRange(prev => ({ ...prev, startDate: e.target.value }))}
            className="bg-gray-700 border border-gray-600 rounded px-2 py-1 text-white text-sm"
          />
          <span className="text-gray-400">to</span>
          <input
            type="date"
            value={customRange.endDate}
            onChange={(e) => setCustomRange(prev => ({ ...prev, endDate: e.target.value }))}
            className="bg-gray-700 border border-gray-600 rounded px-2 py-1 text-white text-sm"
          />
          <button
            onClick={() => setShowCustomRange(false)}
            className="text-gray-400 hover:text-white"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Source Status Card */}
        <div className="bg-gray-800 rounded-xl p-6 border border-gray-700">
          <h2 className="text-xl font-semibold text-white mb-4">Source Status</h2>
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-gray-400">Current Source</span>
              <span className="text-white font-medium">{sourceData.currentSource}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-400">Days Running</span>
              <span className="text-white font-medium">{sourceData.daysRunning} days</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-400">Filament Current</span>
              <span className="text-white font-medium">{sourceData.filamentCurrent} A</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-400">Arc Current</span>
              <span className="text-white font-medium">{sourceData.arcCurrent} mA</span>
            </div>
            <div className="text-xs text-gray-500 mt-4">
              Last updated: {new Date(sourceData.lastUpdated).toLocaleString()}
            </div>
          </div>
        </div>

        {/* Workorder Summary Card */}
        <div className="bg-gray-800 rounded-xl p-6 border border-gray-700">
          <h2 className="text-xl font-semibold text-white mb-4">Work Orders</h2>
          <div className="grid grid-cols-4 gap-4 mb-6">
            <div className="text-center">
              <div className="text-2xl font-bold text-green-500">{workOrderSummary.open}</div>
              <div className="text-sm text-gray-400">Open</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-yellow-500">{workOrderSummary.in_progress}</div>
              <div className="text-sm text-gray-400">In Progress</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-orange-500">{workOrderSummary.pending}</div>
              <div className="text-sm text-gray-400">Pending</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-gray-500">{workOrderSummary.closed}</div>
              <div className="text-sm text-gray-400">Closed</div>
            </div>
          </div>
          <div className="space-y-2">
            {workOrderSummary.workorders
              .filter(wo => wo.status !== 'closed')
              .map((wo, index) => (
                <div 
                  key={index} 
                  className="p-2 bg-gray-700 rounded cursor-pointer hover:bg-gray-600 transition-colors"
                  onClick={() => {
                    if (onEntryClick) {
                      onEntryClick(wo.created_at, wo.shift_type);
                    }
                  }}
                >
                  <div className="flex justify-between">
                    <span className="text-white">#{wo.number}</span>
                    <span className={`${
                      wo.status === 'open' ? 'text-green-500' :
                      wo.status === 'in_progress' ? 'text-yellow-500' :
                      wo.status === 'pending' ? 'text-orange-500' :
                      'text-gray-500'
                    }`}>{wo.status}</span>
                  </div>
                  <p className="text-sm text-gray-300 truncate">{wo.description}</p>
                </div>
              ))}
          </div>
        </div>

        {/* Downtime Summary Card */}
        <div className="bg-gray-800 rounded-xl p-6 border border-gray-700">
          <h2 className="text-xl font-semibold text-white mb-4">Downtime Cases</h2>
          <div className="grid grid-cols-4 gap-4 mb-6">
            <div className="text-center">
              <div className="text-2xl font-bold text-green-500">{downtimeSummary.open}</div>
              <div className="text-sm text-gray-400">Open</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-yellow-500">{downtimeSummary.in_progress}</div>
              <div className="text-sm text-gray-400">In Progress</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-orange-500">{downtimeSummary.pending}</div>
              <div className="text-sm text-gray-400">Pending</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-gray-500">{downtimeSummary.closed}</div>
              <div className="text-sm text-gray-400">Closed</div>
            </div>
          </div>
          <div className="text-sm text-gray-400 mb-4">
            Total Downtime Duration: {Math.round(downtimeSummary.total_duration / 60)} hours {downtimeSummary.total_duration % 60} minutes
          </div>
          <div className="h-[200px] overflow-y-auto scrollbar-thin scrollbar-thumb-gray-700 scrollbar-track-transparent space-y-2">
            {downtimeSummary.cases.map((c, index) => (
              <div 
                key={index} 
                className="p-2 bg-gray-700 rounded cursor-pointer hover:bg-gray-600 transition-colors"
                onClick={() => {
                  if (onEntryClick) {
                    const date = new Date(c.created_at).toISOString().split('T')[0];
                    onEntryClick(date, c.shift_type);
                  }
                }}
              >
                <div className="flex justify-between">
                  <span className="text-white">#{c.number}</span>
                  <span className={`${
                    c.status === 'open' ? 'text-green-500' :
                    c.status === 'in_progress' ? 'text-yellow-500' :
                    c.status === 'pending' ? 'text-orange-500' :
                    'text-gray-500'
                  }`}>{c.status}</span>
                </div>
                <p className="text-sm text-gray-300 truncate">{c.description}</p>
                {c.duration && (
                  <div className="text-xs text-gray-400 mt-1">
                    Duration: {Math.floor(c.duration / 60)}h {c.duration % 60}m
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Charts Section */}
      <div className="mt-6">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* MC Setpoint Chart */}
          <div className="bg-gray-800 rounded-xl p-6 border border-gray-700">
            <h3 className="text-lg font-semibold text-white mb-4">Main Coil Setpoint Trend</h3>
            <div className="h-[300px]">
              {mainCoilData.dates.length > 0 && (
                <Line
                  options={{
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                      legend: {
                        position: 'top' as const,
                        labels: {
                          color: 'white'
                        }
                      }
                    },
                    scales: {
                      x: {
                        display: true,
                        grid: {
                          color: 'rgba(255, 255, 255, 0.1)'
                        },
                        ticks: {
                          color: 'white'
                        }
                      },
                      y: {
                        display: true,
                        grid: {
                          color: 'rgba(255, 255, 255, 0.1)'
                        },
                        ticks: {
                          color: 'white'
                        }
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
                        backgroundColor: 'rgba(255, 206, 86, 0.5)',
                      }
                    ]
                  }}
                />
              )}
            </div>
          </div>

          {/* Beam Profile Chart */}
          <div className="bg-gray-800 rounded-xl p-6 border border-gray-700">
            <h3 className="text-lg font-semibold text-white mb-4">Beam Profile Measurements</h3>
            <div className="h-[300px]">
              {mainCoilData.dates.length > 0 && (
                <Line
                  options={{
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                      legend: {
                        position: 'top' as const,
                        labels: {
                          color: 'white'
                        }
                      }
                    },
                    scales: {
                      x: {
                        display: true,
                        grid: {
                          color: 'rgba(255, 255, 255, 0.1)'
                        },
                        ticks: {
                          color: 'white'
                        }
                      },
                      y: {
                        display: true,
                        grid: {
                          color: 'rgba(255, 255, 255, 0.1)'
                        },
                        ticks: {
                          color: 'white'
                        }
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
                        backgroundColor: 'rgba(75, 192, 192, 0.5)',
                      },
                      {
                        label: 'P1E Y Width (mm)',
                        data: mainCoilData.p1eYWidth,
                        borderColor: 'rgb(54, 162, 235)',
                        backgroundColor: 'rgba(54, 162, 235, 0.5)',
                      }
                    ]
                  }}
                />
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Add ShiftReport component */}
      <ShiftReport
        isOpen={showShiftReport}
        onClose={() => setShowShiftReport(false)}
        shifts={shiftData}
      />
    </div>
  );
};

export default Dashboard; 