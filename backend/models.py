from pydantic import BaseModel, Field, EmailStr
from typing import List, Optional, Dict, Any
from datetime import datetime

# --- Auth Models ---
class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserRegister(BaseModel):
    email: EmailStr
    password: str
    name: str
    role: str = "student" # "student" or "interviewer"
    college: Optional[str] = "Tech Institute of Engineering"

class UserResponse(BaseModel):
    id: str
    email: str
    name: str
    role: str
    college: Optional[str] = None
    avatar: Optional[str] = None
    created_at: Optional[str] = None

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse

# --- Coding Round Models ---
class TestCase(BaseModel):
    id: str
    input: str
    expected_output: str
    is_hidden: bool = False

class CodingQuestion(BaseModel):
    id: str
    title: str
    difficulty: str = "Easy" # Easy, Medium, Hard
    category: str = "Algorithms"
    description: str
    constraints: List[str] = []
    examples: List[Dict[str, Any]] = []
    starter_templates: Dict[str, str] = {}
    test_cases: List[TestCase] = []

class CodingSubmissionItem(BaseModel):
    question_id: str
    language: str
    code: str

class CodingRoundSubmission(BaseModel):
    submissions: List[CodingSubmissionItem]
    time_taken_seconds: Optional[int] = 0

class CodeRunRequest(BaseModel):
    question_id: str
    language: str
    code: str
    custom_input: Optional[str] = None

# --- GD Round Models ---
class SimulatedPeer(BaseModel):
    id: str
    name: str
    avatar: str
    stance: str # "For" or "Against" or "Balanced"
    message: str
    delay_seconds: int = 2

class GDTopic(BaseModel):
    id: str
    title: str
    category: str = "Technology & Society"
    description: str
    prep_time_seconds: int = 60
    discussion_time_seconds: int = 180
    simulated_peers: List[SimulatedPeer] = []
    key_discussion_points: List[str] = []

class GDRoundSubmission(BaseModel):
    topic_id: str
    response: str
    speech_notes: Optional[str] = None
    time_taken_seconds: Optional[int] = 0

# --- HR Round Models ---
class HRQuestion(BaseModel):
    id: str
    question: str
    category: str = "Behavioral"
    tips: Optional[str] = None

class HRAnswerItem(BaseModel):
    question_id: str
    question_text: str
    answer: str

class HRRoundSubmission(BaseModel):
    answers: List[HRAnswerItem]
    time_taken_seconds: Optional[int] = 0

# --- AI Evaluation Schemas ---
class CriteriaScores(BaseModel):
    clarity: int = Field(default=75, ge=0, le=100)
    relevance: int = Field(default=75, ge=0, le=100)
    structure: int = Field(default=75, ge=0, le=100)
    communication: int = Field(default=75, ge=0, le=100)
    critical_thinking: Optional[int] = Field(default=75, ge=0, le=100)
    professionalism: Optional[int] = Field(default=75, ge=0, le=100)

class AIEvaluationResult(BaseModel):
    score: int
    criteria: Dict[str, int]
    strengths: List[str]
    improvements: List[str]
    feedback: str

# --- Mock Drive Models ---
class RoundConfig(BaseModel):
    coding: bool = True
    gd: bool = True
    hr: bool = True

class MockDriveCreate(BaseModel):
    company: str
    role: str
    description: str
    difficulty: str = "Medium" # Easy, Medium, Hard
    duration_mins: int = 60
    rounds: RoundConfig = RoundConfig()
    coding_question_ids: List[str] = []
    gd_topic_id: Optional[str] = None
    hr_question_ids: List[str] = []

class MockDriveUpdate(BaseModel):
    company: Optional[str] = None
    role: Optional[str] = None
    description: Optional[str] = None
    difficulty: Optional[str] = None
    duration_mins: Optional[int] = None
    status: Optional[str] = None # "active", "inactive"
    rounds: Optional[RoundConfig] = None
    coding_question_ids: Optional[List[str]] = None
    gd_topic_id: Optional[str] = None
    hr_question_ids: Optional[List[str]] = None

class MockDriveResponse(BaseModel):
    id: str
    company: str
    role: str
    description: str
    difficulty: str
    duration_mins: int
    status: str
    rounds: RoundConfig
    coding_question_ids: List[str]
    gd_topic_id: Optional[str]
    hr_question_ids: List[str]
    candidates_count: int = 0
    created_at: str

# --- Interview Attempt & Results ---
class StartInterviewRequest(BaseModel):
    drive_id: str

class InterviewAttemptResponse(BaseModel):
    id: str
    user_id: str
    drive_id: str
    drive: Optional[Dict[str, Any]] = None
    current_round: str # "coding", "gd", "hr", "completed"
    status: str # "in_progress", "completed", "abandoned"
    progress_percentage: int
    rounds_status: Dict[str, str] # e.g. {"coding": "completed", "gd": "current", "hr": "locked"}
    round_scores: Dict[str, Optional[int]]
    started_at: str
    completed_at: Optional[str] = None

class FinalReportResponse(BaseModel):
    attempt_id: str
    candidate_name: str
    candidate_email: str
    company: str
    role: str
    overall_score: int
    coding_score: Optional[int] = None
    gd_score: Optional[int] = None
    hr_score: Optional[int] = None
    weighting: Dict[str, float]
    status: str
    round_details: Dict[str, Any]
    strengths: List[str]
    areas_for_improvement: List[str]
    recommended_practice_areas: List[str]
    completed_at: Optional[str] = None
