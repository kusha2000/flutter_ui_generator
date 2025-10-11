import re
import time
import random
import logging
from typing import Optional, Tuple, Callable
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
        """Clean the response by removing markdown code blocks"""
        logger.info(f"🧹 Starting response cleanup...")
        logger.info(f"📏 Original response length: {len(response_text)} characters")
        
        # Remove markdown code blocks
        response_text = re.sub(r'```dart\s*\n?', '', response_text)
        response_text = re.sub(r'```\s*\n?', '', response_text)
        
        # Remove any leading/trailing whitespace
        response_text = response_text.strip()
        
        logger.info(f"🧹 Cleanup complete. Final length: {len(response_text)} characters")
        return response_text
    
    def clean_code_response(self, code: str, widget_name: str = "GeneratedWidget") -> str:
        """Clean and validate the generated code for Flutter 3.27.1"""
        logger.info(f"🧹 Starting code cleanup for Flutter 3.27.1...")
        logger.info(f"🎯 Target widget name: {widget_name}")
        logger.info(f"📏 Original code length: {len(code)} characters")
        
        if not code or not code.strip():
            logger.error("❌ Empty or whitespace-only code detected")
            return self.get_professional_fallback_widget("Empty code response", widget_name)
        
        # Remove markdown code blocks if present
        code = re.sub(r'```dart\n?', '', code)
        code = re.sub(r'```\n?', '', code)
        code = code.strip()
        
        # Fix import statements - Remove ALL spaces after colons in package imports
        logger.info("🔧 Fixing import statements (removing spaces after colons)...")
        
        # Direct replacement approach for Flutter material import
        flutter_import_correct = "import 'package:flutter/material.dart';"
        
        # Check for various forms of the import statement
        has_space_import = False
        
        # Pattern 1: Check for space after package:
        if "import 'package: flutter/material.dart'" in code or 'import "package: flutter/material.dart"' in code or "import 'package:flutter/material.dart'" in code or 'import "package:flutter/material.dart"' :
            logger.warning("⚠️ Found space in import statement after 'package:'")
            logger.warning("   Original: import 'package: flutter/material.dart';")
            has_space_import = True
            
            # Replace with correct import
            code = code.replace("import 'package: flutter/material.dart';", flutter_import_correct)
            code = code.replace("import 'package:flutter/material.dart'", flutter_import_correct)
            code = code.replace('import "package: flutter/material.dart";', flutter_import_correct)
            code = code.replace('import "package:flutter/material.dart"', flutter_import_correct)
            
            logger.info("✅ Fixed space in Flutter material import")
            logger.info(f"   Fixed to: {flutter_import_correct}")
        
        # Additional generic fix for any package imports with spaces
        import_pattern = r"package:\s+"
        if re.search(import_pattern, code):
            if not has_space_import:
                logger.warning("⚠️ Found space in other package imports after 'package:'")
                # Extract and log the problematic import line(s)
                import_matches = re.findall(r"import\s+['\"]package:\s+[^'\"]+['\"];?", code)
                for match in import_matches:
                    logger.warning(f"   Original: {match}")
        
        # Fix common variations of the space issue in imports (generic fix)
        # Handles: 'package: xyz' -> 'package:xyz'
        original_code = code
        code = re.sub(r"'package:\s+", "'package:", code)
        code = re.sub(r'"package:\s+', '"package:', code)
        
        if original_code != code and not has_space_import:
            logger.info("✅ Fixed space in package imports")
            # Log the fixed import line(s)
            import_matches = re.findall(r"import\s+['\"]package:[^'\"]+['\"];?", code)
            for match in import_matches[:3]:  # Show first 3 to avoid spam
                logger.info(f"   Fixed to: {match}")
        
        if not has_space_import and original_code == code:
            logger.info("✅ No space issues found in package imports")
        
        # Check and fix spaces in URLs
        url_pattern = r"['\"]https?:\s+//"
        if re.search(url_pattern, code):
            logger.warning("⚠️ Found space in URL after colon")
            url_match = re.search(r"['\"]https?:\s+//[^'\"]+['\"]", code)
            if url_match:
                logger.warning(f"   Original URL: {url_match.group(0)}")
        
        # Also fix spaces in URLs (like the avatar image)
        # Handles: 'https: //' -> 'https://'
        original_code = code
        code = re.sub(r"'https:\s+//", "'https://", code)
        code = re.sub(r'"https:\s+//', '"https://', code)
        
        if original_code != code:
            logger.info("✅ Fixed space in URLs")
        
        # Check and fix spaces in time formats
        time_pattern = r"(\d+):\s+(\d+)"
        time_matches = re.findall(time_pattern, code)
        if time_matches:
            logger.warning(f"⚠️ Found {len(time_matches)} time format(s) with spaces")
            logger.info(f"   Examples: {', '.join([f'{m[0]}: {m[1]}' for m in time_matches[:3]])}")
        
        # Fix spaces in time formats (like '10: 00 AM' -> '10:00 AM')
        original_code = code
        code = re.sub(r"(\d+):\s+(\d+)", r"\1:\2", code)
        
        if original_code != code:
            logger.info("✅ Fixed spaces in time formats")
        
        logger.info("✅ All import and formatting fixes completed")
        
        # Ensure proper import exists
        if "import 'package:flutter/material.dart';" not in code:
            logger.info("🧹 Adding missing Flutter import")
            code = "import 'package:flutter/material.dart';\n\n" + code
        
        # Fix widget naming
        logger.info(f"🔧 Enforcing widget name: {widget_name}")
        incorrect_names = [
            'GeneratedWidget', 'MainWidget', 'Main', 'MyWidget',
            'AppWidget', 'HomeWidget', 'CustomWidget', 'UIWidget',
            'GeminiGeneratedWidget'  # Add this to handle Gemini's default name
        ]
        
        for incorrect_name in incorrect_names:
            if incorrect_name != widget_name:
                code = re.sub(
                    rf'class\s+{incorrect_name}\s*extends',
                    f'class {widget_name} extends',
                    code
                )
                code = re.sub(
                    rf'const\s+{incorrect_name}\s*\(',
                    f'const {widget_name}(',
                    code
                )
        
        # Flutter 3.27.1 specific fixes
        code = self._apply_flutter_3_27_fixes(code)
        
        # Fix common formatting issues
        code = self._fix_code_formatting(code)
        
        # Verify widget name
        if f'class {widget_name}' not in code:
            logger.warning(f"⚠️ Widget name {widget_name} not found, attempting to fix...")
            class_match = re.search(r'class\s+(\w+)\s+extends\s+(StatelessWidget|StatefulWidget)', code)
            if class_match:
                old_name = class_match.group(1)
                logger.info(f"🔧 Replacing widget name '{old_name}' with '{widget_name}'")
                code = code.replace(f'class {old_name}', f'class {widget_name}')
                code = code.replace(f'const {old_name}(', f'const {widget_name}(')
        
        logger.info(f"✅ Code cleanup complete")
        logger.info(f"📏 Final code length: {len(code)} characters")
        return code
    
    def _apply_flutter_3_27_fixes(self, code: str) -> str:
        """Apply Flutter 3.27.1 specific fixes"""
        logger.info("🔧 Applying Flutter 3.27.1 compatibility fixes...")
        
        # Fix deprecated constructors
        code = re.sub(r'MediaQuery\.of\(context\)\.size\.width', 'MediaQuery.sizeOf(context).width', code)
        code = re.sub(r'MediaQuery\.of\(context\)\.size\.height', 'MediaQuery.sizeOf(context).height', code)
        
        # Fix deprecated Theme access
        code = re.sub(r'Theme\.of\(context\)\.primaryColor', 'Theme.of(context).colorScheme.primary', code)
        code = re.sub(r'Theme\.of\(context\)\.accentColor', 'Theme.of(context).colorScheme.secondary', code)
        
        # Fix Scaffold backgroundColor (ensure proper syntax)
        code = re.sub(r'backgroundColor:\s*Color\(0x[fF]{2}([0-9a-fA-F]{6})\)', r'backgroundColor: Color(0xFF\1)', code)
        
        logger.info("✅ Flutter 3.27.1 compatibility fixes applied")
        return code
    
    def _fix_code_formatting(self, code: str) -> str:
        """Fix common formatting issues in the generated code"""
        # Fix broken lines (but preserve intentional line breaks)
        # This is more conservative to avoid breaking valid multiline statements
        
        # Ensure proper spacing around colons in property assignments
        code = re.sub(r'(\w+):\s*', r'\1: ', code)
        
        # Remove excessive spaces (more than 2 consecutive spaces)
        code = re.sub(r'  +', '  ', code)
        
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
                indented_lines.append('')
                continue
                
            # Decrease indent for closing braces
            if stripped.startswith('}'):
                indent_level = max(0, indent_level - 1)
            
            # Add the line with proper indentation
            indented_lines.append('  ' * indent_level + stripped)
            
            # Increase indent for opening braces
            if stripped.endswith('{') and not stripped.startswith('}'):
                indent_level += 1
        
        return '\n'.join(indented_lines)
    
    def get_professional_fallback_widget(self, error: str, widget_name: str = "GeneratedWidget") -> str:
        """Return a professional fallback widget for Flutter 3.27.1"""
        logger.warning(f"🛡️ Generating professional fallback widget due to error: {error}")
        logger.info(f"🎯 Using widget name: {widget_name}")
        
        fallback_code = f"""import 'package:flutter/material.dart';

class {widget_name} extends StatelessWidget {{
  const {widget_name}({{super.key}});

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
        
        return fallback_code.strip()