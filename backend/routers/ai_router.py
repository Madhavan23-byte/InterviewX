from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional
from services.ai_service import AIService
from auth import get_current_user

router = APIRouter(prefix="/ai", tags=["AI Evaluation"])

class GDEvalRequest(BaseModel):
    topic_title: str
    topic_desc: Optional[str] = ""
    response: str

class HRAnswerItem(BaseModel):
    question_text: str
    answer: str

class HREvalRequest(BaseModel):
    answers: List[HRAnswerItem]

@router.post("/evaluate/gd")
async def evaluate_gd(payload: GDEvalRequest, current_user: dict = Depends(get_current_user)):
    if not payload.response or not payload.response.strip():
        raise HTTPException(status_code=400, detail="GD response cannot be empty")
        
    result = AIService.evaluate_gd(
        topic_title=payload.topic_title,
        topic_desc=payload.topic_desc or "",
        student_response=payload.response
    )
    return result

@router.post("/evaluate/hr")
async def evaluate_hr(payload: HREvalRequest, current_user: dict = Depends(get_current_user)):
    if not payload.answers:
        raise HTTPException(status_code=400, detail="Answers list cannot be empty")
        
    answers_dict = [a.dict() for a in payload.answers]
    result = AIService.evaluate_hr(answers_dict)
    return result
