import React, { useEffect, useState } from 'react';
import { BellRing, LogOut, Mail, Search, Calendar, X, RotateCcw, Send } from 'lucide-react';
import { Auth } from '@supabase/auth-ui-react';
import { ThemeSupa } from '@supabase/auth-ui-shared';
import LogEntryForm from './components/LogEntryForm';
import LogTable from './components/LogTable';
import ShiftSelector from './components/ShiftSelector';
import StartShiftModal from './components/StartShiftModal';
import EndShiftModal from './components/EndShiftModal';
import ShiftReportModal from './components/ShiftReportModal';
import { ActiveShift, ShiftType, SearchFilters } from './types';
import { supabase } from './lib/supabase';
import toast from 'react-hot-toast';

function App() {
  const [session, setSession] = useState(null);
  const [currentShift, setCurrentShift] = useState<ShiftType | undefined>(undefined);
  const [showForm, setShowForm] = useState(false);
  const [showStartShift, setShowStartShift] = useState(false);
  const [showEndShift, setShowEndShift] = useState(false);
  const [showReportModal, setShowReportModal] = useState(false);
  const [showAllLogs, setShowAllLogs] = useState(false);
  const [activeShift, setActiveShift] = useState<ActiveShift | null>(null);
  const [loading, setLoading] = useState(true);
  const [showAdvancedSearch, setShowAdvancedSearch] = useState(false);
  const [searchFilters, setSearchFilters] = useState<SearchFilters>({
    startDate: '',
    endDate: '',
    keyword: '',
  });

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

  if (!session) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center p-4">
        <div className="max-w-md w-full">
          <div className="flex items-center justify-center mb-8">
            <img 
              src="/iba-logo.svg" 
              alt="IBA Logo" 
              className="h-12 w-12"
            />
            <h1 className="text-3xl font-bold text-white ml-3">SAT.125 Logbook</h1>
          </div>
          <div className="bg-gray-800 p-8 rounded-lg shadow-xl border border-gray-700">
            <Auth
              supabaseClient={supabase}
              appearance={{ 
                theme: ThemeSupa,
                variables: {
                  default: {
                    colors: {
                      brand: '#3b82f6',
                      brandAccent: '#2563eb',
                      inputBackground: '#1f2937',
                      inputText: 'white',
                      inputBorder: '#374151',
                      inputBorderHover: '#4b5563',
                      inputBorderFocus: '#3b82f6',
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
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto"></div>
          <p className="mt-4 text-gray-400">Loading...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-900">
      {/* Header */}
      <header className="bg-gray-800 border-b border-gray-700">
        <div className="container mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center space-x-3">
              <img 
                src="/iba-logo.svg" 
                alt="IBA Logo" 
                className="h-8 w-8"
              />
              <h1 className="text-2xl font-bold text-white">SAT.125 Logbook</h1>
            </div>
            <div className="flex items-center space-x-4">
              <button
                onClick={() => {/* TODO: Implement notifications */}}
                className="text-gray-400 hover:text-white transition-colors"
              >
                <BellRing className="h-6 w-6" />
              </button>
              <button
                onClick={() => {/* TODO: Implement email */}}
                className="text-gray-400 hover:text-white transition-colors"
              >
                <Mail className="h-6 w-6" />
              </button>
              <button
                onClick={handleSignOut}
                className="text-gray-400 hover:text-white transition-colors"
              >
                <LogOut className="h-6 w-6" />
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-6">
        {/* Active Shift Status */}
        {activeShift && (
          <div className="mb-6 bg-blue-900/50 border border-blue-700 rounded-lg p-4">
            <h2 className="text-lg font-semibold text-blue-200 mb-2">
              Active Shift: {activeShift.shift_type.charAt(0).toUpperCase() + activeShift.shift_type.slice(1)}
            </h2>
            <div className="space-y-2">
              <p className="text-blue-300">
                Started at: {new Date(activeShift.started_at).toLocaleString()}
              </p>
              <p className="text-blue-300">
                SF#: {activeShift.salesforce_number}
              </p>
              <div className="text-blue-300">
                <span className="font-medium">Engineers: </span>
                {activeShift.engineers?.map(engineer => engineer.engineer.name).join(', ') || 'No engineers assigned'}
              </div>
            </div>
          </div>
        )}

        {/* Controls */}
        <div className="mb-6 space-y-4">
          <div className="flex flex-wrap gap-4 justify-between items-center">
            <div className="flex flex-wrap items-center gap-4">
              <button
                onClick={() => setShowAllLogs(!showAllLogs)}
                className={`px-4 py-2 rounded-md ${
                  showAllLogs
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-700 text-gray-200 hover:bg-gray-600'
                }`}
              >
                All Logs
              </button>
              {!showAllLogs && (
                <ShiftSelector currentShift={currentShift} onShiftChange={setCurrentShift} />
              )}
            </div>
            <div className="flex flex-wrap gap-4">
              <button
                onClick={handleStartShift}
                className={`px-4 py-2 text-white rounded-md transition-colors ${
                  activeShift
                    ? 'bg-gray-600 cursor-not-allowed'
                    : 'bg-green-600 hover:bg-green-700'
                }`}
                disabled={!!activeShift}
              >
                Start Shift
              </button>
              <button
                onClick={handleAddEntry}
                className={`px-4 py-2 text-white rounded-md transition-colors ${
                  !activeShift
                    ? 'bg-gray-600 cursor-not-allowed'
                    : 'bg-blue-600 hover:bg-blue-700'
                }`}
                disabled={!activeShift}
              >
                Add Entry
              </button>
              <button
                onClick={handleEndShift}
                className={`px-4 py-2 text-white rounded-md transition-colors ${
                  !activeShift
                    ? 'bg-gray-600 cursor-not-allowed'
                    : 'bg-red-600 hover:bg-red-700'
                }`}
                disabled={!activeShift}
              >
                End Shift
              </button>
              <button 
                onClick={() => setShowReportModal(true)} 
                className="px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 transition-colors flex items-center space-x-2"
              >
                <Send className="h-4 w-4" />
                <span>Send Report</span>
              </button>
            </div>
          </div>

          {/* Search Bar */}
          <div className="space-y-2">
            <div className="flex items-center gap-2">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                <input
                  type="text"
                  placeholder="Search logs..."
                  value={searchFilters.keyword}
                  onChange={(e) => setSearchFilters(prev => ({ ...prev, keyword: e.target.value }))}
                  className="w-full pl-10 pr-4 py-2 bg-gray-800 border border-gray-700 rounded-md text-white placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                />
              </div>
              <button
                onClick={() => setShowAdvancedSearch(!showAdvancedSearch)}
                className={`px-4 py-2 rounded-md ${
                  showAdvancedSearch
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-700 text-gray-200 hover:bg-gray-600'
                }`}
              >
                <Calendar className="h-5 w-5" />
              </button>
              <button
                onClick={resetSearchFilters}
                className="px-4 py-2 bg-gray-700 text-gray-200 hover:bg-gray-600 rounded-md flex items-center space-x-2"
                title="Reset search filters"
              >
                <RotateCcw className="h-5 w-5" />
              </button>
            </div>

            {showAdvancedSearch && (
              <div className="bg-gray-800 p-4 rounded-md border border-gray-700 space-y-4">
                <div className="flex items-center justify-between">
                  <h3 className="text-white font-medium">Date Range</h3>
                  <button
                    onClick={() => setShowAdvancedSearch(false)}
                    className="text-gray-400 hover:text-white"
                  >
                    <X className="h-5 w-5" />
                  </button>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-1">
                      Start Date
                    </label>
                    <input
                      type="datetime-local"
                      value={searchFilters.startDate}
                      onChange={(e) => setSearchFilters(prev => ({ ...prev, startDate: e.target.value }))}
                      className="w-full bg-gray-700 border border-gray-600 rounded-md text-white px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-1">
                      End Date
                    </label>
                    <input
                      type="datetime-local"
                      value={searchFilters.endDate}
                      onChange={(e) => setSearchFilters(prev => ({ ...prev, endDate: e.target.value }))}
                      className="w-full bg-gray-700 border border-gray-600 rounded-md text-white px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Log Table */}
        <LogTable 
          shift={showAllLogs ? undefined : currentShift} 
          searchFilters={searchFilters}
          onShiftChange={fetchActiveShift}
        />

        {/* Modals */}
        {showForm && (
          <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50">
            <div className="bg-gray-800 rounded-lg p-6 w-full max-w-2xl mx-4">
              <LogEntryForm onClose={() => setShowForm(false)} shift={currentShift!} />
            </div>
          </div>
        )}

        {showStartShift && (
          <StartShiftModal 
            onClose={() => setShowStartShift(false)} 
            onShiftStarted={fetchActiveShift}
          />
        )}

        {showEndShift && currentShift && (
          <EndShiftModal 
            onClose={() => setShowEndShift(false)} 
            currentShift={currentShift}
            onShiftEnded={fetchActiveShift}
          />
        )}

        {/* Shift Report Modal */}
        {showReportModal && (
          <ShiftReportModal onClose={() => setShowReportModal(false)} />
        )}
      </main>
    </div>
  );
}

export default App;