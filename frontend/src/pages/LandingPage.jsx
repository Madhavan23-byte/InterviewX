import React from 'react';
import { Link } from 'react-router-dom';
import { 
  Sparkles, Code2, Users2, UserCheck, BarChart3, 
  ArrowRight, ShieldCheck, CheckCircle2, ChevronRight,
  GraduationCap, Award, Compass, Layers
} from 'lucide-react';
import Navbar from '../components/Navbar';

const LandingPage = () => {
  return (
    <div className="min-h-screen bg-slate-950 flex flex-col selection:bg-indigo-500 selection:text-white">
      <Navbar />

      {/* Hero Section */}
      <section className="relative overflow-hidden pt-20 pb-28 md:pt-32 md:pb-36 border-b border-slate-900">
        {/* Glow ambient gradients */}
        <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[350px] bg-indigo-600/15 rounded-full blur-[140px] pointer-events-none" />
        <div className="absolute top-1/3 left-1/3 w-[300px] h-[250px] bg-emerald-500/10 rounded-full blur-[100px] pointer-events-none" />

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 text-center">
          {/* Badge */}
          <div className="inline-flex items-center space-x-2 px-3.5 py-1.5 rounded-full bg-indigo-500/10 border border-indigo-500/25 text-indigo-300 text-xs font-semibold mb-8 animate-in fade-in slide-in-from-bottom-2">
            <Sparkles className="w-3.5 h-3.5 text-indigo-400" />
            <span>AI-Powered Campus Recruitment Simulation 2026</span>
          </div>

          {/* Heading */}
          <h1 className="text-4xl sm:text-6xl md:text-7xl font-extrabold tracking-tight text-white max-w-4xl mx-auto leading-[1.1]">
            Practice the complete interview journey <br />
            <span className="bg-gradient-to-r from-indigo-400 via-indigo-200 to-emerald-400 bg-clip-text text-transparent">
              before the real one.
            </span>
          </h1>

          {/* Subtitle */}
          <p className="mt-6 text-lg sm:text-xl text-slate-300 max-w-2xl mx-auto font-normal leading-relaxed">
            InterviewX provides realistic recruitment drive simulations for college students:
            from algorithmic coding tests, to simulated peer group discussions, to AI-evaluated HR panel rounds.
          </p>

          {/* CTAs */}
          <div className="mt-10 flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link
              to="/login?role=student"
              className="w-full sm:w-auto px-8 py-3.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-base transition-all shadow-xl shadow-indigo-600/25 flex items-center justify-center space-x-2 group"
            >
              <span>Start Practicing Now</span>
              <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
            </Link>
            <Link
              to="/login?role=interviewer"
              className="w-full sm:w-auto px-8 py-3.5 rounded-xl bg-slate-900 hover:bg-slate-850 text-slate-200 border border-slate-800 font-semibold text-base transition-all flex items-center justify-center space-x-2"
            >
              <GraduationCap className="w-4 h-4 text-emerald-400" />
              <span>For Colleges & Placement Officers</span>
            </Link>
          </div>

          {/* Stepper Preview Pill */}
          <div className="mt-16 max-w-2xl mx-auto p-3 rounded-2xl glass-card border border-slate-800/80 shadow-2xl flex items-center justify-between text-xs sm:text-sm font-medium">
            <div className="flex items-center space-x-2 text-emerald-400">
              <CheckCircle2 className="w-4 h-4" />
              <span>1. Coding</span>
            </div>
            <span className="text-slate-600">→</span>
            <div className="flex items-center space-x-2 text-indigo-400">
              <Users2 className="w-4 h-4" />
              <span>2. Group Discussion</span>
            </div>
            <span className="text-slate-600">→</span>
            <div className="flex items-center space-x-2 text-indigo-400">
              <UserCheck className="w-4 h-4" />
              <span>3. HR Interview</span>
            </div>
            <span className="text-slate-600">→</span>
            <div className="flex items-center space-x-2 text-slate-400">
              <Award className="w-4 h-4" />
              <span>Performance Report</span>
            </div>
          </div>
        </div>
      </section>

      {/* The 3 Core Rounds */}
      <section id="rounds" className="py-24 bg-slate-950 border-b border-slate-900">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-3xl mx-auto mb-16">
            <h2 className="text-xs uppercase font-bold tracking-widest text-indigo-400">3-Stage Placement Pipeline</h2>
            <p className="mt-2 text-3xl sm:text-4xl font-extrabold text-white">
              Mirroring Real Tier-1 Campus Recruitment
            </p>
            <p className="mt-3 text-slate-400">
              Every mock placement drive puts candidates through authentic corporate evaluation criteria.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {/* Round 1 */}
            <div className="p-8 rounded-2xl bg-slate-900/60 border border-slate-800 hover:border-indigo-500/40 transition-all group relative">
              <div className="w-12 h-12 rounded-xl bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center text-indigo-400 mb-6 group-hover:scale-110 transition-transform">
                <Code2 className="w-6 h-6" />
              </div>
              <div className="text-xs font-bold uppercase tracking-wider text-indigo-400 mb-1">Round 01</div>
              <h3 className="text-xl font-bold text-white mb-2">Algorithmic Coding</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                DSA questions covering arrays, hashing, and dynamic programming with controlled test case execution and immediate feedback.
              </p>
              <div className="mt-6 pt-4 border-t border-slate-800 text-xs text-slate-400 flex items-center justify-between">
                <span>Weighting: 40%</span>
                <span className="text-emerald-400 font-semibold">Predefined Tests</span>
              </div>
            </div>

            {/* Round 2 */}
            <div className="p-8 rounded-2xl bg-slate-900/60 border border-slate-800 hover:border-indigo-500/40 transition-all group relative">
              <div className="w-12 h-12 rounded-xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400 mb-6 group-hover:scale-110 transition-transform">
                <Users2 className="w-6 h-6" />
              </div>
              <div className="text-xs font-bold uppercase tracking-wider text-purple-400 mb-1">Round 02</div>
              <h3 className="text-xl font-bold text-white mb-2">Group Discussion (GD)</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                Interactive GD simulator featuring AI peer participants exchanging viewpoints on tech disruption, remote work, and industry dilemmas.
              </p>
              <div className="mt-6 pt-4 border-t border-slate-800 text-xs text-slate-400 flex items-center justify-between">
                <span>Weighting: 25%</span>
                <span className="text-purple-400 font-semibold">Gemini AI Feedback</span>
              </div>
            </div>

            {/* Round 3 */}
            <div className="p-8 rounded-2xl bg-slate-900/60 border border-slate-800 hover:border-indigo-500/40 transition-all group relative">
              <div className="w-12 h-12 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400 mb-6 group-hover:scale-110 transition-transform">
                <UserCheck className="w-6 h-6" />
              </div>
              <div className="text-xs font-bold uppercase tracking-wider text-emerald-400 mb-1">Round 03</div>
              <h3 className="text-xl font-bold text-white mb-2">HR / Personal Interview</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                Comprehensive panel simulator assessing behavioral responses, project storytelling via STAR method, strengths, and cultural alignment.
              </p>
              <div className="mt-6 pt-4 border-t border-slate-800 text-xs text-slate-400 flex items-center justify-between">
                <span>Weighting: 35%</span>
                <span className="text-emerald-400 font-semibold">Communication Metrics</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* AI Evaluation Engine Section */}
      <section id="evaluation" className="py-24 bg-slate-900/30 border-b border-slate-900">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div>
              <div className="text-xs uppercase font-bold tracking-widest text-indigo-400 mb-2">
                Intelligent Assessment
              </div>
              <h2 className="text-3xl sm:text-4xl font-extrabold text-white leading-tight">
                Objective AI Evaluation with Actionable Feedback
              </h2>
              <p className="mt-4 text-slate-400 leading-relaxed">
                Powered by Google Gemini with deterministic fallback intelligence. We assess measurable communication indicators: clarity, relevance, logical structure, and critical thinking.
              </p>

              <div className="mt-8 space-y-4">
                <div className="flex items-start space-x-3">
                  <div className="p-1 rounded-lg bg-emerald-500/10 text-emerald-400 mt-1">
                    <CheckCircle2 className="w-4 h-4" />
                  </div>
                  <div>
                    <h4 className="text-sm font-semibold text-white">Transparent Criteria Scoring</h4>
                    <p className="text-xs text-slate-400">Clear 0-100 scores across Clarity, Relevance, Structure, and Communication.</p>
                  </div>
                </div>

                <div className="flex items-start space-x-3">
                  <div className="p-1 rounded-lg bg-indigo-500/10 text-indigo-400 mt-1">
                    <CheckCircle2 className="w-4 h-4" />
                  </div>
                  <div>
                    <h4 className="text-sm font-semibold text-white">Specific Strengths & Improvements</h4>
                    <p className="text-xs text-slate-400">Tailored action points so students know exactly how to improve before company drives.</p>
                  </div>
                </div>

                <div className="flex items-start space-x-3">
                  <div className="p-1 rounded-lg bg-purple-500/10 text-purple-400 mt-1">
                    <CheckCircle2 className="w-4 h-4" />
                  </div>
                  <div>
                    <h4 className="text-sm font-semibold text-white">Placement Officer Oversight</h4>
                    <p className="text-xs text-slate-400">Real-time candidate monitoring, completion tracking, and cohort analytics.</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Mock Report Card UI */}
            <div className="p-6 rounded-2xl glass-card border border-slate-800 shadow-2xl relative">
              <div className="flex items-center justify-between pb-4 border-b border-slate-800">
                <div className="flex items-center space-x-3">
                  <div className="w-8 h-8 rounded-lg bg-indigo-600/20 text-indigo-400 flex items-center justify-center font-bold text-xs">
                    TCS
                  </div>
                  <div>
                    <div className="text-xs font-bold text-white">TCS Mock Placement Report</div>
                    <div className="text-[10px] text-slate-400">Candidate: Aditya Sharma</div>
                  </div>
                </div>
                <div className="text-right">
                  <span className="text-2xl font-black text-emerald-400">82</span>
                  <span className="text-xs text-slate-400">/100</span>
                </div>
              </div>

              <div className="grid grid-cols-3 gap-3 my-5 text-center">
                <div className="p-3 rounded-xl bg-slate-950/60 border border-slate-800">
                  <div className="text-[10px] text-slate-400">Coding (40%)</div>
                  <div className="text-lg font-bold text-indigo-300">85%</div>
                </div>
                <div className="p-3 rounded-xl bg-slate-950/60 border border-slate-800">
                  <div className="text-[10px] text-slate-400">GD (25%)</div>
                  <div className="text-lg font-bold text-purple-300">78%</div>
                </div>
                <div className="p-3 rounded-xl bg-slate-950/60 border border-slate-800">
                  <div className="text-[10px] text-slate-400">HR (35%)</div>
                  <div className="text-lg font-bold text-emerald-300">80%</div>
                </div>
              </div>

              <div className="space-y-2 text-xs">
                <div className="p-2.5 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-300">
                  <strong>Strength:</strong> Articulate argument structure during the AI ethics debate.
                </div>
                <div className="p-2.5 rounded-lg bg-amber-500/10 border border-amber-500/20 text-amber-300">
                  <strong>Action Area:</strong> Leverage the STAR format when explaining capstone architecture.
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Footer */}
      <footer className="mt-auto py-12 bg-slate-950 border-t border-slate-900 text-center text-xs text-slate-400">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center space-x-2">
            <span className="font-bold text-white">InterviewX</span>
            <span>— AI-Powered Mock Placement Platform</span>
          </div>
          <div>
            Built for National Hackathon 2026. Realistic end-to-end recruitment simulation.
          </div>
        </div>
      </footer>
    </div>
  );
};

export default LandingPage;
