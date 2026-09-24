import React from 'react';

const StatusBadge = ({ type, value }) => {
  const getBadgeStyle = () => {
    const val = (value || '').toLowerCase();
    
    // Difficulty
    if (val === 'easy') return 'bg-emerald-500/10 text-emerald-400 border-emerald-500/30';
    if (val === 'medium') return 'bg-amber-500/10 text-amber-400 border-amber-500/30';
    if (val === 'hard') return 'bg-rose-500/10 text-rose-400 border-rose-500/30';

    // Status
    if (val === 'active' || val === 'completed') return 'bg-emerald-500/10 text-emerald-400 border-emerald-500/30';
    if (val === 'in_progress' || val === 'current') return 'bg-indigo-500/10 text-indigo-400 border-indigo-500/30';
    if (val === 'pending' || val === 'inactive') return 'bg-slate-800 text-slate-400 border-slate-700';

    return 'bg-slate-800 text-slate-300 border-slate-700';
  };

  const getLabel = () => {
    if (value === 'in_progress') return 'In Progress';
    if (value === 'completed') return 'Completed';
    return value;
  };

  return (
    <span
      className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold border ${getBadgeStyle()}`}
    >
      {getLabel()}
    </span>
  );
};

export default StatusBadge;
