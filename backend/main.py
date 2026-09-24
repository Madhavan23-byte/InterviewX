from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from contextlib import asynccontextmanager
import time

from config import settings
from database import db_manager
from seed_data import seed_database

# Routers
from routers.auth_router import router as auth_router
from routers.drives_router import router as drives_router
from routers.interviews_router import router as interviews_router
from routers.results_router import router as results_router
from routers.ai_router import router as ai_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Seed database with mock drives, questions, demo accounts
    print(f"[{settings.PROJECT_NAME}] Starting up backend v{settings.VERSION}...")
    try:
        seed_database()
        print(f"[{settings.PROJECT_NAME}] Seed verification completed.")
    except Exception as e:
        print(f"[{settings.PROJECT_NAME}] Error during startup seeding: {e}")
    yield
    print(f"[{settings.PROJECT_NAME}] Shutting down backend.")

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="Production-quality AI-Powered Mock Placement & Interview Simulation Platform API",
    lifespan=lifespan
)

# CORS setup
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global error handler for resilient responses
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    print(f"[ERROR] Uncaught exception on {request.url.path}: {exc}")
    return JSONResponse(
        status_code=500,
        content={"detail": "An internal server error occurred. Please try again or check backend logs.", "error": str(exc)}
    )

# Include API routers
app.include_router(auth_router, prefix=settings.API_PREFIX)
app.include_router(drives_router, prefix=settings.API_PREFIX)
app.include_router(interviews_router, prefix=settings.API_PREFIX)
app.include_router(results_router, prefix=settings.API_PREFIX)
app.include_router(ai_router, prefix=settings.API_PREFIX)

@app.get("/")
def root():
    return {
        "name": settings.PROJECT_NAME,
        "version": settings.VERSION,
        "status": "online",
        "docs_url": "/docs"
    }

@app.get("/api/health")
def health_check():
    db_stat = db_manager.status()
    return {
        "status": "healthy",
        "timestamp": int(time.time()),
        "database": db_stat,
        "ai_engine": "Gemini API (with heuristic fallback)" if settings.GEMINI_API_KEY else "Deterministic Intelligent Fallback",
        "project": settings.PROJECT_NAME
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
