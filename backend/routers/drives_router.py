from fastapi import APIRouter, HTTPException, Depends, status
from typing import List, Optional
from database import get_collection
from auth import get_current_user, require_role
from models import MockDriveCreate, MockDriveUpdate, MockDriveResponse
from datetime import datetime, timezone
import uuid

router = APIRouter(prefix="/drives", tags=["Mock Drives"])

@router.get("", response_model=List[MockDriveResponse])
async def list_drives(status_filter: Optional[str] = None):
    drives_col = get_collection("mock_drives")
    query = {}
    if status_filter:
        query["status"] = status_filter
        
    drives = drives_col.find(query)
    # Sort newest first
    results = []
    for d in drives:
        results.append(MockDriveResponse(
            id=str(d.get("_id", d.get("id"))),
            company=d.get("company", "Company"),
            role=d.get("role", "Role"),
            description=d.get("description", ""),
            difficulty=d.get("difficulty", "Medium"),
            duration_mins=d.get("duration_mins", 60),
            status=d.get("status", "active"),
            rounds=d.get("rounds", {"coding": True, "gd": True, "hr": True}),
            coding_question_ids=d.get("coding_question_ids", []),
            gd_topic_id=d.get("gd_topic_id"),
            hr_question_ids=d.get("hr_question_ids", []),
            candidates_count=d.get("candidates_count", 0),
            created_at=d.get("created_at", "")
        ))
    return results

@router.get("/{id}")
async def get_drive(id: str):
    drives_col = get_collection("mock_drives")
    drive = drives_col.find_one({"_id": id}) or drives_col.find_one({"id": id})
    if not drive:
        raise HTTPException(status_code=404, detail="Mock drive not found")
        
    drive_id = str(drive.get("_id", drive.get("id")))
    
    # Resolve coding questions
    coding_col = get_collection("coding_questions")
    coding_ids = drive.get("coding_question_ids", [])
    resolved_coding = []
    for qid in coding_ids:
        q = coding_col.find_one({"_id": qid}) or coding_col.find_one({"id": qid})
        if q:
            resolved_coding.append({
                "id": str(q.get("_id", q.get("id"))),
                "title": q.get("title"),
                "difficulty": q.get("difficulty"),
                "category": q.get("category"),
                "description": q.get("description"),
                "constraints": q.get("constraints", []),
                "examples": q.get("examples", []),
                "starter_templates": q.get("starter_templates", {}),
                "test_cases": [
                    {
                        "id": tc.get("id"),
                        "input": tc.get("input"),
                        "expected_output": tc.get("expected_output"),
                        "is_hidden": tc.get("is_hidden", False)
                    } for tc in q.get("test_cases", [])
                ]
            })
            
    # Resolve GD topic
    gd_col = get_collection("gd_topics")
    gd_id = drive.get("gd_topic_id")
    resolved_gd = None
    if gd_id:
        gd = gd_col.find_one({"_id": gd_id}) or gd_col.find_one({"id": gd_id})
        if gd:
            resolved_gd = {
                "id": str(gd.get("_id", gd.get("id"))),
                "title": gd.get("title"),
                "category": gd.get("category"),
                "description": gd.get("description"),
                "prep_time_seconds": gd.get("prep_time_seconds", 60),
                "discussion_time_seconds": gd.get("discussion_time_seconds", 180),
                "key_discussion_points": gd.get("key_discussion_points", []),
                "simulated_peers": gd.get("simulated_peers", [])
            }
            
    # Resolve HR questions
    hr_col = get_collection("hr_questions")
    hr_ids = drive.get("hr_question_ids", [])
    resolved_hr = []
    for hrid in hr_ids:
        hr = hr_col.find_one({"_id": hrid}) or hr_col.find_one({"id": hrid})
        if hr:
            resolved_hr.append({
                "id": str(hr.get("_id", hr.get("id"))),
                "question": hr.get("question"),
                "category": hr.get("category"),
                "tips": hr.get("tips")
            })

    return {
        "id": drive_id,
        "company": drive.get("company"),
        "role": drive.get("role"),
        "description": drive.get("description"),
        "difficulty": drive.get("difficulty"),
        "duration_mins": drive.get("duration_mins"),
        "status": drive.get("status", "active"),
        "rounds": drive.get("rounds", {"coding": True, "gd": True, "hr": True}),
        "coding_questions": resolved_coding,
        "gd_topic": resolved_gd,
        "hr_questions": resolved_hr,
        "candidates_count": drive.get("candidates_count", 0),
        "created_at": drive.get("created_at")
    }

@router.post("", status_code=status.HTTP_201_CREATED)
async def create_drive(payload: MockDriveCreate, current_user: dict = Depends(require_role("interviewer"))):
    drives_col = get_collection("mock_drives")
    new_id = f"drive-{uuid.uuid4().hex[:8]}"
    now = datetime.now(timezone.utc).isoformat()
    
    # Defaults if question ids not passed
    coding_ids = payload.coding_question_ids
    if not coding_ids and payload.rounds.coding:
        coding_ids = ["q-two-sum", "q-reverse-string"]
        
    gd_id = payload.gd_topic_id
    if not gd_id and payload.rounds.gd:
        gd_id = "gd-ai-jobs"
        
    hr_ids = payload.hr_question_ids
    if not hr_ids and payload.rounds.hr:
        hr_ids = ["hr-q1", "hr-q2", "hr-q3", "hr-q4"]

    doc = {
        "_id": new_id,
        "company": payload.company.strip(),
        "role": payload.role.strip(),
        "description": payload.description.strip(),
        "difficulty": payload.difficulty,
        "duration_mins": payload.duration_mins,
        "status": "active",
        "rounds": payload.rounds.dict(),
        "coding_question_ids": coding_ids,
        "gd_topic_id": gd_id,
        "hr_question_ids": hr_ids,
        "candidates_count": 0,
        "created_by": str(current_user["_id"]),
        "created_at": now
    }
    drives_col.insert_one(doc)
    return {"message": "Mock drive created successfully", "id": new_id, "drive": doc}

@router.put("/{id}")
async def update_drive(id: str, payload: MockDriveUpdate, current_user: dict = Depends(require_role("interviewer"))):
    drives_col = get_collection("mock_drives")
    drive = drives_col.find_one({"_id": id}) or drives_col.find_one({"id": id})
    if not drive:
        raise HTTPException(status_code=404, detail="Mock drive not found")
        
    update_data = {}
    if payload.company is not None: update_data["company"] = payload.company
    if payload.role is not None: update_data["role"] = payload.role
    if payload.description is not None: update_data["description"] = payload.description
    if payload.difficulty is not None: update_data["difficulty"] = payload.difficulty
    if payload.duration_mins is not None: update_data["duration_mins"] = payload.duration_mins
    if payload.status is not None: update_data["status"] = payload.status
    if payload.rounds is not None: update_data["rounds"] = payload.rounds.dict()
    if payload.coding_question_ids is not None: update_data["coding_question_ids"] = payload.coding_question_ids
    if payload.gd_topic_id is not None: update_data["gd_topic_id"] = payload.gd_topic_id
    if payload.hr_question_ids is not None: update_data["hr_question_ids"] = payload.hr_question_ids
    
    if update_data:
        drives_col.update_one({"_id": drive["_id"]}, {"$set": update_data})
        
    return {"message": "Mock drive updated successfully", "id": id}

@router.delete("/{id}")
async def delete_drive(id: str, current_user: dict = Depends(require_role("interviewer"))):
    drives_col = get_collection("mock_drives")
    res = drives_col.delete_one({"_id": id})
    if res.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Mock drive not found")
    return {"message": "Mock drive deleted successfully"}
