import { List, LayoutDashboard, AlertTriangle, ClipboardList, RefreshCw, Settings } from 'lucide-react';

const navigation = [
  { name: 'All Logs', href: '/logs', icon: List },
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Downtime', href: '/downtime', icon: AlertTriangle },
  { name: 'Work Orders', href: '/workorders', icon: ClipboardList },
  { name: 'Source Changes', href: '/source-changes', icon: RefreshCw },
  { name: 'Main Coil Tuning', href: '/main-coil-tuning', icon: Settings },
]; 