import React, { useEffect, useState } from 'react';
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
  Scale,
  CoreScaleOptions,
  Tick,
} from 'chart.js';
import { supabase } from '../lib/supabase';
import { LogEntry } from '../types';
import { differenceInDays } from 'date-fns';

// Register ChartJS components
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  ArcElement
);

interface DashboardProps {
  onEntryClick: (date: string, shiftType: string) => void;
}

interface SourceData {
  currentSource: string;
  daysRunning: number;
  filamentCurrent: number;
  arcCurrent: number;
  lastUpdated: string;
}

interface MainCoilData {
  dates: string[];
  mcSetpoint: number[];
  p1eXWidth: number[];
  p1eYWidth: number[];
  p2eXWidth: number[];
  p2eYWidth: number[];
}

interface WorkOrderSummary {
  open: number;
  in_progress: number;
  pending: number;
  closed: number;
  workorders: Array<{
    number: string;
    status: string;
    description: string;
    created_at: string;
    shift_type: string;
  }>;
}

interface DowntimeSummary {
  open: number;
  in_progress: number;
  pending: number;
  closed: number;
  cases: Array<{
    number: string;
    status: string;
    description: string;
    created_at: string;
    shift_type: string;
  }>;
}

const Dashboard: React.FC<DashboardProps> = ({ onEntryClick }) => {
  const [sourceData, setSourceData] = useState<SourceData | null>(null);
  const [mainCoilData, setMainCoilData] = useState<{
    dates: string[];
    mcSetpoint: number[];
    p1eXWidth: number[];
    p1eYWidth: number[];
    p2eXWidth: number[];
    p2eYWidth: number[];
  }>({
    dates: [],
    mcSetpoint: [],
    p1eXWidth: [],
    p1eYWidth: [],
    p2eXWidth: [],
    p2eYWidth: [],
  });
  const [workOrderSummary, setWorkOrderSummary] = useState<WorkOrderSummary>({
    open: 0,
    in_progress: 0,
    pending: 0,
    closed: 0,
    workorders: []
  });
  const [downtimeSummary, setDowntimeSummary] = useState<DowntimeSummary>({
    open: 0,
    in_progress: 0,
    pending: 0,
    closed: 0,
    cases: []
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);

      // Fetch latest source change data
      const { data: sourceChangeData } = await supabase
        .from('log_entries')
        .select('*')
        .eq('category', 'data-sc')
        .order('created_at', { ascending: false })
        .limit(1)
        .single();

      if (sourceChangeData) {
        // Fetch latest main coil tuning data
        const { data: mainCoilData } = await supabase
          .from('log_entries')
          .select('*')
          .eq('category', 'data-mc')
          .order('created_at', { ascending: false })
          .limit(1)
          .single();

        setSourceData({
          currentSource: sourceChangeData.inserted_source_number,
          daysRunning: differenceInDays(new Date(), new Date(sourceChangeData.created_at)),
          filamentCurrent: mainCoilData?.filament_current || 0,
          arcCurrent: mainCoilData?.arc_current || 0,
          lastUpdated: mainCoilData?.created_at || sourceChangeData.created_at,
        });
      }

      // Fetch main coil tuning data for graph
      const { data: mcData, error } = await supabase
        .from('log_entries')
        .select('*')
        .eq('category', 'data-mc')
        .order('created_at', { ascending: true });

      console.log('Raw MC Data:', mcData); // Debug log
      console.log('Fetch Error:', error); // Debug log

      if (mcData && mcData.length > 0) {
        // Filter out invalid data points and process the data
        const validData = mcData.filter(d => {
          // Check if all required fields exist and are numbers
          const isValid = d.p1e_x_width !== null && 
                         d.p1e_y_width !== null && 
                         d.mc_setpoint !== null &&
                         typeof d.p1e_x_width === 'number' &&
                         typeof d.p1e_y_width === 'number' &&
                         typeof d.mc_setpoint === 'number';
          
          if (!isValid) {
            console.log('Invalid data point:', d); // Debug log for invalid data
          }
          return isValid;
        });

        console.log('Valid Data:', validData); // Debug log

        const processedData = {
          dates: validData.map(d => new Date(d.created_at).toLocaleDateString()),
          mcSetpoint: validData.map(d => Number(d.mc_setpoint)),
          p1eXWidth: validData.map(d => Number(d.p1e_x_width)),
          p1eYWidth: validData.map(d => Number(d.p1e_y_width)),
          p2eXWidth: validData.map(d => Number(d.p2e_x_width)),
          p2eYWidth: validData.map(d => Number(d.p2e_y_width)),
        };

        console.log('Processed Data:', processedData); // Debug log
        setMainCoilData(processedData);
      }

      // Fetch workorder summary with shift_type
      const { data: workorders } = await supabase
        .from('log_entries')
        .select('*')
        .eq('category', 'workorder')
        .order('created_at', { ascending: false });

      if (workorders) {
        const openWorkorders = workorders.filter(w => w.workorder_status === 'open');
        const inProgressWorkorders = workorders.filter(w => w.workorder_status === 'in_progress');
        const pendingWorkorders = workorders.filter(w => w.workorder_status === 'pending');
        const closedWorkorders = workorders.filter(w => w.workorder_status === 'closed');
        
        setWorkOrderSummary({
          open: openWorkorders.length,
          in_progress: inProgressWorkorders.length,
          pending: pendingWorkorders.length,
          closed: closedWorkorders.length,
          workorders: workorders.map(w => ({
            number: w.workorder_number,
            status: w.workorder_status,
            description: w.description,
            created_at: w.created_at,
            shift_type: w.shift_type,
          })),
        });
      }

      // Fetch downtime summary with shift_type
      const { data: downtimes } = await supabase
        .from('log_entries')
        .select('*')
        .eq('category', 'downtime')
        .order('created_at', { ascending: false });

      if (downtimes) {
        const openCases = downtimes.filter(d => d.case_status === 'open');
        const inProgressCases = downtimes.filter(d => d.case_status === 'in_progress');
        const pendingCases = downtimes.filter(d => d.case_status === 'pending');
        const closedCases = downtimes.filter(d => d.case_status === 'closed');

        setDowntimeSummary({
          open: openCases.length,
          in_progress: inProgressCases.length,
          pending: pendingCases.length,
          closed: closedCases.length,
          cases: downtimes.map(d => ({
            number: d.case_number,
            status: d.case_status,
            description: d.description,
            created_at: d.created_at,
            shift_type: d.shift_type,
          })),
        });
      }
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
    } finally {
      setLoading(false);
    }
  };

  // Separate chart data for MC Setpoint
  const mcSetpointChartData = {
    labels: mainCoilData.dates,
    datasets: [
      {
        label: 'MC Setpoint (A)',
        data: mainCoilData.mcSetpoint,
        borderColor: 'rgb(255, 206, 86)',
        backgroundColor: 'rgba(255, 206, 86, 0.1)',
        tension: 0.1,
        borderWidth: 2,
        pointRadius: 4,
        pointHoverRadius: 6,
        fill: true,
      }
    ],
  };

  // Separate chart data for P1E measurements only
  const beamProfileChartData = {
    labels: mainCoilData.dates,
    datasets: [
      {
        label: 'P1E X Width (mm)',
        data: mainCoilData.p1eXWidth,
        borderColor: 'rgb(75, 192, 192)',
        backgroundColor: 'rgba(75, 192, 192, 0.1)',
        tension: 0.1,
        borderWidth: 2,
        pointRadius: 4,
        pointHoverRadius: 6,
        fill: true,
      },
      {
        label: 'P1E Y Width (mm)',
        data: mainCoilData.p1eYWidth,
        borderColor: 'rgb(54, 162, 235)',
        backgroundColor: 'rgba(54, 162, 235, 0.1)',
        tension: 0.1,
        borderWidth: 2,
        pointRadius: 4,
        pointHoverRadius: 6,
        fill: true,
      }
    ],
  };

  // Debug logs for chart data
  console.log('Main Coil Chart Data:', mcSetpointChartData);
  console.log('Beam Profile Chart Data:', beamProfileChartData);

  // Calculate min and max for P1E data to set appropriate scale
  const p1eXValues = mainCoilData.p1eXWidth.filter(v => v > 0 && v < 2);
  const p1eYValues = mainCoilData.p1eYWidth.filter(v => v > 0 && v < 2);
  
  // Set default ranges if no valid data points
  const p1eMin = p1eXValues.length > 0 && p1eYValues.length > 0
    ? Math.min(Math.min(...p1eXValues), Math.min(...p1eYValues))
    : 1.2;
  const p1eMax = p1eXValues.length > 0 && p1eYValues.length > 0
    ? Math.max(Math.max(...p1eXValues), Math.max(...p1eYValues))
    : 1.7;

  // Calculate padding based on the data range
  const p1eRange = p1eMax - p1eMin;
  const p1ePadding = Math.max(0.05, p1eRange * 0.1); // Reduced minimum padding for more precise view

  // Common chart options with enhanced interactivity
  const commonOptions = {
    responsive: true,
    maintainAspectRatio: false,
    animation: {
      duration: 750,
      easing: 'easeInOutQuart' as const
    },
    plugins: {
      legend: {
        position: 'top' as const,
        labels: {
          color: 'rgba(255, 255, 255, 0.9)',
          padding: 15,
          font: {
            size: 12,
            weight: 'bold' as const
          },
          usePointStyle: true,
          pointStyle: 'circle'
        }
      },
      tooltip: {
        mode: 'index' as const,
        intersect: false,
        backgroundColor: 'rgba(0, 0, 0, 0.8)',
        titleFont: {
          size: 14,
          weight: 'bold' as const
        },
        bodyFont: {
          size: 13
        },
        padding: 12,
        cornerRadius: 8,
        displayColors: true,
        borderColor: 'rgba(255, 255, 255, 0.2)',
        borderWidth: 1
      }
    },
    interaction: {
      mode: 'nearest' as const,
      axis: 'x' as const,
      intersect: false
    },
    scales: {
      x: {
        grid: {
          color: 'rgba(255, 255, 255, 0.1)',
          drawBorder: false
        },
        ticks: {
          color: 'rgba(255, 255, 255, 0.9)',
          maxRotation: 45,
          minRotation: 45,
          font: {
            size: 11
          },
          padding: 8
        }
      }
    }
  };

  // MC Setpoint specific options
  const mcSetpointOptions = {
    ...commonOptions,
    scales: {
      ...commonOptions.scales,
      y: {
        type: 'linear' as const,
        beginAtZero: false,
        min: Math.min(...mainCoilData.mcSetpoint) - 0.1,
        max: Math.max(...mainCoilData.mcSetpoint) + 0.1,
        grid: {
          color: 'rgba(255, 255, 255, 0.1)',
          drawBorder: false
        },
        ticks: {
          color: 'rgba(255, 255, 255, 0.9)',
          font: {
            size: 11
          },
          padding: 8,
          callback: function(this: Scale<CoreScaleOptions>, tickValue: number | string) {
            return typeof tickValue === 'number' ? tickValue.toFixed(2) + ' A' : tickValue;
          }
        }
      }
    },
    plugins: {
      ...commonOptions.plugins,
      tooltip: {
        ...commonOptions.plugins.tooltip,
        callbacks: {
          label: function(context: any) {
            const value = context.parsed.y;
            return `${context.dataset.label}: ${value.toFixed(2)} A`;
          }
        }
      },
      title: {
        display: true,
        text: 'Main Coil Setpoint Trend',
        color: 'rgba(255, 255, 255, 0.9)',
        font: {
          size: 16,
          weight: 'bold' as const
        },
        padding: 20
      }
    }
  };

  // Beam Profile specific options with improved ranges
  const beamProfileOptions = {
    ...commonOptions,
    scales: {
      ...commonOptions.scales,
      y: {
        type: 'linear' as const,
        min: Math.max(1.2, p1eMin - p1ePadding),
        max: Math.min(1.7, p1eMax + p1ePadding),
        grid: {
          color: 'rgba(255, 255, 255, 0.1)',
          drawBorder: false
        },
        ticks: {
          color: 'rgba(255, 255, 255, 0.9)',
          font: {
            size: 11
          },
          padding: 8,
          stepSize: 0.05,
          callback: function(this: Scale<CoreScaleOptions>, tickValue: number | string) {
            return typeof tickValue === 'number' ? tickValue.toFixed(2) + ' mm' : tickValue;
          }
        }
      }
    },
    plugins: {
      ...commonOptions.plugins,
      tooltip: {
        ...commonOptions.plugins.tooltip,
        callbacks: {
          label: function(context: any) {
            const value = context.parsed.y;
            return `${context.dataset.label}: ${value.toFixed(2)} mm`;
          }
        }
      },
      title: {
        display: true,
        text: 'P1E Beam Profile Measurements',
        color: 'rgba(255, 255, 255, 0.9)',
        font: {
          size: 16,
          weight: 'bold' as const
        },
        padding: 20
      }
    }
  };

  // Log whenever mainCoilData changes
  useEffect(() => {
    console.log('mainCoilData updated:', mainCoilData);
  }, [mainCoilData]);

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

  return (
    <div className="min-h-screen bg-gray-900 p-6">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Source Status Card */}
        <div className="bg-gray-800 rounded-xl p-6 border border-gray-700">
          <h2 className="text-xl font-semibold text-white mb-4">Source Status</h2>
          {sourceData && (
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
          )}
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
          <div className="space-y-2 max-h-40 overflow-y-auto">
            {workOrderSummary.workorders
              .filter(wo => wo.status !== 'closed')
              .map((wo, index) => (
                <div 
                  key={index} 
                  className="p-2 bg-gray-700 rounded cursor-pointer hover:bg-gray-600 transition-colors"
                  onClick={() => {
                    const date = new Date(wo.created_at).toISOString().split('T')[0];
                    onEntryClick(date, wo.shift_type);
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
          <div className="space-y-2 max-h-40 overflow-y-auto">
            {downtimeSummary.cases
              .filter(c => c.status !== 'closed')
              .map((c, index) => (
                <div 
                  key={index} 
                  className="p-2 bg-gray-700 rounded cursor-pointer hover:bg-gray-600 transition-colors"
                  onClick={() => {
                    const date = new Date(c.created_at).toISOString().split('T')[0];
                    onEntryClick(date, c.shift_type);
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
                </div>
              ))}
          </div>
        </div>

        {/* Main Coil Tuning Graphs with enhanced styling */}
        <div className="bg-gray-800 rounded-xl p-8 border border-gray-700 col-span-full">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            {/* MC Setpoint Graph */}
            <div className="h-[400px] p-4 bg-gray-850 rounded-lg shadow-lg">
              <Line
                data={mcSetpointChartData}
                options={mcSetpointOptions}
              />
            </div>

            {/* Beam Profile Graph */}
            <div className="h-[400px] p-4 bg-gray-850 rounded-lg shadow-lg">
              <Line
                data={beamProfileChartData}
                options={beamProfileOptions}
              />
            </div>
          </div>
          <div className="mt-6 text-sm text-gray-400 space-y-2">
            <p className="flex items-center">
              <span className="w-3 h-3 rounded-full bg-yellow-400 inline-block mr-2"></span>
              MC Setpoint changes are shown with high precision (±0.01 A)
            </p>
            <p className="flex items-center">
              <span className="w-3 h-3 rounded-full bg-teal-500 inline-block mr-2"></span>
              P1E X Width (Expected: ~1.5 mm)
            </p>
            <p className="flex items-center">
              <span className="w-3 h-3 rounded-full bg-blue-500 inline-block mr-2"></span>
              P1E Y Width (Expected: ~1.3 mm)
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard; 