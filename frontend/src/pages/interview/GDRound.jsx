import React, { useState, useEffect } from 'react';
import { 
  Users2, MessageSquare, Send, Sparkles, AlertCircle, 
  CheckCircle2, Clock, Bot, Lightbulb, ArrowRight
} from 'lucide-react';
import api from '../../api/client';
import { useToast } from '../../context/ToastContext';

const GDRound = ({ topic, attemptId, onRoundComplete }) => {
  const { showError, showSuccess } = useToast();

  const [response, setResponse] = useState('');
  const [speechNotes, setSpeechNotes] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [activePeers, setActivePeers] = useState([]);
  const [evalResult, setEvalResult] = useState(null);

  // Fallback default topic if none resolved
  const currentTopic = topic || {
    id: 'gd-ai-jobs',
    title: 'Will Artificial Intelligence replace traditional jobs?',
    category: 'Technology & Economy',
    description: 'Examine how rapid advancements in Generative AI, machine automation, and algorithmic reasoning impact entry-level knowledge work, software development, and traditional industries.',
    prep_time_seconds: 60,
    discussion_time_seconds: 180,
    key_discussion_points: [
      'Productivity boost vs routine labor displacement',
      'Evolution of required skill sets (prompt engineering, systems design)',
      'Historical parallels with previous industrial revolutions',
      'Ethical, social, and economic safety nets'
    ],
    simulated_peers: [
      {
        id: 'peer-1',
        name: 'Rohan Deshmukh',
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Rohan',
        stance: 'Balanced',
        message: 'I believe AI will augment rather than outright eliminate workers. Routine repetitive tasks get automated, freeing human engineers to focus on architecture, product intuition, and security.'
      },
      {
        id: 'peer-2',
        name: 'Meera Swaminathan',
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Meera',
        stance: 'Cautionary',
        message: 'While high-level creativity remains human, we must acknowledge the immediate displacement in customer support, junior documentation, and entry-level programming roles. Reskilling is essential.'
      },
      {
        id: 'peer-3',
        name: 'Vikram Sen',
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Vikram',
        stance: 'Optimistic',
        message: 'Every technological revolution created more net employment than it destroyed. AI will birth entirely new career sectors in safety validation, synthetic data, and AI-assisted healthcare.'
      }
    ]
  };

  // Simulate peers entering conversation
  useEffect(() => {
    const peers = currentTopic.simulated_peers || [];
    setActivePeers([]);

    peers.forEach((peer, idx) => {
      const timer = setTimeout(() => {
        setActivePeers((prev) => [...prev, peer]);
      }, (idx + 1) * 2000);
      return () => clearTimeout(timer);
    });
  }, [currentTopic]);

  const wordCount = response.trim() ? response.trim().split(/\s+/).length : 0;

  const handleSubmit = async () => {
    if (wordCount < 15) {
      showError('Please elaborate on your points before submitting (minimum 15 words).');
      return;
    }

    setIsSubmitting(true);
    try {
      const res = await api.post(`/interviews/${attemptId}/gd`, {
        topic_id: currentTopic.id,
        response: response,
        speech_notes: speechNotes,
        time_taken_seconds: 180
      });

      setEvalResult(res.data);
      showSuccess(`GD Round Evaluated! Score: ${res.data.score}/100`);
    } catch (err) {
      showError(err.response?.data?.detail || 'Failed to submit GD response');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleProceed = () => {
    if (evalResult) {
      onRoundComplete(evalResult);
    }
  };

  return (
    <div className="space-y-6">
      {/* GD Topic Header Card */}
      <div className="p-6 rounded-2xl glass-card border border-slate-800 shadow-xl relative overflow-hidden">
        <div className="flex flex-col md:flex-row md:items-start justify-between gap-4">
          <div>
            <div className="inline-flex items-center space-x-2 px-3 py-1 rounded-full bg-purple-500/10 border border-purple-500/20 text-purple-400 text-xs font-semibold mb-2">
              <Users2 className="w-3.5 h-3.5" />
              <span>Round 2: Collaborative Group Discussion Simulation</span>
            </div>
            <h2 className="text-xl sm:text-2xl font-extrabold text-white tracking-tight">
              "{currentTopic.title}"
            </h2>
            <p className="text-xs sm:text-sm text-slate-300 mt-2 max-w-3xl leading-relaxed">
              {currentTopic.description}
            </p>
          </div>

          <div className="flex items-center space-x-2 shrink-0">
            <div className="px-3.5 py-2 rounded-xl bg-slate-900 border border-slate-800 text-center">
              <div className="text-[10px] uppercase font-bold text-slate-400">Discussion Timer</div>
              <div className="text-sm font-mono font-bold text-purple-400">03:00 Mins</div>
            </div>
          </div>
        </div>

        {/* Suggested Talking Points */}
        {currentTopic.key_discussion_points && (
          <div className="mt-4 pt-4 border-t border-slate-800/80 flex flex-wrap items-center gap-2">
            <span className="text-xs font-semibold text-slate-400 flex items-center space-x-1">
              <Lightbulb className="w-3.5 h-3.5 text-amber-400" />
              <span>Key Discussion Pillars:</span>
            </span>
            {currentTopic.key_discussion_points.map((pt, i) => (
              <span key={i} className="text-[11px] px-2.5 py-1 rounded-lg bg-slate-900 border border-slate-800 text-slate-300">
                {pt}
              </span>
            ))}
          </div>
        )}
      </div>

      {/* Main GD Floor: Left (Simulated Participants) | Right (Your Contribution) */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: Simulated Peer Discourse Feed */}
        <div className="lg:col-span-6 space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-300 flex items-center space-x-2">
              <Users2 className="w-4 h-4 text-purple-400" />
              <span>Peer Participant Turns ({activePeers.length} active)</span>
            </h3>
            <span className="text-[11px] text-slate-500">AI Simulated Cohort</span>
          </div>

          <div className="space-y-3 max-h-[460px] overflow-y-auto pr-1">
            {activePeers.map((peer) => (
              <div
                key={peer.id}
                className="p-4 rounded-xl bg-slate-900/80 border border-slate-800/80 shadow-md animate-in fade-in slide-in-from-bottom-2"
              >
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center space-x-2.5">
                    <img src={peer.avatar} alt={peer.name} className="w-7 h-7 rounded-full bg-slate-800" />
                    <div>
                      <span className="text-xs font-bold text-white">{peer.name}</span>
                    </div>
                  </div>
                  <span className="text-[10px] px-2 py-0.5 rounded-full bg-purple-500/10 text-purple-300 border border-purple-500/20 font-medium">
                    {peer.stance}
                  </span>
                </div>
                <p className="text-xs text-slate-300 leading-relaxed pl-9">
                  "{peer.message}"
                </p>
              </div>
            ))}

            {activePeers.length === 0 && (
              <div className="p-8 rounded-xl bg-slate-900/40 border border-slate-800 text-center text-xs text-slate-500">
                Peers are reviewing topic notes and preparing their opening arguments...
              </div>
            )}
          </div>
        </div>

        {/* Right Column: Candidate Statement Input */}
        <div className="lg:col-span-6 flex flex-col space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-300 flex items-center space-x-2">
              <Sparkles className="w-4 h-4 text-indigo-400" />
              <span>Your Argument & Contribution</span>
            </h3>
            <span className={`text-xs font-mono font-medium ${wordCount >= 30 ? 'text-emerald-400' : 'text-slate-400'}`}>
              {wordCount} words (Target: 40-150)
            </span>
          </div>

          <div className="flex-1 flex flex-col rounded-2xl bg-slate-900/70 border border-slate-800 p-4 shadow-xl">
            <textarea
              value={response}
              onChange={(e) => setResponse(e.target.value)}
              disabled={isSubmitting || !!evalResult}
              placeholder="State your opening thesis, address peer arguments (e.g., agreeing or offering a counterpoint to Rohan/Meera), and ground your stance with technological and economic indicators..."
              className="w-full flex-1 min-h-[220px] bg-transparent text-slate-100 placeholder-slate-500 text-xs sm:text-sm focus:outline-none resize-none leading-relaxed"
            />

            <div className="pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs text-slate-400">
              <span>Evaluated on: Relevance, Clarity, Structure, Critical Thinking</span>
              <button
                onClick={handleSubmit}
                disabled={isSubmitting || !!evalResult || wordCount < 10}
                className="py-2 px-5 rounded-xl bg-purple-600 hover:bg-purple-500 disabled:opacity-50 text-white font-bold text-xs transition-all shadow-lg shadow-purple-600/30 flex items-center space-x-2"
              >
                {isSubmitting ? (
                  <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <>
                    <Send className="w-3.5 h-3.5" />
                    <span>Submit GD Speech</span>
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Immediate AI Feedback Drawer / Modal */}
      {evalResult && (
        <div className="p-6 rounded-2xl bg-slate-900 border border-indigo-500/40 shadow-2xl animate-in zoom-in-95">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-slate-800 gap-3">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 rounded-xl bg-indigo-500/10 border border-indigo-500/30 flex items-center justify-center text-indigo-400">
                <Sparkles className="w-5 h-5" />
              </div>
              <div>
                <h3 className="text-base font-bold text-white">AI Group Discussion Evaluation</h3>
                <p className="text-xs text-slate-400">Communication & analytical criteria breakdown</p>
              </div>
            </div>
            <div className="text-right">
              <span className="text-3xl font-black text-emerald-400">{evalResult.score}</span>
              <span className="text-xs text-slate-400"> / 100</span>
            </div>
          </div>

          {/* Criteria Grid */}
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 my-5">
            {evalResult.criteria && Object.entries(evalResult.criteria).map(([criterion, score]) => (
              <div key={criterion} className="p-3 rounded-xl bg-slate-950/80 border border-slate-800 text-center">
                <div className="text-[10px] uppercase font-bold text-slate-400 tracking-wider">
                  {criterion.replace('_', ' ')}
                </div>
                <div className="text-lg font-bold text-indigo-300 mt-1">{score}%</div>
              </div>
            ))}
          </div>

          {/* Feedback Points */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
            <div className="p-3.5 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-300 space-y-1">
              <div className="font-bold flex items-center space-x-1.5 text-emerald-400 mb-1">
                <CheckCircle2 className="w-4 h-4" />
                <span>Demonstrated Strengths</span>
              </div>
              {evalResult.strengths?.map((s, i) => (
                <div key={i}>• {s}</div>
              ))}
            </div>

            <div className="p-3.5 rounded-xl bg-amber-500/10 border border-amber-500/20 text-amber-300 space-y-1">
              <div className="font-bold flex items-center space-x-1.5 text-amber-400 mb-1">
                <AlertCircle className="w-4 h-4" />
                <span>Actionable Improvements</span>
              </div>
              {evalResult.improvements?.map((imp, i) => (
                <div key={i}>• {imp}</div>
              ))}
            </div>
          </div>

          <div className="mt-6 flex justify-end">
            <button
              onClick={handleProceed}
              className="py-2.5 px-6 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs transition-all shadow-lg shadow-indigo-600/30 flex items-center space-x-2"
            >
              <span>Proceed to Round 3: HR Interview</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default GDRound;
