import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import { ToastProvider } from './context/ToastContext';

// Components
import ProtectedRoute from './components/ProtectedRoute';

// Pages
import LandingPage from './pages/LandingPage';
import LoginPage from './pages/auth/LoginPage';
import StudentDashboard from './pages/student/StudentDashboard';
import InterviewRoom from './pages/interview/InterviewRoom';
import ResultReportPage from './pages/interview/ResultReportPage';
import InterviewerDashboard from './pages/interviewer/InterviewerDashboard';

function App() {
  return (
    <Router>
      <ToastProvider>
        <AuthProvider>
          <Routes>
            {/* Public Routes */}
            <Route path="/" element={<LandingPage />} />
            <Route path="/login" element={<LoginPage />} />

            {/* Student Protected Routes */}
            <Route
              path="/student/dashboard"
              element={
                <ProtectedRoute allowedRoles={['student']}>
                  <StudentDashboard />
                </ProtectedRoute>
              }
            />
            <Route
              path="/interview/:attemptId"
              element={
                <ProtectedRoute allowedRoles={['student']}>
                  <InterviewRoom />
                </ProtectedRoute>
              }
            />

            {/* Result Report (Viewable by Student and Interviewer) */}
            <Route
              path="/results/:attemptId"
              element={
                <ProtectedRoute>
                  <ResultReportPage />
                </ProtectedRoute>
              }
            />

            {/* Interviewer / Placement Officer Protected Routes */}
            <Route
              path="/interviewer/dashboard"
              element={
                <ProtectedRoute allowedRoles={['interviewer']}>
                  <InterviewerDashboard />
                </ProtectedRoute>
              }
            />

            {/* Fallback */}
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </AuthProvider>
      </ToastProvider>
    </Router>
  );
}

export default App;
