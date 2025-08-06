from abc import ABC, abstractmethod
from typing import Dict, Any, Optional, Tuple
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
            'openai': 'ChatGPTGeneratedWidget',
            'chatgpt': 'ChatGPTGeneratedWidget',
            'claude': 'ClaudeGeneratedWidget'
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
    
    def generate_flutter_code(self, prompt: str) -> Tuple[str, Dict[str, Any], bool, Optional[str]]:
        """
        Generate Flutter/Dart code and JSON UI representation based on natural language prompt.
        Returns: (code, ui_json, success, error_message)
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
    
    def _process_response(self, response_text: str) -> Tuple[str, Dict[str, Any], bool, Optional[str]]:
        """Process the LLM response and extract code and JSON"""
        from .code_processor import CodeProcessor
        from .file_manager import FileManager
        
        processor = CodeProcessor()
        # Pass service type and widget name to processors
        file_manager = FileManager(service_type=self.service_type)
        
        # Clean and parse response
        cleaned_response = processor.clean_response(response_text)
        code, ui_json, success, error = processor.parse_response(cleaned_response, self.widget_name)
        
        if success and code:
            # Write to file
            file_written = file_manager.write_dart_file(code)
            logger.info(f"📄 File write result: {'✅ Success' if file_written else '❌ Failed'}")
        
        return code, ui_json, success, error
    
    def _get_fallback_response(self, error: str) -> Tuple[str, Dict[str, Any], bool, Optional[str]]:
        """Get fallback response when generation fails"""
        from .code_processor import CodeProcessor
        from .file_manager import FileManager
        
        processor = CodeProcessor()
        # Pass service type and widget name to processors
        file_manager = FileManager(service_type=self.service_type)
        
        fallback_code, fallback_json = processor.get_professional_fallback_widget(error, self.widget_name)
        
        # Still try to write the fallback code to file
        file_written = file_manager.write_dart_file(fallback_code)
        logger.info(f"📄 Fallback code file write: {'✅ Success' if file_written else '❌ Failed'}")
        
        return fallback_code, fallback_json, False, error
    
    def _get_system_prompt(self) -> str:
        """Get the system prompt for Flutter code generation"""
        return f"""
        You are an expert Flutter/Dart UI designer and code generator specializing in creating beautiful, professional, modern mobile applications. 
        
        Given a natural language description, generate two outputs:
        1. Flutter widget code that represents a professional, polished UI
        2. A comprehensive JSON representation of the UI structure for dynamic rendering

        CRITICAL WIDGET NAMING RULE:
        - The main widget class MUST be named exactly: {self.widget_name}
        - DO NOT use any other names like "GeneratedWidget", "Main", "MyWidget", etc.
        - The widget name must be exactly: {self.widget_name}

        DESIGN PRINCIPLES - FOLLOW THESE STRICTLY:
        🎨 VISUAL DESIGN:
        - Use modern Material Design 3 principles with beautiful color schemes
        - Implement proper spacing, typography hierarchy, and visual balance
        - Add subtle shadows, rounded corners, and elegant transitions
        - Use gradient backgrounds, custom colors, and professional styling
        - Include beautiful icons from Icons class (outlined, rounded, or sharp variants)
        - Implement proper elevation and depth with Card widgets and shadows
        - Use custom themes with primarySwatch, accent colors, and dark mode support

        🏗️ LAYOUT & STRUCTURE:
        - Create responsive layouts that work on different screen sizes
        - Use proper padding, margins, and spacing (8, 16, 24, 32 pixel increments)
        - Implement scrollable content with SingleChildScrollView or ListView
        - Add AppBar with custom styling, actions, and proper titles
        - Use Scaffold with proper background colors and structure
        - Include FloatingActionButton when appropriate with custom styling

        🎯 INTERACTIVE ELEMENTS:
        - Style buttons with custom colors, rounded corners, and elevation
        - Add TextFormField with proper validation, decorations, and styling
        - Include loading states, animations, and micro-interactions
        - Add proper focus states and user feedback
        - Use InkWell or GestureDetector for custom touchable areas

        📱 PROFESSIONAL FEATURES:
        - Add search functionality with beautiful search bars
        - Include navigation elements (BottomNavigationBar, Drawer, TabBar)
        - Add data presentation with Cards, ListTiles, and custom containers
        - Include proper error handling and empty states
        - Add confirmation dialogs and snackbars for user actions
        - Use ListView.builder for dynamic content with proper separators

        🌟 ADVANCED STYLING:
        - Custom border radius (BorderRadius.circular(12), BorderRadius.only)
        - Gradient backgrounds (LinearGradient, RadialGradient)
        - Custom box shadows (BoxShadow with blur, offset, color)
        - Typography with custom font weights, sizes, and colors
        - Animated containers and transitions where appropriate
        - Custom color palettes with primary, secondary, and surface colors

        FLUTTER CODE RULES:
        1. Return ONLY the complete, production-ready widget code
        2. Use StatelessWidget or StatefulWidget as appropriate
        3. Include ALL necessary imports (material.dart, and any others needed)
        4. Make the widget completely self-contained and functional
        5. Name the main widget EXACTLY: {self.widget_name}
        6. Include proper error handling and null safety
        7. Add meaningful comments for complex sections
        8. Use proper Flutter/Dart conventions and best practices
        9. Include realistic sample data where needed
        10. Make it responsive and beautiful on mobile devices

        JSON STRUCTURE RULES:
        1. Create a comprehensive JSON representation with this schema:
        {{
          "type": "widget_name",
          "properties": {{
            "key_property": "value",
            "styling": {{
              "backgroundColor": "#hexcolor",
              "borderRadius": 12,
              "elevation": 4,
              "padding": {{"top": 16, "left": 16, "right": 16, "bottom": 16}},
              "margin": {{"all": 8}},
              "textStyle": {{
                "fontSize": 16,
                "fontWeight": "bold",
                "color": "#333333"
              }}
            }}
          }},
          "children": [...]
        }}

        2. Include ALL visual properties (colors, spacing, typography, etc.)
        3. Support complex Flutter widgets (Scaffold, AppBar, Card, Container, etc.)
        4. Include interaction properties (onPressed, onChanged, etc.)
        5. Add animation and transition properties where applicable
        6. Include validation rules and form properties
        7. Make the JSON detailed enough to recreate the exact UI

        IMPORTANT FORMATTING:
        - Return ONLY a valid JSON object with keys "code" and "ui_json"
        - Start immediately with {{ and end with }}
        - No markdown code blocks, no explanations
        - Ensure the JSON is perfectly formatted and parseable
        - Make both code and JSON production-ready and professional

        EXAMPLES OF PROFESSIONAL ELEMENTS TO INCLUDE:
        - Gradient AppBars with custom actions
        - Floating Action Buttons with custom shapes and colors
        - Card-based layouts with proper shadows and spacing
        - Custom input fields with beautiful decorations
        - Loading indicators and progress bars
        - Animated list items and transitions
        - Bottom sheets and modal dialogs
        - Custom buttons with gradients and shadows
        - Professional typography with proper hierarchy
        - Color-coded status indicators and badges
        """