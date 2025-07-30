import google.generativeai as genai
import os
from dotenv import load_dotenv
import re
import json
import ast
import time
import random
from typing import Tuple, Optional, Dict, Any
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

class GeminiService:
    def __init__(self):
        self.api_key = os.getenv('GEMINI_API_KEY')
        logger.info(f"Gemini Key: {self.api_key}")
        
        if not self.api_key:
            raise ValueError("GEMINI_API_KEY not found in environment variables")
        
        genai.configure(api_key=self.api_key)
        
        # Configure generation settings for better reliability
        self.generation_config = {
            'temperature': 0.7,
            'top_p': 0.8,
            'top_k': 40,
            'max_output_tokens': 8192,
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
        
        model_names = [
            'gemini-1.5-flash',
            'gemini-1.5-pro',
            'gemini-1.0-pro',
            'gemini-pro'
        ]
        
        self.model = None
        self.current_model_name = None
        
        for model_name in model_names:
            try:
                logger.info(f"🔄 Trying to initialize model: {model_name}")
                self.model = genai.GenerativeModel(
                    model_name,
                    generation_config=self.generation_config,
                    safety_settings=self.safety_settings
                )
                
                # Test the model with a simple request
                test_response = self.model.generate_content("Hello")
                if test_response.text:
                    logger.info(f"✅ Successfully initialized model: {model_name}")
                    self.current_model_name = model_name
                    break
                    
            except Exception as e:
                logger.error(f"❌ Failed to initialize {model_name}: {str(e)}")
                continue
        
        if not self.model:
            raise ValueError("No available Gemini models found")
        
        logger.info(f"🎯 Using Gemini model: {self.current_model_name}")
    
    def _exponential_backoff(self, attempt: int, base_delay: float = 1.0, max_delay: float = 60.0) -> float:
        """Calculate exponential backoff delay with jitter"""
        delay = min(base_delay * (2 ** attempt), max_delay)
        # Add jitter to prevent thundering herd
        jitter = random.uniform(0.1, 0.3) * delay
        return delay + jitter
    
    def _make_request_with_retry(self, prompt: str, max_retries: int = 3) -> Optional[str]:
        """Make API request with exponential backoff retry logic"""
        last_error = None
        
        for attempt in range(max_retries):
            try:
                logger.info(f"🚀 Attempt {attempt + 1}/{max_retries}: Sending request to Gemini...")
                
                response = self.model.generate_content(prompt)
                
                if response.text and response.text.strip():
                    logger.info(f"✅ Successfully received response on attempt {attempt + 1}")
                    return response.text
                else:
                    logger.warning(f"⚠️ Empty response on attempt {attempt + 1}")
                    last_error = "Empty response from Gemini"
                    
            except Exception as e:
                error_msg = str(e)
                logger.error(f"❌ Attempt {attempt + 1} failed: {error_msg}")
                last_error = error_msg
                
                # Check if it's a rate limit or overload error
                if "503" in error_msg or "overloaded" in error_msg.lower():
                    if attempt < max_retries - 1:
                        delay = self._exponential_backoff(attempt)
                        logger.info(f"⏳ Model overloaded, waiting {delay:.2f}s before retry...")
                        time.sleep(delay)
                        continue
                
                # For other errors, don't retry immediately
                elif "429" in error_msg or "quota" in error_msg.lower():
                    if attempt < max_retries - 1:
                        delay = self._exponential_backoff(attempt, base_delay=5.0)
                        logger.info(f"⏳ Rate limited, waiting {delay:.2f}s before retry...")
                        time.sleep(delay)
                        continue
                
                # For other errors, shorter delay
                elif attempt < max_retries - 1:
                    delay = self._exponential_backoff(attempt, base_delay=2.0)
                    logger.info(f"⏳ Error occurred, waiting {delay:.2f}s before retry...")
                    time.sleep(delay)
                    continue
        
        logger.error(f"❌ All retry attempts failed. Last error: {last_error}")
        return None
    
    def list_available_models(self):
        """List all available models for debugging"""
        try:
            models = genai.list_models()
            logger.info("📋 Available models:")
            for model in models:
                logger.info(f"  - {model.name}")
                logger.info(f"    Supported methods: {model.supported_generation_methods}")
            return models
        except Exception as e:
            logger.error(f"❌ Error listing models: {str(e)}")
            return []

    def generate_flutter_code(self, prompt: str) -> Tuple[str, Dict[str, Any], bool, Optional[str]]:
        """
        Generate Flutter/Dart code and JSON UI representation based on natural language prompt.
        Returns: (code, ui_json, success, error_message)
        """
        logger.info(f"🔍 Received prompt: {prompt}")

        system_prompt = """
        You are an expert Flutter/Dart UI designer and code generator specializing in creating beautiful, professional, modern mobile applications. 
        
        Given a natural language description, generate two outputs:
        1. Flutter widget code that represents a professional, polished UI
        2. A comprehensive JSON representation of the UI structure for dynamic rendering

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
        5. Name the main widget 'GeneratedWidget'
        6. Include proper error handling and null safety
        7. Add meaningful comments for complex sections
        8. Use proper Flutter/Dart conventions and best practices
        9. Include realistic sample data where needed
        10. Make it responsive and beautiful on mobile devices

        JSON STRUCTURE RULES:
        1. Create a comprehensive JSON representation with this schema:
        {
          "type": "widget_name",
          "properties": {
            "key_property": "value",
            "styling": {
              "backgroundColor": "#hexcolor",
              "borderRadius": 12,
              "elevation": 4,
              "padding": {"top": 16, "left": 16, "right": 16, "bottom": 16},
              "margin": {"all": 8},
              "textStyle": {
                "fontSize": 16,
                "fontWeight": "bold",
                "color": "#333333"
              }
            }
          },
          "children": [...]
        }

        2. Include ALL visual properties (colors, spacing, typography, etc.)
        3. Support complex Flutter widgets (Scaffold, AppBar, Card, Container, etc.)
        4. Include interaction properties (onPressed, onChanged, etc.)
        5. Add animation and transition properties where applicable
        6. Include validation rules and form properties
        7. Make the JSON detailed enough to recreate the exact UI

        IMPORTANT FORMATTING:
        - Return ONLY a valid JSON object with keys "code" and "ui_json"
        - Start immediately with { and end with }
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

        full_prompt = f"{system_prompt}\n\nUser request: {prompt}"
        logger.info(f"📝 Full prompt prepared")

        # Make request with retry logic
        response_text = self._make_request_with_retry(full_prompt, max_retries=3)
        
        if not response_text:
            logger.error("❌ Failed to get response from Gemini after all retries")
            fallback_code, fallback_json = self._get_professional_fallback_widget("Failed to get response from Gemini")
            return fallback_code, fallback_json, False, "Failed to get response from Gemini after retries"

        logger.info(f"📋 Raw Gemini response received (length: {len(response_text)})")

        # Clean the response to remove markdown code blocks
        cleaned_response = self._clean_response(response_text)
        logger.info(f"🧹 Cleaned response (length: {len(cleaned_response)})")

        # Try parsing as JSON
        try:
            response_data = json.loads(cleaned_response)
            logger.info("✅ Parsed response as JSON")
        except json.JSONDecodeError as json_error:
            logger.error(f"❌ JSON parsing failed: {str(json_error)}")
            try:
                response_data = ast.literal_eval(cleaned_response)
                logger.info("⚠️ Parsed response as Python literal (fallback)")
            except Exception as ast_error:
                logger.error(f"❌ AST parsing also failed: {str(ast_error)}")
                fallback_code, fallback_json = self._get_professional_fallback_widget("Invalid response format")
                return fallback_code, fallback_json, False, f"Parsing error: {str(json_error)}"

        code = response_data.get("code", "")
        ui_json_raw = response_data.get("ui_json", {})

        if not code:
            logger.error("❌ No code found in response")
            fallback_code, fallback_json = self._get_professional_fallback_widget("No code in response")
            return fallback_code, fallback_json, False, "No code in response"

        logger.info(f"🧹 Cleaning generated code...")
        cleaned_code = self._clean_code_response(code)
        logger.info(f"✅ Cleaned code (length: {len(cleaned_code)})")

        # Handle ui_json - it might be a string or dict
        ui_json = self._parse_ui_json(ui_json_raw)
        logger.info(f"🔍 Parsed UI JSON type: {type(ui_json)}")

        # Validate ui_json
        if not isinstance(ui_json, dict):
            logger.error(f"❌ Invalid JSON structure - expected dict, got {type(ui_json)}")
            fallback_code, fallback_json = self._get_professional_fallback_widget("Invalid JSON structure")
            return fallback_code, fallback_json, False, "Invalid JSON structure"

        return cleaned_code, ui_json, True, None

    def _parse_ui_json(self, ui_json_raw):
        """Parse ui_json whether it's a string or dict"""
        if isinstance(ui_json_raw, dict):
            logger.info("🔍 ui_json is already a dict")
            return ui_json_raw
        elif isinstance(ui_json_raw, str):
            logger.info("🔍 ui_json is a string, parsing...")
            try:
                parsed = json.loads(ui_json_raw)
                logger.info("✅ Successfully parsed ui_json string")
                return parsed
            except json.JSONDecodeError as e:
                logger.error(f"❌ Failed to parse ui_json string: {str(e)}")
                return {}
        else:
            logger.error(f"❌ ui_json is unexpected type: {type(ui_json_raw)}")
            return {}

    def _clean_response(self, response_text: str) -> str:
        """Clean the response by removing markdown code blocks and extra formatting"""
        logger.info(f"🧹 Starting response cleanup...")
        
        # Remove markdown code blocks
        response_text = re.sub(r'```json\s*\n?', '', response_text)
        response_text = re.sub(r'```dart\s*\n?', '', response_text)
        response_text = re.sub(r'```\s*\n?', '', response_text)
        
        # Remove any leading/trailing whitespace
        response_text = response_text.strip()
        
        # If the response doesn't start with {, try to find the JSON part
        if not response_text.startswith('{'):
            # Look for the first { and last }
            start_idx = response_text.find('{')
            end_idx = response_text.rfind('}')
            
            if start_idx != -1 and end_idx != -1 and end_idx > start_idx:
                response_text = response_text[start_idx:end_idx + 1]
                logger.info(f"🧹 Extracted JSON from position {start_idx} to {end_idx}")
            else:
                logger.error(f"🧹 Could not find valid JSON boundaries")
        
        return response_text
    
    def _clean_code_response(self, code: str) -> str:
        """Clean and validate the generated code"""
        logger.info(f"🧹 Starting code cleanup...")
        
        if not code or not code.strip():
            logger.error("🧹 Empty or whitespace-only code")
            return self._get_professional_fallback_widget("Empty code response")[0]
        
        # Remove markdown code blocks if present
        code = re.sub(r'```dart\n?', '', code)
        code = re.sub(r'```\n?', '', code)
        code = code.strip()
        
        # Ensure proper imports
        if "import 'package:flutter/material.dart';" not in code:
            logger.info("🧹 Adding missing Flutter import")
            code = "import 'package:flutter/material.dart';\n\n" + code
        
        # Fix common formatting issues
        code = self._fix_code_formatting(code)
        
        logger.info(f"🧹 Final cleaned code length: {len(code)}")
        return code
    
    def _fix_code_formatting(self, code: str) -> str:
        """Fix common formatting issues in the generated code"""
        # Fix the space issue in import statement
        code = re.sub(r"import 'package:\s+flutter/material\.dart';", "import 'package:flutter/material.dart';", code)
        
        # Fix broken lines
        code = re.sub(r'\n\s*(\w+:)', r' \1', code)
        
        # Ensure proper spacing around operators
        code = re.sub(r'(\w+):', r'\1: ', code)
        
        # Remove duplicate spaces
        code = re.sub(r' +', ' ', code)
        
        # Basic indentation fix
        code = self._fix_basic_indentation(code)
        
        return code
    
    def _fix_basic_indentation(self, code: str) -> str:
        """Apply basic indentation fixes"""
        lines = code.split('\n')
        indented_lines = []
        indent_level = 0
        
        for line in lines:
            stripped = line.strip()
            if not stripped:
                continue
                
            # Decrease indent for closing braces
            if stripped.startswith('}'):
                indent_level = max(0, indent_level - 1)
            
            # Add the line with proper indentation
            indented_lines.append('  ' * indent_level + stripped)
            
            # Increase indent for opening braces
            if stripped.endswith('{'):
                indent_level += 1
        
        return '\n'.join(indented_lines)
    
    def _get_professional_fallback_widget(self, error: str) -> Tuple[str, Dict[str, Any]]:
        """Return a professional fallback widget and comprehensive JSON"""
        logger.warning(f"⚠️ Generating professional fallback widget due to error: {error}")
        
        fallback_code = """import 'package:flutter/material.dart';

class GeneratedWidget extends StatelessWidget {
  const GeneratedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Professional UI',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6366F1),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F7FA),
              Color(0xFFE8EDF5),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Color(0xFFFAFBFF),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 40,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Professional UI Generator',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ready to create beautiful, modern Flutter UIs',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}"""
        
        fallback_json = {
            "type": "Scaffold",
            "properties": {
                "backgroundColor": "#F5F7FA",
                "appBar": {
                    "type": "AppBar",
                    "properties": {
                        "title": "Professional UI",
                        "backgroundColor": "#6366F1",
                        "elevation": 0,
                        "centerTitle": True,
                        "titleStyle": {
                            "fontWeight": "w600",
                            "color": "#FFFFFF"
                        }
                    }
                }
            },
            "children": [
                {
                    "type": "Container",
                    "properties": {
                        "decoration": {
                            "gradient": {
                                "type": "LinearGradient",
                                "begin": "topCenter",
                                "end": "bottomCenter",
                                "colors": ["#F5F7FA", "#E8EDF5"]
                            }
                        }
                    },
                    "children": [
                        {
                            "type": "Center",
                            "children": [
                                {
                                    "type": "Padding",
                                    "properties": {
                                        "padding": {"all": 24.0}
                                    },
                                    "children": [
                                        {
                                            "type": "Card",
                                            "properties": {
                                                "elevation": 8,
                                                "borderRadius": 16,
                                                "gradient": {
                                                    "type": "LinearGradient",
                                                    "begin": "topLeft",
                                                    "end": "bottomRight",
                                                    "colors": ["#FFFFFF", "#FAFBFF"]
                                                }
                                            },
                                            "children": [
                                                {
                                                    "type": "Column",
                                                    "properties": {
                                                        "mainAxisSize": "min",
                                                        "padding": {"all": 32.0}
                                                    },
                                                    "children": [
                                                        {
                                                            "type": "Container",
                                                            "properties": {
                                                                "width": 80,
                                                                "height": 80,
                                                                "decoration": {
                                                                    "color": "#6366F1",
                                                                    "opacity": 0.1,
                                                                    "borderRadius": 40
                                                                }
                                                            },
                                                            "children": [
                                                                {
                                                                    "type": "Icon",
                                                                    "properties": {
                                                                        "icon": "Icons.auto_awesome",
                                                                        "size": 40,
                                                                        "color": "#6366F1"
                                                                    }
                                                                }
                                                            ]
                                                        },
                                                        {
                                                            "type": "SizedBox",
                                                            "properties": {"height": 24}
                                                        },
                                                        {
                                                            "type": "Text",
                                                            "properties": {
                                                                "text": "Professional UI Generator",
                                                                "style": {
                                                                    "fontSize": 22,
                                                                    "fontWeight": "bold",
                                                                    "color": "#1F2937"
                                                                },
                                                                "textAlign": "center"
                                                            }
                                                        },
                                                        {
                                                            "type": "SizedBox",
                                                            "properties": {"height": 12}
                                                        },
                                                        {
                                                            "type": "Text",
                                                            "properties": {
                                                                "text": "Ready to create beautiful, modern Flutter UIs",
                                                                "style": {
                                                                    "fontSize": 14,
                                                                    "color": "#6B7280",
                                                                    "height": 1.5
                                                                },
                                                                "textAlign": "center"
                                                            }
                                                        },
                                                        {
                                                            "type": "SizedBox",
                                                            "properties": {"height": 32}
                                                        },
                                                        {
                                                            "type": "ElevatedButton",
                                                            "properties": {
                                                                "text": "Get Started",
                                                                "onPressed": "() {}",
                                                                "style": {
                                                                    "backgroundColor": "#6366F1",
                                                                    "foregroundColor": "#FFFFFF",
                                                                    "padding": {
                                                                        "horizontal": 32,
                                                                        "vertical": 16
                                                                    },
                                                                    "borderRadius": 12,
                                                                    "elevation": 4,
                                                                    "textStyle": {
                                                                        "fontSize": 16,
                                                                        "fontWeight": "w600"
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    ]
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ]
        }
        
        logger.info(f"⚠️ Professional fallback widget and comprehensive JSON generated")
        return fallback_code.strip(), fallback_json