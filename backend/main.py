from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, Dict, Any
from gemini_services import GeminiService
import uvicorn

app = FastAPI(title="Flutter AI Generator API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Gemini service
try:
    gemini_service = GeminiService()
except ValueError as e:
    print(f"Error initializing Gemini service: {e}")
    gemini_service = None

class PromptRequest(BaseModel):
    prompt: str

class CodeResponse(BaseModel):
    code: str
    ui_json: Dict[str, Any]
    success: bool
    error: Optional[str] = None

@app.get("/")
async def root():
    return {"message": "Flutter AI Generator API is running"}

@app.post("/generate-ui", response_model=CodeResponse)
async def generate_ui(request: PromptRequest):
    """
    Generate Flutter UI code and JSON representation from natural language prompt
    """
    if not gemini_service:
        raise HTTPException(status_code=500, detail="Gemini service not initialized")
    
    if not request.prompt.strip():
        raise HTTPException(status_code=400, detail="Prompt cannot be empty")
    
    try:
        # Generate both Dart code and JSON UI structure
        code, ui_json, success, error_message = gemini_service.generate_flutter_code(request.prompt)
        
        return CodeResponse(
            code=code,
            ui_json=ui_json,
            success=success,
            error=error_message
        )
    except Exception as e:
        return CodeResponse(
            code="",
            ui_json={},
            success=False,
            error=str(e)
        )

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)