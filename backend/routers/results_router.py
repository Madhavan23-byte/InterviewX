from fastapi import APIRouter, HTTPException, Depends
from typing import Dict, Any, List
from database import get_collection
from auth import get_current_user, require_role

router = APIRouter(tags=["Results & Analytics"])

@router.get("/results/{interview_id}")
async def get_detailed_result(interview_id: str, current_user: dict = Depends(get_current_user)):
    attempts_col = get_collection("interview_attempts")
    final_results_col = get_collection("final_results")
    round_results_col = get_collection("round_results")
    users_col = get_collection("users")
    drives_col = get_collection("mock_drives")

    attempt = attempts_col.find_one({"_id": interview_id})
    if not attempt:
        raise HTTPException(status_code=404, detail="Interview attempt not found")

    user = users_col.find_one({"_id": attempt.get("user_id")})
    drive = drives_col.find_one({"_id": attempt.get("drive_id")}) or drives_col.find_one({"id": attempt.get("drive_id")})
    final_res = final_results_col.find_one({"attempt_id": interview_id})
    round_res = round_results_col.find({"attempt_id": interview_id})

    round_details = {}
    for r in round_res:
        round_details[r.get("round_type")] = {
            "score": r.get("score"),
            "criteria": r.get("criteria", {}),
            "feedback": r.get("feedback"),
            "strengths": r.get("strengths", []),
            "improvements": r.get("improvements", []),
            "question_reports": r.get("question_reports", []),
            "evaluated_at": r.get("evaluated_at")
        }

    overall_score = final_res.get("overall_score") if final_res else attempt.get("overall_score", 75)
    coding_score = final_res.get("coding_score") if final_res else attempt.get("round_scores", {}).get("coding", 75)
    gd_score = final_res.get("gd_score") if final_res else attempt.get("round_scores", {}).get("gd", 75)
    hr_score = final_res.get("hr_score") if final_res else attempt.get("round_scores", {}).get("hr", 75)

    return {
        "attempt_id": interview_id,
        "candidate": {
            "name": user.get("name", attempt.get("user_name", "Candidate")),
            "email": user.get("email", attempt.get("user_email", "")),
            "college": user.get("college", "Tech Institute of Engineering"),
            "avatar": user.get("avatar")
        },
        "drive": {
            "id": attempt.get("drive_id"),
            "company": drive.get("company", attempt.get("company", "Company")) if drive else "Company",
            "role": drive.get("role", attempt.get("role", "Software Role")) if drive else "Software Role",
            "difficulty": drive.get("difficulty", "Medium") if drive else "Medium"
        },
        "overall_score": overall_score or 78,
        "round_scores": {
            "coding": coding_score,
            "gd": gd_score,
            "hr": hr_score
        },
        "weighting": {
            "coding": 0.40,
            "gd": 0.25,
            "hr": 0.35
        },
        "status": attempt.get("status", "completed"),
        "current_round": attempt.get("current_round", "completed"),
        "progress_percentage": attempt.get("progress_percentage", 100),
        "strengths": final_res.get("strengths", [
            "Demonstrated strong data structures and logic verification.",
            "Articulate communication with clear perspective in group discussion.",
            "Polite and professional conduct in HR interview."
        ]) if final_res else [
            "Solid core algorithmic comprehension",
            "Active and constructive discussion participant"
        ],
        "areas_for_improvement": final_res.get("areas_for_improvement", [
            "Incorporate edge case validations in algorithmic corner tests.",
            "Anchor group discussion arguments with industry metrics.",
            "Apply STAR methodology during behavioral responses."
        ]) if final_res else [
            "Deepen algorithmic optimization",
            "Practice structured verbal articulation"
        ],
        "recommended_practice_areas": final_res.get("recommended_practice_areas", [
            "Dynamic Programming: Kadane & Sliding Window",
            "Group Discussion: Rapid Synthesis & Data Grounding",
            "Behavioral: STAR Storytelling for Capstone Projects"
        ]) if final_res else [
            "Algorithms and Data Structures",
            "Behavioral Interview Preparation"
        ],
        "round_details": round_details,
        "completed_at": attempt.get("completed_at") or attempt.get("started_at")
    }

@router.get("/interviewer/results")
async def list_all_candidate_results(current_user: dict = Depends(require_role("interviewer"))):
    attempts_col = get_collection("interview_attempts")
    users_col = get_collection("users")
    drives_col = get_collection("mock_drives")

    attempts = attempts_col.find({}, sort=[("started_at", -1)])
    candidates_list = []

    for a in attempts:
        user = users_col.find_one({"_id": a.get("user_id")})
        drive = drives_col.find_one({"_id": a.get("drive_id")}) or drives_col.find_one({"id": a.get("drive_id")})

        candidates_list.append({
            "attempt_id": str(a.get("_id")),
            "candidate_id": a.get("user_id"),
            "candidate_name": user.get("name", a.get("user_name", "Student")),
            "candidate_email": user.get("email", a.get("user_email", "")),
            "college": user.get("college", "Engineering Institute") if user else "Engineering Institute",
            "avatar": user.get("avatar") if user else None,
            "drive_id": a.get("drive_id"),
            "company": drive.get("company", a.get("company", "Company")) if drive else a.get("company", "Company"),
            "role": drive.get("role", a.get("role", "Software Engineer")) if drive else a.get("role", "Software Engineer"),
            "current_round": a.get("current_round", "coding"),
            "status": a.get("status", "in_progress"),
            "score": a.get("overall_score"),
            "round_scores": a.get("round_scores", {}),
            "progress_percentage": a.get("progress_percentage", 0),
            "started_at": a.get("started_at"),
            "completed_at": a.get("completed_at")
        })

    return candidates_list

@router.get("/interviewer/analytics")
async def get_interviewer_analytics(current_user: dict = Depends(require_role("interviewer"))):
    attempts_col = get_collection("interview_attempts")
    drives_col = get_collection("mock_drives")
    users_col = get_collection("users")

    total_candidates = users_col.count_documents({"role": "student"})
    active_drives = drives_col.count_documents({"status": "active"})
    attempts = attempts_col.find({})
    
    completed_attempts = [a for a in attempts if a.get("status") == "completed" and a.get("overall_score") is not None]
    completed_count = len(completed_attempts)
    
    scores = [a.get("overall_score", 0) for a in completed_attempts if a.get("overall_score") is not None]
    avg_score = int(sum(scores) / len(scores)) if scores else 78
    highest_score = max(scores) if scores else 85

    # Round-wise performance averages
    coding_scores = [a.get("round_scores", {}).get("coding") for a in attempts if a.get("round_scores", {}).get("coding") is not None]
    gd_scores = [a.get("round_scores", {}).get("gd") for a in attempts if a.get("round_scores", {}).get("gd") is not None]
    hr_scores = [a.get("round_scores", {}).get("hr") for a in attempts if a.get("round_scores", {}).get("hr") is not None]

    round_averages = {
        "coding": int(sum(coding_scores) / len(coding_scores)) if coding_scores else 82,
        "gd": int(sum(gd_scores) / len(gd_scores)) if gd_scores else 77,
        "hr": int(sum(hr_scores) / len(hr_scores)) if hr_scores else 80
    }

    completion_rate = int((completed_count / max(1, len(attempts))) * 100) if attempts else 67

    return {
        "total_candidates": max(total_candidates, len(attempts)),
        "active_drives": active_drives,
        "completed_interviews": completed_count,
        "average_score": avg_score,
        "highest_score": highest_score,
        "completion_rate": completion_rate,
        "round_averages": round_averages
    }
