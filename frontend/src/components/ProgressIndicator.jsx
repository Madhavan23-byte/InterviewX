import React from 'react';
import { Code2, Users2, UserCheck, Award, CheckCircle, Lock, ArrowRight } from 'lucide-react';

const ProgressIndicator = ({ currentRound = 'coding', roundsStatus = {}, compact = false }) => {
  const steps = [
    { id: 'coding', name: 'Round 1: Coding', icon: Code2, short: 'Coding' },
    { id: 'gd', name: 'Round 2: Group Discussion', icon: Users2, short: 'GD' },
    { id: 'hr', name: 'Round 3: HR Interview', icon: UserCheck, short: 'HR' },
    { id: 'completed', name: 'Final Report', icon: Award, short: 'Result' }
  ];

  const getStepState = (stepId, index) => {
    // If specifically marked in roundsStatus
    if (roundsStatus[stepId] === 'completed') return 'completed';
    if (currentRound === 'completed') return 'completed';
    if (currentRound === stepId) return 'current';
    
    // Position-based fallback
    const roundOrder = ['coding', 'gd', 'hr', 'completed'];
    const currentIdx = roundOrder.indexOf(currentRound);
    if (index < currentIdx) return 'completed';
    return 'locked';
  };

  if (compact) {
    return (
      <div className="flex items-center space-x-2 text-xs">
        {steps.map((step, idx) => {
          const state = getStepState(step.id, idx);
          return (
            <React.Fragment key={step.id}>
              <div
                className={`flex items-center space-x-1.5 px-2.5 py-1 rounded-lg border font-medium ${
                  state === 'completed'
                    ? 'bg-emerald-950/40 border-emerald-500/30 text-emerald-400'
                    : state === 'current'
                    ? 'bg-indigo-600/20 border-indigo-500 text-indigo-300 ring-2 ring-indigo-500/20 animate-pulse'
                    : 'bg-slate-900 border-slate-800 text-slate-500'
                }`}
              >
                {state === 'completed' ? (
                  <CheckCircle className="w-3.5 h-3.5 text-emerald-400" />
                ) : state === 'current' ? (
                  <span className="w-2 h-2 rounded-full bg-indigo-400 animate-ping mr-0.5" />
                ) : (
                  <Lock className="w-3 h-3 text-slate-600" />
                )}
                <span>{step.short}</span>
                {state === 'completed' && <span>✓</span>}
              </div>
              {idx < steps.length - 1 && <span className="text-slate-600">→</span>}
            </React.Fragment>
          );
        })}
      </div>
    );
  }

  return (
    <div className="w-full bg-slate-900/60 border border-slate-800/80 rounded-2xl p-4 sm:p-5 backdrop-blur-md">
      <div className="flex items-center justify-between relative">
        {/* Connecting Progress Line */}
        <div className="absolute top-5 left-8 right-8 h-[2px] bg-slate-800 z-0 hidden sm:block">
          <div
            className="h-full bg-gradient-to-r from-emerald-500 via-indigo-500 to-indigo-600 transition-all duration-500"
            style={{
              width:
                currentRound === 'coding'
                  ? '0%'
                  : currentRound === 'gd'
                  ? '33%'
                  : currentRound === 'hr'
                  ? '66%'
                  : '100%',
            }}
          />
        </div>

        {steps.map((step, idx) => {
          const state = getStepState(step.id, idx);
          const Icon = step.icon;

          return (
            <div key={step.id} className="flex-1 flex flex-col items-center relative z-10">
              <div
                className={`w-10 h-10 rounded-xl flex items-center justify-center border transition-all duration-300 ${
                  state === 'completed'
                    ? 'bg-emerald-500 text-slate-950 border-emerald-400 shadow-lg shadow-emerald-500/20'
                    : state === 'current'
                    ? 'bg-indigo-600 text-white border-indigo-400 ring-4 ring-indigo-500/20 shadow-lg shadow-indigo-600/30'
                    : 'bg-slate-900 text-slate-500 border-slate-800'
                }`}
              >
                {state === 'completed' ? (
                  <CheckCircle className="w-5 h-5 text-slate-950 stroke-[2.5]" />
                ) : state === 'locked' ? (
                  <Lock className="w-4 h-4 text-slate-600" />
                ) : (
                  <Icon className="w-5 h-5" />
                )}
              </div>

              <div className="mt-2 text-center">
                <div
                  className={`text-xs font-semibold ${
                    state === 'current'
                      ? 'text-indigo-400 font-bold'
                      : state === 'completed'
                      ? 'text-emerald-400'
                      : 'text-slate-500'
                  }`}
                >
                  {step.short} {state === 'completed' && '✓'}
                </div>
                <div className="text-[10px] uppercase font-bold tracking-wider text-slate-400 hidden md:block">
                  {state === 'current' ? '→ Current' : state === 'completed' ? 'Passed' : 'Locked 🔒'}
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default ProgressIndicator;
