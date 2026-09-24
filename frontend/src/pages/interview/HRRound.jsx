import React, { useState } from 'react';
import { 
  UserCheck, Send, Sparkles, ChevronRight, ChevronLeft, 
  HelpCircle, CheckCircle2, AlertCircle, Award, Check
} from 'lucide-react';
import api from '../../api/client';
import { useToast } from '../../context/ToastContext';

const HRRound = ({ questions = [], attemptId, onRoundComplete }) => {
  const { showError, showSuccess } = useToast();

  const defaultQuestions = [
    {
      id: 'hr-q1',
      question: 'Tell me about yourself and your academic background.',
      category: 'Introduction',
      tips: 'Deliver a structured 90-second overview covering your degree, technical passion, and relevant project achievements.'
    },
    {
      id: 'hr-q2',
      question: 'Why should our company hire you over other qualified candidates?',
      category: 'Value Fit',
      tips: 'Focus on how quickly you pick up tech stacks, your strong problem-solving discipline, and team alignment.'
    },
    {
      id: 'hr-q3',
      question: 'Explain your strongest technical project and your key contribution.',
      category: 'Project Showcase',
      tips: 'Follow the STAR format: Situation, Task, Actions you took, and measurable Results achieved.'
    },
    {
      id: 'hr-q4',
      question: 'What are your primary technical and interpersonal strengths?',
      category: 'Strengths',
      tips: 'State 2 core strengths and give quick anecdotal proof from hackathons or college assignments.'
    },
    {
      id: 'hr-q5',
      question: 'What is one weakness or area of improvement you are actively working on?',
      category: 'Self-Awareness',
      tips: 'Identify a real skill gap and immediately describe the proactive steps or courses you are taking to overcome it.'
    },
    {
      id: 'hr-q6',
      question: 'Where do you see yourself in five years within the software industry?',
      category: 'Vision',
      tips: 'Show ambition for system architecture mastery, engineering ownership, and helping mentor future juniors.'
    }
  ];

  const activeQuestions = questions.length > 0 ? questions : defaultQuestions;

  const [activeQIdx, setActiveQIdx] = useState(0);
  const [answers, setAnswers] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [evalResult, setEvalResult] = useState(null);

  const currentQ = activeQuestions[activeQIdx] || activeQuestions[0];
  const currentAnswer = answers[currentQ.id] || '';

  const handleAnswerChange = (val) => {
    setAnswers((prev) => ({ ...prev, [currentQ.id]: val }));
  };

  const answeredCount = Object.values(answers).filter((a) => a && a.trim().length >= 10).length;

  const handleSubmitRound = async () => {
    if (answeredCount < 2) {
      showError('Please provide detailed answers to at least 2 questions before finalizing the HR round.');
      return;
    }

    setIsSubmitting(true);
    try {
      const answersPayload = activeQuestions.map((q) => ({
        question_id: q.id,
        question_text: q.question,
        answer: answers[q.id] || 'Candidate provided summary acknowledgement during interview session.'
      }));

      const res = await api.post(`/interviews/${attemptId}/hr`, {
        answers: answersPayload,
        time_taken_seconds: 600
      });

      // Complete interview in backend
      await api.post(`/interviews/${attemptId}/complete`);

      setEvalResult(res.data);
      showSuccess(`HR Round Completed! Finalizing Interview Results.`);
      onRoundComplete(res.data);
    } catch (err) {
      showError(err.response?.data?.detail || 'Failed to submit HR responses');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6">
      {/* Interviewer Visual Card */}
      <div className="p-6 rounded-2xl glass-card border border-slate-800 shadow-xl flex flex-col md:flex-row items-center md:items-start justify-between gap-6">
        <div className="flex items-center space-x-4">
          <div className="relative">
            <img
              src="https://api.dicebear.com/7.x/avataaars/svg?seed=HRManagerPriya"
              alt="HR Panel Head"
              className="w-16 h-16 rounded-2xl bg-indigo-900/40 border-2 border-indigo-500/40 p-1 shadow-lg"
            />
            <span className="absolute bottom-0 right-0 w-4 h-4 rounded-full bg-emerald-500 border-2 border-slate-950" />
          </div>
          <div>
            <div className="flex items-center space-x-2">
              <h2 className="text-lg font-bold text-white">Dr. Priya Nair</h2>
              <span className="text-[10px] px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 font-bold">
                Panel Lead
              </span>
            </div>
            <p className="text-xs text-slate-400 mt-0.5">
              Senior Corporate Recruiter & Campus Placement Lead
            </p>
            <p className="text-[11px] text-slate-500 mt-1 italic">
              "Welcome to Round 3. We are assessing communication indicators, structural coherence, and professional readiness."
            </p>
          </div>
        </div>

        <div className="text-right shrink-0">
          <div className="text-[10px] uppercase font-bold text-slate-400">Questions Answered</div>
          <div className="text-lg font-black text-indigo-400">
            {answeredCount} / {activeQuestions.length}
          </div>
        </div>
      </div>

      {/* Main Question Workspace */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: Question Navigator */}
        <div className="lg:col-span-4 space-y-2">
          <div className="text-xs font-bold uppercase tracking-wider text-slate-400 mb-2">
            Interview Prompts
          </div>
          <div className="space-y-2">
            {activeQuestions.map((q, idx) => {
              const isAnswered = answers[q.id]?.trim().length >= 10;
              const isCurrent = activeQIdx === idx;

              return (
                <button
                  key={q.id || idx}
                  onClick={() => setActiveQIdx(idx)}
                  className={`w-full p-3 rounded-xl border text-left transition-all flex items-center justify-between text-xs ${
                    isCurrent
                      ? 'bg-indigo-600/20 border-indigo-500 text-white font-bold ring-1 ring-indigo-500/30'
                      : 'bg-slate-900/60 border-slate-800 text-slate-300 hover:border-slate-700'
                  }`}
                >
                  <div className="flex items-center space-x-2.5 truncate mr-2">
                    <span className="text-[11px] font-mono text-slate-400">0{idx + 1}.</span>
                    <span className="truncate">{q.question}</span>
                  </div>
                  {isAnswered && (
                    <Check className="w-4 h-4 text-emerald-400 shrink-0 stroke-[2.5]" />
                  )}
                </button>
              );
            })}
          </div>

          <div className="pt-4">
            <button
              onClick={handleSubmitRound}
              disabled={isSubmitting || answeredCount < 2}
              className="w-full py-3 px-4 rounded-xl bg-emerald-600 hover:bg-emerald-500 disabled:opacity-50 text-white font-bold text-xs transition-all shadow-lg shadow-emerald-600/25 flex items-center justify-center space-x-2"
            >
              {isSubmitting ? (
                <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  <Award className="w-4 h-4" />
                  <span>Submit HR Round & Generate Report</span>
                </>
              )}
            </button>
            <p className="text-[11px] text-slate-500 text-center mt-2">
              Requires at least 2 answered questions to finalize.
            </p>
          </div>
        </div>

        {/* Right Column: Question & Answer Editor */}
        <div className="lg:col-span-8 flex flex-col space-y-4">
          <div className="p-6 rounded-2xl glass-card border border-slate-800 shadow-xl space-y-4">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold uppercase tracking-wider text-indigo-400">
                Question {activeQIdx + 1} of {activeQuestions.length} — {currentQ.category || 'Behavioral'}
              </span>
            </div>

            <h3 className="text-xl font-extrabold text-white leading-snug">
              {currentQ.question}
            </h3>

            {/* Recruiter Tip */}
            {currentQ.tips && (
              <div className="p-3 rounded-xl bg-slate-900 border border-slate-800 text-xs text-indigo-300 flex items-start space-x-2.5">
                <HelpCircle className="w-4 h-4 text-indigo-400 shrink-0 mt-0.5" />
                <span><strong>Interviewer Tip:</strong> {currentQ.tips}</span>
              </div>
            )}

            {/* Answer Textarea */}
            <div className="mt-4">
              <label className="block text-xs font-semibold text-slate-300 mb-1.5">
                Your Answer / Response
              </label>
              <textarea
                value={currentAnswer}
                onChange={(e) => handleAnswerChange(e.target.value)}
                placeholder="Type your structured answer here. Speak clearly, outline concrete situations, and showcase your alignment with company culture..."
                rows={7}
                className="w-full p-4 rounded-xl bg-slate-950 border border-slate-800 text-slate-100 text-xs sm:text-sm placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-indigo-500/30 focus:border-indigo-500 leading-relaxed resize-none"
              />
              <div className="mt-2 flex items-center justify-between text-xs text-slate-500">
                <span>Evaluated strictly on communication & professional indicators.</span>
                <span className="font-mono">
                  {currentAnswer.trim() ? currentAnswer.trim().split(/\s+/).length : 0} words
                </span>
              </div>
            </div>

            {/* Question Paging Controls */}
            <div className="pt-4 border-t border-slate-800 flex items-center justify-between">
              <button
                type="button"
                onClick={() => setActiveQIdx((prev) => Math.max(0, prev - 1))}
                disabled={activeQIdx === 0}
                className="flex items-center space-x-1 px-3 py-1.5 rounded-lg bg-slate-900 hover:bg-slate-800 text-slate-300 text-xs disabled:opacity-40"
              >
                <ChevronLeft className="w-4 h-4" />
                <span>Previous</span>
              </button>

              <button
                type="button"
                onClick={() => setActiveQIdx((prev) => Math.min(activeQuestions.length - 1, prev + 1))}
                disabled={activeQIdx === activeQuestions.length - 1}
                className="flex items-center space-x-1 px-3 py-1.5 rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold disabled:opacity-40"
              >
                <span>Next Question</span>
                <ChevronRight className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default HRRound;
