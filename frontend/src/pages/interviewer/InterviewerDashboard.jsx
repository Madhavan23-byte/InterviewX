import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { useToast } from '../../context/ToastContext';
import api from '../../api/client';
import Navbar from '../../components/Navbar';
import StatusBadge from '../../components/StatusBadge';
import CreateDriveModal from './CreateDriveModal';
import { 
  Building2, Users2, Award, TrendingUp, Plus, Eye, 
  ToggleLeft, ToggleRight, CheckCircle2, Clock, BarChart3, 
  ExternalLink, Search, RefreshCw, FileText, CheckCircle
} from 'lucide-react';

const InterviewerDashboard = () => {
  const { user } = useAuth();
  const { showError, showSuccess } = useToast();
  const navigate = useNavigate();

  const [drives, setDrives] = useState([]);
  const [candidates, setCandidates] = useState([]);
  const [analytics, setAnalytics] = useState(null);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [candidateSearch, setCandidateSearch] = useState('');

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    setLoading(true);
    try {
      const [drivesRes, resultsRes, analyticsRes] = await Promise.all([
        api.get('/drives'),
        api.get('/interviewer/results'),
        api.get('/interviewer/analytics')
      ]);

      setDrives(drivesRes.data || []);
      setCandidates(resultsRes.data || []);
      setAnalytics(analyticsRes.data || null);
    } catch (err) {
      showError('Failed to fetch placement officer analytics');
    } finally {
      setLoading(false);
    }
  };

  const handleToggleDriveStatus = async (driveId, currentStatus) => {
    const newStatus = currentStatus === 'active' ? 'inactive' : 'active';
    try {
      await api.put(`/drives/${driveId}`, { status: newStatus });
      showSuccess(`Drive marked as ${newStatus}`);
      fetchDashboardData();
    } catch (err) {
      showError('Failed to update drive status');
    }
  };

  const filteredCandidates = candidates.filter((c) => {
    const term = candidateSearch.toLowerCase();
    return (
      c.candidate_name?.toLowerCase().includes(term) ||
      c.candidate_email?.toLowerCase().includes(term) ||
      c.company?.toLowerCase().includes(term)
    );
  });

  return (
    <div className="min-h-screen bg-slate-950 flex flex-col">
      <Navbar />

      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8">
        {/* Header with Title and Create Action */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-6 border-b border-slate-800">
          <div>
            <div className="text-xs uppercase font-bold text-indigo-400 tracking-wider">
              Placement Cell & Corporate Recruitment Oversight
            </div>
            <h1 className="text-2xl sm:text-3xl font-extrabold text-white tracking-tight mt-1">
              Placement Officer Dashboard
            </h1>
            <p className="text-xs sm:text-sm text-slate-400 mt-1">
              Supervising candidate performance across mock drives, round progress, and cohort readiness
            </p>
          </div>

          <div className="flex items-center space-x-3">
            <button
              onClick={() => setIsModalOpen(true)}
              className="px-4 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-xs tracking-wide transition-all shadow-lg shadow-indigo-600/30 flex items-center space-x-2"
            >
              <Plus className="w-4 h-4" />
              <span>Create Mock Drive</span>
            </button>
          </div>
        </div>

        {/* 4 Stats Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="p-5 rounded-2xl glass-card border border-slate-800">
            <div className="text-xs text-slate-400 font-medium">Total Registered Candidates</div>
            <div className="text-2xl font-black text-white mt-1">
              {analytics?.total_candidates ?? candidates.length}
            </div>
            <div className="text-[11px] text-indigo-400 mt-1">Active Batch 2026</div>
          </div>

          <div className="p-5 rounded-2xl glass-card border border-slate-800">
            <div className="text-xs text-slate-400 font-medium">Active Mock Drives</div>
            <div className="text-2xl font-black text-indigo-400 mt-1">
              {analytics?.active_drives ?? drives.length}
            </div>
            <div className="text-[11px] text-slate-400 mt-1">Ready for simulation</div>
          </div>

          <div className="p-5 rounded-2xl glass-card border border-slate-800">
            <div className="text-xs text-slate-400 font-medium">Completed Interviews</div>
            <div className="text-2xl font-black text-emerald-400 mt-1">
              {analytics?.completed_interviews ?? 1}
            </div>
            <div className="text-[11px] text-emerald-400/80 mt-1">
              {analytics?.completion_rate ?? 67}% completion rate
            </div>
          </div>

          <div className="p-5 rounded-2xl glass-card border border-slate-800">
            <div className="text-xs text-slate-400 font-medium">Cohort Average Score</div>
            <div className="text-2xl font-black text-purple-400 mt-1">
              {analytics?.average_score ?? 81}
              <span className="text-xs text-slate-400 font-normal"> / 100</span>
            </div>
            <div className="text-[11px] text-purple-300 mt-1">Highest: {analytics?.highest_score ?? 85}</div>
          </div>
        </div>

        {/* Round Performance Breakdown Cards */}
        {analytics?.round_averages && (
          <div className="p-6 rounded-2xl glass-card border border-slate-800">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-300 mb-4 flex items-center space-x-2">
              <BarChart3 className="w-4 h-4 text-indigo-400" />
              <span>Round-Wise Performance Analytics</span>
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="p-4 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between">
                <div>
                  <div className="text-xs text-slate-400">Coding DSA (Round 1)</div>
                  <div className="text-xl font-bold text-indigo-300 mt-1">
                    {analytics.round_averages.coding}%
                  </div>
                </div>
                <div className="w-12 h-2 rounded-full bg-slate-800 overflow-hidden">
                  <div className="h-full bg-indigo-500" style={{ width: `${analytics.round_averages.coding}%` }} />
                </div>
              </div>

              <div className="p-4 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between">
                <div>
                  <div className="text-xs text-slate-400">Group Discussion (Round 2)</div>
                  <div className="text-xl font-bold text-purple-300 mt-1">
                    {analytics.round_averages.gd}%
                  </div>
                </div>
                <div className="w-12 h-2 rounded-full bg-slate-800 overflow-hidden">
                  <div className="h-full bg-purple-500" style={{ width: `${analytics.round_averages.gd}%` }} />
                </div>
              </div>

              <div className="p-4 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between">
                <div>
                  <div className="text-xs text-slate-400">HR Interview (Round 3)</div>
                  <div className="text-xl font-bold text-emerald-300 mt-1">
                    {analytics.round_averages.hr}%
                  </div>
                </div>
                <div className="w-12 h-2 rounded-full bg-slate-800 overflow-hidden">
                  <div className="h-full bg-emerald-500" style={{ width: `${analytics.round_averages.hr}%` }} />
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Section: Mock Placement Drives Table */}
        <div className="p-6 rounded-2xl glass-card border border-slate-800 space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-base font-bold text-white tracking-tight">Mock Placement Drives</h2>
              <p className="text-xs text-slate-400">Manage company configurations, rounds, and candidate access</p>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-slate-900/90 text-slate-400 uppercase font-bold text-[10px] tracking-wider border-b border-slate-800">
                <tr>
                  <th className="py-3 px-4">Company</th>
                  <th className="py-3 px-4">Role</th>
                  <th className="py-3 px-4">Difficulty</th>
                  <th className="py-3 px-4">Rounds</th>
                  <th className="py-3 px-4">Candidates</th>
                  <th className="py-3 px-4">Status</th>
                  <th className="py-3 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800/80 text-slate-300">
                {drives.map((d) => (
                  <tr key={d.id} className="hover:bg-slate-900/50 transition-colors">
                    <td className="py-3.5 px-4 font-bold text-white flex items-center space-x-2">
                      <div className="w-7 h-7 rounded-lg bg-indigo-600/20 text-indigo-400 flex items-center justify-center font-bold text-xs">
                        {d.company[0]}
                      </div>
                      <span>{d.company}</span>
                    </td>
                    <td className="py-3.5 px-4 text-slate-200">{d.role}</td>
                    <td className="py-3.5 px-4">
                      <StatusBadge type="difficulty" value={d.difficulty} />
                    </td>
                    <td className="py-3.5 px-4 font-mono text-[11px]">
                      {d.rounds?.coding && 'Coding '}{d.rounds?.gd && 'GD '}{d.rounds?.hr && 'HR'}
                    </td>
                    <td className="py-3.5 px-4">{d.candidates_count} students</td>
                    <td className="py-3.5 px-4">
                      <StatusBadge type="status" value={d.status} />
                    </td>
                    <td className="py-3.5 px-4 text-right space-x-2">
                      <button
                        onClick={() => handleToggleDriveStatus(d.id, d.status)}
                        className="p-1 rounded-lg hover:bg-slate-800 text-slate-400 hover:text-white transition-colors"
                        title={d.status === 'active' ? 'Deactivate Drive' : 'Activate Drive'}
                      >
                        {d.status === 'active' ? (
                          <ToggleRight className="w-4 h-4 text-emerald-400" />
                        ) : (
                          <ToggleLeft className="w-4 h-4 text-slate-500" />
                        )}
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Section: Candidate Monitoring Table */}
        <div className="p-6 rounded-2xl glass-card border border-slate-800 space-y-4">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
            <div>
              <h2 className="text-base font-bold text-white tracking-tight">Candidate Placement Monitoring</h2>
              <p className="text-xs text-slate-400">Track candidate progression across recruitment rounds in real-time</p>
            </div>

            <div className="relative w-full sm:w-64">
              <Search className="w-4 h-4 text-slate-500 absolute left-3 top-2.5" />
              <input
                type="text"
                value={candidateSearch}
                onChange={(e) => setCandidateSearch(e.target.value)}
                placeholder="Search candidates or company..."
                className="w-full pl-9 pr-3 py-1.5 bg-slate-900 border border-slate-800 rounded-xl text-xs text-white placeholder-slate-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              />
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-slate-900/90 text-slate-400 uppercase font-bold text-[10px] tracking-wider border-b border-slate-800">
                <tr>
                  <th className="py-3 px-4">Candidate</th>
                  <th className="py-3 px-4">Drive</th>
                  <th className="py-3 px-4">Current Round</th>
                  <th className="py-3 px-4">Status</th>
                  <th className="py-3 px-4">Overall Score</th>
                  <th className="py-3 px-4">Progress</th>
                  <th className="py-3 px-4 text-right">Detailed Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800/80 text-slate-300">
                {filteredCandidates.map((c) => (
                  <tr key={c.attempt_id} className="hover:bg-slate-900/50 transition-colors">
                    <td className="py-3.5 px-4">
                      <div className="flex items-center space-x-2.5">
                        <img
                          src={c.avatar || `https://api.dicebear.com/7.x/avataaars/svg?seed=${c.candidate_name}`}
                          alt={c.candidate_name}
                          className="w-7 h-7 rounded-full bg-slate-800"
                        />
                        <div>
                          <div className="font-bold text-white">{c.candidate_name}</div>
                          <div className="text-[10px] text-slate-400">{c.college}</div>
                        </div>
                      </div>
                    </td>
                    <td className="py-3.5 px-4">
                      <div className="font-semibold text-slate-200">{c.company}</div>
                      <div className="text-[10px] text-slate-400">{c.role}</div>
                    </td>
                    <td className="py-3.5 px-4 uppercase font-bold text-indigo-400 text-[11px]">
                      {c.current_round}
                    </td>
                    <td className="py-3.5 px-4">
                      <StatusBadge type="status" value={c.status} />
                    </td>
                    <td className="py-3.5 px-4">
                      {c.score !== null && c.score !== undefined ? (
                        <span className="font-black text-emerald-400 text-sm">{c.score} / 100</span>
                      ) : (
                        <span className="text-slate-500 font-mono">Pending</span>
                      )}
                    </td>
                    <td className="py-3.5 px-4">
                      <div className="flex items-center space-x-2">
                        <div className="w-16 h-1.5 rounded-full bg-slate-800 overflow-hidden">
                          <div
                            className="h-full bg-emerald-500"
                            style={{ width: `${c.progress_percentage}%` }}
                          />
                        </div>
                        <span className="text-[11px] font-mono">{c.progress_percentage}%</span>
                      </div>
                    </td>
                    <td className="py-3.5 px-4 text-right">
                      <button
                        onClick={() => navigate(`/results/${c.attempt_id}`)}
                        className="inline-flex items-center space-x-1.5 px-3 py-1.5 rounded-lg bg-indigo-600/20 hover:bg-indigo-600/30 text-indigo-300 font-semibold border border-indigo-500/30 transition-colors"
                      >
                        <FileText className="w-3.5 h-3.5" />
                        <span>View Report</span>
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Modal */}
        <CreateDriveModal
          isOpen={isModalOpen}
          onClose={() => setIsModalOpen(false)}
          onCreated={fetchDashboardData}
        />
      </main>
    </div>
  );
};

export default InterviewerDashboard;
