import React, { useEffect, useState, useMemo } from 'react';
import { BellRing, LogOut, Mail, Search, Calendar, X, RotateCcw, Send, Filter, ClipboardList, History, Settings, Clock, Archive, BookOpen, FileText, Shield, CheckCircle, XCircle } from 'lucide-react';
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
import { ActiveShift, ShiftType, SearchFilters, LogEntry, LogCategory } from './types';
import { supabase } from './lib/supabase';
import toast from 'react-hot-toast';
import { Session } from '@supabase/supabase-js';

interface AccessRequest {
  id: string;
  name: string;
  email: string;
  role: string;
  message: string;
  status: 'pending' | 'approved' | 'rejected';
  created_at: string;
}

// Update the styles with new animations
const styles = `
  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translate(-50%, -50%) scale(0.5);
    }
    to {
      opacity: 1;
      transform: translate(-50%, -50%) scale(1);
    }
  }

  @keyframes float {
    0% {
      transform: translateY(0px);
    }
    50% {
      transform: translateY(-5px);
    }
    100% {
      transform: translateY(0px);
    }
  }

  @keyframes pulse {
    0% {
      box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.4);
    }
    70% {
      box-shadow: 0 0 0 10px rgba(99, 102, 241, 0);
    }
    100% {
      box-shadow: 0 0 0 0 rgba(99, 102, 241, 0);
    }
  }

  @keyframes emojiBounce {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.2); }
  }

  @keyframes emojiRotate {
    0% { transform: rotate(0deg); }
    25% { transform: rotate(-10deg); }
    75% { transform: rotate(10deg); }
    100% { transform: rotate(0deg); }
  }

  .tooltip-animation {
    animation: float 2s ease-in-out infinite;
  }

  .refresh-pulse {
    position: relative;
  }

  .refresh-pulse::before {
    content: '';
    position: absolute;
    inset: -3px;
    border-radius: 8px;
    background: linear-gradient(45deg, #4f46e5, #6366f1);
    opacity: 0;
    transition: opacity 0.3s ease;
  }

  .refresh-pulse:hover::before {
    opacity: 0.3;
    animation: pulse 2s infinite;
  }

  .vertical-text {
    writing-mode: vertical-rl;
    transform: rotate(180deg);
    white-space: nowrap;
    transition: all 0.3s ease;
    letter-spacing: 0.025em;
  }

  .sidebar-transition {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .emoji-animate {
    animation: emojiBounce 2s infinite, emojiRotate 2s infinite;
    display: inline-block;
  }

  .minimized-text {
    position: absolute;
    left: 0;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 10;
  }

  .minimized-text-container {
    background: rgba(17, 24, 39, 0.7);
    backdrop-filter: blur(8px);
    padding: 1.25rem 0.5rem;
    border-radius: 0.5rem;
    border: 1px solid rgba(255, 255, 255, 0.1);
    transition: all 0.3s ease;
    margin: 0 auto;
  }

  .minimized-text-container:hover {
    background: rgba(17, 24, 39, 0.8);
    border-color: rgba(255, 255, 255, 0.2);
  }

  .emoji-tooltip {
    position: absolute;
    left: 100%;
    top: 50%;
    transform: translateY(-50%);
    margin-left: 0.75rem;
    background: rgba(79, 70, 229, 0.9);
    backdrop-filter: blur(8px);
    padding: 0.5rem 0.75rem;
    border-radius: 9999px;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    opacity: 0;
    transition: all 0.3s ease;
    pointer-events: none;
    white-space: nowrap;
  }

  .minimized-text-container:hover .emoji-tooltip {
    opacity: 1;
    transform: translateY(-50%) translateX(5px);
  }

  .expanded-tooltip {
    position: absolute;
    top: 100%;
    left: 50%;
    transform: translateX(-50%);
    margin-top: 0.5rem;
    background: rgba(79, 70, 229, 0.9);
    backdrop-filter: blur(8px);
    padding: 0.5rem 0.75rem;
    border-radius: 9999px;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    opacity: 0;
    transition: all 0.3s ease;
    pointer-events: none;
    white-space: nowrap;
  }

  .expanded-container:hover .expanded-tooltip {
    opacity: 1;
    transform: translateX(-50%) translateY(5px);
  }

  .sidebar-item {
    position: relative;
    width: 100%;
    display: flex;
    align-items: center;
    padding: 0.75rem 0;
    transition: all 0.3s ease;
  }

  .sidebar-item.expanded {
    padding: 0.75rem 1rem;
    justify-content: flex-start;
  }

  .sidebar-item.collapsed {
    justify-content: center;
  }

  .sidebar-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 20px;
    height: 20px;
    position: relative;
    flex-shrink: 0;
  }

  .sidebar-text {
    margin-left: 0.75rem;
    font-medium;
    transition: all 0.3s ease;
    white-space: nowrap;
  }

  .sidebar-tooltip {
    position: absolute;
    left: 100%;
    top: 50%;
    transform: translateY(-50%);
    margin-left: 0.75rem;
    background: rgba(17, 24, 39, 0.9);
    backdrop-filter: blur(8px);
    padding: 0.5rem 0.75rem;
    border-radius: 0.5rem;
    white-space: nowrap;
    opacity: 0;
    pointer-events: none;
    transition: all 0.2s ease;
    z-index: 50;
  }

  .sidebar-item:hover .sidebar-tooltip {
    opacity: 1;
    transform: translateY(-50%) translateX(5px);
  }
`;

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
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [searchFilters, setSearchFilters] = useState<SearchFilters>({
    startDate: '',
    endDate: '',
    keyword: '',
  });
  const [recentLogs, setRecentLogs] = useState<LogEntry[]>([]);
  const [previousShift, setPreviousShift] = useState<ActiveShift | null>(null);
  const [showDateFilter, setShowDateFilter] = useState(false);
  const [showSignupRequest, setShowSignupRequest] = useState(false);
  const [signupForm, setSignupForm] = useState({
    name: '',
    email: '',
    role: '',
    message: ''
  });
  const [isAdmin, setIsAdmin] = useState(false);
  const [accessRequests, setAccessRequests] = useState<AccessRequest[]>([]);
  const [showAdminPanel, setShowAdminPanel] = useState(false);

  // Add array of emojis for random selection
  const refreshEmojis = ["🔄", "✨", "🚀", "💫", "🎯", "🌟", "⚡️", "🔮"];
  const [currentEmoji, setCurrentEmoji] = useState(refreshEmojis[0]);

  // Function to change emoji randomly
  useEffect(() => {
    const interval = setInterval(() => {
      const randomEmoji = refreshEmojis[Math.floor(Math.random() * refreshEmojis.length)];
      setCurrentEmoji(randomEmoji);
    }, 2000);
    return () => clearInterval(interval);
  }, []);

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
        // Set loading immediately
        setLoading(true);
        
        // Get the stored session first
        const { data: { session }, error: sessionError } = await supabase.auth.getSession();
        
        if (sessionError) throw sessionError;

        if (mounted) {
          setSession(session);
          if (session) {
            await fetchActiveShift();
          }
        }
      } catch (error) {
        console.error('Auth initialization error:', error);
        if (mounted) {
          toast.error('Failed to initialize authentication');
        }
      } finally {
        // Only set loading to false after everything is done
        if (mounted) {
          setLoading(false);
        }
      }
    }

    initializeAuth();

    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (_event, session) => {
      if (mounted) {
        setSession(session);
        if (session) {
          await fetchActiveShift();
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

  useEffect(() => {
    const checkAdminStatus = async () => {
      try {
        const { data: { user } } = await supabase.auth.getUser();
        if (!user) return;

        const { data: profile } = await supabase
          .from('profiles')
          .select('is_admin')
          .eq('id', user.id)
          .single();

        setIsAdmin(profile?.is_admin || false);
      } catch (error) {
        console.error('Error checking admin status:', error);
      }
    };

    checkAdminStatus();
  }, []);

  const fetchActiveShift = async () => {
    try {
      const { data: activeShifts, error } = await supabase
        .from('active_shifts')
        .select(`
          *,
          engineers:shift_engineers!fk_shift(
            engineer:engineers!fk_engineer(*)
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
        .order('created_at', { ascending: false });

      if (error) throw error;
      setRecentLogs(data || []);
    } catch (error) {
      console.error('Error fetching recent logs:', error);
      toast.error('Failed to fetch recent logs');
    }
  };

  const handleCriticalEventClick = async (log: LogEntry) => {
    try {
      // Switch to All Logs view first
      setShowAllLogs(true);
      setShowAdvancedSearch(true);
      setShowDateFilter(true);

      // Get the date from the log entry
      const logDate = new Date(log.created_at);
      const formattedDate = logDate.toISOString().slice(0, 10); // Format: YYYY-MM-DD

      // Set filters with just the date and shift type
      setSearchFilters({
        keyword: '',
        startDate: formattedDate,
        endDate: formattedDate,
        shiftType: log.shift_type,
        category: undefined
      });

      // Debug log to verify the filters being set
      console.log('Setting filters:', {
        date: formattedDate,
        shiftType: log.shift_type,
        logTime: log.created_at
      });

    } catch (error) {
      console.error('Error handling critical event click:', error);
      toast.error('Failed to load shift data');
    }
  };

  const handleSignupRequest = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const { error } = await supabase
        .from('access_requests')
        .insert([
          {
            name: signupForm.name,
            email: signupForm.email,
            role: signupForm.role,
            message: signupForm.message,
            status: 'pending'
          }
        ]);

      if (error) throw error;

      toast.success('Access request submitted successfully');
      setShowSignupRequest(false);
      setSignupForm({ name: '', email: '', role: '', message: '' });
    } catch (error) {
      console.error('Error submitting access request:', error);
      toast.error('Failed to submit access request');
    }
  };

  const handleRequestStatus = async (requestId: string, status: 'approved' | 'rejected') => {
    try {
      if (status === 'approved') {
        // First get the request details
        const { data: requestData, error: requestError } = await supabase
          .from('access_requests')
          .select('*')
          .eq('id', requestId)
          .single();

        if (requestError) throw requestError;

        // Create user in Auth
        const { data: userData, error: userError } = await supabase.auth.admin.createUser({
          email: requestData.email,
          email_confirm: true,
          user_metadata: {
            name: requestData.name,
            role: requestData.role
          }
        });

        if (userError) throw userError;

        // Create profile
        const { error: profileError } = await supabase
          .from('profiles')
          .insert([{
            id: userData.user.id,
            is_admin: false,
            name: requestData.name,
            role: requestData.role
          }]);

        if (profileError) throw profileError;

        // Update the redirectTo URL to match your development environment
        const { error: resetError } = await supabase.auth.resetPasswordForEmail(
          requestData.email,
          { 
            redirectTo: 'http://localhost:5173/auth/callback'  // Update this URL to match your Vite development server
          }
        );

        if (resetError) throw resetError;
      }

      // Update request status
      const { error: statusError } = await supabase
        .from('access_requests')
        .update({ status })
        .eq('id', requestId);

      if (statusError) throw statusError;
      
      toast.success(
        status === 'approved' 
          ? 'Request approved. User will receive an email to set their password.' 
          : 'Request rejected successfully'
      );
      fetchAccessRequests();
    } catch (error) {
      console.error('Error handling request:', error);
      toast.error('Failed to process request');
    }
  };

  const fetchAccessRequests = async () => {
    try {
      const { data, error } = await supabase
        .from('access_requests')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      setAccessRequests(data || []);
    } catch (error) {
      console.error('Error fetching access requests:', error);
      toast.error('Failed to fetch access requests');
    }
  };

  // Add this new function for clean refresh
  const handleRefresh = async () => {
    try {
      setLoading(true);
      // Refetch active shift
      await fetchActiveShift();
      // Refetch recent logs
      await fetchRecentLogs();
      // Reset search filters
      resetSearchFilters();
      // Reset view to current shift
      setShowAllLogs(false);
      setShowAdvancedSearch(false);
      setShowDateFilter(false);
      toast.success('Page refreshed successfully');
    } catch (error) {
      console.error('Error refreshing data:', error);
      toast.error('Failed to refresh data');
    } finally {
      setLoading(false);
    }
  };

  // Add this useEffect to inject the styles
  useEffect(() => {
    const styleElement = document.createElement('style');
    styleElement.innerHTML = styles;
    document.head.appendChild(styleElement);
    return () => {
      document.head.removeChild(styleElement);
    };
  }, []);

  // Memoize the Auth component at the top level
  const authComponent = useMemo(() => (
    <Auth
      supabaseClient={supabase}
      appearance={{ 
        theme: ThemeSupa,
        variables: {
          default: {
            colors: {
              brand: '#818CF8',
              brandAccent: '#6366F1',
              inputBackground: 'rgba(255, 255, 255, 0.1)',
              inputText: 'white',
              inputPlaceholder: 'rgba(255, 255, 255, 0.5)',
              inputBorder: 'rgba(255, 255, 255, 0.2)',
              inputBorderHover: 'rgba(255, 255, 255, 0.3)',
              inputBorderFocus: '#818CF8',
            },
          },
        },
        style: {
          button: {
            borderRadius: '0.5rem',
            padding: '0.75rem 1rem',
            fontSize: '0.875rem',
            fontWeight: '500',
            border: 'none',
          },
          input: {
            borderRadius: '0.5rem',
            padding: '0.75rem 1rem',
            fontSize: '0.875rem',
          },
          message: {
            borderRadius: '0.5rem',
            fontSize: '0.875rem',
          },
        },
      }}
      theme="dark"
      providers={[]}
      redirectTo={window.location.origin}
      magicLink={false}
      showLinks={false}
      view="sign_in"
    />
  ), []);

  // Add a helper to restore active shift if a 'shift ended' log is deleted
  const restoreActiveShiftIfNeeded = async () => {
    // Check if there is no active shift
    const { data: activeShifts, error: activeError } = await supabase
      .from('active_shifts')
      .select('*')
      .order('started_at', { ascending: false })
      .limit(1)
      .maybeSingle();
    if (activeError) return;
    if (activeShifts) return; // Already active

    // Find the last 'shift started' log
    const { data: startLog, error: startError } = await supabase
      .from('log_entries')
      .select('*')
      .eq('category', 'shift')
      .ilike('description', '%shift started%')
      .order('created_at', { ascending: false })
      .limit(1)
      .single();
    if (startError || !startLog) return;

    // Check if there is a corresponding 'shift ended' log after this
    const { data: endLog, error: endError } = await supabase
      .from('log_entries')
      .select('*')
      .eq('category', 'shift')
      .eq('shift_type', startLog.shift_type)
      .gt('created_at', startLog.created_at)
      .ilike('description', '%shift ended%')
      .order('created_at', { ascending: true })
      .limit(1)
      .maybeSingle();
    if (endError) return;
    if (endLog) return; // There is an end log, so don't restore

    // Restore the active shift
    await supabase.from('active_shifts').insert({
      shift_type: startLog.shift_type,
      started_by: startLog.user_id,
      salesforce_number: startLog.description.match(/SF#: (.*?)\)/)?.[1] || '',
      started_at: startLog.created_at
    });
    // Re-fetch active shift
    await fetchActiveShift();
  };

  // Patch the log deletion handler to call restoreActiveShiftIfNeeded after deletion
  const handleDeleteLogEntry = async (logId: string) => {
    try {
      // Delete the log entry
      const { error } = await supabase.from('log_entries').delete().eq('id', logId);
      if (error) throw error;
      // If it was a shift ended log, try to restore active shift
      await restoreActiveShiftIfNeeded();
      // Refresh logs and active shift
      await fetchRecentLogs();
      await fetchActiveShift();
      toast.success('Log entry deleted');
    } catch (error) {
      toast.error('Failed to delete log entry');
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-900 via-blue-900 to-indigo-900 flex items-center justify-center">
        <div className="flex flex-col items-center space-y-4">
          <div className="bg-[#8CC63F] rounded-xl p-2.5 mb-4 shadow-lg shadow-[#8CC63F]/20">
            <img 
              src="/iba-logo.ico" 
              alt="IBA Logo" 
              className="h-12 w-12"
            />
          </div>
          <div className="flex items-center space-x-3">
            <div className="w-3 h-3 bg-blue-500 rounded-full animate-bounce [animation-delay:-0.3s]"></div>
            <div className="w-3 h-3 bg-blue-500 rounded-full animate-bounce [animation-delay:-0.15s]"></div>
            <div className="w-3 h-3 bg-blue-500 rounded-full animate-bounce"></div>
          </div>
          <p className="text-white/80 text-sm">Loading your session...</p>
        </div>
      </div>
    );
  }

  if (!session) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-900 via-blue-900 to-indigo-900 flex items-center justify-center p-4">
        <div className="max-w-md w-full">
          <div className="flex flex-col items-center justify-center mb-8">
            <div className="bg-[#8CC63F] rounded-xl p-2.5 mb-4 shadow-lg shadow-[#8CC63F]/20">
              <img 
                src="/iba-logo.ico" 
                alt="IBA Logo" 
                className="h-12 w-12"
              />
            </div>
            <h1 className="text-4xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-white to-gray-300 mb-1">Logbook</h1>
            <p className="text-lg text-gray-400">SAT.125 Chennai</p>
          </div>
          <div className="bg-white/10 backdrop-blur-lg p-8 rounded-2xl shadow-2xl border border-white/20">
            <div className="mb-6">
              <div className="flex items-center justify-between mb-4">
                <h2 className="text-xl font-semibold text-white">Welcome Back</h2>
                <button
                  onClick={() => setShowSignupRequest(true)}
                  className="text-sm text-indigo-400 hover:text-indigo-300 transition-colors"
                >
                  Request Access
                </button>
              </div>
              <p className="text-sm text-gray-400">Please sign in to continue to the logbook system.</p>
            </div>
            {authComponent}
          </div>
          <p className="text-center mt-6 text-sm text-gray-500">
            © {new Date().getFullYear()} IBA Group. All rights reserved.
          </p>
        </div>

        {/* Signup Request Modal */}
        {showSignupRequest && (
          <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50">
            <div className="bg-gray-900 rounded-2xl p-6 max-w-md w-full mx-4 border border-white/10">
              <h3 className="text-xl font-semibold text-white mb-2">Request Access</h3>
              <p className="text-sm text-gray-400 mb-4">
                Please provide your details. The admin will review your request and grant access if approved.
              </p>
              <form onSubmit={handleSignupRequest} className="space-y-4">
                <div>
                  <label htmlFor="name" className="block text-sm font-medium text-gray-300 mb-1">Full Name</label>
                  <input
                    type="text"
                    id="name"
                    value={signupForm.name}
                    onChange={(e) => setSignupForm({ ...signupForm, name: e.target.value })}
                    className="w-full bg-white/10 border border-white/20 rounded-lg px-4 py-2 text-white placeholder-gray-400 focus:outline-none focus:border-indigo-500"
                    placeholder="Enter your full name"
                    required
                  />
                </div>
                <div>
                  <label htmlFor="email" className="block text-sm font-medium text-gray-300 mb-1">Email Address</label>
                  <input
                    type="email"
                    id="email"
                    value={signupForm.email}
                    onChange={(e) => setSignupForm({ ...signupForm, email: e.target.value })}
                    className="w-full bg-white/10 border border-white/20 rounded-lg px-4 py-2 text-white placeholder-gray-400 focus:outline-none focus:border-indigo-500"
                    placeholder="Enter your email"
                    required
                  />
                </div>
                <div>
                  <label htmlFor="role" className="block text-sm font-medium text-gray-300 mb-1">Role</label>
                  <input
                    type="text"
                    id="role"
                    value={signupForm.role}
                    onChange={(e) => setSignupForm({ ...signupForm, role: e.target.value })}
                    className="w-full bg-white/10 border border-white/20 rounded-lg px-4 py-2 text-white placeholder-gray-400 focus:outline-none focus:border-indigo-500"
                    placeholder="Enter your role (e.g., Engineer, Operator)"
                    required
                  />
                </div>
                <div>
                  <label htmlFor="message" className="block text-sm font-medium text-gray-300 mb-1">Message</label>
                  <textarea
                    id="message"
                    value={signupForm.message}
                    onChange={(e) => setSignupForm({ ...signupForm, message: e.target.value })}
                    className="w-full bg-white/10 border border-white/20 rounded-lg px-4 py-2 text-white placeholder-gray-400 focus:outline-none focus:border-indigo-500 h-24 resize-none"
                    placeholder="Briefly explain why you need access"
                    required
                  />
                </div>
                <div className="flex justify-end gap-3 mt-6">
                  <button
                    type="button"
                    onClick={() => setShowSignupRequest(false)}
                    className="px-4 py-2 text-sm font-medium text-gray-300 hover:text-white transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="px-4 py-2 text-sm font-medium bg-indigo-600 text-white rounded-lg hover:bg-indigo-500 transition-colors"
                  >
                    Submit Request
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}
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
                <div className="h-[120px] overflow-y-auto scrollbar-thin scrollbar-thumb-gray-700 scrollbar-track-transparent">
                 {recentLogs.length > 0 ? (
                    recentLogs.map(log => (
                      <div 
                        key={log.id}
                        onClick={() => handleCriticalEventClick(log)}
                        className={`p-1.5 rounded mb-1.5 ${
                          log.category === 'error' 
                            ? 'bg-red-900/20 border border-red-700/50' 
                            : 'bg-yellow-900/20 border border-yellow-700/50'
                        } cursor-pointer hover:bg-white/5 transition-colors`}
                      >
                        <div className="flex items-center justify-between">
                          <div className="flex items-center gap-2">
                            <span className={`px-1.5 py-0.5 text-xs font-medium rounded ${
                              log.category === 'error' 
                                ? 'bg-red-900 text-red-200' 
                                : 'bg-yellow-900 text-yellow-200'
                            }`}>
                              {log.category.toUpperCase()}
                            </span>
                            {log.category === 'downtime' && log.case_number && (
                              <span className="text-xs text-yellow-400">
                                #{log.case_number} ({log.case_status})
                              </span>
                            )}
                          </div>
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
        <div className={`flex-1 ${showAllLogs ? 'p-0' : 'p-2'} bg-gradient-to-br from-gray-900 via-blue-900 to-indigo-900`} style={{ minHeight: showAllLogs ? '100vh' : 'calc(100vh - 140px)' }}>
          <div className={`bg-white/10 backdrop-blur-lg ${showAllLogs ? '' : 'rounded-lg'} border border-white/20 h-full flex flex-col overflow-hidden will-change-scroll`}>
            <div className="flex justify-between items-center px-4 py-3 border-b border-white/10 bg-gray-900/50 backdrop-blur-lg sticky top-0 z-10">
              <div className="flex items-center gap-4">
                <h3 className="text-lg font-semibold text-white">
                  {showAllLogs ? 'All Logs' : 'Current Shift Logs'}
                </h3>
                {showAllLogs && (
              <button
                    onClick={() => setShowAdvancedSearch(!showAdvancedSearch)}
                    className={`px-2 py-1 text-xs rounded flex items-center gap-1 transition-colors ${
                      showAdvancedSearch 
                        ? 'bg-indigo-600 text-white hover:bg-indigo-700' 
                        : 'bg-gray-800 text-gray-300 hover:text-white border border-gray-700'
                    }`}
                  >
                    <Filter className="h-3 w-3" />
                    Filter
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
            {showAllLogs && (
              <div className="border-b border-white/10 bg-gray-900/50 backdrop-blur-lg sticky top-[57px] z-10">
                <div className="p-2 flex flex-wrap items-center gap-2">
                  <div className="flex-1 min-w-[200px]">
                <input
                  type="text"
                      placeholder="Search in descriptions..."
                  value={searchFilters.keyword}
                      onChange={(e) => setSearchFilters({ ...searchFilters, keyword: e.target.value })}
                      className="w-full px-3 py-1.5 bg-gray-800 border border-gray-700 rounded text-sm text-white placeholder-gray-400 focus:outline-none focus:border-indigo-500"
                />
              </div>

                  {showAdvancedSearch && (
                    <div className="flex items-center gap-2">
                      <select
                        value={searchFilters.shiftType || ''}
                        onChange={(e) => setSearchFilters({ ...searchFilters, shiftType: e.target.value as ShiftType | undefined })}
                        className="px-3 py-1.5 bg-gray-800 border border-gray-700 rounded text-sm text-white focus:outline-none focus:border-indigo-500"
                      >
                        <option value="">All Shifts</option>
                        <option value="morning">Morning</option>
                        <option value="afternoon">Afternoon</option>
                        <option value="night">Night</option>
                      </select>

                      <select
                        value={searchFilters.category || ''}
                        onChange={(e) => setSearchFilters({ ...searchFilters, category: e.target.value as LogCategory | undefined })}
                        className="px-3 py-1.5 bg-gray-800 border border-gray-700 rounded text-sm text-white focus:outline-none focus:border-indigo-500"
                      >
                        <option value="">All Categories</option>
                        <option value="general">📝 General</option>
                        <option value="error">⚠️ Error</option>
                        <option value="downtime">🔄 Downtime</option>
                        <option value="workorder">📋 Work Order</option>
                        <option value="data-collection">📊 Data Collection</option>
                        <option value="shift">👤 Shift Changes</option>
                      </select>

              <button
                        onClick={() => setShowDateFilter(!showDateFilter)}
                        className={`px-3 py-1.5 text-xs rounded flex items-center gap-1 transition-colors ${
                          showDateFilter 
                            ? 'bg-indigo-600 text-white hover:bg-indigo-700' 
                            : 'bg-gray-800 text-gray-300 hover:text-white border border-gray-700'
                        }`}
                      >
                        <Calendar className="h-3 w-3" />
                        Date Filter
              </button>

                  <button
                        onClick={() => {
                          resetSearchFilters();
                          setShowDateFilter(false);
                        }}
                        className="px-3 py-1.5 text-xs bg-gray-800 text-gray-300 hover:text-white border border-gray-700 rounded transition-colors flex items-center gap-1"
                      >
                        <RotateCcw className="h-3 w-3" />
                        Reset
                  </button>
                </div>
                  )}
                </div>

                {/* Date Filter Section */}
                {showAdvancedSearch && showDateFilter && (
                  <div className="p-2 pt-0 flex gap-2 items-center">
                    <div className="flex items-center gap-2">
                    <input
                        type="date"
                      value={searchFilters.startDate}
                        onChange={(e) => setSearchFilters({ ...searchFilters, startDate: e.target.value })}
                        className="px-3 py-1.5 bg-gray-800 border border-gray-700 rounded text-sm text-white focus:outline-none focus:border-indigo-500"
                      />
                      <span className="text-gray-400">to</span>
                    <input
                        type="date"
                      value={searchFilters.endDate}
                        onChange={(e) => setSearchFilters({ ...searchFilters, endDate: e.target.value })}
                        className="px-3 py-1.5 bg-gray-800 border border-gray-700 rounded text-sm text-white focus:outline-none focus:border-indigo-500"
                    />
                </div>
              </div>
            )}
          </div>
            )}

            <div className="flex-1 overflow-auto overscroll-none">
              <div className="h-full bg-gradient-to-br from-gray-900 via-blue-900 to-indigo-900">
        <LogTable 
                  showAllLogs={showAllLogs}
          searchFilters={searchFilters}
                  activeShift={activeShift}
                />
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Navigation Sidebar */}
      <div 
        className={`fixed left-0 top-0 bottom-0 ${
          isSidebarOpen ? 'w-64' : 'w-16'
        } bg-white/10 backdrop-blur-lg border-r border-white/10 sidebar-transition z-50 flex flex-col overflow-hidden`}
      >
        {/* Top section with logo and navigation */}
        <div className="flex-1">
          <div className="p-4">
            <div className={`flex items-center ${isSidebarOpen ? 'justify-start' : 'justify-center'} mb-8`}>
              <div className="flex items-center space-x-3">
                <div 
                  onClick={() => setIsSidebarOpen(!isSidebarOpen)}
                  className="bg-[#8CC63F] rounded-lg p-1.5 min-w-[32px] min-h-[32px] flex items-center justify-center cursor-pointer hover:brightness-110 hover:scale-105 transition-all duration-200"
                  title={isSidebarOpen ? "Collapse sidebar" : "Expand sidebar"}
                >
                  <img 
                    src="/iba-logo.ico" 
                    alt="IBA Logo" 
                    className="h-5 w-5"
                  />
                </div>
                {/* Expanded view */}
                {isSidebarOpen ? (
                  <div 
                    onClick={handleRefresh}
                    className="relative overflow-hidden w-auto opacity-100 cursor-pointer group expanded-container"
                  >
                    <div className="relative p-2 rounded-lg hover:bg-white/5 transition-colors">
                      <h1 className="text-xl font-bold text-white bg-gradient-to-r from-indigo-400 to-blue-400 bg-clip-text text-transparent whitespace-nowrap group-hover:scale-105 transition-transform">
                        Logbook
                      </h1>
                      <p className="text-xs text-gray-400 whitespace-nowrap">SAT.125 Chennai</p>
                      
                      {/* Expanded tooltip */}
                      <div className="expanded-tooltip">
                        <span className="emoji-animate">{currentEmoji}</span>
                        <span className="text-white text-sm">Click to refresh</span>
                      </div>
                    </div>
                  </div>
                ) : (
                  /* Minimized view */
                  <div className="minimized-text">
                    <div 
                      onClick={handleRefresh}
                      className="minimized-text-container cursor-pointer group"
                    >
                      <div className="vertical-text flex items-center justify-center">
                        <span className="text-sm font-medium">
                          <span className="text-white">Logbook</span>
                          <span className="text-gray-400"> - </span>
                          <span className="text-gray-400">SAT.125 Chennai</span>
                        </span>
                      </div>
                      {/* Side tooltip */}
                      <div className="emoji-tooltip">
                        <span className="emoji-animate text-lg">{currentEmoji}</span>
                        <span className="text-white text-xs">Click to refresh</span>
                      </div>
            </div>
          </div>
        )}
              </div>
            </div>

            <nav className="space-y-1">
              <button 
                onClick={() => {
                  setShowAllLogs(false);
                  resetSearchFilters();
                }}
                className={`sidebar-item ${isSidebarOpen ? 'expanded' : 'collapsed'} group ${
                  !showAllLogs 
                    ? 'text-white' 
                    : 'text-gray-400 hover:text-white hover:bg-white/5'
                }`}
              >
                <div className="sidebar-icon">
                  <Clock className="h-5 w-5" />
                  {!showAllLogs && (
                    <div className="absolute -top-1 -right-1 w-2 h-2 bg-green-400 rounded-full animate-pulse" />
                  )}
                </div>
                {isSidebarOpen ? (
                  <span className="sidebar-text">Current Shift</span>
                ) : (
                  <span className="sidebar-tooltip text-sm text-white">
                    Current Shift
                  </span>
                )}
              </button>
              
              <button 
                onClick={() => {
                  setShowAllLogs(true);
                  resetSearchFilters();
                }}
                className={`sidebar-item ${isSidebarOpen ? 'expanded' : 'collapsed'} group ${
                  showAllLogs 
                    ? 'text-white' 
                    : 'text-gray-400 hover:text-white hover:bg-white/5'
                }`}
              >
                <div className="sidebar-icon">
                  <BookOpen className="h-5 w-5" />
                </div>
                {isSidebarOpen ? (
                  <span className="sidebar-text">All Logs</span>
                ) : (
                  <span className="sidebar-tooltip text-sm text-white">
                    All Logs
                  </span>
                )}
              </button>
            </nav>
          </div>
        </div>

        {/* Bottom section with logout button */}
        <div className="mt-auto">
          {isAdmin && (
            <button 
              onClick={() => {
                setShowAdminPanel(true);
                fetchAccessRequests();
              }}
              className={`sidebar-item ${isSidebarOpen ? 'expanded' : 'collapsed'} group text-gray-400 hover:text-white hover:bg-white/5`}
            >
              <div className="sidebar-icon">
                <Shield className="h-5 w-5" />
              </div>
              {isSidebarOpen ? (
                <span className="sidebar-text">Admin Panel</span>
              ) : (
                <span className="sidebar-tooltip text-sm text-white">
                  Admin Panel
                </span>
              )}
            </button>
          )}
          
          <button 
            onClick={handleSignOut}
            className={`sidebar-item ${isSidebarOpen ? 'expanded' : 'collapsed'} group text-red-400 hover:text-red-300 hover:bg-red-500/10`}
          >
            <div className="sidebar-icon">
              <LogOut className="h-5 w-5" />
            </div>
            {isSidebarOpen ? (
              <span className="sidebar-text">Logout</span>
            ) : (
              <span className="sidebar-tooltip text-sm text-white">
                Logout
              </span>
            )}
          </button>
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
        {showAdminPanel && (
          <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50">
            <div className="bg-gray-900 rounded-2xl p-6 max-w-4xl w-full mx-4 border border-white/10">
              <div className="flex items-center justify-between mb-6">
                <h3 className="text-xl font-semibold text-white">Access Request Management</h3>
                <button
                  onClick={() => setShowAdminPanel(false)}
                  className="text-gray-400 hover:text-white transition-colors"
                >
                  <X className="h-5 w-5" />
                </button>
              </div>

              <div className="space-y-4">
                {accessRequests.length === 0 ? (
                  <p className="text-center text-gray-400 py-8">No pending access requests</p>
                ) : (
                  accessRequests.map((request) => (
                    <div 
                      key={request.id} 
                      className="bg-white/5 rounded-xl p-4 border border-white/10"
                    >
                      <div className="flex items-start justify-between">
                        <div>
                          <h4 className="text-white font-medium">{request.name}</h4>
                          <p className="text-sm text-gray-400">{request.email}</p>
                          <p className="text-sm text-gray-300 mt-1">Role: {request.role}</p>
                          <p className="text-sm text-gray-400 mt-2">{request.message}</p>
                          <div className="mt-2 flex items-center gap-2">
                            <span className={`text-xs px-2 py-1 rounded ${
                              request.status === 'pending' ? 'bg-yellow-500/20 text-yellow-300' :
                              request.status === 'approved' ? 'bg-green-500/20 text-green-300' :
                              'bg-red-500/20 text-red-300'
                            }`}>
                              {request.status.charAt(0).toUpperCase() + request.status.slice(1)}
                            </span>
                            <span className="text-xs text-gray-500">
                              {new Date(request.created_at).toLocaleDateString()}
                            </span>
                          </div>
                        </div>
                        {request.status === 'pending' && (
                          <div className="flex gap-2">
                            <button
                              onClick={() => handleRequestStatus(request.id, 'approved')}
                              className="p-2 rounded-lg bg-green-500/10 text-green-400 hover:bg-green-500/20 transition-colors"
                              title="Approve Request"
                            >
                              <CheckCircle className="h-5 w-5" />
                            </button>
                            <button
                              onClick={() => handleRequestStatus(request.id, 'rejected')}
                              className="p-2 rounded-lg bg-red-500/10 text-red-400 hover:bg-red-500/20 transition-colors"
                              title="Reject Request"
                            >
                              <XCircle className="h-5 w-5" />
                            </button>
                          </div>
                        )}
                      </div>
                    </div>
                  ))
                )}
              </div>
            </div>
          </div>
        )}
    </div>
  );
}

export default App;