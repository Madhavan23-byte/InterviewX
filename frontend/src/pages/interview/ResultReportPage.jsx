import React, { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import confetti from 'canvas-confetti';
import api from '../../api/client';
import { useToast } from '../../context/ToastContext';
import Navbar from '../../components/Navbar';
import { 
  Award, CheckCircle2, AlertCircle, ArrowLeft, Printer, 
  Code2, Users2, UserCheck, TrendingUp, Sparkles, Compass, 
  Building2, GraduationCap, Share2
} from 'lucide-react';

const ResultReportPage = () => {
  const { attemptId } = useParams();
  const navigate = useNavigate();
  const { showError, showSuccess } = useToast();

  const [report, setReport] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchReport();
  }, [attemptId]);

  const fetchReport = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/results/${attemptId}`);
      setReport(res.data);

      // Trigger celebratory confetti if score is high
      if (res.data.overall_score >= 70) {
        confetti({
          particleCount: 80,
          spread: 70,
          origin: { y: 0.6 }
        });
      }
    } catch (err) {
      showError(err.response?.data?.detail || 'Failed to fetch interview report');
    } finally {
      setLoading(false);
    }
  };

  const handlePrint = () => {
    window.print();
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-950 flex flex-col">
        <Navbar />
        <div className="flex-1 flex flex-col items-center justify-center space-y-4">
          <div className="w-10 h-10 border-4 border-indigo-500/20 border-t-indigo-500 rounded-full animate-spin" />
          <div className="text-slate-400 text-sm font-medium">Synthesizing placement performance report...</div>
        </div>
      </div>
    );
  }

  if (!report) {
    return (
      <div className="min-h-screen bg-slate-950 flex flex-col">
        <Navbar />
        <div className="flex-1 flex flex-col items-center justify-center p-6 text-center">
          <AlertCircle className="w-12 h-12 text-rose-400 mb-3" />
          <h2 className="text-xl font-bold text-white">Report Not Found</h2>
          <p className="text-xs text-slate-400 mt-1">Could not find results for this attempt ID.</p>
          <Link
            to="/student/dashboard"
            className="mt-4 px-4 py-2 bg-slate-800 text-white rounded-xl text-xs font-semibold"
          >
            Back to Dashboard
          </Link>
        </div>
      </div>
    );
  }

  const { overall_score, round_scores, candidate, drive, weighting } = report;

  const getReadinessLevel = (score) => {
    if (score >= 80) return { label: 'Placement Ready — Highly Recommended', color: 'text-emerald-400', bg: 'bg-emerald-500/10 border-emerald-500/30' };
    if (score >= 65) return { label: 'Good Potential — Focused Practice Recommended', color: 'text-indigo-400', bg: 'bg-indigo-500/10 border-indigo-500/30' };
    return { label: 'Developing — Comprehensive Revision Required', color: 'text-amber-400', bg: 'bg-amber-500/10 border-amber-500/30' };
  };

  const readiness = getReadinessLevel(overall_score);

  return (
    <div className="min-h-screen bg-slate-950 flex flex-col print:bg-white print:text-black">
      <div className="print:hidden">
        <Navbar />
      </div>

      <main className="flex-1 max-w-5xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Top Actions Bar (Hidden when printing) */}
        <div className="flex items-center justify-between pb-6 border-b border-slate-800 print:hidden">
          <button
            onClick={() => navigate('/student/dashboard')}
            className="flex items-center space-x-2 text-xs font-semibold text-slate-400 hover:text-white transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Dashboard</span>
          </button>

          <div className="flex items-center space-x-3">
            <button
              onClick={handlePrint}
              className="flex items-center space-x-1.5 px-3.5 py-1.5 rounded-xl bg-slate-900 border border-slate-800 text-slate-300 hover:text-white text-xs font-semibold transition-colors"
            >
              <Printer className="w-4 h-4" />
              <span>Print / Download PDF</span>
            </button>
          </div>
        </div>

        {/* Hero Report Header Card */}
        <div className="mt-6 p-8 rounded-3xl glass-card border border-slate-800 shadow-2xl relative overflow-hidden print:border print:border-gray-300 print:shadow-none">
          <div className="flex flex-col md:flex-row items-center justify-between gap-6">
            <div>
              <div className={`inline-flex items-center space-x-1.5 px-3 py-1 rounded-full border text-xs font-bold mb-3 ${readiness.bg} ${readiness.color}`}>
                <Sparkles className="w-3.5 h-3.5" />
                <span>{readiness.label}</span>
              </div>
              <h1 className="text-3xl sm:text-4xl font-black text-white tracking-tight print:text-black">
                Placement Performance Report
              </h1>
              <p className="text-sm text-slate-400 mt-1 print:text-gray-600">
                Evaluation for <strong className="text-slate-200 print:text-black">{drive?.company}</strong> — {drive?.role}
              </p>

              {/* Candidate Info */}
              <div className="mt-4 flex flex-wrap items-center gap-4 text-xs text-slate-300 print:text-gray-700">
                <span className="flex items-center space-x-1.5">
                  <strong className="text-slate-400">Candidate:</strong>
                  <span>{candidate?.name}</span>
                </span>
                <span className="text-slate-600">•</span>
                <span className="flex items-center space-x-1.5">
                  <GraduationCap className="w-4 h-4 text-indigo-400" />
                  <span>{candidate?.college}</span>
                </span>
              </div>
            </div>

            {/* Overall Score Dial */}
            <div className="flex flex-col items-center justify-center p-6 rounded-2xl bg-slate-900/90 border border-slate-800 text-center min-w-[180px] print:bg-gray-100">
              <div className="text-[11px] uppercase font-bold text-slate-400 tracking-wider">
                Overall Mock Score
              </div>
              <div className="text-5xl font-black text-emerald-400 mt-1 print:text-black">
                {overall_score}
                <span className="text-base text-slate-400 font-normal">/100</span>
              </div>
              <div className="text-[10px] text-slate-400 mt-2">
                Weighted Cumulative
              </div>
            </div>
          </div>
        </div>

        {/* 3 Rounds Breakdown Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 my-8">
          {/* Round 1: Coding */}
          <div className="p-6 rounded-2xl glass-card border border-slate-800">
            <div className="flex items-center justify-between mb-4">
              <div className="w-10 h-10 rounded-xl bg-indigo-500/10 border border-indigo-500/25 flex items-center justify-center text-indigo-400">
                <Code2 className="w-5 h-5" />
              </div>
              <span className="text-[11px] font-bold text-slate-400">Weight: 40%</span>
            </div>
            <div className="text-xs uppercase font-bold text-indigo-400 tracking-wider">Round 01</div>
            <h3 className="text-lg font-bold text-white mt-0.5 print:text-black">Coding & DSA</h3>
            <div className="text-3xl font-black text-white mt-3 print:text-black">
              {round_scores?.coding ?? 80}
              <span className="text-xs text-slate-400 font-normal"> / 100</span>
            </div>
            <div className="mt-4 pt-3 border-t border-slate-800/80 text-[11px] text-slate-400">
              Assessed via automated unit test runner against predefined edge inputs.
            </div>
          </div>

          {/* Round 2: GD */}
          <div className="p-6 rounded-2xl glass-card border border-slate-800">
            <div className="flex items-center justify-between mb-4">
              <div className="w-10 h-10 rounded-xl bg-purple-500/10 border border-purple-500/25 flex items-center justify-center text-purple-400">
                <Users2 className="w-5 h-5" />
              </div>
              <span className="text-[11px] font-bold text-slate-400">Weight: 25%</span>
            </div>
            <div className="text-xs uppercase font-bold text-purple-400 tracking-wider">Round 02</div>
            <h3 className="text-lg font-bold text-white mt-0.5 print:text-black">Group Discussion</h3>
            <div className="text-3xl font-black text-white mt-3 print:text-black">
              {round_scores?.gd ?? 75}
              <span className="text-xs text-slate-400 font-normal"> / 100</span>
            </div>
            <div className="mt-4 pt-3 border-t border-slate-800/80 text-[11px] text-slate-400">
              Evaluated on clarity, topical relevance, argumentation, and critical thinking.
            </div>
          </div>

          {/* Round 3: HR */}
          <div className="p-6 rounded-2xl glass-card border border-slate-800">
            <div className="flex items-center justify-between mb-4">
              <div className="w-10 h-10 rounded-xl bg-emerald-500/10 border border-emerald-500/25 flex items-center justify-center text-emerald-400">
                <UserCheck className="w-5 h-5" />
              </div>
              <span className="text-[11px] font-bold text-slate-400">Weight: 35%</span>
            </div>
            <div className="text-xs uppercase font-bold text-emerald-400 tracking-wider">Round 03</div>
            <h3 className="text-lg font-bold text-white mt-0.5 print:text-black">HR & Behavioral</h3>
            <div className="text-3xl font-black text-white mt-3 print:text-black">
              {round_scores?.hr ?? 78}
              <span className="text-xs text-slate-400 font-normal"> / 100</span>
            </div>
            <div className="mt-4 pt-3 border-t border-slate-800/80 text-[11px] text-slate-400">
              Assessed on professional narrative structure, STAR method, and alignment.
            </div>
          </div>
        </div>

        {/* Strengths & Areas for Improvement Split */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 my-8">
          {/* Key Strengths */}
          <div className="p-6 rounded-2xl glass-card border border-slate-800 space-y-4">
            <div className="flex items-center space-x-2 text-emerald-400">
              <CheckCircle2 className="w-5 h-5" />
              <h3 className="text-base font-bold text-white print:text-black">Key Evaluated Strengths</h3>
            </div>
            <ul className="space-y-2.5 text-xs text-slate-300 print:text-gray-800">
              {report.strengths?.map((st, i) => (
                <li key={i} className="flex items-start space-x-2">
                  <span className="text-emerald-400 font-bold shrink-0">✓</span>
                  <span>{st}</span>
                </li>
              ))}
            </ul>
          </div>

          {/* Actionable Improvements */}
          <div className="p-6 rounded-2xl glass-card border border-slate-800 space-y-4">
            <div className="flex items-center space-x-2 text-amber-400">
              <AlertCircle className="w-5 h-5" />
              <h3 className="text-base font-bold text-white print:text-black">Areas for Improvement</h3>
            </div>
            <ul className="space-y-2.5 text-xs text-slate-300 print:text-gray-800">
              {report.areas_for_improvement?.map((imp, i) => (
                <li key={i} className="flex items-start space-x-2">
                  <span className="text-amber-400 font-bold shrink-0">→</span>
                  <span>{imp}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* Recommended Practice Areas */}
        <div className="p-6 rounded-2xl glass-card border border-slate-800 space-y-4">
          <div className="flex items-center space-x-2 text-indigo-400">
            <Compass className="w-5 h-5" />
            <h3 className="text-base font-bold text-white print:text-black">Recommended Practice Areas</h3>
          </div>
          <p className="text-xs text-slate-400">
            Targeted syllabus modules to strengthen before upcoming company drives:
          </p>
          <div className="flex flex-wrap gap-2.5">
            {report.recommended_practice_areas?.map((area, i) => (
              <span
                key={i}
                className="px-3 py-1.5 rounded-xl bg-slate-900 border border-slate-800 text-xs font-semibold text-indigo-300 print:bg-gray-100 print:text-black"
              >
                {area}
              </span>
            ))}
          </div>
        </div>

        {/* Completion Disclaimer */}
        <div className="mt-8 text-center text-xs text-slate-400 print:text-gray-500">
          Interview Completed on {new Date(report.completed_at || Date.now()).toLocaleDateString()} • Generated by InterviewX AI Mock Placement Platform
        </div>
      </main>
    </div>
  );
};

export default ResultReportPage;
