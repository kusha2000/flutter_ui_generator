import requests
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

class OpenRouterService(BaseLLMService):
    """OpenRouter-specific implementation of the LLM service"""
    
    def __init__(self, generation_config: GenerationConfig = None, retry_config: RetryConfig = None):
        load_dotenv()
        
        # Initialize API key first
        self.api_key = os.getenv('OPENROUTER_API_KEY')
        logger.info(f"🔑 OpenRouter API Key loaded: {'✅ Found' if self.api_key else '❌ Missing'}")
        
        if not self.api_key:
            logger.error("❌ OPENROUTER_API_KEY not found in environment variables")
            raise ValueError("OPENROUTER_API_KEY not found in environment variables")
        
        # OpenRouter-specific generation config optimized for code generation
        if generation_config is None:
            generation_config = GenerationConfig(
                temperature=0.3,
                top_p=0.9,
                top_k=40,
                max_output_tokens=4096
            )
        
        # Initialize parent class BEFORE trying to initialize the model
        super().__init__(generation_config, retry_config)
        
        logger.info("⚙️ Configuring OpenRouter...")
        self.base_url = "https://openrouter.ai/api/v1"
        self.headers = {
            "Authorization": f"Bearer {self.api_key}",
            "HTTP-Referer": "https://myapp.com",
            "X-Title": "LLM Code Generation Service"
        }
        
        # Initialize the model - this must succeed
        if not self._initialize_model():
            error_msg = "Failed to initialize any OpenRouter model. Please check your API key and network connection."
            logger.error(f"💥 {error_msg}")
            raise ValueError(error_msg)
        
        logger.info(f"✅ OpenRouterService initialized successfully with model: {self.current_model_name}")
    
    def _get_available_models(self):
        """Get list of available OpenRouter models optimized for code generation"""
        try:
            logger.info("📋 Fetching available models...")
            # OpenRouter models that support code generation
            # Prioritized by quality and code generation capability
            available = [
                'meta-llama/llama-3.3-70b-instruct',
                'mistralai/mistral-large-2',
                'meta-llama/llama-3.1-405b-instruct',
                'qwen/qwen-2.5-72b-instruct',
                'meta-llama/llama-3.1-70b-instruct',
                'mistralai/mistral-small-24b-instruct-2501',
                'meta-llama/llama-3.2-11b-vision-instruct',
                'google/gemma-2-9b-it',
                'mistralai/mistral-nemo',
                'meta-llama/llama-3.2-3b-instruct',
            ]
            
            for model in available:
                logger.info(f"  ✓ {model}")
            
            return available
        except Exception as e:
            logger.error(f"❌ Error fetching models: {str(e)}")
            return []
    
    def _initialize_model(self) -> bool:
        """Initialize the OpenRouter model"""
        available_models = self._get_available_models()
        
        if not available_models:
            logger.warning("⚠️ Could not fetch models, using fallback list")
            available_models = [
                'meta-llama/llama-3.3-70b-instruct',
                'mistralai/mistral-large-2'
            ]
        
        logger.info(f"🔍 Testing {len(available_models)} models...")
        
        for i, model_name in enumerate(available_models):
            try:
                logger.info(f"🔄 [{i+1}/{len(available_models)}] Testing: {model_name}")
                
                # Test the model with a simple request
                response = requests.post(
                    f"{self.base_url}/chat/completions",
                    headers=self.headers,
                    json={
                        "model": model_name,
                        "messages": [{"role": "user", "content": "Hi"}],
                        "temperature": 0.3,
                        "max_tokens": 10
                    },
                    timeout=30
                )
                
                if response.status_code == 200:
                    response_data = response.json()
                    if response_data.get("choices") and len(response_data["choices"]) > 0:
                        response_text = response_data["choices"][0]["message"]["content"]
                        logger.info(f"✅ Model {model_name} working!")
                        logger.info(f"📝 Test response: {response_text[:50]}")
                        
                        # CRITICAL FIX: Set both model attributes
                        self.current_model_name = model_name
                        self.model = self  # Reference to self for parent class compatibility
                        
                        logger.info(f"✅ self.model set successfully")
                        logger.info(f"✅ self.current_model_name set to: {self.current_model_name}")
                        return True
                    else:
                        logger.warning(f"⚠️ Model {model_name} returned empty response")
                else:
                    error_msg = response.json().get("error", {}).get("message", "Unknown error")
                    logger.error(f"❌ Model {model_name} failed with status {response.status_code}: {error_msg}")
                    
                    # If it's an API key issue, stop trying
                    if "unauthorized" in error_msg.lower() or "invalid" in error_msg.lower():
                        logger.error("🔑 API key issue detected - stopping model tests")
                        return False
                    
                    continue
                    
            except requests.exceptions.Timeout:
                logger.error(f"❌ Model {model_name} request timed out")
                continue
            except Exception as e:
                error_str = str(e)
                logger.error(f"❌ Model {model_name} failed: {error_str}")
                continue
        
        logger.error("💥 No available OpenRouter models could be initialized")
        return False
    
    def _make_api_request(self, prompt: str) -> Optional[str]:
        """Make a single API request to OpenRouter"""
        if not hasattr(self, 'current_model_name') or not self.current_model_name:
            raise ValueError("Model not initialized. Cannot make API request.")
        
        try:
            logger.info(f"🚀 Making API request to OpenRouter ({self.current_model_name})...")
            
            response = requests.post(
                f"{self.base_url}/chat/completions",
                headers=self.headers,
                json={
                    "model": self.current_model_name,
                    "messages": [{"role": "user", "content": prompt}],
                    "temperature": self.generation_config.temperature,
                    "top_p": self.generation_config.top_p,
                    "top_k": self.generation_config.top_k,
                    "max_tokens": self.generation_config.max_output_tokens
                },
                timeout=60
            )
            
            if response.status_code == 200:
                response_data = response.json()
                if response_data.get("choices") and len(response_data["choices"]) > 0:
                    response_text = response_data["choices"][0]["message"]["content"]
                    logger.info(f"✅ Received response ({len(response_text)} chars)")
                    return response_text
                else:
                    logger.warning("⚠️ Empty response from OpenRouter")
                    return None
            else:
                error_msg = response.json().get("error", {}).get("message", "Unknown error")
                logger.error(f"❌ OpenRouter API request failed with status {response.status_code}: {error_msg}")
                raise Exception(f"OpenRouter API error: {error_msg}")
                
        except requests.exceptions.Timeout:
            logger.error("❌ OpenRouter API request timed out")
            raise Exception("OpenRouter API request timed out")
        except Exception as e:
            logger.error(f"❌ OpenRouter API request failed: {str(e)}")
            raise e
    
    def list_available_models(self):
        """List all available OpenRouter models"""
        logger.info("📋 Listing available OpenRouter models...")
        try:
            models = self._get_available_models()
            logger.info(f"📊 Found {len(models)} models")
            model_list = []
            
            for i, model in enumerate(models):
                model_list.append({
                    'name': model,
                    'provider': 'OpenRouter',
                    'supported_methods': ['chat/completions']
                })
            
            return model_list
        except Exception as e:
            logger.error(f"❌ Error listing models: {str(e)}")
            return []