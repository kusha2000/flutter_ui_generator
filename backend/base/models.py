from typing import Dict, Any, Optional, Tuple
from pydantic import BaseModel
from abc import ABC, abstractmethod
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class PromptRequest(BaseModel):
    """Request model for UI generation prompts"""
    prompt: str

class CodeResponse(BaseModel):
    """Response model for generated code and UI JSON"""
    code: str
    ui_json: Dict[str, Any]
    success: bool
    error: Optional[str] = None

class GenerationConfig:
    """Configuration for LLM generation parameters"""
    def __init__(
        self,
        temperature: float = 0.7,
        top_p: float = 0.8,
        top_k: int = 40,
        max_output_tokens: int = 8192
    ):
        self.temperature = temperature
        self.top_p = top_p
        self.top_k = top_k
        self.max_output_tokens = max_output_tokens

class RetryConfig:
    """Configuration for retry logic"""
    def __init__(
        self,
        max_retries: int = 3,
        base_delay: float = 1.0,
        max_delay: float = 60.0
    ):
        self.max_retries = max_retries
        self.base_delay = base_delay
        self.max_delay = max_delay