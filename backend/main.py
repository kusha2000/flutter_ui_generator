from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import logging
from base.models import PromptRequest, CodeResponse
from gemini.gemini_services import GeminiService
from groqs.groq_services import GroqService
from coheres.cohere_services import CohereService
from huggingFace.huggingFace_services import HuggingFaceService
from openRouter.openRouter_services import OpenRouterService

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="Flutter AI Generator API",
    description="Generate Flutter UI code from natural language descriptions",
    version="2.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize LLM service
SERVICE_TYPE = 'huggingface'  # Options: 'gemini', 'openai', 'claude'

try:
    logger.info(f"🚀 Initializing {SERVICE_TYPE.upper()} service...")
    
    if SERVICE_TYPE.lower() == 'gemini':
        llm_service = GeminiService()
        logger.info("✅ Gemini service initialized successfully")
    elif SERVICE_TYPE.lower() == 'groq':
        llm_service = GroqService()
        logger.info("✅ Groq service initialized successfully")
        # raise NotImplementedError("OpenAI service not yet implemented")
    elif SERVICE_TYPE.lower() == 'cohere':
        llm_service = CohereService()
        logger.info("✅ cohere service initialized successfully")
    elif SERVICE_TYPE.lower() == 'huggingface':
        llm_service = HuggingFaceService()
        logger.info("✅ huggingFace service initialized successfully")
    else:
        raise ValueError(f"Unsupported LLM service: {SERVICE_TYPE}")
        
except Exception as e:
    logger.error(f"❌ Error initializing LLM service: {e}")
    llm_service = None

@app.get("/")
async def root():
    """Root endpoint with service information"""
    return {
        "message": "Flutter AI Generator API",
        "version": "2.0.0",
        "status": "running",
        "service": llm_service.__class__.__name__ if llm_service else "No service",
        "model": llm_service.current_model_name if llm_service else "No model",
        "widget_name": llm_service.widget_name if llm_service else None
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    is_healthy = llm_service is not None
    return {
        "status": "healthy" if is_healthy else "unhealthy",
        "service": llm_service.__class__.__name__ if llm_service else None,
        "model": llm_service.current_model_name if llm_service else None,
        "widget_name": llm_service.widget_name if llm_service else None
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
            "available_models": models,
            "widget_name": llm_service.widget_name
        }
    except Exception as e:
        logger.error(f"❌ Error listing models: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error listing models: {str(e)}")

@app.post("/generate-ui", response_model=CodeResponse)
async def generate_ui(request: PromptRequest):
    """
    Generate Flutter UI code from natural language prompt
    
    Returns:
    - code: Generated Flutter/Dart code
    - success: Whether generation was successful
    - error: Error message if failed
    - widget_name: Name of the generated widget class
    """
    if not llm_service:
        raise HTTPException(
            status_code=503,
            detail="LLM service not initialized. Please check server logs."
        )
    
    if not request.prompt or not request.prompt.strip():
        raise HTTPException(
            status_code=400,
            detail="Prompt cannot be empty"
        )
    
    try:
        logger.info("=" * 80)
        logger.info(f"🎨 NEW UI GENERATION REQUEST")
        logger.info(f"📝 Prompt: {request.prompt}")
        logger.info(f"🔧 Service: {llm_service.__class__.__name__}")
        logger.info(f"🎯 Widget: {llm_service.widget_name}")
        logger.info("=" * 80)
        
        # Generate Flutter code
        code, success, error_message = llm_service.generate_flutter_code(request.prompt)
        
        response = CodeResponse(
            code=code,
            success=success,
            error=error_message,
            widget_name=llm_service.widget_name
        )
        
        logger.info("=" * 80)
        logger.info(f"✅ GENERATION COMPLETED")
        logger.info(f"   Success: {success}")
        logger.info(f"   Code length: {len(code)} characters")
        logger.info(f"   Widget name: {llm_service.widget_name}")
        if error_message:
            logger.error(f"   Error: {error_message}")
        logger.info("=" * 80)
        
        return response
        
    except Exception as e:
        logger.error("=" * 80)
        logger.error(f"❌ GENERATION FAILED")
        logger.error(f"   Error: {str(e)}")
        logger.error("=" * 80)
        
        # Return fallback response instead of raising exception
        from base.code_processor import CodeProcessor
        processor = CodeProcessor()
        fallback_code = processor.get_professional_fallback_widget(
            str(e), 
            llm_service.widget_name if llm_service else "GeneratedWidget"
        )
        
        return CodeResponse(
            code=fallback_code,
            success=False,
            error=f"Generation failed: {str(e)}",
            widget_name=llm_service.widget_name if llm_service else "GeneratedWidget"
        )

@app.get("/service-info")
async def service_info():
    """Get detailed information about the current service configuration"""
    if not llm_service:
        raise HTTPException(status_code=500, detail="LLM service not initialized")
    
    return {
        "service_type": llm_service.service_type,
        "service_class": llm_service.__class__.__name__,
        "widget_name": llm_service.widget_name,
        "current_model": llm_service.current_model_name,
        "generation_config": {
            "temperature": llm_service.generation_config.temperature,
            "top_p": llm_service.generation_config.top_p,
            "top_k": llm_service.generation_config.top_k,
            "max_output_tokens": llm_service.generation_config.max_output_tokens
        },
        "retry_config": {
            "max_retries": llm_service.retry_config.max_retries,
            "base_delay": llm_service.retry_config.base_delay,
            "max_delay": llm_service.retry_config.max_delay
        }
    }

if __name__ == "__main__":
    logger.info("🚀 Starting Flutter AI Generator API...")
    uvicorn.run(
        app, 
        host="0.0.0.0", 
        port=8000,
        log_level="info"
    )