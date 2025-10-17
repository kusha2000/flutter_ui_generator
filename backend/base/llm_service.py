from abc import ABC, abstractmethod
from typing import Optional, Tuple
import logging
from .models import GenerationConfig, RetryConfig

logger = logging.getLogger(__name__)

class BaseLLMService(ABC):
    """Abstract base class for LLM services"""
    
    def __init__(self, generation_config: GenerationConfig = None, retry_config: RetryConfig = None):
        self.generation_config = generation_config or GenerationConfig()
        self.retry_config = retry_config or RetryConfig()
        self.model = None
        self.current_model_name = None
        # Get service type from class name (e.g., "GeminiService" -> "gemini")
        self.service_type = self.__class__.__name__.replace("Service", "").lower()
        # Set widget name based on service type
        self.widget_name = self._get_widget_name()
        logger.info(f"🚀 Initializing {self.__class__.__name__} with service type: {self.service_type}")
        logger.info(f"🎯 Widget name will be: {self.widget_name}")
    
    def _get_widget_name(self) -> str:
        """Get the appropriate widget name based on service type"""
        service_widget_mapping = {
            'gemini': 'GeminiGeneratedWidget',
            'groq': 'GroqGeneratedWidget',
            'cohere': 'CohereGeneratedWidget',
            'huggingface': 'HuggingFaceGeneratedWidget',
            'openrouter': 'OpenRouterGeneratedWidget'
        }
        return service_widget_mapping.get(self.service_type, 'GeneratedWidget')
    
    @abstractmethod
    def _initialize_model(self) -> bool:
        """Initialize the LLM model. Returns True if successful."""
        pass
    
    @abstractmethod
    def _make_api_request(self, prompt: str) -> Optional[str]:
        """Make a single API request. Returns response text or None if failed."""
        pass
    
    @abstractmethod
    def list_available_models(self):
        """List all available models for the LLM service"""
        pass
    
    def generate_flutter_code(self, prompt: str) -> Tuple[str, bool, Optional[str]]:
        """
        Generate Flutter/Dart code based on natural language prompt.
        Returns: (code, success, error_message)
        """
        logger.info(f"🎨 Starting Flutter code generation with {self.__class__.__name__}")
        logger.info(f"🔍 Received prompt: {prompt}")
        
        if not self.model:
            logger.error("❌ Model not initialized")
            return self._get_fallback_response("Model not initialized")
        
        # Generate the system prompt
        system_prompt = self._get_system_prompt()
        full_prompt = f"{system_prompt}\n\nUser request: {prompt}"
        
        # Make API request with retry logic
        response_text = self._make_request_with_retry(full_prompt)
        
        if not response_text:
            logger.error("❌ Failed to get response from LLM")
            return self._get_fallback_response("Failed to get response from LLM")
        
        # Process the response
        return self._process_response(response_text)
    
    def _make_request_with_retry(self, prompt: str) -> Optional[str]:
        """Make API request with retry logic"""
        from .code_processor import CodeProcessor
        
        processor = CodeProcessor()
        return processor.make_request_with_retry(
            self._make_api_request, 
            prompt, 
            self.retry_config
        )
    
    def _process_response(self, response_text: str) -> Tuple[str, bool, Optional[str]]:
        """Process the LLM response and extract code"""
        from .code_processor import CodeProcessor
        from .file_manager import FileManager
        
        processor = CodeProcessor()
        file_manager = FileManager(service_type=self.service_type)
        
        # Clean the response
        cleaned_response = processor.clean_response(response_text)
        
        # Clean and validate the code
        cleaned_code = processor.clean_code_response(cleaned_response, self.widget_name)
        
        # Check if we got fallback code (which means there was an error)
        if "Professional UI Generator" in cleaned_code and "Ready to create beautiful" in cleaned_code:
            logger.warning("⚠️ Received fallback code, generation may have failed")
            success = False
            error = "Generated code failed validation, using fallback"
        else:
            success = True
            error = None
        
        # Write to file
        if cleaned_code:
            file_written = file_manager.write_dart_file(cleaned_code)
            logger.info(f"📄 File write result: {'✅ Success' if file_written else '❌ Failed'}")
        
        return cleaned_code, success, error
    
    def _get_fallback_response(self, error: str) -> Tuple[str, bool, Optional[str]]:
        """Get fallback response when generation fails"""
        from .code_processor import CodeProcessor
        from .file_manager import FileManager
        
        processor = CodeProcessor()
        file_manager = FileManager(service_type=self.service_type)
        
        fallback_code = processor.get_professional_fallback_widget(error, self.widget_name)
        
        # Still try to write the fallback code to file
        file_written = file_manager.write_dart_file(fallback_code)
        logger.info(f"📄 Fallback code file write: {'✅ Success' if file_written else '❌ Failed'}")
        
        return fallback_code, False, error
    
    def _get_system_prompt(self) -> str:
        """Get the system prompt for Flutter code generation"""
        return f"""You are an expert Flutter/Dart developer specializing in creating beautiful, professional, modern mobile applications using Flutter 3.27.1.

CRITICAL REQUIREMENTS:
1. Generate ONLY pure Dart code - NO JSON, NO explanations, NO markdown
2. Use Flutter 3.27.1 syntax and best practices ONLY
3. The main widget class MUST be named exactly: {self.widget_name}
4. Return ONLY the complete Dart code, nothing else

FLUTTER 3.27.1 COMPATIBILITY RULES:
✅ USE THESE (Flutter 3.27.1 compatible):
- super.key instead of Key? key in constructors: const {self.widget_name}({{super.key}})
- MediaQuery.sizeOf(context) instead of MediaQuery.of(context).size
- Theme.of(context).colorScheme.primary instead of Theme.of(context).primaryColor
- Theme.of(context).colorScheme.secondary instead of Theme.of(context).accentColor
- ElevatedButton.styleFrom() with backgroundColor and foregroundColor parameters
- TextButton.styleFrom() with proper color parameters
- OutlinedButton.styleFrom() with proper color parameters
- Icons from material.dart (Icons.home, Icons.search, etc.)

❌ AVOID THESE (deprecated or problematic):
- Old Key? key syntax: DON'T use {{Key? key}} : super(key: key)
- MediaQuery.of(context).size - use MediaQuery.sizeOf(context) instead
- primaryColor, accentColor - use colorScheme instead
- RaisedButton, FlatButton (removed) - use ElevatedButton, TextButton instead
- Old button styling syntax

DESIGN PRINCIPLES:
🎨 VISUAL DESIGN:
- Use modern Material Design 3 with beautiful color schemes
- Implement proper spacing (8, 16, 24, 32 pixel increments)
- Add subtle shadows, rounded corners (BorderRadius.circular(8-16))
- Use gradient backgrounds where appropriate
- Include Material Icons (Icons.* from material.dart)
- Proper elevation with Card widgets (elevation: 2-8)

🏗️ LAYOUT & STRUCTURE:
- Always start with Scaffold
- Include AppBar with custom styling when appropriate
- Use proper padding with const EdgeInsets
- Implement scrollable content with SingleChildScrollView or ListView
- Create responsive layouts
- Use Column, Row, Stack appropriately

🎯 INTERACTIVE ELEMENTS:
- ElevatedButton with proper styling using styleFrom()
- TextFormField with InputDecoration for forms
- InkWell or GestureDetector for custom touch areas
- Proper const constructors everywhere possible

📱 PROFESSIONAL FEATURES:
- Beautiful Cards with elevation and border radius
- ListTile for list items
- Proper color schemes with Color(0xFF...)
- SizedBox for spacing
- Center, Padding, Container for layout
- Column/Row with proper MainAxisAlignment and CrossAxisAlignment

CODE STRUCTURE RULES:
1. Start with: import 'package:flutter/material.dart';
2. Class declaration: class {self.widget_name} extends StatelessWidget
3. Constructor: const {self.widget_name}({{super.key}});
4. Build method: @override Widget build(BuildContext context)
5. Return a complete, functional widget tree
6. Use const constructors wherever possible
7. Proper indentation (2 spaces)
8. Include realistic sample data where needed
9. Make it production-ready and error-free

EXAMPLE STRUCTURE:
```dart
import 'package:flutter/material.dart';

class {self.widget_name} extends StatelessWidget {{
  const {self.widget_name}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
        backgroundColor: const Color(0xFF6366F1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Your UI here
            ],
          ),
        ),
      ),
    );
  }}
}}
```

CRITICAL: Return ONLY the Dart code. No JSON, no explanations, no markdown blocks. Just pure Dart code that starts with 'import' and ends with the closing brace of the class.
"""