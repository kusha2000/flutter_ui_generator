from huggingface_hub import InferenceClient
import os
from dotenv import load_dotenv
import logging
from typing import Optional
import sys
from pathlib import Path
import time

# Add the backend directory to the Python path
backend_dir = Path(__file__).parent.parent
sys.path.insert(0, str(backend_dir))

from base.llm_service import BaseLLMService
from base.models import GenerationConfig, RetryConfig

logger = logging.getLogger(__name__)

class HuggingFaceService(BaseLLMService):
    """Hugging Face-specific implementation of the LLM service"""
    
    def __init__(self, generation_config: GenerationConfig = None, retry_config: RetryConfig = None):
        load_dotenv()
        
        # HuggingFace-specific generation config optimized for code generation
        if generation_config is None:
            generation_config = GenerationConfig(
                temperature=0.6,  # Lower for more consistent code
                top_p=0.9,
                top_k=40,
                max_output_tokens=3000  # Increased for larger code outputs
            )
        
        super().__init__(generation_config, retry_config)
        
        self.api_key = os.getenv('HUGGINGFACE_API_KEY')
        logger.info(f"🔑 Hugging Face API Key loaded: {'✅ Found' if self.api_key else '❌ Missing'}")
        
        if not self.api_key:
            logger.error("❌ HUGGINGFACE_API_KEY not found in environment variables")
            raise ValueError("HUGGINGFACE_API_KEY not found in environment variables")
        
        logger.info("⚙️ Configuring Hugging Face AI...")
        self.client = InferenceClient(token=self.api_key)
        
        # Test API key validity first
        if not self._test_api_key():
            logger.error("❌ API Key test failed. Check your HUGGINGFACE_API_KEY.")
            raise ValueError("Invalid HUGGINGFACE_API_KEY")
        
        # Initialize the model - this MUST succeed
        if not self._initialize_model():
            error_msg = "Failed to initialize any Hugging Face model. Please check your API key and network connection."
            logger.error(f"💥 {error_msg}")
            raise ValueError(error_msg)
        
        logger.info(f"✅ HuggingFaceService initialized successfully with model: {self.current_model_name}")
    
    def _test_api_key(self) -> bool:
        """Test if the API key is valid"""
        try:
            logger.info("🔑 Testing API key validity...")
            # Try a simple request to verify the key
            response = self.client.text_generation(
                "test",
                model="gpt2",
                max_new_tokens=5
            )
            logger.info("✅ API Key is valid")
            return True
        except Exception as e:
            error_msg = str(e).lower()
            if "invalid" in error_msg or "unauthorized" in error_msg or "authentication" in error_msg:
                logger.error(f"❌ Invalid API Key: {str(e)}")
                return False
            # Other errors don't necessarily mean invalid key, so we return True
            logger.warning(f"⚠️ API key test inconclusive: {str(e)[:100]}")
            return True
    
    def _get_available_models(self):
        """Get list of available Hugging Face models for code generation
        
        These models are verified to work with HuggingFace Inference API chat_completion
        """
        try:
            logger.info("📋 Using verified models that support chat completion API...")
            
            # Models verified to work with HuggingFace Inference API chat_completion
            # Prioritized by code generation capability
            available = [
                # Tier 1: Code-specialized models (BEST for Flutter/Dart)
                'deepseek-ai/deepseek-coder-7b-instruct',      # Best for code
                'Qwen/Qwen2.5-Coder-7B-Instruct',              # Alternative code specialist
                
                # Tier 2: Strong general-purpose models
                'mistralai/Mistral-7B-Instruct-v0.3',          # Currently working, reliable
                'teknium/OpenHermes-2.5-Mistral-7B',           # Extended context, good formatting
                
                # Tier 3: Backup options
                'HuggingFaceH4/zephyr-7b-beta',                # Good instruction following
                'meta-llama/Llama-2-7b-chat-hf',               # Widely tested
            ]
            
            logger.info(f"📋 Total models available for testing: {len(available)}")
            return available
        except Exception as e:
            logger.error(f"❌ Error fetching models: {str(e)}")
            return []
    
    def _test_model(self, model_name: str) -> bool:
        """Test if a model is available and working using chat completion API"""
        try:
            logger.info(f"🧪 Testing model: {model_name}")
            
            messages = [{"role": "user", "content": "Say hello in one word"}]
            
            response = self.client.chat_completion(
                messages=messages,
                model=model_name,
                max_tokens=20,
                temperature=0.7
            )
            
            if response and hasattr(response, 'choices') and len(response.choices) > 0:
                content = response.choices[0].message.content
                if content and len(content.strip()) > 0:
                    logger.info(f"✅ Model {model_name} working: {content[:50]}...")
                    return True
            
            logger.warning(f"⚠️ Model {model_name} returned empty response")
            return False
                
        except Exception as e:
            error_msg = str(e).lower()
            
            # Categorize and log specific error types
            if "not supported" in error_msg or "not support" in error_msg:
                logger.debug(f"⚠️ {model_name}: doesn't support chat completion")
            elif "currently loading" in error_msg or "loading" in error_msg:
                logger.debug(f"⏳ {model_name}: is loading (try again in 1-2 min)")
            elif "rate limit" in error_msg:
                logger.debug(f"⏸️ {model_name}: rate limited (wait 10-15 min)")
            elif "not found" in error_msg or "does not exist" in error_msg:
                logger.debug(f"🔍 {model_name}: not found")
            elif "authorization" in error_msg or "gated" in error_msg:
                logger.debug(f"🔒 {model_name}: requires acceptance on HuggingFace")
            else:
                logger.debug(f"❌ {model_name}: {str(e)[:100]}")
            
            return False
    
    def _initialize_model(self) -> bool:
        """Initialize the Hugging Face model with enhanced error reporting"""
        available_models = self._get_available_models()
        
        if not available_models:
            logger.error("❌ Could not fetch model list")
            return False
        
        logger.info(f"🔍 Testing {len(available_models)} models...")
        test_results = {}
        
        for i, model_name in enumerate(available_models):
            logger.info(f"🔄 [{i+1}/{len(available_models)}] Testing: {model_name}")
            result = self._test_model(model_name)
            test_results[model_name] = result
            
            if result:
                # Set model attributes properly
                self.current_model_name = model_name
                self.model = self.client  # Store client for API calls
                
                logger.info(f"✅ self.current_model_name set to: {self.current_model_name}")
                logger.info(f"✅ self.model set to: {type(self.model).__name__}")
                logger.info(f"🎉 Successfully initialized: {model_name}")
                return True
            
            # Add small delay between tests to avoid rate limiting
            time.sleep(0.5)
        
        # No model worked - provide detailed diagnostics
        logger.error("💥 No models initialized. Testing diagnostics:")
        logger.error("")
        logger.error("🔧 TROUBLESHOOTING:")
        logger.error("1️⃣ VERIFY API KEY:")
        logger.error("   - Go to https://huggingface.co/settings/tokens")
        logger.error("   - Create/copy your API token")
        logger.error("   - Update your .env file: HUGGINGFACE_API_KEY=your_token")
        logger.error("")
        logger.error("2️⃣ ACCEPT GATED MODELS (if needed):")
        logger.error("   - https://huggingface.co/deepseek-ai/deepseek-coder-7b-instruct")
        logger.error("   - https://huggingface.co/meta-llama/Llama-2-7b-chat-hf")
        logger.error("")
        logger.error("3️⃣ CHECK RATE LIMITS (Free Tier):")
        logger.error("   - You may be rate limited. Wait 10-15 minutes.")
        logger.error("   - Consider: https://huggingface.co/pricing")
        logger.error("")
        logger.error("4️⃣ TEST RESULTS:")
        for model, success in test_results.items():
            status = "✅" if success else "❌"
            logger.error(f"   {status} {model}")
        
        return False
    
    def _make_api_request(self, prompt: str) -> Optional[str]:
        """Make a single API request to Hugging Face using chat completion
        
        Optimized for code generation with proper error handling
        """
        # Verify model is initialized
        if not hasattr(self, 'current_model_name') or not self.current_model_name:
            error_msg = "Model not initialized. Cannot make API request."
            logger.error(f"❌ {error_msg}")
            raise RuntimeError(error_msg)
        
        if not hasattr(self, 'model') or not self.model:
            error_msg = "Client not initialized. Cannot make API request."
            logger.error(f"❌ {error_msg}")
            raise RuntimeError(error_msg)
        
        try:
            logger.info("🚀 Making API request...")
            logger.info(f"📤 Model: {self.current_model_name}")
            logger.info(f"📏 Prompt length: {len(prompt)} characters")
            
            # Format prompt for better code generation
            system_prompt = """You are an expert Flutter/Dart code generator. 
Generate clean, well-formatted, and production-ready code. 
Follow Flutter best practices and use modern Dart syntax.
Ensure all imports are correct and code is properly structured."""
            
            messages = [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt}
            ]
            
            response = self.model.chat_completion(
                messages=messages,
                model=self.current_model_name,
                max_tokens=self.generation_config.max_output_tokens,
                temperature=self.generation_config.temperature,
                top_p=self.generation_config.top_p,
            )
            
            if response and hasattr(response, 'choices') and len(response.choices) > 0:
                content = response.choices[0].message.content
                if content and len(content.strip()) > 0:
                    logger.info(f"✅ Response received ({len(content)} chars)")
                    return content.strip()
            
            logger.warning("⚠️ Empty response received")
            return None
                
        except Exception as e:
            error_msg = str(e).lower()
            
            if "loading" in error_msg:
                logger.error(f"⏳ Model is loading. Wait 1-2 minutes and retry.")
            elif "rate limit" in error_msg:
                logger.error(f"⏸️ Rate limited. Wait 10-15 minutes before retrying.")
            elif "timeout" in error_msg:
                logger.error(f"⏱️ Timeout. Try smaller model or reduce max_tokens.")
            elif "authorization" in error_msg or "gated" in error_msg:
                logger.error(f"🔒 Authorization error. Accept terms on HuggingFace.")
            else:
                logger.error(f"❌ API error: {str(e)}")
            
            raise e
    
    def list_available_models(self):
        """List all available Hugging Face models"""
        logger.info("📋 Listing available models...")
        try:
            models = self._get_available_models()
            model_list = []
            
            for model in models:
                model_list.append({
                    'name': model,
                    'supported_methods': ['chat_completion'],
                    'provider': 'Hugging Face'
                })
            
            logger.info(f"📊 Total models: {len(model_list)}")
            return model_list
        except Exception as e:
            logger.error(f"❌ Error listing models: {str(e)}")
            return []
    
    def switch_model(self, model_name: str) -> bool:
        """Switch to a different model at runtime"""
        try:
            logger.info(f"🔄 Switching to: {model_name}")
            
            if self._test_model(model_name):
                self.current_model_name = model_name
                self.model = self.client  # Update client reference
                logger.info(f"✅ Switched to: {model_name}")
                return True
            else:
                logger.error(f"❌ Failed to switch: {model_name}")
                return False
                
        except Exception as e:
            logger.error(f"❌ Error switching model: {str(e)}")
            return False