from typing import Dict, Any, Optional
from pydantic import BaseModel, Field
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class PromptRequest(BaseModel):
    """Request model for UI generation prompts"""
    prompt: str = Field(..., min_length=1, description="Natural language description of the UI to generate")
    
    class Config:
        json_schema_extra = {
            "example": {
                "prompt": "Create a login screen with email and password fields"
            }
        }

class CodeResponse(BaseModel):
    """Response model for generated code"""
    code: str = Field(..., description="Generated Flutter/Dart code")
    success: bool = Field(..., description="Whether code generation was successful")
    error: Optional[str] = Field(None, description="Error message if generation failed")
    widget_name: Optional[str] = Field(None, description="Name of the generated widget class")
    
    class Config:
        json_schema_extra = {
            "example": {
                "code": "import 'package:flutter/material.dart';\n\nclass GeminiGeneratedWidget extends StatelessWidget {...}",
                "success": True,
                "error": None,
                "widget_name": "GeminiGeneratedWidget"
            }
        }

class GenerationConfig:
    """Configuration for LLM generation parameters"""
    def __init__(
        self,
        temperature: float = 0.3,  # Lowered for more consistent code generation
        top_p: float = 0.9,
        top_k: int = 40,
        max_output_tokens: int = 4096  # Reduced since we only need code
    ):
        self.temperature = temperature
        self.top_p = top_p
        self.top_k = top_k
        self.max_output_tokens = max_output_tokens
        
        logger.info(f"🔧 GenerationConfig initialized:")
        logger.info(f"   Temperature: {temperature}")
        logger.info(f"   Top P: {top_p}")
        logger.info(f"   Top K: {top_k}")
        logger.info(f"   Max tokens: {max_output_tokens}")

class RetryConfig:
    """Configuration for retry logic"""
    def __init__(
        self,
        max_retries: int = 3,
        base_delay: float = 1.0,
        max_delay: float = 30.0  # Reduced max delay
    ):
        self.max_retries = max_retries
        self.base_delay = base_delay
        self.max_delay = max_delay
        
        logger.info(f"🔄 RetryConfig initialized:")
        logger.info(f"   Max retries: {max_retries}")
        logger.info(f"   Base delay: {base_delay}s")
        logger.info(f"   Max delay: {max_delay}s")