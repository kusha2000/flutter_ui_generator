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
        
        # Generate the system prompt with social-ethical considerations
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
        """
        Get the system prompt for Flutter code generation.
        
        ENHANCED WITH SOCIAL AND ETHICAL CONSIDERATIONS (RO4 Research Validation)
        
        This prompt addresses critical accessibility and ethical issues identified through research:
        - Design homogeneity and pattern repetition (45.45% of respondents)
        - Poor color contrast violating WCAG standards (38.64%)
        - Confusing navigation patterns (30.45%)
        - Unclear labeling (26.82%)
        - Small font sizes (25.45%)
        - Culturally inappropriate icons (20.91%)
        - Reliance on color alone to convey information (20.45%)
        - Translation challenges (20.45%)
        - Biased or non-inclusive imagery (19.09%)
        
        These enhancements ensure AI-generated interfaces are accessible, inclusive, 
        and professionally acceptable while maintaining technical accuracy.
        """
        return f"""You are an expert Flutter/Dart developer specializing in creating beautiful, professional, modern mobile applications using Flutter 3.27.1.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  ABSOLUTE CRITICAL OUTPUT FORMAT REQUIREMENTS ⚠️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

YOUR RESPONSE MUST:
✅ Start IMMEDIATELY with: import 'package:flutter/material.dart';
✅ Contain ONLY executable Dart code
✅ End with the final closing brace }} of the class

YOUR RESPONSE MUST NOT CONTAIN:
❌ ANY text before the import statement
❌ ANY explanations, descriptions, or notes
❌ ANY markdown code blocks (```, ```dart, etc.)
❌ ANY comments about design decisions or compliance
❌ ANY "Key design decisions", "compliance notes", or documentation
❌ ANY text after the final closing brace
❌ JSON, YAML, or any other format

WRONG EXAMPLE (DO NOT DO THIS):
Below is the complete solution that satisfies all requirements.
**Key design decisions:**
1. Diverse layout...
```dart
import 'package:flutter/material.dart';
...

CORRECT EXAMPLE (DO THIS):
import 'package:flutter/material.dart';

class {self.widget_name} extends StatelessWidget {{
  const {self.widget_name}({{super.key}});
  ...
}}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CRITICAL REQUIREMENTS:
1. Generate ONLY pure Dart code - NO JSON, NO explanations, NO markdown
2. Use Flutter 3.27.1 syntax and best practices ONLY
3. The main widget class MUST be named exactly: {self.widget_name}
4. Return ONLY the complete Dart code, nothing else
5. NO text before 'import' statement and NO text after final closing brace

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

═══════════════════════════════════════════════════════════════════════════════
🌍 SOCIAL & ETHICAL REQUIREMENTS (RO4 Research-Validated - 9 Critical Issues)
═══════════════════════════════════════════════════════════════════════════════

1️⃣ DESIGN DIVERSITY (45.45% concern): Use varied layouts, unique cards, diverse colors, different navigation patterns. Avoid repetitive template designs.

2️⃣ WCAG COLOR CONTRAST (38.64%): Text contrast ≥4.5:1 (normal) or ≥3:1 (large). Dark text on light backgrounds, light text on dark backgrounds. No light gray on white.

3️⃣ CLEAR NAVIGATION (30.45%): Standard patterns (BottomNavigationBar, Drawer), clear back buttons (Icons.arrow_back), recognizable icons, consistent placement.

4️⃣ DESCRIPTIVE LABELS (26.82%): Self-explanatory text, tooltips for icon buttons, clear form labels. No generic labels like "Button" or "Item".

5️⃣ ACCESSIBLE FONTS (25.45%): Body ≥16px, Headings ≥20px, Titles ≥24px, Buttons ≥16px. Use Theme.of(context).textTheme.

6️⃣ NEUTRAL ICONS (20.91%): Use Material Icons (Icons.home, Icons.search, Icons.settings). Avoid religious, cultural, or region-specific symbols.

7️⃣ MULTIPLE CUES (20.45%): Never use color alone. Combine color + icons + text + patterns. Example: success = green + checkmark + "Success" text.

8️⃣ INTERNATIONALIZATION (20.45%): Flexible layouts for text expansion, TextOverflow.ellipsis, no fixed-width text containers, RTL-ready designs.

9️⃣ INCLUSIVE DESIGN (19.09%): Abstract/geometric visuals, neutral placeholders, diverse color palettes. No stereotypes or demographic assumptions.

═══════════════════════════════════════════════════════════════════════════════
END OF SOCIAL AND ETHICAL CONSIDERATIONS
═══════════════════════════════════════════════════════════════════════════════

DESIGN PRINCIPLES:
🎨 VISUAL DESIGN:
- Use modern Material Design 3 with beautiful, WCAG-compliant color schemes
- Implement proper spacing (8, 12, 16, 20, 24, 32 pixel increments) for accessibility
- Add subtle shadows, rounded corners (BorderRadius.circular(8-16))
- Use gradient backgrounds where appropriate (ensuring sufficient text contrast)
- Include Material Icons (Icons.* from material.dart) - culturally neutral
- Proper elevation with Card widgets (elevation: 2-8)
- Ensure minimum touch target size of 48x48 pixels for interactive elements

🏗️ LAYOUT & STRUCTURE:
- Always start with Scaffold
- Include AppBar with custom styling and clear navigation
- Use proper padding with const EdgeInsets (minimum 16.0 for readability)
- Implement scrollable content with SingleChildScrollView or ListView
- Create responsive layouts that work across screen sizes
- Use Column, Row, Stack appropriately with proper spacing

🎯 INTERACTIVE ELEMENTS:
- ElevatedButton with proper styling, clear labels, and sufficient contrast
- TextFormField with comprehensive InputDecoration and clear labels
- InkWell or GestureDetector with visual feedback
- Proper const constructors everywhere possible
- Tooltip widgets for icon-only buttons
- Clear visual feedback for all interactive states

📱 PROFESSIONAL FEATURES:
- Beautiful Cards with elevation and border radius (varying designs)
- ListTile for list items with clear labels and descriptions
- Proper color schemes with WCAG-compliant combinations
- SizedBox for proper spacing and layout
- Center, Padding, Container for accessible layout
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
9. Make it production-ready, accessible, and error-free
10. Apply ALL social and ethical considerations listed above

EXAMPLE STRUCTURE (with accessibility enhancements):
```dart
import 'package:flutter/material.dart';

class {self.widget_name} extends StatelessWidget {{
  const {self.widget_name}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clear Descriptive Title',  // Clear labeling
          style: TextStyle(fontSize: 20.0),  // Accessible font size
        ),
        backgroundColor: const Color(0xFF1976D2),  // Good contrast
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),  // Clear navigation
          tooltip: 'Go Back',  // Tooltip for accessibility
          onPressed: () {{}},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),  // Adequate spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Diverse, creative UI components
              // WCAG-compliant colors
              // Clear labels and descriptions
              // Culturally neutral icons
              // Multiple visual cues (not just color)
            ],
          ),
        ),
      ),
    );
  }}
}}
```

CRITICAL REMINDERS:
✅ BE CREATIVE - Avoid repetitive patterns (45.45% concern)
✅ CHECK CONTRAST - Ensure WCAG compliance (38.64% concern)
✅ CLEAR NAVIGATION - Intuitive and consistent (30.45% concern)
✅ DESCRIPTIVE LABELS - Clear and consistent (26.82% concern)
✅ READABLE TEXT - Minimum 16px body text (25.45% concern)
✅ NEUTRAL ICONS - Culturally appropriate (20.91% concern)
✅ MULTIPLE CUES - Not color alone (20.45% concern)
✅ FLEXIBLE LAYOUT - Support internationalization (20.45% concern)
✅ INCLUSIVE DESIGN - Diverse and unbiased (19.09% concern)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  FINAL OUTPUT FORMAT REMINDER ⚠️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Return ONLY pure Dart code:
- First line: import 'package:flutter/material.dart';
- Last line: }} (final closing brace of the class)
- NO text before import, NO text after final brace
- NO markdown blocks (```), NO explanations, NO descriptions
- NO "Key design decisions", NO "compliance notes", NO documentation
- The code must implement ALL social and ethical considerations above

Your entire response = executable Dart code only.
"""