import React, { useState, useEffect, useRef } from 'react';
import { Clock, AlertTriangle } from 'lucide-react';

const Timer = ({ initialSeconds = 1800, onExpire, storageKey, label = "Time Remaining" }) => {
  const [secondsLeft, setSecondsLeft] = useState(() => {
    if (storageKey) {
      const saved = localStorage.getItem(storageKey);
      if (saved !== null) {
        const parsed = parseInt(saved, 10);
        if (!isNaN(parsed) && parsed > 0) return parsed;
      }
    }
    return Math.max(0, initialSeconds);
  });

  const onExpireRef = useRef(onExpire);
  onExpireRef.current = onExpire;

  useEffect(() => {
    if (storageKey) {
      localStorage.setItem(storageKey, secondsLeft.toString());
    }

    if (secondsLeft <= 0) {
      if (onExpireRef.current) {
        onExpireRef.current();
      }
      return;
    }

    const interval = setInterval(() => {
      setSecondsLeft((prev) => {
        const next = Math.max(0, prev - 1);
        if (storageKey) {
          localStorage.setItem(storageKey, next.toString());
        }
        if (next === 0 && onExpireRef.current) {
          onExpireRef.current();
        }
        return next;
      });
    }, 1000);

    return () => clearInterval(interval);
  }, [secondsLeft, storageKey]);

  const minutes = Math.floor(secondsLeft / 60);
  const seconds = secondsLeft % 60;
  const formatted = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;

  const isLow = secondsLeft <= 60;
  const isCritical = secondsLeft <= 20;

  return (
    <div
      className={`inline-flex items-center space-x-2 px-3 py-1.5 rounded-xl border text-sm font-mono font-bold transition-colors ${
        isCritical
          ? 'bg-rose-500/15 border-rose-500/40 text-rose-400 animate-pulse'
          : isLow
          ? 'bg-amber-500/15 border-amber-500/40 text-amber-400'
          : 'bg-slate-900 border-slate-800 text-slate-200'
      }`}
    >
      {isCritical ? (
        <AlertTriangle className="w-4 h-4 text-rose-400 shrink-0" />
      ) : (
        <Clock className={`w-4 h-4 shrink-0 ${isLow ? 'text-amber-400' : 'text-indigo-400'}`} />
      )}
      <div className="flex items-center space-x-1.5">
        <span className="text-[11px] font-sans font-medium text-slate-400 hidden sm:inline">{label}:</span>
        <span className="tracking-wider">{formatted}</span>
      </div>
    </div>
  );
};

export default Timer;
