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
      
      # CRITICAL FIX: Log the first few lines to see what we're dealing with
      logger.info("=" * 80)
      logger.info("📋 ORIGINAL CODE (First 300 characters):")
      logger.info(f"   {repr(code[:300])}")
      logger.info("=" * 80)
      
      # FIX 1: Remove ALL spaces after colons in package imports
      # This is the most aggressive fix - it handles ALL variations
      logger.info("🔧 Fixing import statements (removing ALL spaces after 'package:')...")
      logger.info(f"   Checking for pattern 'package:\\s+' in code...")
      
      # Check if the problem exists
      space_match = re.search(r"package:\s+", code)
      if space_match:
          logger.warning("⚠️ FOUND SPACE ISSUE!")
          logger.warning(f"   Matched text: {repr(space_match.group(0))}")
          logger.warning(f"   Position: {space_match.start()} to {space_match.end()}")
          logger.warning(f"   Context (50 chars): {repr(code[max(0, space_match.start()-10):space_match.end()+40])}")
      
      # Pattern 1: Fix "package: " (space after colon) - MOST AGGRESSIVE
      original_code = code
      
      # Replace any whitespace (including newlines, tabs) after 'package:' in imports
      code = re.sub(r"import\s+['\"]package:\s+([^'\"]+)['\"]", r"import 'package:\1'", code)
      logger.info(f"   After regex fix 1: {repr(code[:100])}")
      
      # Also handle cases where quotes might be inconsistent
      code = re.sub(r"'package:\s+", "'package:", code)
      logger.info(f"   After regex fix 2: {repr(code[:100])}")
      
      code = re.sub(r'"package:\s+', '"package:', code)
      logger.info(f"   After regex fix 3: {repr(code[:100])}")
      
      # Extra aggressive: remove ANY whitespace between 'package:' and the next word
      code = re.sub(r'package:\s+(\w)', r'package:\1', code)
      logger.info(f"   After regex fix 4: {repr(code[:100])}")
      
      if original_code != code:
          logger.info("✅ Fixed spaces in package imports")
          # Show what changed
          import_matches = re.findall(r"import\s+['\"]package:[^'\"]+['\"];?", code)
          for match in import_matches[:3]:
              logger.info(f"   Fixed import: {repr(match)}")
      else:
          logger.info("⚠️ No changes made - pattern might not have matched")
          logger.info(f"   First line: {repr(code.split(chr(10))[0] if chr(10) in code else code[:100])}")
      
      # FIX 2: Remove double/triple/multiple semicolons
      logger.info("🔧 Fixing multiple semicolons...")
      
      if re.search(r';{2,}', code):
          logger.warning("⚠️ Found multiple semicolons in code")
          # Replace 2 or more semicolons with just one
          code = re.sub(r';{2,}', ';', code)
          logger.info("✅ Fixed multiple semicolons")
      else:
          logger.info("✅ No multiple semicolon issues found")
      
      # FIX 3: Fix spaces in URLs (like 'https: //' -> 'https://')
      if re.search(r"https?:\s+//", code):
          logger.warning("⚠️ Found space in URL after colon")
          code = re.sub(r"https?:\s+//", lambda m: m.group(0).replace(' ', ''), code)
          logger.info("✅ Fixed spaces in URLs")
      
      # FIX 4: Fix spaces in time formats (like '10: 00' -> '10:00')
      time_pattern = r"(\d+):\s+(\d+)"
      if re.search(time_pattern, code):
          logger.warning("⚠️ Found spaces in time formats")
          code = re.sub(time_pattern, r"\1:\2", code)
          logger.info("✅ Fixed spaces in time formats")
      
      # FIX 5: Ensure the correct Flutter import exists
      correct_import = "import 'package:flutter/material.dart';"
      
      # Check if ANY form of flutter/material import exists
      has_flutter_import = bool(re.search(r"import\s+['\"]package:flutter/material\.dart['\"];?", code))
      
      if not has_flutter_import:
          logger.info("🧹 Adding missing Flutter import")
          code = correct_import + "\n\n" + code
      else:
          logger.info("✅ Flutter material import found")
      
      logger.info("✅ All import and formatting fixes completed")
      
      # Fix widget naming
      logger.info(f"🔧 Enforcing widget name: {widget_name}")
      incorrect_names = [
          'GeneratedWidget', 'MainWidget', 'Main', 'MyWidget',
          'AppWidget', 'HomeWidget', 'CustomWidget', 'UIWidget',
          'GeminiGeneratedWidget', 'GroqGeneratedWidget', 
          'ChatGPTGeneratedWidget', 'ClaudeGeneratedWidget'
      ]
      
      for incorrect_name in incorrect_names:
          if incorrect_name != widget_name:
              code = re.sub(
                  rf'\bclass\s+{incorrect_name}\s+extends',
                  f'class {widget_name} extends',
                  code
              )
              code = re.sub(
                  rf'\bconst\s+{incorrect_name}\s*\(',
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
      
      # FINAL VERIFICATION: Check if the space issue is STILL there
      logger.info("=" * 80)
      logger.info("🔍 FINAL VERIFICATION:")
      space_check = re.search(r"package:\s+\w", code)
      
      if space_check:
          logger.error("❌ CRITICAL: Space after 'package:' STILL EXISTS after all fixes!")
          logger.error(f"   Matched text: {repr(space_check.group(0))}")
          logger.error(f"   Position: {space_check.start()} to {space_check.end()}")
          
          # Show the problematic line
          problem_line_match = re.search(r'import[^;]+package:[^;]+;', code)
          if problem_line_match:
              logger.error(f"   Full import line: {repr(problem_line_match.group(0))}")
          
          # One last desperate attempt - simple string replacement
          logger.info("🔧 Applying FINAL string replacement fix...")
          code = code.replace("package: ", "package:")
          logger.info(f"   After string replacement: {repr(code[:100])}")
          
          # Check again
          final_check = re.search(r"package:\s+\w", code)
          if final_check:
              logger.error("❌ STILL FAILED! Space persists even after string replacement!")
              logger.error(f"   The space character might be: {repr(code[final_check.start()+8:final_check.start()+10])}")
          else:
              logger.info("✅ String replacement fixed it!")
      else:
          logger.info("✅ No spaces found after 'package:' - code is clean!")
      
      logger.info("=" * 80)
      
      logger.info(f"✅ Code cleanup complete")
      logger.info(f"📏 Final code length: {len(code)} characters")
      
      # Log the first 3 lines to verify
      logger.info("=" * 80)
      logger.info("📋 FINAL CODE - First 3 lines:")
      lines = code.split('\n')
      for i, line in enumerate(lines[:3], 1):
          logger.info(f"   Line {i}: {repr(line)}")
      logger.info("=" * 80)
      
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