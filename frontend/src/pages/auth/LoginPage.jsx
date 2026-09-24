import React, { useState, useEffect } from 'react';
import { useNavigate, useSearchParams, Link } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { useToast } from '../../context/ToastContext';
import { Sparkles, User, Briefcase, Lock, Mail, ArrowRight, ShieldCheck } from 'lucide-react';
import Navbar from '../../components/Navbar';

const LoginPage = () => {
  const [searchParams] = useSearchParams();
  const initialRole = searchParams.get('role') || 'student';

  const [activeTab, setActiveTab] = useState(initialRole); // 'student' or 'interviewer'
  const [email, setEmail] = useState(initialRole === 'interviewer' ? 'interviewer@demo.com' : 'student@demo.com');
  const [password, setPassword] = useState('password123');
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  const { login } = useAuth();
  const { showSuccess, showError } = useToast();
  const navigate = useNavigate();

  useEffect(() => {
    if (activeTab === 'student') {
      setEmail('student@demo.com');
      setPassword('password123');
    } else {
      setEmail('interviewer@demo.com');
      setPassword('password123');
    }
    setErrorMessage('');
  }, [activeTab]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!email || !password) {
      setErrorMessage('Please fill in both email and password.');
      return;
    }

    setLoading(true);
    setErrorMessage('');

    try {
      const user = await login(email, password);
      showSuccess(`Welcome back, ${user.name}!`);

      if (user.role === 'interviewer') {
        navigate('/interviewer/dashboard');
      } else {
        navigate('/student/dashboard');
      }
    } catch (err) {
      const detail = err.response?.data?.detail || 'Authentication failed. Please verify credentials.';
      setErrorMessage(detail);
      showError(detail);
    } finally {
      setLoading(false);
    }
  };

  const handleQuickFill = (role) => {
    setActiveTab(role);
    if (role === 'student') {
      setEmail('student@demo.com');
      setPassword('password123');
    } else {
      setEmail('interviewer@demo.com');
      setPassword('password123');
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 flex flex-col">
      <Navbar />

      <div className="flex-1 flex items-center justify-center p-4 sm:p-6 lg:p-8">
        <div className="w-full max-w-md">
          {/* Card Container */}
          <div className="glass-card rounded-2xl border border-slate-800 p-8 shadow-2xl relative overflow-hidden">
            {/* Top decorative gradient */}
            <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-indigo-500 via-purple-500 to-emerald-400" />

            {/* Header */}
            <div className="text-center mb-6">
              <h2 className="text-2xl font-extrabold text-white tracking-tight">
                Sign In to Interview<span className="text-indigo-400">X</span>
              </h2>
              <p className="text-xs text-slate-400 mt-1">
                Access your realistic placement simulation portal
              </p>
            </div>

            {/* Role Switcher Tabs */}
            <div className="flex rounded-xl bg-slate-900/90 p-1 border border-slate-800 mb-6">
              <button
                type="button"
                onClick={() => handleQuickFill('student')}
                className={`flex-1 flex items-center justify-center space-x-2 py-2 text-xs font-semibold rounded-lg transition-all ${
                  activeTab === 'student'
                    ? 'bg-indigo-600 text-white shadow-md'
                    : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                <User className="w-3.5 h-3.5" />
                <span>Student</span>
              </button>
              <button
                type="button"
                onClick={() => handleQuickFill('interviewer')}
                className={`flex-1 flex items-center justify-center space-x-2 py-2 text-xs font-semibold rounded-lg transition-all ${
                  activeTab === 'interviewer'
                    ? 'bg-indigo-600 text-white shadow-md'
                    : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                <Briefcase className="w-3.5 h-3.5" />
                <span>Placement Officer</span>
              </button>
            </div>

            {/* Error Message Alert */}
            {errorMessage && (
              <div className="mb-4 p-3 rounded-xl bg-rose-500/10 border border-rose-500/30 text-rose-300 text-xs font-medium">
                {errorMessage}
              </div>
            )}

            {/* Login Form */}
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">
                  Email Address
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-500">
                    <Mail className="w-4 h-4" />
                  </div>
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    placeholder="name@example.com"
                    className="w-full pl-10 pr-3 py-2.5 bg-slate-900 border border-slate-800 rounded-xl text-sm text-white placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-indigo-500/40 focus:border-indigo-500 transition-all"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">
                  Password
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-500">
                    <Lock className="w-4 h-4" />
                  </div>
                  <input
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                    placeholder="••••••••"
                    className="w-full pl-10 pr-3 py-2.5 bg-slate-900 border border-slate-800 rounded-xl text-sm text-white placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-indigo-500/40 focus:border-indigo-500 transition-all"
                  />
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full mt-2 py-3 px-4 bg-indigo-600 hover:bg-indigo-500 disabled:opacity-50 text-white text-sm font-semibold rounded-xl shadow-lg shadow-indigo-600/30 transition-all flex items-center justify-center space-x-2"
              >
                {loading ? (
                  <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <>
                    <span>Enter {activeTab === 'student' ? 'Student Portal' : 'Interviewer Portal'}</span>
                    <ArrowRight className="w-4 h-4" />
                  </>
                )}
              </button>
            </form>

            {/* Quick Demo Credentials Footer */}
            <div className="mt-6 pt-5 border-t border-slate-800">
              <div className="flex items-center justify-between text-[11px] text-slate-400 mb-2">
                <span className="font-semibold text-slate-300 flex items-center space-x-1">
                  <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
                  <span>Demo Credentials (1-Click Fill):</span>
                </span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-xs">
                <button
                  type="button"
                  onClick={() => handleQuickFill('student')}
                  className={`p-2 rounded-lg border text-left transition-all ${
                    activeTab === 'student'
                      ? 'bg-indigo-950/40 border-indigo-500/40 text-indigo-300'
                      : 'bg-slate-900/60 border-slate-800 text-slate-400 hover:border-slate-700'
                  }`}
                >
                  <div className="font-bold text-slate-200">Student Demo</div>
                  <div className="text-[10px] text-slate-400 truncate">student@demo.com</div>
                </button>

                <button
                  type="button"
                  onClick={() => handleQuickFill('interviewer')}
                  className={`p-2 rounded-lg border text-left transition-all ${
                    activeTab === 'interviewer'
                      ? 'bg-indigo-950/40 border-indigo-500/40 text-indigo-300'
                      : 'bg-slate-900/60 border-slate-800 text-slate-400 hover:border-slate-700'
                  }`}
                >
                  <div className="font-bold text-slate-200">Interviewer Demo</div>
                  <div className="text-[10px] text-slate-400 truncate">interviewer@demo.com</div>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
