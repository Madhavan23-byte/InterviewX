import React, { useState } from 'react';
import api from '../../api/client';
import { useToast } from '../../context/ToastContext';
import Modal from '../../components/Modal';
import { Building2, Layers, Clock, Sparkles } from 'lucide-react';

const CreateDriveModal = ({ isOpen, onClose, onCreated }) => {
  const { showError, showSuccess } = useToast();

  const [company, setCompany] = useState('');
  const [role, setRole] = useState('');
  const [description, setDescription] = useState('');
  const [difficulty, setDifficulty] = useState('Medium');
  const [durationMins, setDurationMins] = useState(60);
  const [rounds, setRounds] = useState({
    coding: true,
    gd: true,
    hr: true
  });
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!company.trim() || !role.trim() || !description.trim()) {
      showError('Please fill in Company, Job Role, and Description');
      return;
    }

    if (!rounds.coding && !rounds.gd && !rounds.hr) {
      showError('At least one round must be enabled');
      return;
    }

    setLoading(true);
    try {
      const payload = {
        company: company.trim(),
        role: role.trim(),
        description: description.trim(),
        difficulty: difficulty,
        duration_mins: parseInt(durationMins, 10),
        rounds: rounds,
        coding_question_ids: ['q-two-sum', 'q-reverse-string', 'q-max-subarray'],
        gd_topic_id: 'gd-ai-jobs',
        hr_question_ids: ['hr-q1', 'hr-q2', 'hr-q3', 'hr-q4']
      };

      const res = await api.post('/drives', payload);
      showSuccess(`Mock placement drive for ${company} created successfully!`);
      onCreated();
      onClose();
      // Reset
      setCompany('');
      setRole('');
      setDescription('');
    } catch (err) {
      showError(err.response?.data?.detail || 'Failed to create mock drive');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Create New Mock Placement Drive" maxWidth="max-w-xl">
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold text-slate-300 mb-1">Company Name</label>
            <input
              type="text"
              value={company}
              onChange={(e) => setCompany(e.target.value)}
              required
              placeholder="e.g. Google, Microsoft, Wipro"
              className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-white placeholder-slate-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-300 mb-1">Job Role</label>
            <input
              type="text"
              value={role}
              onChange={(e) => setRole(e.target.value)}
              required
              placeholder="e.g. SDE-1, Graduate Engineer"
              className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-white placeholder-slate-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            />
          </div>
        </div>

        <div>
          <label className="block text-xs font-semibold text-slate-300 mb-1">Drive Description</label>
          <textarea
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            required
            rows={3}
            placeholder="Outline the placement criteria, required skills, and assessment objectives..."
            className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-white placeholder-slate-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 resize-none"
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold text-slate-300 mb-1">Difficulty Level</label>
            <select
              value={difficulty}
              onChange={(e) => setDifficulty(e.target.value)}
              className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="Easy">Easy</option>
              <option value="Medium">Medium</option>
              <option value="Hard">Hard</option>
            </select>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-300 mb-1">Duration (Minutes)</label>
            <input
              type="number"
              min="15"
              max="180"
              value={durationMins}
              onChange={(e) => setDurationMins(e.target.value)}
              className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
            />
          </div>
        </div>

        {/* Round Configuration */}
        <div>
          <label className="block text-xs font-semibold text-slate-300 mb-2">Round Pipeline Configuration</label>
          <div className="grid grid-cols-3 gap-3">
            <label className={`p-3 rounded-xl border flex flex-col items-center justify-center cursor-pointer transition-all ${
              rounds.coding ? 'bg-indigo-600/20 border-indigo-500 text-indigo-300' : 'bg-slate-950 border-slate-800 text-slate-500'
            }`}>
              <input
                type="checkbox"
                checked={rounds.coding}
                onChange={(e) => setRounds((prev) => ({ ...prev, coding: e.target.checked }))}
                className="hidden"
              />
              <span className="text-xs font-bold">Round 1</span>
              <span className="text-[11px] mt-0.5">Coding DSA</span>
            </label>

            <label className={`p-3 rounded-xl border flex flex-col items-center justify-center cursor-pointer transition-all ${
              rounds.gd ? 'bg-purple-600/20 border-purple-500 text-purple-300' : 'bg-slate-950 border-slate-800 text-slate-500'
            }`}>
              <input
                type="checkbox"
                checked={rounds.gd}
                onChange={(e) => setRounds((prev) => ({ ...prev, gd: e.target.checked }))}
                className="hidden"
              />
              <span className="text-xs font-bold">Round 2</span>
              <span className="text-[11px] mt-0.5">Group Discussion</span>
            </label>

            <label className={`p-3 rounded-xl border flex flex-col items-center justify-center cursor-pointer transition-all ${
              rounds.hr ? 'bg-emerald-600/20 border-emerald-500 text-emerald-300' : 'bg-slate-950 border-slate-800 text-slate-500'
            }`}>
              <input
                type="checkbox"
                checked={rounds.hr}
                onChange={(e) => setRounds((prev) => ({ ...prev, hr: e.target.checked }))}
                className="hidden"
              />
              <span className="text-xs font-bold">Round 3</span>
              <span className="text-[11px] mt-0.5">HR Interview</span>
            </label>
          </div>
        </div>

        <div className="pt-4 border-t border-slate-800 flex justify-end space-x-3">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-semibold"
          >
            Cancel
          </button>
          <button
            type="submit"
            disabled={loading}
            className="px-5 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 disabled:opacity-50 text-white text-xs font-bold transition-all shadow-md shadow-indigo-600/30 flex items-center space-x-2"
          >
            {loading ? (
              <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
            ) : (
              <span>Create Mock Drive</span>
            )}
          </button>
        </div>
      </form>
    </Modal>
  );
};

export default CreateDriveModal;
