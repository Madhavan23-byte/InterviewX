import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { useToast } from '../../context/ToastContext';
import api from '../../api/client';
import Navbar from '../../components/Navbar';
import StatusBadge from '../../components/StatusBadge';
import { 
  Building2, Clock, Layers, ArrowRight, Play, CheckCircle2, 
  Award, TrendingUp, Sparkles, GraduationCap, AlertCircle, FileText
} from 'lucide-react';

const StudentDashboard = () => {
  const { user } = useAuth();
  const { showError, showSuccess } = useToast();
  const navigate = useNavigate();

  const [drives, setDrives] = useState([]);
  const [loading, setLoading] = useState(true);
  const [startingDriveId, setStartingDriveId] = useState(null);
  const [activeAttempt, setActiveAttempt] = useState(null);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    setLoading(true);
    try {
      const res = await api.get('/drives');
      setDrives(res.data || []);

      // Check if user has an ongoing or recent attempt
      // Using interviewer results API or drive status
      // We can also query drives
    } catch (err) {
      showError('Unable to load placement drives. Please check backend connection.');
    } finally {
      setLoading(false);
    }
  };

  const handleStartInterview = async (driveId) => {
    setStartingDriveId(driveId);
    try {
      const res = await api.post('/interviews/start', { drive_id: driveId });
      const { attempt_id, is_resumed, current_round } = res.data;
      if (is_resumed) {
        showSuccess(`Resuming your interview in round: ${current_round.toUpperCase()}`);
      } else {
        showSuccess('Starting Mock Placement Drive!');
      }
      navigate(`/interview/${attempt_id}`);
    } catch (err) {
      showError(err.response?.data?.detail || 'Failed to start interview drive');
    } finally {
      setStartingDriveId(null);
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 flex flex-col">
      <Navbar />

      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Welcome Header */}
        <div className="flex flex-col md:flex-row md:items-center md:justify-between pb-8 border-b border-slate-800/80 gap-4">
          <div>
            <div className="inline-flex items-center space-x-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-semibold mb-2">
              <Sparkles className="w-3.5 h-3.5" />
              <span>Campus Placement Season 2026</span>
            </div>
            <h1 className="text-2xl sm:text-3xl font-extrabold text-white tracking-tight">
              Welcome back, {user?.name || 'Candidate'}
            </h1>
            <p className="text-xs sm:text-sm text-slate-400 mt-1 flex items-center space-x-2">
              <GraduationCap className="w-4 h-4 text-indigo-400 shrink-0" />
              <span>{user?.college || 'National Institute of Technology'} — Final Year Recruitment Prep</span>
            </p>
          </div>

          <div className="flex items-center space-x-3">
            <div className="px-4 py-2.5 rounded-xl bg-slate-900 border border-slate-800 text-right">
              <div className="text-[10px] uppercase font-bold text-slate-400 tracking-wider">Placement Readiness</div>
              <div className="text-lg font-black text-emerald-400 flex items-center justify-end space-x-1">
                <span>82%</span>
                <TrendingUp className="w-4 h-4 text-emerald-400" />
              </div>
            </div>
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 my-8">
          <div className="p-5 rounded-2xl glass-card border border-slate-800">
            <div className="text-xs text-slate-400 font-medium">Available Mock Drives</div>
            <div className="text-2xl font-black text-white mt-2">{drives.length}</div>
            <div className="text-[11px] text-indigo-400 mt-1">Tier-1 Corporates</div>
          </div>

          <div className="p-5 rounded-2xl glass-card border border-slate-800">
            <div className="text-xs text-slate-400 font-medium">Interview Rounds</div>
            <div className="text-2xl font-black text-indigo-300 mt-2">3 Rounds</div>
            <div className="text-[11px] text-slate-400 mt-1">Coding → GD → HR</div>
          </div>

          <div className="p-5 rounded-2xl glass-card border border-slate-800">
            <div className="text-xs text-slate-400 font-medium">Average Mock Score</div>
            <div className="text-2xl font-black text-emerald-400 mt-2">81 / 100</div>
            <div className="text-[11px] text-emerald-400/80 mt-1">Top 15% Percentile</div>
          </div>

          <div className="p-5 rounded-2xl glass-card border border-slate-800">
            <div className="text-xs text-slate-400 font-medium">Placement Status</div>
            <div className="text-2xl font-black text-purple-400 mt-2">Eligible</div>
            <div className="text-[11px] text-slate-400 mt-1">Active Candidate</div>
          </div>
        </div>

        {/* Section: Available Mock Placement Drives */}
        <div className="mt-10">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-xl font-bold text-white tracking-tight">Active Placement Drives</h2>
              <p className="text-xs text-slate-400">Select a company drive to begin simulated recruitment rounds</p>
            </div>
          </div>

          {loading ? (
            <div className="py-20 flex flex-col items-center justify-center space-y-4">
              <div className="w-8 h-8 border-4 border-indigo-500/20 border-t-indigo-500 rounded-full animate-spin" />
              <div className="text-xs text-slate-400">Loading mock placement drives...</div>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {drives.map((drive) => {
                const roundCount = (drive.rounds?.coding ? 1 : 0) + (drive.rounds?.gd ? 1 : 0) + (drive.rounds?.hr ? 1 : 0);
                const isStarting = startingDriveId === drive.id;

                return (
                  <div
                    key={drive.id}
                    className="flex flex-col justify-between p-6 rounded-2xl glass-card border border-slate-800 hover:border-indigo-500/40 transition-all shadow-xl group hover:shadow-indigo-500/5 relative"
                  >
                    <div>
                      {/* Top Header */}
                      <div className="flex items-start justify-between">
                        <div className="flex items-center space-x-3">
                          <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-indigo-900/60 to-slate-900 border border-indigo-500/20 flex items-center justify-center font-extrabold text-lg text-indigo-300">
                            {drive.company?.[0]}
                          </div>
                          <div>
                            <h3 className="text-lg font-bold text-white group-hover:text-indigo-300 transition-colors">
                              {drive.company}
                            </h3>
                            <div className="text-xs font-semibold text-slate-300">{drive.role}</div>
                          </div>
                        </div>
                        <StatusBadge type="difficulty" value={drive.difficulty} />
                      </div>

                      {/* Description */}
                      <p className="text-xs text-slate-400 mt-4 line-clamp-3 leading-relaxed">
                        {drive.description}
                      </p>

                      {/* Metadata Chips */}
                      <div className="grid grid-cols-2 gap-2 my-5 text-xs text-slate-300">
                        <div className="flex items-center space-x-2 p-2 rounded-xl bg-slate-900/80 border border-slate-800/80">
                          <Layers className="w-4 h-4 text-indigo-400 shrink-0" />
                          <span>{roundCount} Rounds</span>
                        </div>
                        <div className="flex items-center space-x-2 p-2 rounded-xl bg-slate-900/80 border border-slate-800/80">
                          <Clock className="w-4 h-4 text-amber-400 shrink-0" />
                          <span>{drive.duration_mins} Mins</span>
                        </div>
                      </div>

                      {/* Round Badges */}
                      <div className="flex items-center space-x-1.5 text-[11px] font-medium text-slate-400 mb-6">
                        <span className="text-[10px] uppercase font-bold text-slate-400">Rounds:</span>
                        {drive.rounds?.coding && (
                          <span className="px-2 py-0.5 rounded-md bg-indigo-500/10 text-indigo-300 border border-indigo-500/20">
                            Coding
                          </span>
                        )}
                        {drive.rounds?.gd && (
                          <span className="px-2 py-0.5 rounded-md bg-purple-500/10 text-purple-300 border border-purple-500/20">
                            GD
                          </span>
                        )}
                        {drive.rounds?.hr && (
                          <span className="px-2 py-0.5 rounded-md bg-emerald-500/10 text-emerald-300 border border-emerald-500/20">
                            HR
                          </span>
                        )}
                      </div>
                    </div>

                    {/* Start CTA */}
                    <button
                      onClick={() => handleStartInterview(drive.id)}
                      disabled={isStarting}
                      className="w-full py-3 px-4 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-xs tracking-wide transition-all shadow-md shadow-indigo-600/20 flex items-center justify-center space-x-2 disabled:opacity-50"
                    >
                      {isStarting ? (
                        <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                      ) : (
                        <>
                          <Play className="w-3.5 h-3.5 fill-current" />
                          <span>Start Mock Interview</span>
                        </>
                      )}
                    </button>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Demo Candidate Quick Report Access */}
        <div className="mt-14 p-6 rounded-2xl glass-card border border-slate-800 flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center space-x-4">
            <div className="w-12 h-12 rounded-xl bg-emerald-500/10 border border-emerald-500/25 flex items-center justify-center text-emerald-400 shrink-0">
              <Award className="w-6 h-6" />
            </div>
            <div>
              <div className="text-sm font-bold text-white">Sample Completed Evaluation Report</div>
              <div className="text-xs text-slate-400 mt-0.5">
                Inspect a finished 3-round interview report with weighted score analytics and AI recommendations
              </div>
            </div>
          </div>
          <button
            onClick={() => navigate('/results/attempt-arun-tcs')}
            className="w-full sm:w-auto px-5 py-2.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 font-semibold text-xs transition-colors flex items-center justify-center space-x-2 shrink-0"
          >
            <FileText className="w-4 h-4 text-emerald-400" />
            <span>View Detailed Report</span>
          </button>
        </div>
      </main>
    </div>
  );
};

export default StudentDashboard;
