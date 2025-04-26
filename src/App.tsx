import React, { useEffect, useState } from 'react';
import { BellRing, LogOut, Mail, Search, Calendar, X, RotateCcw, Send, Filter, ClipboardList, History, Settings } from 'lucide-react';
import { Auth } from '@supabase/auth-ui-react';
import { ThemeSupa } from '@supabase/auth-ui-shared';
import LogEntryForm from './components/LogEntryForm';
import LogTable from './components/LogTable';
import ShiftSelector from './components/ShiftSelector';
import StartShiftModal from './components/StartShiftModal';
import EndShiftModal from './components/EndShiftModal';
import ShiftReportModal from './components/ShiftReportModal';
import LoadingSpinner from './components/LoadingSpinner';
import ErrorMessage from './components/ErrorMessage';
import AdvancedSearch from './components/AdvancedSearch';
import QuickEntry from './components/QuickEntry';
import { ActiveShift, ShiftType, SearchFilters, LogEntry } from './types';
import { supabase } from './lib/supabase';
import toast from 'react-hot-toast';
import { Session } from '@supabase/supabase-js';

function App() {
  const [session, setSession] = useState<Session | null>(null);
  const [currentShift, setCurrentShift] = useState<ShiftType | undefined>(undefined);
  const [showForm, setShowForm] = useState(false);
  const [showStartShift, setShowStartShift] = useState(false);
  const [showEndShift, setShowEndShift] = useState(false);
  const [showReportModal, setShowReportModal] = useState(false);
  const [showAllLogs, setShowAllLogs] = useState(false);
  const [activeShift, setActiveShift] = useState<ActiveShift | null>(null);
  const [loading, setLoading] = useState(true);
  const [showAdvancedSearch, setShowAdvancedSearch] = useState(false);
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const [searchFilters, setSearchFilters] = useState<SearchFilters>({
    startDate: '',
    endDate: '',
    keyword: '',
  });
  const [recentLogs, setRecentLogs] = useState<LogEntry[]>([]);
  const [previousShift, setPreviousShift] = useState<ActiveShift | null>(null);

  const resetSearchFilters = () => {
    setSearchFilters({
      startDate: '',
      endDate: '',
      keyword: '',
    });
  };

  useEffect(() => {
    let mounted = true;

    async function initializeAuth() {
      try {
        const { data: { session }, error: sessionError } = await supabase.auth.getSession();
        
        if (sessionError) throw sessionError;

        if (mounted) {
          setSession(session);
          if (session) {
            await fetchActiveShift();
          }
          setLoading(false);
        }
      } catch (error) {
        console.error('Auth initialization error:', error);
        if (mounted) {
          setLoading(false);
          toast.error('Failed to initialize authentication');
        }
      }
    }

    initializeAuth();

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (mounted) {
        setSession(session);
        if (session) {
          fetchActiveShift();
        }
        setLoading(false);
      }
    });

    return () => {
      mounted = false;
      subscription?.unsubscribe();
    };
  }, []);

  useEffect(() => {
    fetchRecentLogs();

    // Subscribe to real-time changes in log_entries
    const logChannel = supabase.channel('log_entries_changes');
    const logSubscription = logChannel
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'log_entries'
        },
        async (payload) => {
          await fetchRecentLogs();
        }
      )
      .subscribe();

    return () => {
      logChannel.unsubscribe();
    };
  }, []);

  const fetchActiveShift = async () => {
    try {
      const { data: activeShifts, error } = await supabase
        .from('active_shifts')
        .select(`
          *,
          engineers:shift_engineers(
            engineer:engineers(*)
          )
        `)
        .order('started_at', { ascending: false })
        .limit(1)
        .maybeSingle();

      if (error) throw error;

      if (activeShifts) {
        setActiveShift(activeShifts);
        setCurrentShift(activeShifts.shift_type);
      } else {
        setActiveShift(null);
        setCurrentShift(undefined);
      }
    } catch (error) {
      console.error('Error fetching active shift:', error);
      toast.error('Failed to fetch active shift status');
    }
  };

  const handleSignOut = async () => {
    try {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
      toast.success('Signed out successfully');
    } catch (error) {
      console.error('Error signing out:', error);
      toast.error('Error signing out');
    }
  };

  const handleStartShift = () => {
    if (activeShift) {
      toast.error('Cannot start a new shift while another shift is active');
      return;
    }
    setShowStartShift(true);
  };

  const handleEndShift = () => {
    if (!activeShift) {
      toast.error('No active shift to end');
      return;
    }
    setShowEndShift(true);
  };

  const handleAddEntry = () => {
    if (!activeShift) {
      toast.error('Please start a shift before adding entries');
      return;
    }
    setShowForm(true);
  };

  const fetchRecentLogs = async () => {
    try {
      const { data, error } = await supabase
        .from('log_entries')
        .select('*')
        .in('category', ['error', 'downtime'])
        .order('created_at', { ascending: false })
        .limit(2);

      if (error) throw error;
      setRecentLogs(data || []);
    } catch (error) {
      console.error('Error fetching recent logs:', error);
      toast.error('Failed to fetch recent logs');
    }
  };

  if (!session) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-indigo-900 via-blue-900 to-blue-800 flex items-center justify-center p-4">
        <div className="max-w-md w-full">
          <div className="flex items-center justify-center mb-8">
            <img 
              src="/iba-logo.svg" 
              alt="IBA Logo" 
              className="h-16 w-16"
            />
            <h1 className="text-4xl font-bold text-white ml-4">SAT.125 Logbook</h1>
          </div>
          <div className="bg-white/10 backdrop-blur-lg p-8 rounded-2xl shadow-2xl border border-white/20">
            <Auth
              supabaseClient={supabase}
              appearance={{ 
                theme: ThemeSupa,
                variables: {
                  default: {
                    colors: {
                      brand: '#4F46E5',
                      brandAccent: '#4338CA',
                      inputBackground: 'rgba(255, 255, 255, 0.1)',
                      inputText: 'white',
                      inputBorder: 'rgba(255, 255, 255, 0.2)',
                      inputBorderHover: 'rgba(255, 255, 255, 0.3)',
                      inputBorderFocus: '#4F46E5',
                    },
                  },
                },
              }}
              theme="dark"
              providers={[]}
              magicLink={false}
              showLinks={false}
              view="sign_in"
            />
          </div>
        </div>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center">
        <LoadingSpinner size="lg" text="Loading application..." />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-blue-900 to-indigo-900">
      {/* Main Content Layout */}
      <div className={`${isSidebarOpen ? 'ml-64' : 'ml-16'} transition-all duration-300 ease-in-out min-h-screen flex flex-col`}>
        {/* Top Section: Active Shift and Critical Events in a row */}
        {!showAllLogs && (
          <div className="flex gap-4 p-2">
            {/* Active Shift */}
            <div className="flex-1">
              <div className="bg-white/10 backdrop-blur-lg rounded-lg border border-white/20 p-3">
                <div className="flex justify-between items-start">
                  <div>
                    <div className="flex items-center gap-2">
                      <h3 className="text-lg font-semibold text-white">Active Shift</h3>
                      {activeShift && (
                        <span className="text-sm text-indigo-400">
                          ({activeShift.shift_type.charAt(0).toUpperCase() + activeShift.shift_type.slice(1)} Shift)
                        </span>
                      )}
                      {activeShift && (
              <button
                          onClick={handleEndShift}
                          className="px-2 py-0.5 bg-red-600 text-white text-sm rounded hover:bg-red-700 transition-colors"
              >
                          End Shift
              </button>
                      )}
                    </div>
                    {activeShift ? (
                      <div className="text-xs text-gray-300 mt-1">
                        <span className="mr-3">Started: {new Date(activeShift.started_at).toLocaleString()}</span>
                        <span>Engineers: {activeShift.engineers?.map(e => e.engineer.name).join(', ')}</span>
                      </div>
                    ) : (
                      <div className="flex items-center gap-2 mt-1">
                        <span className="text-sm text-gray-300">Start a new shift to begin logging entries</span>
              <button
                          onClick={handleStartShift}
                          className="px-2 py-0.5 bg-indigo-600 text-white text-sm rounded hover:bg-indigo-700 transition-colors"
                        >
                          Start Shift
              </button>
            </div>
                    )}
          </div>
        </div>
        {activeShift && (
                  <div className="mt-2">
                    <QuickEntry 
                      activeShift={activeShift} 
                      onEntryAdded={fetchRecentLogs} 
                      onFullFormClick={() => setShowForm(true)}
                    />
                  </div>
                )}
              </div>
            </div>

            {/* Critical Events */}
            <div className="w-80">
              <div className="bg-white/10 backdrop-blur-lg rounded-lg border border-white/20 p-3">
                <h3 className="text-lg font-semibold text-white mb-2">Critical Events</h3>
                <div className="space-y-1">
                  {recentLogs.length > 0 ? (
                    recentLogs.map(log => (
                      <div 
                        key={log.id} 
                        className={`p-1.5 rounded ${
                          log.category === 'error' 
                            ? 'bg-red-900/20 border border-red-700/50' 
                            : 'bg-yellow-900/20 border border-yellow-700/50'
                        }`}
                      >
                        <div className="flex items-center justify-between">
                          <span className={`px-1.5 py-0.5 text-xs font-medium rounded ${
                            log.category === 'error' 
                              ? 'bg-red-900 text-red-200' 
                              : 'bg-yellow-900 text-yellow-200'
                          }`}>
                            {log.category.toUpperCase()}
                          </span>
                          <span className="text-xs text-gray-400">
                            {new Date(log.created_at).toLocaleTimeString()}
                          </span>
                        </div>
                        <p className="text-xs text-white mt-1">{log.description}</p>
                      </div>
                    ))
                  ) : (
                    <div className="text-center py-1 text-gray-400 text-xs">
                      No critical events recorded
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Main Log Table Section - Takes maximum available space */}
        <div className={`flex-1 ${showAllLogs ? 'p-0' : 'p-2'}`} style={{ minHeight: showAllLogs ? '100vh' : 'calc(100vh - 140px)' }}>
          <div className={`bg-white/10 backdrop-blur-lg ${showAllLogs ? '' : 'rounded-lg'} border border-white/20 h-full flex flex-col overflow-hidden`}>
            <div className="flex justify-between items-center px-4 py-3 border-b border-white/10">
              <div className="flex items-center gap-4">
                <h3 className="text-lg font-semibold text-white">
                  {showAllLogs ? 'All Logs' : 'Current Shift Logs'}
                </h3>
                {showAllLogs && (
              <button
                    onClick={() => setShowAdvancedSearch(!showAdvancedSearch)}
                    className="px-2 py-1 text-xs text-gray-300 hover:text-white hover:bg-white/10 rounded transition-colors flex items-center gap-1"
                  >
                    <Filter className="h-3 w-3" />
                    <span>{showAdvancedSearch ? 'Hide Filters' : 'Show Filters'}</span>
              </button>
              )}
            </div>
              <div className="flex items-center gap-2">
                {!showAllLogs && (
              <button
                    onClick={() => {
                      setShowAllLogs(true);
                      resetSearchFilters();
                    }}
                    className="px-2 py-1 text-xs text-gray-300 hover:text-white hover:bg-white/10 rounded transition-colors flex items-center gap-1"
                  >
                    <History className="h-3 w-3" />
                    <span>View All Logs</span>
              </button>
                )}
              <button
                  onClick={() => {/* TODO: Export functionality */}}
                  className="px-2 py-1 text-xs bg-gray-700 text-white rounded hover:bg-gray-600 transition-colors"
                >
                  Export All Logs
              </button>
              </div>
            </div>

            {/* Advanced Search Section */}
            {showAllLogs && showAdvancedSearch && (
              <div className="border-b border-white/10 bg-white/5">
                <div className="p-3">
                  <AdvancedSearch
                    filters={searchFilters}
                    onFiltersChange={setSearchFilters}
                    onReset={resetSearchFilters}
                  />
                </div>
              </div>
            )}

            <div className="flex-1">
              <LogTable
                showAllLogs={showAllLogs}
                searchFilters={searchFilters}
                activeShift={activeShift}
              />
            </div>
          </div>
        </div>
      </div>

      {/* Navigation Sidebar */}
      <div 
        className={`fixed left-0 top-0 bottom-0 ${
          isSidebarOpen ? 'w-64' : 'w-16'
        } bg-white/10 backdrop-blur-lg border-r border-white/10 transition-all duration-300 ease-in-out z-50`}
      >
        <div className="p-4">
          <div className={`flex items-center ${isSidebarOpen ? 'justify-between' : 'justify-center'} mb-8`}>
            <div className="flex items-center space-x-3">
              <img src="/iba-logo.svg" alt="IBA Logo" className="h-8 w-8" />
              {isSidebarOpen && <h1 className="text-lg font-bold text-white">SAT.125</h1>}
            </div>
            <button
              onClick={() => setIsSidebarOpen(!isSidebarOpen)}
              className="text-gray-300 hover:text-white transition-colors"
              title={isSidebarOpen ? "Collapse sidebar" : "Expand sidebar"}
            >
              {isSidebarOpen ? (
                <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
                </svg>
              ) : (
                <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 5l7 7-7 7M5 5l7 7-7 7" />
                </svg>
              )}
            </button>
          </div>

          <nav className="space-y-2">
            <button 
              onClick={() => {
                setShowAllLogs(false);
                resetSearchFilters();
              }}
              className={`w-full flex items-center ${
                isSidebarOpen ? 'px-4' : 'justify-center'
              } py-3 rounded-lg transition-colors group relative ${
                !showAllLogs 
                  ? 'bg-indigo-600 text-white' 
                  : 'text-gray-300 hover:bg-white/10'
              }`}
              title={isSidebarOpen ? '' : 'Current Shift'}
            >
              <ClipboardList className="h-5 w-5" />
              {isSidebarOpen ? (
                <span className="ml-3">Current Shift</span>
              ) : (
                <span className="absolute left-16 bg-gray-800 text-white px-2 py-1 rounded text-sm opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-50">
                  Current Shift
                </span>
              )}
            </button>
            
            <button 
              onClick={() => {
                setShowAllLogs(true);
                resetSearchFilters();
              }}
              className={`w-full flex items-center ${
                isSidebarOpen ? 'px-4' : 'justify-center'
              } py-3 rounded-lg transition-colors group relative ${
                showAllLogs 
                  ? 'bg-indigo-600 text-white' 
                  : 'text-gray-300 hover:bg-white/10'
              }`}
              title={isSidebarOpen ? '' : 'All Logs'}
            >
              <History className="h-5 w-5" />
              {isSidebarOpen ? (
                <span className="ml-3">All Logs</span>
              ) : (
                <span className="absolute left-16 bg-gray-800 text-white px-2 py-1 rounded text-sm opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-50">
                  All Logs
                </span>
              )}
            </button>
          </nav>
        </div>
      </div>

        {/* Modals */}
        {showForm && (
      <LogEntryForm
        onClose={() => setShowForm(false)}
        activeShift={activeShift}
      />
        )}
        {showStartShift && (
          <StartShiftModal 
            onClose={() => setShowStartShift(false)} 
        onSuccess={fetchActiveShift}
          />
        )}
    {showEndShift && (
          <EndShiftModal 
            onClose={() => setShowEndShift(false)} 
        onSuccess={fetchActiveShift}
        activeShift={activeShift}
          />
        )}
        {showReportModal && (
    <ShiftReportModal
      onClose={() => setShowReportModal(false)}
      activeShift={activeShift}
    />
        )}
    </div>
  );
}

export default App;