import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { Briefcase, LogOut, Sparkles, User, ShieldCheck } from 'lucide-react';

const Navbar = () => {
  const { user, isAuthenticated, isInterviewer, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <header className="sticky top-0 z-40 w-full glass-card border-b border-slate-800/80 bg-slate-950/80 backdrop-blur-md">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
        {/* Brand Logo */}
        <Link to={isAuthenticated ? (isInterviewer ? '/interviewer/dashboard' : '/student/dashboard') : '/'} className="flex items-center space-x-3 group">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 via-indigo-500 to-emerald-400 p-[2px] transition-transform group-hover:scale-105 shadow-lg shadow-indigo-500/20">
            <div className="w-full h-full bg-slate-950 rounded-[10px] flex items-center justify-center">
              <Sparkles className="w-5 h-5 text-indigo-400" />
            </div>
          </div>
          <div>
            <div className="flex items-center space-x-2">
              <span className="font-extrabold text-xl tracking-tight text-white group-hover:text-indigo-300 transition-colors">
                Interview<span className="text-indigo-400">X</span>
              </span>
              <span className="text-[10px] uppercase font-bold tracking-wider px-2 py-0.5 rounded-full bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
                AI Placement
              </span>
            </div>
          </div>
        </Link>

        {/* Center / Navigation Links */}
        <div className="hidden md:flex items-center space-x-6 text-sm font-medium">
          {isAuthenticated ? (
            <>
              {isInterviewer ? (
                <>
                  <Link to="/interviewer/dashboard" className="text-slate-300 hover:text-white transition-colors">
                    Drives & Analytics
                  </Link>
                </>
              ) : (
                <>
                  <Link to="/student/dashboard" className="text-slate-300 hover:text-white transition-colors">
                    Available Drives
                  </Link>
                </>
              )}
            </>
          ) : (
            <>
              <a href="#features" className="text-slate-400 hover:text-slate-200 transition-colors">How It Works</a>
              <a href="#rounds" className="text-slate-400 hover:text-slate-200 transition-colors">Interview Rounds</a>
              <a href="#evaluation" className="text-slate-400 hover:text-slate-200 transition-colors">AI Evaluation</a>
            </>
          )}
        </div>

        {/* User / Auth CTA */}
        <div className="flex items-center space-x-4">
          {isAuthenticated ? (
            <div className="flex items-center space-x-3">
              <div className="flex items-center space-x-2.5 px-3 py-1.5 rounded-xl bg-slate-900 border border-slate-800">
                {user?.avatar ? (
                  <img src={user.avatar} alt={user.name} className="w-7 h-7 rounded-full bg-slate-800" />
                ) : (
                  <div className="w-7 h-7 rounded-full bg-indigo-500/20 text-indigo-400 flex items-center justify-center font-bold text-xs">
                    {user?.name?.[0] || 'U'}
                  </div>
                )}
                <div className="text-left hidden sm:block">
                  <div className="text-xs font-semibold text-slate-200 leading-tight">{user?.name}</div>
                  <div className="text-[10px] uppercase font-semibold text-indigo-400 tracking-wider">
                    {user?.role}
                  </div>
                </div>
              </div>

              <button
                onClick={handleLogout}
                title="Sign Out"
                className="p-2 rounded-xl text-slate-400 hover:text-rose-400 hover:bg-slate-900 border border-transparent hover:border-slate-800 transition-all"
              >
                <LogOut className="w-4 h-4" />
              </button>
            </div>
          ) : (
            <div className="flex items-center space-x-3">
              <Link
                to="/login"
                className="text-xs font-medium text-slate-300 hover:text-white px-3 py-2 transition-colors"
              >
                Sign In
              </Link>
              <Link
                to="/login"
                className="text-xs font-semibold px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white transition-all shadow-md shadow-indigo-600/30 flex items-center space-x-1.5"
              >
                <span>Demo Access</span>
              </Link>
            </div>
          )}
        </div>
      </div>
    </header>
  );
};

export default Navbar;
