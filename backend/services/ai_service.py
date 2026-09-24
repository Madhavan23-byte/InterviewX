import json
import re
import requests
from typing import Dict, Any, List, Optional
from config import settings

class AIService:
    @staticmethod
    def _call_gemini(prompt: str) -> Optional[dict]:
        if not settings.GEMINI_API_KEY:
            return None
            
        endpoint = f"https://generativelanguage.googleapis.com/v1beta/models/{settings.GEMINI_MODEL}:generateContent?key={settings.GEMINI_API_KEY}"
        payload = {
            "contents": [{
                "parts": [{"text": prompt}]
            }],
            "generationConfig": {
                "temperature": 0.2,
                "responseMimeType": "application/json"
            }
        }
        
        try:
            res = requests.post(endpoint, json=payload, timeout=8)
            if res.status_code == 200:
                data = res.json()
                raw_text = data["candidates"][0]["content"]["parts"][0]["text"]
                return json.loads(raw_text)
            else:
                print(f"[AI Service] Gemini returned status {res.status_code}: {res.text[:200]}")
        except Exception as e:
            print(f"[AI Service] Gemini call exception: {e}")
            
        return None

    @classmethod
    def evaluate_gd(cls, topic_title: str, topic_desc: str, student_response: str) -> dict:
        prompt = f"""
You are an expert campus placement panel evaluator assessing a candidate's Group Discussion response.
Topic: "{topic_title}"
Context: "{topic_desc}"
Candidate Response:
\"\"\"{student_response}\"\"\"

Evaluate the response strictly as communication and analytical indicators based on the text submitted.
Return a valid JSON object matching this schema:
{{
  "score": <overall score integer between 40 and 95>,
  "criteria": {{
    "clarity": <int 40-100>,
    "relevance": <int 40-100>,
    "structure": <int 40-100>,
    "communication": <int 40-100>,
    "critical_thinking": <int 40-100>
  }},
  "strengths": [<list of 2-3 specific strength bullet points>],
  "improvements": [<list of 2-3 specific actionable improvement tips>],
  "feedback": "<2-3 sentence overall constructive summary of their performance>"
}}
"""
        result = cls._call_gemini(prompt)
        if result and "score" in result and "criteria" in result:
            return result
            
        # Fallback deterministic evaluator
        return cls._fallback_gd_evaluation(topic_title, student_response)

    @staticmethod
    def _fallback_gd_evaluation(topic_title: str, response: str) -> dict:
        text = response.strip()
        words = text.split()
        word_count = len(words)
        paragraphs = [p for p in text.split("\n") if p.strip()]
        
        # Criteria scoring heuristics
        relevance_score = 65
        topic_words = set(re.findall(r'\b[a-zA-Z]{4,}\b', topic_title.lower()))
        response_words = set(re.findall(r'\b[a-zA-Z]{4,}\b', text.lower()))
        overlap = len(topic_words.intersection(response_words))
        relevance_score += min(25, overlap * 8)
        
        # Word count / substance
        if word_count < 30:
            substance = 45
        elif word_count < 75:
            substance = 65
        elif word_count < 180:
            substance = 82
        else:
            substance = 88
            
        # Structure
        structure_score = 70
        if len(paragraphs) >= 2:
            structure_score += 10
        signpost_keywords = ["firstly", "moreover", "however", "in contrast", "in conclusion", "for instance", "furthermore", "on the other hand"]
        has_signposts = any(sp in text.lower() for sp in signpost_keywords)
        if has_signposts:
            structure_score += 10
            
        clarity_score = min(92, max(55, int((substance + structure_score) / 2) + 2))
        communication_score = min(90, max(50, int(substance * 0.9 + 5)))
        critical_thinking = min(95, max(50, 72 + (8 if "however" in text.lower() or "balance" in text.lower() or "impact" in text.lower() else 0)))
        
        overall = int((relevance_score * 0.25) + (clarity_score * 0.2) + (structure_score * 0.2) + (communication_score * 0.15) + (critical_thinking * 0.2))
        overall = max(45, min(95, overall))
        
        strengths = []
        improvements = []
        
        if word_count >= 80:
            strengths.append("Provided a well-elaborated discussion point with sufficient depth.")
        else:
            improvements.append("Elaborate further on your opening arguments to sustain active presence in the GD.")
            
        if overlap >= 2:
            strengths.append(f"Directly addressed core aspects of the topic '{topic_title}'.")
        else:
            improvements.append("Incorporate specific terminology and contextual keywords related to the discussion topic.")
            
        if has_signposts:
            strengths.append("Good logical signposting connecting arguments and counterpoints.")
        else:
            improvements.append("Use transitional connectors (e.g., 'Furthermore', 'On the contrary') to create cohesive flow.")
            
        if len(strengths) < 2:
            strengths.append("Clear stance articulated early in the contribution.")
        if len(improvements) < 2:
            improvements.append("Ground arguments with concrete industry examples or statistical indicators.")
            
        return {
            "score": overall,
            "criteria": {
                "clarity": clarity_score,
                "relevance": relevance_score,
                "structure": structure_score,
                "communication": communication_score,
                "critical_thinking": critical_thinking
            },
            "strengths": strengths[:3],
            "improvements": improvements[:3],
            "feedback": f"Constructive participation in the group discussion. Candidate maintained a clear stance on '{topic_title}' with {word_count} words articulated. Enhance by citing industry use cases and synthesizing peer viewpoints."
        }

    @classmethod
    def evaluate_hr(cls, answers: List[dict]) -> dict:
        formatted_answers = "\n\n".join([
            f"Question: {a.get('question_text', 'HR Question')}\nAnswer: {a.get('answer', '')}"
            for a in answers
        ])
        
        prompt = f"""
You are a senior HR recruitment manager assessing a college placement candidate's HR / Personal Interview responses.
Candidate Responses:
{formatted_answers}

Evaluate the communication, professionalism, structural clarity, and relevance across all answers.
Do NOT claim to measure true personality or psychological confidence; evaluate strictly as communication indicators.
Return a valid JSON object matching this schema:
{{
  "score": <overall score integer between 45 and 95>,
  "criteria": {{
    "clarity": <int 40-100>,
    "relevance": <int 40-100>,
    "professionalism": <int 40-100>,
    "communication": <int 40-100>,
    "confidence_indicators": <int 40-100>
  }},
  "strengths": [<list of 2-3 specific strength bullet points>],
  "improvements": [<list of 2-3 specific actionable improvement tips>],
  "feedback": "<2-3 sentence professional HR summary review>"
}}
"""
        result = cls._call_gemini(prompt)
        if result and "score" in result and "criteria" in result:
            return result
            
        return cls._fallback_hr_evaluation(answers)

    @staticmethod
    def _fallback_hr_evaluation(answers: List[dict]) -> dict:
        total_words = 0
        answered_count = 0
        total_questions = max(1, len(answers))
        
        for a in answers:
            ans_text = a.get("answer", "").strip()
            w_count = len(ans_text.split())
            total_words += w_count
            if w_count >= 10:
                answered_count += 1
                
        completion_ratio = answered_count / total_questions
        avg_words_per_ans = total_words / total_questions
        
        # Clarity & Professionalism
        clarity = int(60 + min(25, avg_words_per_ans * 0.4))
        relevance = int(65 + (25 * completion_ratio))
        professionalism = int(70 + min(20, (total_words / 20)))
        communication = int(65 + min(25, (clarity + professionalism) / 2 * 0.3))
        confidence_indicators = int(68 + min(22, (answered_count * 5)))
        
        overall = int((clarity * 0.2) + (relevance * 0.25) + (professionalism * 0.2) + (communication * 0.2) + (confidence_indicators * 0.15))
        overall = max(48, min(95, overall))
        
        strengths = [
            f"Addressed {answered_count} of {total_questions} personal interview questions with structured responses.",
            "Demonstrated polite, professional tone suitable for corporate placement rounds."
        ]
        
        improvements = [
            "Leverage the STAR method (Situation, Task, Action, Result) when discussing past project milestones.",
            "Quantify measurable outcomes (e.g., performance improvement percentages, team size) when highlighting strengths."
        ]
        
        if avg_words_per_ans < 35:
            improvements.insert(0, "Provide richer context rather than brief summaries to showcase depth of character and initiative.")
        else:
            strengths.append("Good narrative pacing with relevant examples of personal technical growth.")
            
        return {
            "score": overall,
            "criteria": {
                "clarity": clarity,
                "relevance": relevance,
                "professionalism": professionalism,
                "communication": communication,
                "confidence_indicators": confidence_indicators
            },
            "strengths": strengths[:3],
            "improvements": improvements[:3],
            "feedback": f"Strong behavioral presence demonstrated during the HR interview. Candidate effectively communicated background and career aspirations across {answered_count} questions. Elevate responses further with specific STAR examples and data points."
        }
