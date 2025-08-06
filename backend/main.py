from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import logging
from base.models import PromptRequest, CodeResponse
from gemini.gemini_services import GeminiService

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Flutter AI Generator API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize LLM service (Gemini for now, easily swappable later)
try:
    logger.info("✅ LLM service initialized successfully")

    SERVICE_TYPE = 'gemini'

    if SERVICE_TYPE.lower() == 'gemini':
        llm_service = GeminiService()
        logger.info("✅ Gemini service initialized successfully")
    elif SERVICE_TYPE.lower() == 'openai':
        llm_service = OpenAIService()
        logger.info("✅ ChatGPT service initialized successfully")
    elif SERVICE_TYPE.lower() == 'claude':
        llm_service = ClaudeService()
        logger.info("✅ Claude service initialized successfully")
    else:
        raise ValueError(f"Unsupported LLM service: {SERVICE_TYPE}")
        
except ValueError as e:
        logger.error(f"❌ Error initializing LLM service: {e}")
        llm_service = None

@app.get("/")
async def root():
    return {
        "message": "Flutter AI Generator API is running",
        "service": llm_service.__class__.__name__ if llm_service else "No service",
        "model": llm_service.current_model_name if llm_service else "No model"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy" if llm_service else "unhealthy",
        "service": llm_service.__class__.__name__ if llm_service else None,
        "model": llm_service.current_model_name if llm_service else None
    }

@app.get("/models")
async def list_models():
    """List available models for the current LLM service"""
    if not llm_service:
        raise HTTPException(status_code=500, detail="LLM service not initialized")
    
    try:
        models = llm_service.list_available_models()
        return {
            "service": llm_service.__class__.__name__,
            "current_model": llm_service.current_model_name,
            "available_models": models
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error listing models: {str(e)}")

@app.post("/generate-ui", response_model=CodeResponse)
async def generate_ui(request: PromptRequest):
    """
    Generate Flutter UI code and JSON representation from natural language prompt
    """
    if not llm_service:
        raise HTTPException(status_code=500, detail="LLM service not initialized")
    
    if not request.prompt.strip():
        raise HTTPException(status_code=400, detail="Prompt cannot be empty")
    
    try:
        logger.info(f"🎨 Processing UI generation request")
        logger.info(f"📝 Prompt: {request.prompt}")
        
        # Generate both Dart code and JSON UI structure
        code, ui_json, success, error_message = llm_service.generate_flutter_code(request.prompt)
        
        response = CodeResponse(
            code=code,
            ui_json=ui_json,
            success=success,
            error=error_message
        )
        
        logger.info(f"✅ UI generation completed: success={success}")
        return response
        
    except Exception as e:
        logger.error(f"❌ Error in generate_ui: {str(e)}")
        return CodeResponse(
            code="",
            ui_json={},
            success=False,
            error=str(e)
        )

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)