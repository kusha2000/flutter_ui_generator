from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import logging
from typing import List, Dict, Any
import asyncio
from concurrent.futures import ThreadPoolExecutor
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
    description="Generate Flutter UI code from natural language descriptions using multiple LLMs",
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

# Initialize all LLM services
services: Dict[str, Any] = {}
SERVICE_TYPES = ['gemini', 'groq', 'cohere', 'huggingface', 'openrouter']

def initialize_services():
    """Initialize all available LLM services"""
    for service_type in SERVICE_TYPES:
        try:
            logger.info(f"🚀 Initializing {service_type.upper()} service...")
            
            if service_type == 'gemini':
                services['gemini'] = GeminiService()
                logger.info("✅ Gemini service initialized successfully")
            elif service_type == 'groq':
                services['groq'] = GroqService()
                logger.info("✅ Groq service initialized successfully")
            elif service_type == 'cohere':
                services['cohere'] = CohereService()
                logger.info("✅ Cohere service initialized successfully")
            elif service_type == 'huggingface':
                services['huggingface'] = HuggingFaceService()
                logger.info("✅ HuggingFace service initialized successfully")
            elif service_type == 'openrouter':
                services['openrouter'] = OpenRouterService()
                logger.info("✅ OpenRouter service initialized successfully")
                
        except Exception as e:
            logger.warning(f"⚠️ Error initializing {service_type} service: {e}")
            services[service_type] = None

# Initialize services on startup
initialize_services()

def generate_code_with_service(service_name: str, service: Any, prompt: str) -> Dict[str, Any]:
    """Generate code using a single service"""
    try:
        if service is None:
            return {
                "service": service_name,
                "success": False,
                "error": "Service not initialized",
                "code": None,
                "widget_name": None
            }
        
        logger.info(f"🔄 Generating code with {service_name}...")
        code, success, error = service.generate_flutter_code(prompt)
        
        return {
            "service": service_name,
            "success": success,
            "error": error,
            "code": code,
            "widget_name": service.widget_name,
            "model": service.current_model_name
        }
    except Exception as e:
        logger.error(f"❌ Error with {service_name}: {str(e)}")
        return {
            "service": service_name,
            "success": False,
            "error": f"Generation failed: {str(e)}",
            "code": None,
            "widget_name": None
        }

@app.get("/")
async def root():
    """Root endpoint with service information"""
    available_services = []
    for name, service in services.items():
        if service:
            available_services.append({
                "service": name,
                "model": service.current_model_name,
                "widget": service.widget_name
            })
    
    return {
        "message": "Flutter AI Generator API (Multi-LLM)",
        "version": "2.0.0",
        "status": "running",
        "available_services": available_services,
        "total_services": len(available_services)
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    available_count = sum(1 for s in services.values() if s is not None)
    
    return {
        "status": "healthy" if available_count > 0 else "unhealthy",
        "available_services": available_count,
        "total_services": len(SERVICE_TYPES),
        "services_status": {
            name: "initialized" if service else "failed"
            for name, service in services.items()
        }
    }

@app.get("/models")
async def list_models():
    """List available models for all initialized services"""
    models_info = {}
    
    for name, service in services.items():
        if service:
            try:
                models = service.list_available_models()
                models_info[name] = {
                    "current_model": service.current_model_name,
                    "available_models": models
                }
            except Exception as e:
                models_info[name] = {"error": str(e)}
        else:
            models_info[name] = {"status": "not initialized"}
    
    return {
        "services_models": models_info,
        "total_available_services": sum(1 for s in services.values() if s is not None)
    }

@app.post("/generate-ui")
async def generate_ui(request: PromptRequest):
    """
    Generate Flutter UI code from natural language prompt using ALL services
    
    Returns:
    - results: Array of results from each service
      - service: Service name
      - code: Generated Flutter/Dart code
      - success: Whether generation was successful
      - error: Error message if failed
      - widget_name: Name of the generated widget class
      - model: Model used by the service
    - summary: Summary of generation results
    """
    if not services or all(v is None for v in services.values()):
        raise HTTPException(
            status_code=503,
            detail="No LLM services initialized. Please check server logs."
        )
    
    if not request.prompt or not request.prompt.strip():
        raise HTTPException(
            status_code=400,
            detail="Prompt cannot be empty"
        )
    
    try:
        logger.info("=" * 80)
        logger.info(f"🎨 NEW MULTI-SERVICE UI GENERATION REQUEST")
        logger.info(f"📝 Prompt: {request.prompt}")
        logger.info(f"🔧 Services: {len(services)} available")
        logger.info("=" * 80)
        
        # Generate code with all services in parallel
        results = []
        
        with ThreadPoolExecutor(max_workers=5) as executor:
            futures = []
            for service_name, service in services.items():
                future = executor.submit(
                    generate_code_with_service,
                    service_name,
                    service,
                    request.prompt
                )
                futures.append(future)
            
            # Collect results as they complete
            for future in futures:
                result = future.result()
                results.append(result)
        
        # Calculate summary
        successful = sum(1 for r in results if r['success'])
        failed = len(results) - successful
        
        logger.info("=" * 80)
        logger.info(f"✅ MULTI-SERVICE GENERATION COMPLETED")
        logger.info(f"   Total services: {len(results)}")
        logger.info(f"   Successful: {successful}")
        logger.info(f"   Failed: {failed}")
        logger.info("=" * 80)
        
        return {
            "results": results,
            "summary": {
                "total_services": len(results),
                "successful": successful,
                "failed": failed,
                "timestamp": None
            }
        }
        
    except Exception as e:
        logger.error("=" * 80)
        logger.error(f"❌ MULTI-SERVICE GENERATION FAILED")
        logger.error(f"   Error: {str(e)}")
        logger.error("=" * 80)
        
        raise HTTPException(
            status_code=500,
            detail=f"Generation failed: {str(e)}"
        )

@app.get("/service-info")
async def service_info():
    """Get detailed information about all initialized services"""
    info = {}
    
    for name, service in services.items():
        if service:
            info[name] = {
                "service_class": service.__class__.__name__,
                "widget_name": service.widget_name,
                "current_model": service.current_model_name,
                "generation_config": {
                    "temperature": service.generation_config.temperature,
                    "top_p": service.generation_config.top_p,
                    "top_k": service.generation_config.top_k,
                    "max_output_tokens": service.generation_config.max_output_tokens
                },
                "retry_config": {
                    "max_retries": service.retry_config.max_retries,
                    "base_delay": service.retry_config.base_delay,
                    "max_delay": service.retry_config.max_delay
                }
            }
        else:
            info[name] = {"status": "not initialized"}
    
    return info

if __name__ == "__main__":
    logger.info("🚀 Starting Flutter AI Generator API (Multi-LLM)...")
    uvicorn.run(
        app, 
        host="0.0.0.0", 
        port=8000,
        log_level="info"
    )