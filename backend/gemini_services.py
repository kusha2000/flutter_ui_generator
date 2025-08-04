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
from pathlib import Path

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

class GeminiService:
    def __init__(self):
        print("🚀 Initializing GeminiService...")
        
        self.api_key = os.getenv('GEMINI_API_KEY')
        print(f"🔑 Gemini API Key loaded: {'✅ Found' if self.api_key else '❌ Missing'}")
        logger.info(f"Gemini Key: {self.api_key}")
        
        if not self.api_key:
            print("❌ GEMINI_API_KEY not found in environment variables")
            raise ValueError("GEMINI_API_KEY not found in environment variables")
        
        print("⚙️ Configuring Gemini AI...")
        genai.configure(api_key=self.api_key)
        
        # Configure generation settings for better reliability
        self.generation_config = {
            'temperature': 0.7,
            'top_p': 0.8,
            'top_k': 40,
            'max_output_tokens': 8192,
        }
        print(f"📋 Generation config set: {self.generation_config}")
        
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
        print(f"🛡️ Safety settings configured with {len(self.safety_settings)} categories")
        
        model_names = [
            'gemini-1.5-flash',
            'gemini-1.5-pro',
            'gemini-1.0-pro',
            'gemini-pro'
        ]
        print(f"🔍 Attempting to initialize models in order: {model_names}")
        
        self.model = None
        self.current_model_name = None
        
        for i, model_name in enumerate(model_names):
            try:
                print(f"🔄 [{i+1}/{len(model_names)}] Trying to initialize model: {model_name}")
                logger.info(f"🔄 Trying to initialize model: {model_name}")
                
                self.model = genai.GenerativeModel(
                    model_name,
                    generation_config=self.generation_config,
                    safety_settings=self.safety_settings
                )
                
                # Test the model with a simple request
                print(f"🧪 Testing model {model_name} with simple request...")
                test_response = self.model.generate_content("Hello")
                
                if test_response.text:
                    print(f"✅ Successfully initialized and tested model: {model_name}")
                    print(f"📝 Test response received: {test_response.text[:50]}...")
                    logger.info(f"✅ Successfully initialized model: {model_name}")
                    self.current_model_name = model_name
                    break
                else:
                    print(f"⚠️ Model {model_name} initialized but returned empty test response")
                    
            except Exception as e:
                print(f"❌ Failed to initialize {model_name}: {str(e)}")
                logger.error(f"❌ Failed to initialize {model_name}: {str(e)}")
                continue
        
        if not self.model:
            print("💥 No available Gemini models found - raising error")
            raise ValueError("No available Gemini models found")
        
        print(f"🎯 Successfully using Gemini model: {self.current_model_name}")
        logger.info(f"🎯 Using Gemini model: {self.current_model_name}")
        
        # Set up file paths
        self._setup_file_paths()
    
    def _setup_file_paths(self):
        """Set up file paths for writing generated code"""
        print("📁 Setting up file paths...")
        
        # Get the current directory (backend)
        current_dir = Path(__file__).parent
        print(f"📍 Current directory: {current_dir}")
        
        # Navigate to the frontend/lib/widgets directory
        self.frontend_dir = current_dir.parent / "frontend"
        self.lib_dir = self.frontend_dir / "lib"
        self.widgets_dir = self.lib_dir / "widgets"
        self.target_file = self.widgets_dir / "generated_widget_loader.dart"
        
        print(f"📂 Frontend directory: {self.frontend_dir}")
        print(f"📂 Lib directory: {self.lib_dir}")
        print(f"📂 Widgets directory: {self.widgets_dir}")
        print(f"📄 Target file: {self.target_file}")
        
        # Check if directories exist
        if not self.frontend_dir.exists():
            print(f"⚠️ Frontend directory does not exist: {self.frontend_dir}")
        if not self.lib_dir.exists():
            print(f"⚠️ Lib directory does not exist: {self.lib_dir}")
        if not self.widgets_dir.exists():
            print(f"📁 Creating widgets directory: {self.widgets_dir}")
            self.widgets_dir.mkdir(parents=True, exist_ok=True)
        
        print("✅ File paths setup complete")
    
    def _write_dart_file(self, dart_code: str) -> bool:
        """Write the generated Dart code to the target file"""
        print(f"📝 Writing Dart code to file: {self.target_file}")
        print(f"📏 Code length: {len(dart_code)} characters")
        
        try:
            # Ensure the widgets directory exists
            self.widgets_dir.mkdir(parents=True, exist_ok=True)
            print(f"📁 Ensured widgets directory exists: {self.widgets_dir}")
            
            # Write the Dart code to the file
            with open(self.target_file, 'w', encoding='utf-8') as f:
                f.write(dart_code)
            
            print(f"✅ Successfully wrote Dart code to: {self.target_file}")
            print(f"📊 File size: {self.target_file.stat().st_size} bytes")
            
            # Verify the file was written correctly
            if self.target_file.exists():
                with open(self.target_file, 'r', encoding='utf-8') as f:
                    written_content = f.read()
                if len(written_content) == len(dart_code):
                    print(f"✅ File verification successful - content matches")
                    return True
                else:
                    print(f"⚠️ File verification warning - length mismatch: {len(written_content)} vs {len(dart_code)}")
                    return True  # Still consider it successful
            else:
                print(f"❌ File verification failed - file does not exist after write")
                return False
                
        except Exception as e:
            print(f"❌ Error writing Dart file: {str(e)}")
            logger.error(f"❌ Error writing Dart file: {str(e)}")
            return False
    
    def _exponential_backoff(self, attempt: int, base_delay: float = 1.0, max_delay: float = 60.0) -> float:
        """Calculate exponential backoff delay with jitter"""
        print(f"⏱️ Calculating backoff delay for attempt {attempt + 1}")
        
        delay = min(base_delay * (2 ** attempt), max_delay)
        # Add jitter to prevent thundering herd
        jitter = random.uniform(0.1, 0.3) * delay
        final_delay = delay + jitter
        
        print(f"⏱️ Base delay: {delay:.2f}s, Jitter: {jitter:.2f}s, Final delay: {final_delay:.2f}s")
        return final_delay
    
    def _make_request_with_retry(self, prompt: str, max_retries: int = 3) -> Optional[str]:
        """Make API request with exponential backoff retry logic"""
        print(f"📡 Starting API request with max {max_retries} retries")
        print(f"📏 Prompt length: {len(prompt)} characters")
        
        last_error = None
        
        for attempt in range(max_retries):
            try:
                print(f"🚀 Attempt {attempt + 1}/{max_retries}: Sending request to Gemini...")
                logger.info(f"🚀 Attempt {attempt + 1}/{max_retries}: Sending request to Gemini...")
                
                response = self.model.generate_content(prompt)
                print(f"📨 Received response from Gemini")
                
                if response.text and response.text.strip():
                    print(f"✅ Successfully received response on attempt {attempt + 1}")
                    print(f"📏 Response length: {len(response.text)} characters")
                    print(f"📝 Response preview: {response.text[:100]}...")
                    logger.info(f"✅ Successfully received response on attempt {attempt + 1}")
                    return response.text
                else:
                    print(f"⚠️ Empty response on attempt {attempt + 1}")
                    logger.warning(f"⚠️ Empty response on attempt {attempt + 1}")
                    last_error = "Empty response from Gemini"
                    
            except Exception as e:
                error_msg = str(e)
                print(f"❌ Attempt {attempt + 1} failed with error: {error_msg}")
                logger.error(f"❌ Attempt {attempt + 1} failed: {error_msg}")
                last_error = error_msg
                
                # Check if it's a rate limit or overload error
                if "503" in error_msg or "overloaded" in error_msg.lower():
                    if attempt < max_retries - 1:
                        delay = self._exponential_backoff(attempt)
                        print(f"⏳ Model overloaded, waiting {delay:.2f}s before retry...")
                        logger.info(f"⏳ Model overloaded, waiting {delay:.2f}s before retry...")
                        time.sleep(delay)
                        continue
                
                # For other errors, don't retry immediately
                elif "429" in error_msg or "quota" in error_msg.lower():
                    if attempt < max_retries - 1:
                        delay = self._exponential_backoff(attempt, base_delay=5.0)
                        print(f"⏳ Rate limited, waiting {delay:.2f}s before retry...")
                        logger.info(f"⏳ Rate limited, waiting {delay:.2f}s before retry...")
                        time.sleep(delay)
                        continue
                
                # For other errors, shorter delay
                elif attempt < max_retries - 1:
                    delay = self._exponential_backoff(attempt, base_delay=2.0)
                    print(f"⏳ Error occurred, waiting {delay:.2f}s before retry...")
                    logger.info(f"⏳ Error occurred, waiting {delay:.2f}s before retry...")
                    time.sleep(delay)
                    continue
        
        print(f"❌ All retry attempts failed. Last error: {last_error}")
        logger.error(f"❌ All retry attempts failed. Last error: {last_error}")
        return None
    
    def list_available_models(self):
        """List all available models for debugging"""
        print("📋 Listing available Gemini models...")
        
        try:
            models = genai.list_models()
            print("📋 Available models:")
            logger.info("📋 Available models:")
            
            for i, model in enumerate(models):
                print(f"  {i+1}. {model.name}")
                print(f"     Supported methods: {model.supported_generation_methods}")
                logger.info(f"  - {model.name}")
                logger.info(f"    Supported methods: {model.supported_generation_methods}")
            
            print(f"📊 Total models found: {len(list(models))}")
            return models
            
        except Exception as e:
            print(f"❌ Error listing models: {str(e)}")
            logger.error(f"❌ Error listing models: {str(e)}")
            return []

    def generate_flutter_code(self, prompt: str) -> Tuple[str, Dict[str, Any], bool, Optional[str]]:
        """
        Generate Flutter/Dart code and JSON UI representation based on natural language prompt.
        Also writes the generated code to the target Dart file.
        Returns: (code, ui_json, success, error_message)
        """
        print("=" * 80)
        print("🎨 STARTING FLUTTER CODE GENERATION")
        print("=" * 80)
        print(f"🔍 Received prompt: '{prompt}'")
        print(f"📏 Prompt length: {len(prompt)} characters")
        logger.info(f"🔍 Received prompt: {prompt}")

        print("\n📝 Preparing system prompt...")
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

        print("✅ System prompt prepared")
        print(f"📏 System prompt length: {len(system_prompt)} characters")

        full_prompt = f"{system_prompt}\n\nUser request: {prompt}"
        print(f"📏 Full prompt length: {len(full_prompt)} characters")
        logger.info(f"📝 Full prompt prepared")

        print("\n🌐 Making API request to Gemini...")
        # Make request with retry logic
        response_text = self._make_request_with_retry(full_prompt, max_retries=3)
        
        if not response_text:
            print("❌ Failed to get response from Gemini after all retries")
            logger.error("❌ Failed to get response from Gemini after all retries")
            fallback_code, fallback_json = self._get_professional_fallback_widget("Failed to get response from Gemini")
            
            # Still try to write the fallback code to file
            print("📝 Writing fallback code to file...")
            file_written = self._write_dart_file(fallback_code)
            print(f"📄 Fallback code file write: {'✅ Success' if file_written else '❌ Failed'}")
            
            return fallback_code, fallback_json, False, "Failed to get response from Gemini after retries"

        print(f"📋 Raw Gemini response received")
        print(f"📏 Response length: {len(response_text)} characters")
        print(f"📝 Response preview: {response_text[:200]}...")
        logger.info(f"📋 Raw Gemini response received (length: {len(response_text)})")

        print("\n🧹 Cleaning response...")
        # Clean the response to remove markdown code blocks
        cleaned_response = self._clean_response(response_text)
        print(f"🧹 Cleaned response")
        print(f"📏 Cleaned length: {len(cleaned_response)} characters")
        print(f"📝 Cleaned preview: {cleaned_response[:200]}...")
        logger.info(f"🧹 Cleaned response (length: {len(cleaned_response)})")

        print("\n🔍 Parsing JSON response...")
        # Try parsing as JSON
        try:
            response_data = json.loads(cleaned_response)
            print("✅ Successfully parsed response as JSON")
            logger.info("✅ Parsed response as JSON")
        except json.JSONDecodeError as json_error:
            print(f"❌ JSON parsing failed: {str(json_error)}")
            logger.error(f"❌ JSON parsing failed: {str(json_error)}")
            try:
                print("🔄 Attempting AST literal_eval as fallback...")
                response_data = ast.literal_eval(cleaned_response)
                print("⚠️ Successfully parsed response as Python literal (fallback)")
                logger.info("⚠️ Parsed response as Python literal (fallback)")
            except Exception as ast_error:
                print(f"❌ AST parsing also failed: {str(ast_error)}")
                logger.error(f"❌ AST parsing also failed: {str(ast_error)}")
                fallback_code, fallback_json = self._get_professional_fallback_widget("Invalid response format")
                
                # Still try to write the fallback code to file
                print("📝 Writing fallback code to file...")
                file_written = self._write_dart_file(fallback_code)
                print(f"📄 Fallback code file write: {'✅ Success' if file_written else '❌ Failed'}")
                
                return fallback_code, fallback_json, False, f"Parsing error: {str(json_error)}"

        print("\n📤 Extracting code and UI JSON from response...")
        code = response_data.get("code", "")
        ui_json_raw = response_data.get("ui_json", {})
        
        print(f"📋 Code extracted: {'✅ Found' if code else '❌ Missing'}")
        print(f"📋 UI JSON extracted: {'✅ Found' if ui_json_raw else '❌ Missing'}")

        if not code:
            print("❌ No code found in response")
            logger.error("❌ No code found in response")
            fallback_code, fallback_json = self._get_professional_fallback_widget("No code in response")
            
            # Still try to write the fallback code to file
            print("📝 Writing fallback code to file...")
            file_written = self._write_dart_file(fallback_code)
            print(f"📄 Fallback code file write: {'✅ Success' if file_written else '❌ Failed'}")
            
            return fallback_code, fallback_json, False, "No code in response"

        print(f"📏 Raw code length: {len(code)} characters")
        print(f"📝 Raw code preview: {code[:200]}...")

        print("\n🧹 Cleaning generated code...")
        cleaned_code = self._clean_code_response(code)
        print(f"✅ Code cleaned")
        print(f"📏 Cleaned code length: {len(cleaned_code)} characters")
        print(f"📝 Cleaned code preview: {cleaned_code[:200]}...")
        logger.info(f"✅ Cleaned code (length: {len(cleaned_code)})")

        print("\n🔍 Parsing UI JSON...")
        # Handle ui_json - it might be a string or dict
        ui_json = self._parse_ui_json(ui_json_raw)
        print(f"🔍 Parsed UI JSON type: {type(ui_json)}")
        print(f"📊 UI JSON keys: {list(ui_json.keys()) if isinstance(ui_json, dict) else 'Not a dict'}")
        logger.info(f"🔍 Parsed UI JSON type: {type(ui_json)}")

        # Validate ui_json
        if not isinstance(ui_json, dict):
            print(f"❌ Invalid JSON structure - expected dict, got {type(ui_json)}")
            logger.error(f"❌ Invalid JSON structure - expected dict, got {type(ui_json)}")
            fallback_code, fallback_json = self._get_professional_fallback_widget("Invalid JSON structure")
            
            # Still try to write the fallback code to file
            print("📝 Writing fallback code to file...")
            file_written = self._write_dart_file(fallback_code)
            print(f"📄 Fallback code file write: {'✅ Success' if file_written else '❌ Failed'}")
            
            return fallback_code, fallback_json, False, "Invalid JSON structure"

        print("\n📝 Writing generated code to Dart file...")
        # Write the generated code to the target file
        file_written = self._write_dart_file(cleaned_code)
        
        if file_written:
            print("✅ Successfully wrote generated code to file!")
        else:
            print("⚠️ Failed to write code to file, but continuing with response")

        print("\n🎉 FLUTTER CODE GENERATION COMPLETED SUCCESSFULLY!")
        print("=" * 80)
        print(f"📊 Final Results:")
        print(f"   Code length: {len(cleaned_code)} characters")
        print(f"   UI JSON keys: {len(ui_json)} top-level keys")
        print(f"   File written: {'✅ Yes' if file_written else '❌ No'}")
        print("=" * 80)

        return cleaned_code, ui_json, True, None

    def _parse_ui_json(self, ui_json_raw):
        """Parse ui_json whether it's a string or dict"""
        print(f"🔍 Parsing UI JSON of type: {type(ui_json_raw)}")
        
        if isinstance(ui_json_raw, dict):
            print("🔍 ui_json is already a dict")
            logger.info("🔍 ui_json is already a dict")
            return ui_json_raw
        elif isinstance(ui_json_raw, str):
            print("🔍 ui_json is a string, attempting to parse...")
            print(f"📏 String length: {len(ui_json_raw)} characters")
            logger.info("🔍 ui_json is a string, parsing...")
            try:
                parsed = json.loads(ui_json_raw)
                print("✅ Successfully parsed ui_json string")
                logger.info("✅ Successfully parsed ui_json string")
                return parsed
            except json.JSONDecodeError as e:
                print(f"❌ Failed to parse ui_json string: {str(e)}")
                logger.error(f"❌ Failed to parse ui_json string: {str(e)}")
                return {}
        else:
            print(f"❌ ui_json is unexpected type: {type(ui_json_raw)}")
            logger.error(f"❌ ui_json is unexpected type: {type(ui_json_raw)}")
            return {}

    def _clean_response(self, response_text: str) -> str:
        """Clean the response by removing markdown code blocks and extra formatting"""
        print(f"🧹 Starting response cleanup...")
        print(f"📏 Original response length: {len(response_text)} characters")
        logger.info(f"🧹 Starting response cleanup...")
        
        original_length = len(response_text)
        
        # Remove markdown code blocks
        response_text = re.sub(r'```json\s*\n?', '', response_text)
        response_text = re.sub(r'```dart\s*\n?', '', response_text)
        response_text = re.sub(r'```\s*\n?', '', response_text)
        
        print(f"🧹 Removed markdown blocks")
        
        # Remove any leading/trailing whitespace
        response_text = response_text.strip()
        
        print(f"🧹 Stripped whitespace")
        
        # If the response doesn't start with {, try to find the JSON part
        if not response_text.startswith('{'):
            print("🔍 Response doesn't start with '{', searching for JSON boundaries...")
            # Look for the first { and last }
            start_idx = response_text.find('{')
            end_idx = response_text.rfind('}')
            
            if start_idx != -1 and end_idx != -1 and end_idx > start_idx:
                response_text = response_text[start_idx:end_idx + 1]
                print(f"🧹 Extracted JSON from position {start_idx} to {end_idx}")
                logger.info(f"🧹 Extracted JSON from position {start_idx} to {end_idx}")
            else:
                print(f"❌ Could not find valid JSON boundaries")
                logger.error(f"🧹 Could not find valid JSON boundaries")
        else:
            print("✅ Response already starts with '{'")
        
        final_length = len(response_text)
        print(f"🧹 Cleanup complete: {original_length} → {final_length} characters")
        
        return response_text
    
    def _clean_code_response(self, code: str) -> str:
        """Clean and validate the generated code"""
        print(f"🧹 Starting code cleanup...")
        print(f"📏 Original code length: {len(code)} characters")
        logger.info(f"🧹 Starting code cleanup...")
        
        if not code or not code.strip():
            print("❌ Empty or whitespace-only code detected")
            logger.error("🧹 Empty or whitespace-only code")
            return self._get_professional_fallback_widget("Empty code response")[0]
        
        original_length = len(code)
        
        # Remove markdown code blocks if present
        print("🧹 Removing markdown code blocks...")
        code = re.sub(r'```dart\n?', '', code)
        code = re.sub(r'```\n?', '', code)
        code = code.strip()
        
        # Ensure proper imports
        if "import 'package:flutter/material.dart';" not in code:
            print("🧹 Adding missing Flutter import")
            logger.info("🧹 Adding missing Flutter import")
            code = "import 'package:flutter/material.dart';\n\n" + code
        else:
            print("✅ Flutter import already present")
        
        # Fix common formatting issues
        print("🧹 Fixing code formatting...")
        code = self._fix_code_formatting(code)
        
        final_length = len(code)
        print(f"🧹 Code cleanup complete: {original_length} → {final_length} characters")
        logger.info(f"🧹 Final cleaned code length: {len(code)}")
        return code
    
    def _fix_code_formatting(self, code: str) -> str:
        """Fix common formatting issues in the generated code"""
        print("🔧 Applying code formatting fixes...")
        
        # Fix the space issue in import statement
        code = re.sub(r"import 'package:\s+flutter/material\.dart';", "import 'package:flutter/material.dart';", code)
        print("🔧 Fixed import statement spacing")
        
        # Fix broken lines
        code = re.sub(r'\n\s*(\w+:)', r' \1', code)
        print("🔧 Fixed broken lines")
        
        # Ensure proper spacing around operators
        code = re.sub(r'(\w+):', r'\1: ', code)
        print("🔧 Fixed operator spacing")
        
        # Remove duplicate spaces
        code = re.sub(r' +', ' ', code)
        print("🔧 Removed duplicate spaces")
        
        # Basic indentation fix
        print("🔧 Applying basic indentation fixes...")
        code = self._fix_basic_indentation(code)
        
        print("✅ Code formatting fixes applied")
        return code
    
    def _fix_basic_indentation(self, code: str) -> str:
        """Apply basic indentation fixes"""
        print("📐 Starting indentation fix...")
        
        lines = code.split('\n')
        indented_lines = []
        indent_level = 0
        
        print(f"📐 Processing {len(lines)} lines...")
        
        for i, line in enumerate(lines):
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
        
        result = '\n'.join(indented_lines)
        print(f"📐 Indentation fix complete: {len(lines)} → {len(indented_lines)} lines")
        return result
    
    def _get_professional_fallback_widget(self, error: str) -> Tuple[str, Dict[str, Any]]:
        """Return a professional fallback widget and comprehensive JSON"""
        print(f"🛡️ Generating professional fallback widget...")
        print(f"⚠️ Reason: {error}")
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
        
        print(f"🛡️ Professional fallback widget generated")
        print(f"📏 Fallback code length: {len(fallback_code)} characters")
        print(f"📊 Fallback JSON keys: {len(fallback_json)} top-level keys")
        logger.info(f"⚠️ Professional fallback widget and comprehensive JSON generated")
        
        return fallback_code.strip(), fallback_json
