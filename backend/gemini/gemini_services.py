
import google.generativeai as genai
import os
from dotenv import load_dotenv
import logging
from typing import Optional
import sys
from pathlib import Path

# Add the backend directory to the Python path
backend_dir = Path(__file__).parent.parent
sys.path.insert(0, str(backend_dir))

from base.llm_service import BaseLLMService
from base.models import GenerationConfig, RetryConfig

logger = logging.getLogger(__name__)

class GeminiService(BaseLLMService):
    """Gemini-specific implementation of the LLM service"""
    
    def __init__(self, generation_config: GenerationConfig = None, retry_config: RetryConfig = None):
        load_dotenv()
        
        # Gemini-specific generation config
        if generation_config is None:
            generation_config = GenerationConfig(
                temperature=0.7,
                top_p=0.8,
                top_k=40,
                max_output_tokens=8192
            )
        
        super().__init__(generation_config, retry_config)
        
        self.api_key = os.getenv('GEMINI_API_KEY')
        logger.info(f"🔑 Gemini API Key loaded: {'✅ Found' if self.api_key else '❌ Missing'}")
        
        if not self.api_key:
            logger.error("❌ GEMINI_API_KEY not found in environment variables")
            raise ValueError("GEMINI_API_KEY not found in environment variables")
        
        logger.info("⚙️ Configuring Gemini AI...")
        genai.configure(api_key=self.api_key)
        
        # Configure generation settings for Gemini
        self.gemini_generation_config = {
            'temperature': self.generation_config.temperature,
            'top_p': self.generation_config.top_p,
            'top_k': self.generation_config.top_k,
            'max_output_tokens': self.generation_config.max_output_tokens,
        }
        
        # Safety settings to avoid blocks
        self.safety_settings = [
            {
                "category": "HARM_CATEGORY_HARASSMENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
                "category": "HARM_CATEGORY_HATE_SPEECH",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
                "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
                "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            }
        ]
        
        # Initialize the model
        if not self._initialize_model():
            raise ValueError("Failed to initialize Gemini model")
    
    def _initialize_model(self) -> bool:
        """Initialize the Gemini model"""
        model_names = [
            'gemini-1.5-flash',
            'gemini-1.5-pro',
            'gemini-1.0-pro',
            'gemini-pro'
        ]
        
        logger.info(f"🔍 Attempting to initialize models in order: {model_names}")
        
        for i, model_name in enumerate(model_names):
            try:
                logger.info(f"🔄 [{i+1}/{len(model_names)}] Trying to initialize model: {model_name}")
                
                self.model = genai.GenerativeModel(
                    model_name,
                    generation_config=self.gemini_generation_config,
                    safety_settings=self.safety_settings
                )
                
                # Test the model with a simple request
                logger.info(f"🧪 Testing model {model_name} with simple request...")
                test_response = self.model.generate_content("Hello")
                
                if test_response.text:
                    logger.info(f"✅ Successfully initialized and tested model: {model_name}")
                    logger.info(f"📝 Test response received: {test_response.text[:50]}...")
                    self.current_model_name = model_name
                    return True
                else:
                    logger.warning(f"⚠️ Model {model_name} initialized but returned empty test response")
                    
            except Exception as e:
                logger.error(f"❌ Failed to initialize {model_name}: {str(e)}")
                continue
        
        logger.error("💥 No available Gemini models found")
        return False
    
    def _make_api_request(self, prompt: str) -> Optional[str]:
        """Make a single API request to Gemini"""
        try:
            response = self.model.generate_content(prompt)
            return response.text if response.text else None
        except Exception as e:
            logger.error(f"❌ Gemini API request failed: {str(e)}")
            # Re-raise the exception so the retry logic can handle it
            raise e
    
    def list_available_models(self):
        """List all available Gemini models"""
        logger.info("📋 Listing available Gemini models...")
        
        try:
            models = genai.list_models()
            logger.info("📋 Available models:")
            
            model_list = []
            for i, model in enumerate(models):
                logger.info(f"  {i+1}. {model.name}")
                logger.info(f"     Supported methods: {model.supported_generation_methods}")
                model_list.append({
                    'name': model.name,
                    'supported_methods': model.supported_generation_methods
                })
            
            logger.info(f"📊 Total models found: {len(model_list)}")
            return model_list
            
        except Exception as e:
            logger.error(f"❌ Error listing models: {str(e)}")
            return []