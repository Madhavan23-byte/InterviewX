import React, { useState, useEffect } from 'react';
import { 
  Play, Send, CheckCircle2, XCircle, AlertCircle, 
  Code, RefreshCw, ChevronLeft, ChevronRight, Check
} from 'lucide-react';
import api from '../../api/client';
import { useToast } from '../../context/ToastContext';

const CodingRound = ({ questions = [], attemptId, onRoundComplete }) => {
  const { showError, showSuccess } = useToast();

  const [currentIdx, setCurrentIdx] = useState(0);
  const [language, setLanguage] = useState('python');
  // Store code per question and language
  const [solutions, setSolutions] = useState({});
  const [testResults, setTestResults] = useState({});
  const [isRunning, setIsRunning] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [questionStatus, setQuestionStatus] = useState({});

  const currentQ = questions[currentIdx] || {
    id: 'q-default',
    title: 'Coding Problem',
    description: 'Solve the problem statement.',
    constraints: [],
    examples: [],
    starter_templates: {},
    test_cases: []
  };

  // Initialize starter template
  useEffect(() => {
    if (!currentQ.id) return;
    const key = `${currentQ.id}_${language}`;
    if (!solutions[key]) {
      const template = currentQ.starter_templates?.[language] || 
        (language === 'python' ? 'def solution():\n    # Write your code here\n    pass\n' : '// Write your solution here\n');
      setSolutions((prev) => ({ ...prev, [key]: template }));
    }
  }, [currentQ.id, language]);

  const activeCodeKey = `${currentQ.id}_${language}`;
  const activeCode = solutions[activeCodeKey] || '';

  const handleCodeChange = (newCode) => {
    setSolutions((prev) => ({ ...prev, [activeCodeKey]: newCode }));
  };

  const handleRunCode = async () => {
    setIsRunning(true);
    try {
      const res = await api.post('/interviews/run-code', {
        question_id: currentQ.id,
        language: language,
        code: activeCode
      });
      setTestResults((prev) => ({ ...prev, [currentQ.id]: res.data }));
      if (res.data.passed_count === res.data.total_count) {
        showSuccess(`All ${res.data.total_count} test cases passed!`);
        setQuestionStatus((prev) => ({ ...prev, [currentQ.id]: true }));
      } else {
        showError(`${res.data.passed_count}/${res.data.total_count} test cases passed.`);
      }
    } catch (err) {
      showError(err.response?.data?.detail || 'Execution error');
    } finally {
      setIsRunning(false);
    }
  };

  const handleSubmitRound = async () => {
    setIsSubmitting(true);
    try {
      const payloadSubmissions = questions.map((q) => {
        const codeKey = `${q.id}_${language}`;
        const code = solutions[codeKey] || q.starter_templates?.[language] || '# Solution';
        return {
          question_id: q.id,
          language: language,
          code: code
        };
      });

      const res = await api.post(`/interviews/${attemptId}/coding`, {
        submissions: payloadSubmissions,
        time_taken_seconds: 600
      });

      showSuccess(`Coding Round Submitted! Score: ${res.data.score}/100`);
      onRoundComplete(res.data);
    } catch (err) {
      showError(err.response?.data?.detail || 'Failed to submit coding round');
    } finally {
      setIsSubmitting(false);
    }
  };

  const currentResults = testResults[currentQ.id];

  return (
    <div className="flex flex-col h-[calc(100vh-14rem)] min-h-[580px] bg-slate-950 rounded-2xl border border-slate-800 overflow-hidden shadow-2xl">
      {/* Top Bar: Question Tabs & Language Selector */}
      <div className="flex flex-wrap items-center justify-between px-4 py-3 bg-slate-900/90 border-b border-slate-800 gap-3">
        {/* Question Selector Tabs */}
        <div className="flex items-center space-x-2">
          {questions.map((q, idx) => (
            <button
              key={q.id || idx}
              onClick={() => setCurrentIdx(idx)}
              className={`flex items-center space-x-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all ${
                currentIdx === idx
                  ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/30'
                  : 'bg-slate-800/80 text-slate-400 hover:text-slate-200'
              }`}
            >
              <span>Q{idx + 1}</span>
              <span className="hidden sm:inline">: {q.title}</span>
              {questionStatus[q.id] && <Check className="w-3 h-3 text-emerald-300 stroke-[3]" />}
            </button>
          ))}
        </div>

        {/* Right: Language Selector & Actions */}
        <div className="flex items-center space-x-3">
          <div className="flex items-center space-x-1 text-xs text-slate-400">
            <span>Lang:</span>
            <select
              value={language}
              onChange={(e) => setLanguage(e.target.value)}
              className="bg-slate-800 border border-slate-700 text-slate-200 text-xs rounded-lg px-2.5 py-1.5 font-mono focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="python">Python 3</option>
              <option value="javascript">JavaScript</option>
              <option value="java">Java</option>
              <option value="cpp">C++</option>
            </select>
          </div>

          <button
            onClick={handleRunCode}
            disabled={isRunning}
            className="flex items-center space-x-1.5 px-3.5 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-semibold border border-slate-700 transition-colors disabled:opacity-50"
          >
            {isRunning ? (
              <RefreshCw className="w-3.5 h-3.5 animate-spin" />
            ) : (
              <Play className="w-3.5 h-3.5 fill-current text-emerald-400" />
            )}
            <span>Run Tests</span>
          </button>

          <button
            onClick={handleSubmitRound}
            disabled={isSubmitting}
            className="flex items-center space-x-1.5 px-4 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-bold transition-all shadow-md shadow-emerald-600/30 disabled:opacity-50"
          >
            {isSubmitting ? (
              <RefreshCw className="w-3.5 h-3.5 animate-spin" />
            ) : (
              <Send className="w-3.5 h-3.5" />
            )}
            <span>Submit Round</span>
          </button>
        </div>
      </div>

      {/* Main Split: Left (Problem) | Right (Editor & Test Results) */}
      <div className="flex-1 grid grid-cols-1 lg:grid-cols-12 overflow-hidden">
        {/* Left Column: Problem Details */}
        <div className="lg:col-span-5 border-r border-slate-800/80 p-5 overflow-y-auto bg-slate-900/30">
          <div className="flex items-center justify-between mb-3">
            <span className="text-xs font-bold uppercase tracking-wider text-indigo-400">
              Problem {currentIdx + 1} of {questions.length}
            </span>
            <span className="px-2 py-0.5 rounded text-[11px] font-semibold bg-slate-800 text-slate-300">
              {currentQ.difficulty || 'Easy'}
            </span>
          </div>

          <h2 className="text-xl font-bold text-white mb-3">{currentQ.title}</h2>
          
          <div className="text-xs text-slate-300 leading-relaxed whitespace-pre-line mb-6">
            {currentQ.description}
          </div>

          {/* Examples */}
          {currentQ.examples && currentQ.examples.length > 0 && (
            <div className="mb-6 space-y-3">
              <div className="text-xs font-bold text-slate-300 uppercase tracking-wider">Examples:</div>
              {currentQ.examples.map((ex, i) => (
                <div key={i} className="p-3 rounded-xl bg-slate-900/90 border border-slate-800 font-mono text-xs">
                  <div className="text-slate-400">Input: <span className="text-slate-200">{ex.input}</span></div>
                  <div className="text-slate-400 mt-1">Output: <span className="text-emerald-400">{ex.output}</span></div>
                  {ex.explanation && (
                    <div className="text-slate-500 text-[11px] font-sans mt-1">
                      Note: {ex.explanation}
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}

          {/* Constraints */}
          {currentQ.constraints && currentQ.constraints.length > 0 && (
            <div>
              <div className="text-xs font-bold text-slate-300 uppercase tracking-wider mb-2">Constraints:</div>
              <ul className="list-disc list-inside space-y-1 text-xs text-slate-400 font-mono">
                {currentQ.constraints.map((c, i) => (
                  <li key={i}>{c}</li>
                ))}
              </ul>
            </div>
          )}
        </div>

        {/* Right Column: Code Editor & Test Cases */}
        <div className="lg:col-span-7 flex flex-col bg-slate-950 overflow-hidden">
          {/* Editor Header */}
          <div className="px-4 py-2 bg-slate-900/60 border-b border-slate-800/80 flex items-center justify-between text-xs text-slate-400 font-mono">
            <span>solution.{language === 'python' ? 'py' : language === 'javascript' ? 'js' : language === 'java' ? 'java' : 'cpp'}</span>
            <span>Tab size: 4 spaces</span>
          </div>

          {/* Code Textarea with Line Numbers simulation */}
          <div className="flex-1 relative font-mono text-xs overflow-hidden">
            <textarea
              value={activeCode}
              onChange={(e) => handleCodeChange(e.target.value)}
              spellCheck="false"
              className="w-full h-full p-4 bg-slate-950 text-indigo-100 font-mono text-xs resize-none focus:outline-none leading-relaxed selection:bg-indigo-600/40"
              placeholder="# Write your code here..."
            />
          </div>

          {/* Test Case Output Drawer */}
          <div className="h-44 border-t border-slate-800 bg-slate-900/90 p-3 overflow-y-auto">
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs font-bold uppercase tracking-wider text-slate-300">
                Test Case Execution
              </span>
              {currentResults && (
                <span className={`text-xs font-bold ${currentResults.passed_count === currentResults.total_count ? 'text-emerald-400' : 'text-amber-400'}`}>
                  {currentResults.status}
                </span>
              )}
            </div>

            {currentResults ? (
              <div className="space-y-2">
                {currentResults.test_results?.map((tr, i) => (
                  <div
                    key={i}
                    className={`p-2.5 rounded-lg border text-xs font-mono flex items-center justify-between ${
                      tr.passed
                        ? 'bg-emerald-950/20 border-emerald-500/30 text-emerald-300'
                        : 'bg-rose-950/20 border-rose-500/30 text-rose-300'
                    }`}
                  >
                    <div className="flex items-center space-x-2">
                      {tr.passed ? (
                        <CheckCircle2 className="w-4 h-4 text-emerald-400 shrink-0" />
                      ) : (
                        <XCircle className="w-4 h-4 text-rose-400 shrink-0" />
                      )}
                      <span>Test Case {i + 1} {tr.is_hidden ? '(Hidden)' : ''}</span>
                    </div>
                    <div className="text-[11px] text-slate-400">
                      Output: <span className={tr.passed ? 'text-emerald-400' : 'text-rose-400'}>{tr.actual_output}</span>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="h-28 flex flex-col items-center justify-center text-xs text-slate-500 space-y-1">
                <span>Click "Run Tests" to evaluate your solution against test cases</span>
                <span className="text-[11px] text-slate-600">Tests run securely in safe sandboxed execution</span>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default CodingRound;
