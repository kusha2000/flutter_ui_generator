import cohere
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

class CohereService(BaseLLMService):
    """Cohere-specific implementation of the LLM service"""
    
    def __init__(self, generation_config: GenerationConfig = None, retry_config: RetryConfig = None):
        load_dotenv()
        
        # Initialize API key first
        self.api_key = os.getenv('COHERE_API_KEY')
        logger.info(f"🔑 Cohere API Key loaded: {'✅ Found' if self.api_key else '❌ Missing'}")
        
        if not self.api_key:
            logger.error("❌ COHERE_API_KEY not found in environment variables")
            raise ValueError("COHERE_API_KEY not found in environment variables")
        
        # Cohere-specific generation config optimized for code generation
        if generation_config is None:
            generation_config = GenerationConfig(
                temperature=0.4,
                top_p=0.8,
                top_k=40,
                max_output_tokens=4096
            )
        
        # Initialize parent class BEFORE trying to initialize the model
        super().__init__(generation_config, retry_config)
        
        logger.info("⚙️ Configuring Cohere AI...")
        # Use the correct Cohere v5+ API initialization
        self.client = cohere.ClientV2(api_key=self.api_key)
        
        # Initialize the model - this must succeed
        if not self._initialize_model():
            error_msg = "Failed to initialize any Cohere model. Please check your API key and network connection."
            logger.error(f"💥 {error_msg}")
            raise ValueError(error_msg)
        
        logger.info(f"✅ CohereService initialized successfully with model: {self.current_model_name}")
    
    def _get_available_models(self):
        """Get list of available Cohere models"""
        try:
            logger.info("📋 Fetching available models...")
            # Cohere models that support chat/generation
            # Try newer models first
            available = [
                'command-r-plus-08-2024',
                'command-r-08-2024', 
                'command-r-plus',
                'command-r',
                'command',
                'command-light'
            ]
            
            for model in available:
                logger.info(f"  ✓ {model}")
            
            return available
        except Exception as e:
            logger.error(f"❌ Error fetching models: {str(e)}")
            return []
    
    def _initialize_model(self) -> bool:
        """Initialize the Cohere model"""
        available_models = self._get_available_models()
        
        if not available_models:
            logger.warning("⚠️ Could not fetch models, using fallback list")
            available_models = ['command-r-plus', 'command-r', 'command']
        
        logger.info(f"🔍 Testing {len(available_models)} models...")
        
        for i, model_name in enumerate(available_models):
            try:
                logger.info(f"🔄 [{i+1}/{len(available_models)}] Testing: {model_name}")
                
                # Test the model with a simple request
                test_response = self.client.chat(
                    model=model_name,
                    messages=[{"role": "user", "content": "Hi"}],
                    temperature=0.3,
                    max_tokens=10
                )
                
                if test_response.message and test_response.message.content:
                    response_text = test_response.message.content[0].text
                    logger.info(f"✅ Model {model_name} working!")
                    logger.info(f"📝 Test response: {response_text[:50]}")
                    
                    # CRITICAL FIX: Set both model attributes
                    self.current_model_name = model_name
                    self.model = self.client  # The parent class checks for self.model
                    
                    logger.info(f"✅ self.model set to: {type(self.model)}")
                    logger.info(f"✅ self.current_model_name set to: {self.current_model_name}")
                    return True
                else:
                    logger.warning(f"⚠️ Model {model_name} returned empty response")
                    
            except Exception as e:
                error_str = str(e)
                logger.error(f"❌ Model {model_name} failed: {error_str}")
                
                # If it's an API key issue, stop trying
                if 'api_key' in error_str.lower() or 'unauthorized' in error_str.lower():
                    logger.error("🔑 API key issue detected - stopping model tests")
                    return False
                
                continue
        
        logger.error("💥 No available Cohere models could be initialized")
        return False
    
    def _make_api_request(self, prompt: str) -> Optional[str]:
        """Make a single API request to Cohere"""
        if not hasattr(self, 'current_model_name') or not self.current_model_name:
            raise ValueError("Model not initialized. Cannot make API request.")
        
        try:
            logger.info(f"🚀 Making API request to Cohere ({self.current_model_name})...")
            response = self.client.chat(
                model=self.current_model_name,
                messages=[{"role": "user", "content": prompt}],
                temperature=self.generation_config.temperature,
                p=self.generation_config.top_p,
                k=self.generation_config.top_k,
                max_tokens=self.generation_config.max_output_tokens
            )
            
            if response.message and response.message.content:
                response_text = response.message.content[0].text
                logger.info(f"✅ Received response ({len(response_text)} chars)")
                return response_text
            else:
                logger.warning("⚠️ Empty response from Cohere")
                return None
        except Exception as e:
            logger.error(f"❌ Cohere API request failed: {str(e)}")
            raise e
    
    def list_available_models(self):
        """List all available Cohere models"""
        logger.info("📋 Listing available Cohere models...")
        try:
            models = self._get_available_models()
            logger.info(f"📊 Found {len(models)} models")
            model_list = []
            
            for i, model in enumerate(models):
                model_list.append({
                    'name': model,
                    'supported_methods': ['chat', 'generate']
                })
            
            return model_list
        except Exception as e:
            logger.error(f"❌ Error listing models: {str(e)}")
            return []