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

class GroqService(BaseLLMService):
    """Groq-specific implementation of the LLM service"""
    
    def __init__(self, generation_config: GenerationConfig = None, retry_config: RetryConfig = None):
        load_dotenv()
        
        # Groq-specific generation config optimized for code generation
        if generation_config is None:
            generation_config = GenerationConfig(
                temperature=0.4,
                top_p=0.8,
                top_k=40,
                max_output_tokens=8192
            )
        
        self.api_key = os.getenv('GROQ_API_KEY')
        logger.info(f"🔑 Groq API Key loaded: {'✅ Found' if self.api_key else '❌ Missing'}")
        
        if not self.api_key:
            logger.error("❌ GROQ_API_KEY not found in environment variables")
            raise ValueError("GROQ_API_KEY not found in environment variables")
        
        logger.info("⚙️ Configuring Groq AI...")
        
        # Import Groq SDK
        try:
            from groq import Groq
            self.Groq = Groq
            logger.info("✅ Groq SDK imported successfully")
        except ImportError:
            logger.error("❌ Groq SDK not installed. Run: pip install groq")
            raise ImportError("Please install groq: pip install groq")
        
        # Initialize Groq client
        self.client = self.Groq(api_key=self.api_key)
        logger.info("✅ Groq client initialized")
        
        # NOW call super().__init__() FIRST (before initializing model)
        super().__init__(generation_config, retry_config)
        
        # Initialize the model AFTER calling super().__init__()
        if not self._initialize_model():
            raise ValueError("Failed to initialize Groq model - no models available")
        
        logger.info(f"✅ GroqService fully initialized with model: {self.current_model_name}")
    
    def _get_available_models(self):
        """Get list of available Groq models suitable for code generation"""
        try:
            logger.info("📋 Fetching available models from Groq...")
            
            # Models to EXCLUDE (not suitable for code generation)
            EXCLUDED_MODELS = [
                'llama-prompt-guard',  # Guard models
                'whisper',             # Audio transcription
                'playai-tts',          # Text-to-speech
            ]
            
            # Priority order for code generation (best first)
            PRIORITY_MODELS = [
                'llama-3.3-70b-versatile',
                'llama-3.1-70b-versatile', 
                'mixtral-8x7b-32768',
                'llama-3.1-8b-instant',
                'gemma2-9b-it',
                'qwen/qwen3-32b',
                'openai/gpt-oss-120b',
                'openai/gpt-oss-20b',
                'groq/compound',
                'allam-2-7b',
                'moonshotai/kimi-k2-instruct',
                'meta-llama/llama-4-maverick-17b-128e-instruct',
                'meta-llama/llama-4-scout-17b-16e-instruct',
            ]
            
            # Try to get models from API
            models_response = self.client.models.list()
            available_models = []
            
            for model in models_response.data:
                model_id = model.id
                
                # Skip excluded models
                if any(excluded in model_id.lower() for excluded in EXCLUDED_MODELS):
                    logger.info(f"⏭️ Skipping unsuitable model: {model_id}")
                    continue
                
                available_models.append(model_id)
                logger.info(f"✅ Found available model: {model_id}")
            
            if not available_models:
                raise Exception("No suitable models found")
            
            # Sort by priority
            def model_priority(model_name):
                for i, priority_model in enumerate(PRIORITY_MODELS):
                    if priority_model in model_name:
                        return i
                return len(PRIORITY_MODELS)  # Unknown models go last
            
            available_models.sort(key=model_priority)
            logger.info(f"📊 Sorted {len(available_models)} models by priority")
            
            return available_models
                
        except Exception as e:
            logger.warning(f"⚠️ Could not fetch models from API: {str(e)}")
            logger.info("📋 Using fallback model list...")
            
            # Fallback list of known good Groq models for code generation
            fallback_models = [
                'llama-3.3-70b-versatile',
                'llama-3.1-70b-versatile',
                'mixtral-8x7b-32768',
                'llama-3.1-8b-instant',
                'gemma2-9b-it',
            ]
            
            for model in fallback_models:
                logger.info(f"✅ Fallback model: {model}")
            
            return fallback_models
    
    def _initialize_model(self) -> bool:
        """Initialize the Groq model with proper error handling"""
        available_models = self._get_available_models()
        
        if not available_models:
            logger.error("❌ No models available")
            return False
        
        logger.info(f"🔍 Attempting to initialize models (max 5 attempts)")
        
        # Try only first 5 models to avoid long initialization
        models_to_try = available_models[:5]
        
        for i, model_name in enumerate(models_to_try):
            try:
                logger.info(f"🔄 [{i+1}/{len(models_to_try)}] Trying model: {model_name}")
                logger.info(f"🧪 Testing model with simple request...")
                
                # Test with minimal tokens first
                chat_completion = self.client.chat.completions.create(
                    messages=[
                        {
                            "role": "user",
                            "content": "Hello, respond with just 'OK'",
                        }
                    ],
                    model=model_name,
                    temperature=0.5,
                    max_tokens=10,
                    top_p=0.9
                )
                
                if chat_completion.choices and chat_completion.choices[0].message.content:
                    # Now test with higher tokens to ensure it supports code generation
                    logger.info(f"🧪 Testing with higher token limit...")
                    test_completion = self.client.chat.completions.create(
                        messages=[
                            {
                                "role": "user",
                                "content": "Write a simple hello function in Python",
                            }
                        ],
                        model=model_name,
                        temperature=0.5,
                        max_tokens=500,  # Test with reasonable token limit
                        top_p=0.9
                    )
                    
                    if test_completion.choices and test_completion.choices[0].message.content:
                        logger.info(f"✅ Successfully initialized model: {model_name}")
                        logger.info(f"📝 Test response received successfully")
                        self.current_model_name = model_name
                        self.model = model_name
                        return True
                    else:
                        logger.warning(f"⚠️ Model {model_name} failed token test")
                else:
                    logger.warning(f"⚠️ Model {model_name} returned empty response")
                    
            except Exception as e:
                error_msg = str(e)
                logger.error(f"❌ Failed to initialize {model_name}: {error_msg}")
                
                # If it's a token limit error, skip this model
                if 'max_tokens' in error_msg.lower() or '512' in error_msg:
                    logger.warning(f"⚠️ {model_name} has insufficient token limit, skipping...")
                
                if i < len(models_to_try) - 1:
                    logger.info(f"🔄 Trying next model...")
                continue
        
        logger.error("💥 All models failed to initialize")
        return False
    
    def _make_api_request(self, prompt: str) -> Optional[str]:
        """Make a single API request to Groq with smart token handling"""
        if not self.current_model_name:
            raise ValueError("Model not initialized - current_model_name is None")
            
        try:
            logger.info("🚀 Making API request to Groq...")
            logger.info(f"🎯 Using model: {self.current_model_name}")
            
            # Use configured max tokens, but clamp to reasonable limits
            max_tokens = min(self.generation_config.max_output_tokens, 8192)
            
            chat_completion = self.client.chat.completions.create(
                messages=[
                    {
                        "role": "user",
                        "content": prompt,
                    }
                ],
                model=self.current_model_name,
                temperature=self.generation_config.temperature,
                max_tokens=max_tokens,
                top_p=self.generation_config.top_p
            )
            
            if chat_completion.choices and chat_completion.choices[0].message.content:
                content = chat_completion.choices[0].message.content
                logger.info(f"✅ Received response from Groq")
                logger.info(f"📏 Response length: {len(content)} characters")
                
                # Log token usage
                if hasattr(chat_completion, 'usage'):
                    usage = chat_completion.usage
                    logger.info(f"📊 Token usage - Prompt: {usage.prompt_tokens}, "
                              f"Completion: {usage.completion_tokens}, "
                              f"Total: {usage.total_tokens}")
                
                return content
            else:
                logger.warning("⚠️ Empty response from Groq")
                return None
                
        except Exception as e:
            error_msg = str(e)
            logger.error(f"❌ Groq API request failed: {error_msg}")
            
            # If we hit a token limit, try with reduced tokens
            if 'max_tokens' in error_msg.lower():
                logger.warning("⚠️ Token limit exceeded, retrying with reduced tokens...")
                try:
                    reduced_tokens = 4096  # Try with half
                    logger.info(f"🔄 Retrying with max_tokens={reduced_tokens}")
                    
                    chat_completion = self.client.chat.completions.create(
                        messages=[{"role": "user", "content": prompt}],
                        model=self.current_model_name,
                        temperature=self.generation_config.temperature,
                        max_tokens=reduced_tokens,
                        top_p=self.generation_config.top_p
                    )
                    
                    if chat_completion.choices and chat_completion.choices[0].message.content:
                        logger.info("✅ Succeeded with reduced tokens")
                        return chat_completion.choices[0].message.content
                except Exception as retry_error:
                    logger.error(f"❌ Retry also failed: {str(retry_error)}")
            
            raise e
    
    def list_available_models(self):
        """List all available Groq models"""
        logger.info("📋 Listing available Groq models...")
        try:
            models_response = self.client.models.list()
            model_list = []
            
            for model in models_response.data:
                model_info = {
                    'id': model.id,
                    'name': model.id,
                    'owned_by': getattr(model, 'owned_by', 'groq'),
                    'active': getattr(model, 'active', True),
                    'context_window': getattr(model, 'context_window', 32768)
                }
                model_list.append(model_info)
                logger.info(f"  📦 {model_info['id']}")
            
            logger.info(f"📊 Total models found: {len(model_list)}")
            return model_list
            
        except Exception as e:
            logger.error(f"❌ Error listing models: {str(e)}")
            
            # Return fallback list
            fallback_list = [
                {
                    'id': 'llama-3.3-70b-versatile',
                    'name': 'Llama 3.3 70B Versatile',
                    'description': 'Latest and best for complex tasks and code generation',
                    'context_window': 32768
                },
                {
                    'id': 'llama-3.1-70b-versatile',
                    'name': 'Llama 3.1 70B Versatile',
                    'description': 'Best for complex tasks and code generation',
                    'context_window': 32768
                },
                {
                    'id': 'llama-3.1-8b-instant',
                    'name': 'Llama 3.1 8B Instant',
                    'description': 'Fastest model, good for simple tasks',
                    'context_window': 8192
                },
                {
                    'id': 'mixtral-8x7b-32768',
                    'name': 'Mixtral 8x7B',
                    'description': 'Balanced performance and speed',
                    'context_window': 32768
                },
                {
                    'id': 'gemma2-9b-it',
                    'name': 'Gemma 2 9B IT',
                    'description': 'Efficient and capable',
                    'context_window': 8192
                }
            ]
            
            logger.info("📋 Using fallback model list:")
            for model in fallback_list:
                logger.info(f"  📦 {model['id']} - {model['description']}")
            
            return fallback_list

    def stream_response(self, prompt: str):
        """Stream response from Groq"""
        if not self.current_model_name:
            raise ValueError("Model not initialized - current_model_name is None")
            
        try:
            logger.info("🌊 Streaming response from Groq...")
            
            stream = self.client.chat.completions.create(
                messages=[
                    {
                        "role": "user",
                        "content": prompt,
                    }
                ],
                model=self.current_model_name,
                temperature=self.generation_config.temperature,
                max_tokens=self.generation_config.max_output_tokens,
                top_p=self.generation_config.top_p,
                stream=True
            )
            
            for chunk in stream:
                if chunk.choices and chunk.choices[0].delta.content:
                    yield chunk.choices[0].delta.content
                    
        except Exception as e:
            logger.error(f"❌ Groq streaming failed: {str(e)}")
            yield f"Error: {str(e)}"

    def get_usage_info(self):
        """Get API usage information"""
        try:
            logger.info("📊 Fetching usage information...")
            return {
                "message": "Usage tracked per request",
                "current_model": self.current_model_name,
                "note": "Check individual request responses for token usage"
            }
        except Exception as e:
            logger.error(f"❌ Error fetching usage info: {str(e)}")
            return None