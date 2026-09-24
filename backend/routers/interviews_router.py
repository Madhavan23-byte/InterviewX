from fastapi import APIRouter, HTTPException, Depends, status
from typing import Dict, Any, List, Optional
from database import get_collection
from auth import get_current_user
from models import (
    StartInterviewRequest, CodingRoundSubmission, GDRoundSubmission, 
    HRRoundSubmission, CodeRunRequest
)
from services.code_evaluator import CodeEvaluator
from services.ai_service import AIService
from datetime import datetime, timezone
import uuid

router = APIRouter(prefix="/interviews", tags=["Interviews"])

def calculate_next_round(drive_rounds: dict, current_round: str) -> str:
    # Order: coding -> gd -> hr -> completed
    round_order = ["coding", "gd", "hr"]
    try:
        current_idx = round_order.index(current_round)
    except ValueError:
        return "completed"

    for r in round_order[current_idx + 1:]:
        if drive_rounds.get(r, True):
            return r
    return "completed"

def get_progress_pct(current_round: str) -> int:
    if current_round == "coding":
        return 10
    elif current_round == "gd":
        return 40
    elif current_round == "hr":
        return 75
    elif current_round == "completed":
        return 100
    return 0

@router.post("/start")
async def start_interview(payload: StartInterviewRequest, current_user: dict = Depends(get_current_user)):
    drives_col = get_collection("mock_drives")
    attempts_col = get_collection("interview_attempts")
    
    drive = drives_col.find_one({"_id": payload.drive_id}) or drives_col.find_one({"id": payload.drive_id})
    if not drive:
        raise HTTPException(status_code=404, detail="Mock drive not found")
        
    drive_id = str(drive.get("_id", drive.get("id")))
    user_id = str(current_user["_id"])
    
    # Check for active existing in-progress attempt for this drive & user
    existing = attempts_col.find_one({
        "user_id": user_id,
        "drive_id": drive_id,
        "status": "in_progress"
    })
    if existing:
        return {
            "attempt_id": str(existing["_id"]),
            "is_resumed": True,
            "current_round": existing.get("current_round", "coding"),
            "status": existing.get("status", "in_progress"),
            "progress_percentage": existing.get("progress_percentage", 10)
        }

    rounds_config = drive.get("rounds", {"coding": True, "gd": True, "hr": True})
    first_round = "coding" if rounds_config.get("coding") else ("gd" if rounds_config.get("gd") else "hr")
    
    now = datetime.now(timezone.utc).isoformat()
    new_attempt_id = f"attempt-{uuid.uuid4().hex[:8]}"
    
    doc = {
        "_id": new_attempt_id,
        "user_id": user_id,
        "user_name": current_user.get("name", "Student Candidate"),
        "user_email": current_user.get("email", ""),
        "drive_id": drive_id,
        "company": drive.get("company"),
        "role": drive.get("role"),
        "current_round": first_round,
        "status": "in_progress",
        "progress_percentage": get_progress_pct(first_round),
        "rounds_status": {
            "coding": "current" if first_round == "coding" else "pending",
            "gd": "current" if first_round == "gd" else ("pending" if rounds_config.get("gd") else "disabled"),
            "hr": "current" if first_round == "hr" else ("pending" if rounds_config.get("hr") else "disabled")
        },
        "round_scores": {
            "coding": None,
            "gd": None,
            "hr": None
        },
        "overall_score": None,
        "started_at": now,
        "completed_at": None
    }
    
    attempts_col.insert_one(doc)
    # Increment candidates count
    drives_col.update_one({"_id": drive["_id"]}, {"$inc": {"candidates_count": 1}})
    
    return {
        "attempt_id": new_attempt_id,
        "is_resumed": False,
        "current_round": first_round,
        "status": "in_progress",
        "progress_percentage": get_progress_pct(first_round)
    }

@router.get("/{id}")
async def get_interview_state(id: str, current_user: dict = Depends(get_current_user)):
    attempts_col = get_collection("interview_attempts")
    drives_col = get_collection("mock_drives")
    
    attempt = attempts_col.find_one({"_id": id})
    if not attempt:
        raise HTTPException(status_code=404, detail="Interview session not found")
        
    drive = drives_col.find_one({"_id": attempt.get("drive_id")}) or drives_col.find_one({"id": attempt.get("drive_id")})
    
    # Retrieve round results if any
    round_results_col = get_collection("round_results")
    results = round_results_col.find({"attempt_id": id})
    results_map = {r.get("round_type"): r for r in results}

    return {
        "id": str(attempt["_id"]),
        "user_id": attempt.get("user_id"),
        "drive_id": attempt.get("drive_id"),
        "company": attempt.get("company", drive.get("company", "Company") if drive else "Company"),
        "role": attempt.get("role", drive.get("role", "Role") if drive else "Role"),
        "current_round": attempt.get("current_round", "coding"),
        "status": attempt.get("status", "in_progress"),
        "progress_percentage": attempt.get("progress_percentage", 10),
        "rounds_status": attempt.get("rounds_status", {}),
        "round_scores": attempt.get("round_scores", {}),
        "overall_score": attempt.get("overall_score"),
        "started_at": attempt.get("started_at"),
        "completed_at": attempt.get("completed_at"),
        "round_evaluations": {
            k: {
                "score": v.get("score"),
                "feedback": v.get("feedback"),
                "strengths": v.get("strengths", []),
                "improvements": v.get("improvements", [])
            } for k, v in results_map.items()
        }
    }

@router.post("/run-code")
async def run_code(payload: CodeRunRequest, current_user: dict = Depends(get_current_user)):
    """Runs student code against visible test cases for rapid debugging"""
    eval_result = CodeEvaluator.evaluate_question(
        question_id=payload.question_id,
        language=payload.language,
        code=payload.code
    )
    return eval_result

@router.post("/{id}/coding")
async def submit_coding_round(id: str, payload: CodingRoundSubmission, current_user: dict = Depends(get_current_user)):
    attempts_col = get_collection("interview_attempts")
    drives_col = get_collection("mock_drives")
    round_results_col = get_collection("round_results")
    
    attempt = attempts_col.find_one({"_id": id})
    if not attempt:
        raise HTTPException(status_code=404, detail="Interview attempt not found")
        
    drive = drives_col.find_one({"_id": attempt["drive_id"]}) or drives_col.find_one({"id": attempt["drive_id"]})
    rounds_config = drive.get("rounds", {"coding": True, "gd": True, "hr": True}) if drive else {"coding": True, "gd": True, "hr": True}

    # Evaluate all submitted problems
    total_score = 0
    question_reports = []
    
    for item in payload.submissions:
        res = CodeEvaluator.evaluate_question(
            question_id=item.question_id,
            language=item.language,
            code=item.code
        )
        total_score += res.get("score", 0)
        question_reports.append({
            "question_id": item.question_id,
            "language": item.language,
            "code": item.code,
            "score": res.get("score", 0),
            "passed_count": res.get("passed_count", 0),
            "total_count": res.get("total_count", 0),
            "test_results": res.get("test_results", [])
        })

    avg_score = int(total_score / max(1, len(payload.submissions))) if payload.submissions else 0
    
    # Save round result
    now = datetime.now(timezone.utc).isoformat()
    result_doc = {
        "_id": f"rr-{uuid.uuid4().hex[:8]}",
        "attempt_id": id,
        "round_type": "coding",
        "score": avg_score,
        "question_reports": question_reports,
        "time_taken_seconds": payload.time_taken_seconds,
        "strengths": [
            "Demonstrated solid algorithmic understanding and handling of edge constraints.",
            "Efficient variable tracking and output formatting."
        ],
        "improvements": [
            "Test corner cases with zero and negative numbers before submitting.",
            "Optimize auxiliary space complexity for large datasets."
        ],
        "feedback": f"Coding round completed with {avg_score}/100. Successfully cleared core and edge test cases across submitted algorithmic problems.",
        "evaluated_at": now
    }
    round_results_col.insert_one(result_doc)

    # Transition to next round
    next_round = calculate_next_round(rounds_config, "coding")
    rounds_status = attempt.get("rounds_status", {})
    rounds_status["coding"] = "completed"
    if next_round in rounds_status:
        rounds_status[next_round] = "current"
        
    round_scores = attempt.get("round_scores", {})
    round_scores["coding"] = avg_score

    attempts_col.update_one({"_id": id}, {
        "$set": {
            "current_round": next_round,
            "progress_percentage": get_progress_pct(next_round),
            "rounds_status": rounds_status,
            "round_scores": round_scores
        }
    })

    return {
        "score": avg_score,
        "next_round": next_round,
        "feedback": result_doc["feedback"],
        "question_reports": question_reports
    }

@router.post("/{id}/gd")
async def submit_gd_round(id: str, payload: GDRoundSubmission, current_user: dict = Depends(get_current_user)):
    attempts_col = get_collection("interview_attempts")
    drives_col = get_collection("mock_drives")
    gd_col = get_collection("gd_topics")
    round_results_col = get_collection("round_results")
    
    attempt = attempts_col.find_one({"_id": id})
    if not attempt:
        raise HTTPException(status_code=404, detail="Interview attempt not found")
        
    drive = drives_col.find_one({"_id": attempt["drive_id"]}) or drives_col.find_one({"id": attempt["drive_id"]})
    rounds_config = drive.get("rounds", {"coding": True, "gd": True, "hr": True}) if drive else {"coding": True, "gd": True, "hr": True}

    topic = gd_col.find_one({"_id": payload.topic_id}) or gd_col.find_one({"id": payload.topic_id})
    topic_title = topic.get("title", "Group Discussion") if topic else "Group Discussion"
    topic_desc = topic.get("description", "") if topic else ""

    # Call AI Evaluator (Gemini with deterministic fallback)
    eval_result = AIService.evaluate_gd(
        topic_title=topic_title,
        topic_desc=topic_desc,
        student_response=payload.response
    )

    now = datetime.now(timezone.utc).isoformat()
    result_doc = {
        "_id": f"rr-{uuid.uuid4().hex[:8]}",
        "attempt_id": id,
        "round_type": "gd",
        "score": eval_result.get("score", 75),
        "criteria": eval_result.get("criteria", {}),
        "response": payload.response,
        "speech_notes": payload.speech_notes,
        "strengths": eval_result.get("strengths", []),
        "improvements": eval_result.get("improvements", []),
        "feedback": eval_result.get("feedback", ""),
        "evaluated_at": now
    }
    round_results_col.insert_one(result_doc)

    next_round = calculate_next_round(rounds_config, "gd")
    rounds_status = attempt.get("rounds_status", {})
    rounds_status["gd"] = "completed"
    if next_round in rounds_status:
        rounds_status[next_round] = "current"
        
    round_scores = attempt.get("round_scores", {})
    round_scores["gd"] = eval_result.get("score", 75)

    attempts_col.update_one({"_id": id}, {
        "$set": {
            "current_round": next_round,
            "progress_percentage": get_progress_pct(next_round),
            "rounds_status": rounds_status,
            "round_scores": round_scores
        }
    })

    return {
        "score": eval_result.get("score", 75),
        "criteria": eval_result.get("criteria", {}),
        "next_round": next_round,
        "feedback": eval_result.get("feedback", ""),
        "strengths": eval_result.get("strengths", []),
        "improvements": eval_result.get("improvements", [])
    }

@router.post("/{id}/hr")
async def submit_hr_round(id: str, payload: HRRoundSubmission, current_user: dict = Depends(get_current_user)):
    attempts_col = get_collection("interview_attempts")
    drives_col = get_collection("mock_drives")
    round_results_col = get_collection("round_results")
    
    attempt = attempts_col.find_one({"_id": id})
    if not attempt:
        raise HTTPException(status_code=404, detail="Interview attempt not found")
        
    drive = drives_col.find_one({"_id": attempt["drive_id"]}) or drives_col.find_one({"id": attempt["drive_id"]})
    rounds_config = drive.get("rounds", {"coding": True, "gd": True, "hr": True}) if drive else {"coding": True, "gd": True, "hr": True}

    answers_list = [a.dict() for a in payload.answers]
    eval_result = AIService.evaluate_hr(answers_list)

    now = datetime.now(timezone.utc).isoformat()
    result_doc = {
        "_id": f"rr-{uuid.uuid4().hex[:8]}",
        "attempt_id": id,
        "round_type": "hr",
        "score": eval_result.get("score", 78),
        "criteria": eval_result.get("criteria", {}),
        "answers": answers_list,
        "strengths": eval_result.get("strengths", []),
        "improvements": eval_result.get("improvements", []),
        "feedback": eval_result.get("feedback", ""),
        "evaluated_at": now
    }
    round_results_col.insert_one(result_doc)

    next_round = calculate_next_round(rounds_config, "hr")
    rounds_status = attempt.get("rounds_status", {})
    rounds_status["hr"] = "completed"
    
    round_scores = attempt.get("round_scores", {})
    round_scores["hr"] = eval_result.get("score", 78)

    attempts_col.update_one({"_id": id}, {
        "$set": {
            "current_round": next_round,
            "progress_percentage": get_progress_pct(next_round),
            "rounds_status": rounds_status,
            "round_scores": round_scores
        }
    })

    return {
        "score": eval_result.get("score", 78),
        "criteria": eval_result.get("criteria", {}),
        "next_round": next_round,
        "feedback": eval_result.get("feedback", ""),
        "strengths": eval_result.get("strengths", []),
        "improvements": eval_result.get("improvements", [])
    }

@router.post("/{id}/complete")
async def complete_interview(id: str, current_user: dict = Depends(get_current_user)):
    attempts_col = get_collection("interview_attempts")
    drives_col = get_collection("mock_drives")
    round_results_col = get_collection("round_results")
    final_results_col = get_collection("final_results")
    
    attempt = attempts_col.find_one({"_id": id})
    if not attempt:
        raise HTTPException(status_code=404, detail="Interview attempt not found")
        
    drive = drives_col.find_one({"_id": attempt["drive_id"]}) or drives_col.find_one({"id": attempt["drive_id"]})
    
    # Retrieve all round scores
    r_results = round_results_col.find({"attempt_id": id})
    scores_dict = {}
    strengths_all = []
    improvements_all = []
    
    for r in r_results:
        rtype = r.get("round_type")
        scores_dict[rtype] = r.get("score", 70)
        strengths_all.extend(r.get("strengths", []))
        improvements_all.extend(r.get("improvements", []))

    # Fallbacks from attempt round_scores if not in r_results
    for k in ["coding", "gd", "hr"]:
        if k not in scores_dict and attempt.get("round_scores", {}).get(k) is not None:
            scores_dict[k] = attempt["round_scores"][k]

    c_score = scores_dict.get("coding", 75)
    g_score = scores_dict.get("gd", 75)
    h_score = scores_dict.get("hr", 75)

    # Requirement 11: Weighting: Coding 40%, GD 25%, HR 35%
    overall = int((c_score * 0.40) + (g_score * 0.25) + (h_score * 0.35))
    
    now = datetime.now(timezone.utc).isoformat()
    final_doc = {
        "_id": f"final-{id}",
        "attempt_id": id,
        "user_id": attempt.get("user_id"),
        "drive_id": attempt.get("drive_id"),
        "overall_score": overall,
        "coding_score": c_score,
        "gd_score": g_score,
        "hr_score": h_score,
        "weighting": {"coding": 0.40, "gd": 0.25, "hr": 0.35},
        "status": "completed",
        "strengths": list(dict.fromkeys(strengths_all))[:4] or [
            "Good algorithmic problem solving foundation",
            "Clear and articulate communication in group setting",
            "Professional personal interview demeanor"
        ],
        "areas_for_improvement": list(dict.fromkeys(improvements_all))[:4] or [
            "Practice writing optimized Kadane's and Dynamic Programming solutions",
            "Incorporate more industry metrics and data points in group discussions",
            "Structure behavioral responses using the STAR method"
        ],
        "recommended_practice_areas": [
            "Data Structures: Sliding Window & Hash Maps",
            "Group Discussion: Structured Argumentation & Rebuttals",
            "Behavioral: STAR Framework for Complex Projects"
        ],
        "completed_at": now
    }
    
    # Save or update final result
    existing = final_results_col.find_one({"attempt_id": id})
    if existing:
        final_results_col.update_one({"_id": existing["_id"]}, {"$set": final_doc})
    else:
        final_results_col.insert_one(final_doc)

    # Update attempt
    attempts_col.update_one({"_id": id}, {
        "$set": {
            "status": "completed",
            "current_round": "completed",
            "progress_percentage": 100,
            "overall_score": overall,
            "completed_at": now
        }
    })

    return {
        "message": "Interview completed successfully",
        "attempt_id": id,
        "overall_score": overall,
        "coding_score": c_score,
        "gd_score": g_score,
        "hr_score": h_score
    }
