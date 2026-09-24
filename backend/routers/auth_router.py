from fastapi import APIRouter, HTTPException, Depends, status
from pydantic import BaseModel
from database import get_collection
from auth import verify_password, hash_password, create_access_token, get_current_user
from models import UserLogin, UserRegister, TokenResponse, UserResponse
from datetime import datetime, timezone
import uuid

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/login", response_model=TokenResponse)
async def login(credentials: UserLogin):
    users_col = get_collection("users")
    user = users_col.find_one({"email": credentials.email.lower().strip()})
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password"
        )
        
    if not verify_password(credentials.password, user.get("password_hash", "")):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password"
        )
        
    user_id = str(user["_id"])
    token = create_access_token({
        "sub": user_id,
        "email": user["email"],
        "role": user.get("role", "student"),
        "name": user.get("name", "User")
    })
    
    return TokenResponse(
        access_token=token,
        token_type="bearer",
        user=UserResponse(
            id=user_id,
            email=user["email"],
            name=user.get("name", "User"),
            role=user.get("role", "student"),
            college=user.get("college"),
            avatar=user.get("avatar"),
            created_at=user.get("created_at")
        )
    )

@router.get("/me", response_model=UserResponse)
async def get_me(current_user: dict = Depends(get_current_user)):
    return UserResponse(
        id=str(current_user["_id"]),
        email=current_user["email"],
        name=current_user.get("name", "User"),
        role=current_user.get("role", "student"),
        college=current_user.get("college"),
        avatar=current_user.get("avatar"),
        created_at=current_user.get("created_at")
    )

@router.post("/register", response_model=TokenResponse)
async def register(req: UserRegister):
    users_col = get_collection("users")
    existing = users_col.find_one({"email": req.email.lower().strip()})
    if existing:
        raise HTTPException(status_code=400, detail="Account with this email already exists")
        
    user_id = f"user-{uuid.uuid4().hex[:8]}"
    now = datetime.now(timezone.utc).isoformat()
    doc = {
        "_id": user_id,
        "email": req.email.lower().strip(),
        "password_hash": hash_password(req.password),
        "name": req.name,
        "role": req.role if req.role in ["student", "interviewer"] else "student",
        "college": req.college or "Tech Institute of Engineering",
        "avatar": f"https://api.dicebear.com/7.x/avataaars/svg?seed={req.name}",
        "created_at": now
    }
    users_col.insert_one(doc)
    
    token = create_access_token({
        "sub": user_id,
        "email": doc["email"],
        "role": doc["role"],
        "name": doc["name"]
    })
    
    return TokenResponse(
        access_token=token,
        token_type="bearer",
        user=UserResponse(
            id=user_id,
            email=doc["email"],
            name=doc["name"],
            role=doc["role"],
            college=doc["college"],
            avatar=doc["avatar"],
            created_at=doc["created_at"]
        )
    )
