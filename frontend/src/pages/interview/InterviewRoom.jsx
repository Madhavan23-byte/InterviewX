import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../../api/client';
import { useToast } from '../../context/ToastContext';
import Navbar from '../../components/Navbar';
import ProgressIndicator from '../../components/ProgressIndicator';
import Timer from '../../components/Timer';
import CodingRound from './CodingRound';
import GDRound from './GDRound';
import HRRound from './HRRound';
import { AlertCircle, ChevronLeft } from 'lucide-react';

const InterviewRoom = () => {
  const { attemptId } = useParams();
  const navigate = useNavigate();
  const { showError, showSuccess } = useToast();

  const [attempt, setAttempt] = useState(null);
  const [driveData, setDriveData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchSession();
  }, [attemptId]);

  const fetchSession = async () => {
    setLoading(true);
    try {
      const attRes = await api.get(`/interviews/${attemptId}`);
      setAttempt(attRes.data);

      if (attRes.data.status === 'completed' || attRes.data.current_round === 'completed') {
        navigate(`/results/${attemptId}`);
        return;
      }

      // Fetch drive details
      if (attRes.data.drive_id) {
        const driveRes = await api.get(`/drives/${attRes.data.drive_id}`);
        setDriveData(driveRes.data);
      }
    } catch (err) {
      showError(err.response?.data?.detail || 'Failed to load interview attempt');
    } finally {
      setLoading(false);
    }
  };

  const handleRoundComplete = (resultData) => {
    const nextRound = resultData.next_round || 'completed';
    if (nextRound === 'completed') {
      navigate(`/results/${attemptId}`);
    } else {
      setAttempt((prev) => ({
        ...prev,
        current_round: nextRound,
        rounds_status: {
          ...prev.rounds_status,
          [prev.current_round]: 'completed',
          [nextRound]: 'current'
        }
      }));
    }
  };

  const handleTimerExpire = () => {
    showError('Time has expired for this round! Auto-advancing evaluation.');
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-950 flex flex-col">
        <Navbar />
        <div className="flex-1 flex flex-col items-center justify-center space-y-4">
          <div className="w-10 h-10 border-4 border-indigo-500/20 border-t-indigo-500 rounded-full animate-spin" />
          <div className="text-slate-400 text-sm font-medium">Preparing interview simulation environment...</div>
        </div>
      </div>
    );
  }

  if (!attempt) {
    return (
      <div className="min-h-screen bg-slate-950 flex flex-col">
        <Navbar />
        <div className="flex-1 flex flex-col items-center justify-center p-6 text-center">
          <AlertCircle className="w-12 h-12 text-rose-400 mb-3" />
          <h2 className="text-xl font-bold text-white">Interview Not Found</h2>
          <p className="text-xs text-slate-400 mt-1">This interview session could not be retrieved.</p>
          <button
            onClick={() => navigate('/student/dashboard')}
            className="mt-4 px-4 py-2 bg-slate-800 text-white rounded-xl text-xs font-semibold"
          >
            Back to Dashboard
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-950 flex flex-col">
      <Navbar />

      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6">
        {/* Top Control Bar */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
          <div className="flex items-center space-x-3">
            <button
              onClick={() => navigate('/student/dashboard')}
              className="p-2 rounded-xl bg-slate-900 border border-slate-800 text-slate-400 hover:text-white transition-colors"
              title="Dashboard"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <div>
              <div className="text-[10px] uppercase font-bold tracking-wider text-slate-400">
                Active Placement Drive
              </div>
              <h1 className="text-lg font-black text-white flex items-center space-x-2">
                <span>{attempt.company}</span>
                <span className="text-slate-600">—</span>
                <span className="text-indigo-400 font-semibold">{attempt.role}</span>
              </h1>
            </div>
          </div>

          <div className="flex items-center space-x-3 self-end sm:self-auto">
            <Timer
              initialSeconds={1800}
              storageKey={`interview_timer_${attemptId}_${attempt.current_round}`}
              onExpire={handleTimerExpire}
            />
          </div>
        </div>

        {/* Stepper Progress Bar */}
        <div className="mb-8">
          <ProgressIndicator
            currentRound={attempt.current_round}
            roundsStatus={attempt.rounds_status || {}}
          />
        </div>

        {/* Active Round Stage */}
        <div className="animate-in fade-in duration-300">
          {attempt.current_round === 'coding' && (
            <CodingRound
              questions={driveData?.coding_questions || []}
              attemptId={attemptId}
              onRoundComplete={handleRoundComplete}
            />
          )}

          {attempt.current_round === 'gd' && (
            <GDRound
              topic={driveData?.gd_topic}
              attemptId={attemptId}
              onRoundComplete={handleRoundComplete}
            />
          )}

          {attempt.current_round === 'hr' && (
            <HRRound
              questions={driveData?.hr_questions || []}
              attemptId={attemptId}
              onRoundComplete={handleRoundComplete}
            />
          )}
        </div>
      </main>
    </div>
  );
};

export default InterviewRoom;
