import os
from pydantic import BaseModel
from dotenv import load_dotenv

# Load .env if present
load_dotenv()

class Settings(BaseModel):
    PROJECT_NAME: str = "InterviewX"
    VERSION: str = "1.0.0"
    API_PREFIX: str = "/api"
    
    # Database
    MONGO_URI: str = os.getenv("MONGO_URI", "mongodb://localhost:27017")
    DB_NAME: str = os.getenv("DB_NAME", "interviewx")
    
    # Auth
    JWT_SECRET: str = os.getenv("JWT_SECRET", "super-secret-interviewx-jwt-key-change-in-prod-123456789")
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "1440")) # 24 hours
    
    # AI - Gemini
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")
    GEMINI_MODEL: str = os.getenv("GEMINI_MODEL", "gemini-1.5-flash")
    
    # CORS
    CORS_ORIGINS: list = [
        "http://localhost:5173",
        "http://127.0.0.1:5173",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "*"
    ]

settings = Settings()
