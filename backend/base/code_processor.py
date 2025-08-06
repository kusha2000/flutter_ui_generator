import json
import ast
import re
import time
import random
import logging
from typing import Dict, Any, Optional, Tuple, Callable
from .models import RetryConfig

logger = logging.getLogger(__name__)

class CodeProcessor:
    """Handles code processing, cleaning, and parsing operations"""
    
    def __init__(self):
        logger.info("🔧 Initializing CodeProcessor...")
    
    def make_request_with_retry(
        self, 
        api_call: Callable[[str], Optional[str]], 
        prompt: str, 
        retry_config: RetryConfig
    ) -> Optional[str]:
        """Make API request with exponential backoff retry logic"""
        logger.info(f"📡 Starting API request with max {retry_config.max_retries} retries")
        logger.info(f"📏 Prompt length: {len(prompt)} characters")
        
        last_error = None
        
        for attempt in range(retry_config.max_retries):
            try:
                logger.info(f"🚀 Attempt {attempt + 1}/{retry_config.max_retries}: Sending request...")
                
                response = api_call(prompt)
                
                if response and response.strip():
                    logger.info(f"✅ Successfully received response on attempt {attempt + 1}")
                    logger.info(f"📏 Response length: {len(response)} characters")
                    return response
                else:
                    logger.warning(f"⚠️ Empty response on attempt {attempt + 1}")
                    last_error = "Empty response from API"
                    
            except Exception as e:
                error_msg = str(e)
                logger.error(f"❌ Attempt {attempt + 1} failed with error: {error_msg}")
                last_error = error_msg
                
                # Handle different types of errors
                if attempt < retry_config.max_retries - 1:
                    delay = self._exponential_backoff(
                        attempt, 
                        retry_config.base_delay, 
                        retry_config.max_delay
                    )
                    
                    if "503" in error_msg or "overloaded" in error_msg.lower():
                        logger.info(f"⏳ Service overloaded, waiting {delay:.2f}s before retry...")
                    elif "429" in error_msg or "quota" in error_msg.lower():
                        delay = self._exponential_backoff(attempt, base_delay=5.0)
                        logger.info(f"⏳ Rate limited, waiting {delay:.2f}s before retry...")
                    else:
                        logger.info(f"⏳ Error occurred, waiting {delay:.2f}s before retry...")
                    
                    time.sleep(delay)
        
        logger.error(f"❌ All retry attempts failed. Last error: {last_error}")
        return None
    
    def _exponential_backoff(self, attempt: int, base_delay: float = 1.0, max_delay: float = 60.0) -> float:
        """Calculate exponential backoff delay with jitter"""
        delay = min(base_delay * (2 ** attempt), max_delay)
        jitter = random.uniform(0.1, 0.3) * delay
        return delay + jitter
    
    def clean_response(self, response_text: str) -> str:
        """Clean the response by removing markdown code blocks and extra formatting"""
        logger.info(f"🧹 Starting response cleanup...")
        logger.info(f"📏 Original response length: {len(response_text)} characters")
        
        # Remove markdown code blocks
        response_text = re.sub(r'```json\s*\n?', '', response_text)
        response_text = re.sub(r'```dart\s*\n?', '', response_text)
        response_text = re.sub(r'```\s*\n?', '', response_text)
        
        # Remove any leading/trailing whitespace
        response_text = response_text.strip()
        
        # If the response doesn't start with {, try to find the JSON part
        if not response_text.startswith('{'):
            logger.info("🔍 Response doesn't start with '{', searching for JSON boundaries...")
            start_idx = response_text.find('{')
            end_idx = response_text.rfind('}')
            
            if start_idx != -1 and end_idx != -1 and end_idx > start_idx:
                response_text = response_text[start_idx:end_idx + 1]
                logger.info(f"🧹 Extracted JSON from position {start_idx} to {end_idx}")
        
        logger.info(f"🧹 Cleanup complete")
        return response_text
    
    def parse_response(self, cleaned_response: str, widget_name: str = "GeneratedWidget") -> Tuple[str, Dict[str, Any], bool, Optional[str]]:
        """Parse the cleaned response and extract code and JSON"""
        logger.info("🔍 Parsing JSON response...")
        logger.info(f"🎯 Target widget name: {widget_name}")
        
        # Try parsing as JSON
        try:
            response_data = json.loads(cleaned_response)
            logger.info("✅ Successfully parsed response as JSON")
        except json.JSONDecodeError as json_error:
            logger.error(f"❌ JSON parsing failed: {str(json_error)}")
            try:
                logger.info("🔄 Attempting AST literal_eval as fallback...")
                response_data = ast.literal_eval(cleaned_response)
                logger.info("⚠️ Successfully parsed response as Python literal (fallback)")
            except Exception as ast_error:
                logger.error(f"❌ AST parsing also failed: {str(ast_error)}")
                fallback_code, fallback_json = self.get_professional_fallback_widget("Invalid response format", widget_name)
                return fallback_code, fallback_json, False, f"Parsing error: {str(json_error)}"
        
        # Extract code and UI JSON
        code = response_data.get("code", "")
        ui_json_raw = response_data.get("ui_json", {})
        
        if not code:
            logger.error("❌ No code found in response")
            fallback_code, fallback_json = self.get_professional_fallback_widget("No code in response", widget_name)
            return fallback_code, fallback_json, False, "No code in response"
        
        # Clean and validate code
        cleaned_code = self.clean_code_response(code, widget_name)
        
        # Parse UI JSON
        ui_json = self._parse_ui_json(ui_json_raw)
        
        # Validate ui_json
        if not isinstance(ui_json, dict):
            logger.error(f"❌ Invalid JSON structure - expected dict, got {type(ui_json)}")
            fallback_code, fallback_json = self.get_professional_fallback_widget("Invalid JSON structure", widget_name)
            return fallback_code, fallback_json, False, "Invalid JSON structure"
        
        logger.info("✅ Response parsed successfully")
        return cleaned_code, ui_json, True, None
    
    def clean_code_response(self, code: str, widget_name: str = "GeneratedWidget") -> str:
        """Clean and validate the generated code"""
        logger.info(f"🧹 Starting code cleanup...")
        logger.info(f"🎯 Target widget name: {widget_name}")
        logger.info(f"📏 Original code length: {len(code)} characters")
        
        if not code or not code.strip():
            logger.error("❌ Empty or whitespace-only code detected")
            return self.get_professional_fallback_widget("Empty code response", widget_name)[0]
        
        # Remove markdown code blocks if present
        code = re.sub(r'```dart\n?', '', code)
        code = re.sub(r'```\n?', '', code)
        code = code.strip()
        
        # Fix the import statement issue (remove extra space)
        logger.info("🔧 Fixing import statement...")
        code = re.sub(r"import\s+'package:\s+flutter/material\.dart';", "import 'package:flutter/material.dart';", code)
        
        # Ensure proper imports
        if "import 'package:flutter/material.dart';" not in code:
            logger.info("🧹 Adding missing Flutter import")
            code = "import 'package:flutter/material.dart';\n\n" + code
        
        # Fix widget naming - replace any incorrect widget names with the correct one
        logger.info(f"🔧 Enforcing widget name: {widget_name}")
        
        # List of common incorrect widget names to replace
        incorrect_names = [
            'GeneratedWidget',
            'MainWidget', 
            'Main',
            'MyWidget',
            'AppWidget',
            'HomeWidget',
            'CustomWidget',
            'UIWidget'
        ]
        
        # Replace incorrect widget names with the correct one
        for incorrect_name in incorrect_names:
            if incorrect_name != widget_name:  # Don't replace if it's already correct
                # Replace class declaration
                code = re.sub(
                    rf'class\s+{incorrect_name}\s*extends',
                    f'class {widget_name} extends',
                    code
                )
                # Replace constructor
                code = re.sub(
                    rf'const\s+{incorrect_name}\s*\(',
                    f'const {widget_name}(',
                    code
                )
        
        # Fix common formatting issues
        code = self._fix_code_formatting(code)
        
        # Verify the widget name is correctly set
        if f'class {widget_name}' not in code:
            logger.warning(f"⚠️ Widget name {widget_name} not found in code, attempting to fix...")
            # Try to find any class declaration and replace it
            class_match = re.search(r'class\s+(\w+)\s+extends\s+(StatelessWidget|StatefulWidget)', code)
            if class_match:
                old_name = class_match.group(1)
                logger.info(f"🔧 Replacing widget name '{old_name}' with '{widget_name}'")
                code = code.replace(f'class {old_name}', f'class {widget_name}')
                code = code.replace(f'const {old_name}(', f'const {widget_name}(')
            else:
                logger.error(f"❌ Could not find class declaration to fix widget name")
        
        logger.info(f"🧹 Code cleanup complete")
        return code
    
    def _fix_code_formatting(self, code: str) -> str:
        """Fix common formatting issues in the generated code"""
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
    
    def _parse_ui_json(self, ui_json_raw):
        """Parse ui_json whether it's a string or dict"""
        if isinstance(ui_json_raw, dict):
            return ui_json_raw
        elif isinstance(ui_json_raw, str):
            try:
                return json.loads(ui_json_raw)
            except json.JSONDecodeError as e:
                logger.error(f"❌ Failed to parse ui_json string: {str(e)}")
                return {}
        else:
            logger.error(f"❌ ui_json is unexpected type: {type(ui_json_raw)}")
            return {}
    
    def get_professional_fallback_widget(self, error: str, widget_name: str = "GeneratedWidget") -> Tuple[str, Dict[str, Any]]:
        """Return a professional fallback widget and comprehensive JSON"""
        logger.warning(f"🛡️ Generating professional fallback widget due to error: {error}")
        logger.info(f"🎯 Using widget name: {widget_name}")
        
        fallback_code = f"""import 'package:flutter/material.dart';

class {widget_name} extends StatelessWidget {{
  const {widget_name}({{Key? key}}) : super(key: key);

  @override
  Widget build(BuildContext context) {{
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
                      onPressed: () {{}},
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
  }}
}}"""
        
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
                                    "type": "Card",
                                    "properties": {
                                        "elevation": 8,
                                        "borderRadius": 16,
                                        "padding": {"all": 32.0}
                                    },
                                    "children": [
                                        {
                                            "type": "Column",
                                            "properties": {"mainAxisSize": "min"},
                                            "children": [
                                                {
                                                    "type": "Icon",
                                                    "properties": {
                                                        "icon": "Icons.auto_awesome",
                                                        "size": 40,
                                                        "color": "#6366F1"
                                                    }
                                                },
                                                {
                                                    "type": "Text",
                                                    "properties": {
                                                        "text": "Professional UI Generator",
                                                        "style": {
                                                            "fontSize": 22,
                                                            "fontWeight": "bold",
                                                            "color": "#1F2937"
                                                        }
                                                    }
                                                },
                                                {
                                                    "type": "ElevatedButton",
                                                    "properties": {
                                                        "text": "Get Started",
                                                        "style": {
                                                            "backgroundColor": "#6366F1",
                                                            "borderRadius": 12,
                                                            "elevation": 4
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
        
        return fallback_code.strip(), fallback_json