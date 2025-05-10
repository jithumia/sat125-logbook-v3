import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
    storageKey: 'sat125-logbook-auth',
    storage: window.localStorage,
    flowType: 'pkce'
  },
  realtime: {
    params: {
      eventsPerSecond: 10
    },
    timeout: 30000, // Increase the timeout for reconnections
    headers: {
      Prefer: 'resolution=merge-duplicates'
    }
  },
  global: {
    fetch: (...args) => {
      return fetch(...args)
        .catch(error => {
          console.error('Network error during Supabase request:', error);
          throw error;
        });
    }
  }
});

// Add reconnection handler for visibility changes
document.addEventListener('visibilitychange', async () => {
  if (document.visibilityState === 'visible') {
    console.log('Tab visible: Checking Supabase connection');
    try {
      // Check if we need to refresh the session
      const { data: { session }, error } = await supabase.auth.getSession();
      if (session && !error) {
        // Just ping to keep the connection alive, don't refresh token unless needed
        console.log('Supabase connection active');
      } else {
        // Only refresh if there's an actual issue
        console.log('Refreshing Supabase connection');
        await supabase.auth.refreshSession();
      }
    } catch (error) {
      console.error('Error refreshing Supabase connection:', error);
    }
  }
});

// Add a global error handler for auth errors
supabase.auth.onAuthStateChange((event, session) => {
  console.log('Auth state changed:', event, session);
  if (event === 'SIGNED_OUT') {
    // Clear any cached data
    window.localStorage.removeItem('sat125-logbook-auth');
  }
});