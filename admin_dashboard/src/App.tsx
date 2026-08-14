import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { AdminLayout } from './components/AdminLayout';
import { Dashboard } from './pages/Dashboard';
import { Users } from './pages/Users';
import { Workers } from './pages/Workers';
import { Jobs } from './pages/Jobs';
import { Payments } from './pages/Payments';
import { Categories } from './pages/Categories';
import { Notifications } from './pages/Notifications';
import { Disputes } from './pages/Disputes';
import { SupportTickets } from './pages/SupportTickets';
import { Analytics } from './pages/Analytics';
import { Settings } from './pages/Settings';

function App() {
  return (
    <Routes>
      <Route path="/" element={<AdminLayout />}>
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<Dashboard />} />
        <Route path="users" element={<Users />} />
        <Route path="workers" element={<Workers />} />
        <Route path="jobs" element={<Jobs />} />
        <Route path="payments" element={<Payments />} />
        <Route path="categories" element={<Categories />} />
        <Route path="notifications" element={<Notifications />} />
        <Route path="disputes" element={<Disputes />} />
        <Route path="support" element={<SupportTickets />} />
        <Route path="analytics" element={<Analytics />} />
        <Route path="settings" element={<Settings />} />
      </Route>
    </Routes>
  );
}

export default App;