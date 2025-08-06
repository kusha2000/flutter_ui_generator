import logging
from pathlib import Path

logger = logging.getLogger(__name__)

class FileManager:
    """Handles file operations for generated code"""
    
    def __init__(self, service_type: str = "general"):
        self.service_type = service_type.lower()
        logger.info(f"📁 Initializing FileManager for service: {self.service_type}")
        self._setup_file_paths()
    
    def _setup_file_paths(self):
        """Set up file paths for writing generated code"""
        logger.info("📁 Setting up file paths...")
        
        # Get the current directory (backend)
        current_dir = Path(__file__).parent.parent
        logger.info(f"📍 Current directory: {current_dir}")
        
        # Navigate to the frontend/lib/widgets directory
        self.frontend_dir = current_dir.parent / "frontend"
        self.lib_dir = self.frontend_dir / "lib"
        self.widgets_dir = self.lib_dir / "widgets"
        
        # Generate filename based on service type
        filename = f"{self.service_type}_generated_widget_loader.dart"
        self.target_file = self.widgets_dir / filename
        
        logger.info(f"📂 Frontend directory: {self.frontend_dir}")
        logger.info(f"📂 Target file: {self.target_file}")
        
        # Check if directories exist
        if not self.frontend_dir.exists():
            logger.warning(f"⚠️ Frontend directory does not exist: {self.frontend_dir}")
        if not self.widgets_dir.exists():
            logger.info(f"📁 Creating widgets directory: {self.widgets_dir}")
            self.widgets_dir.mkdir(parents=True, exist_ok=True)
        
        logger.info("✅ File paths setup complete")
    
    def write_dart_file(self, dart_code: str) -> bool:
        """Write the generated Dart code to the target file"""
        logger.info(f"📝 Writing Dart code to file: {self.target_file}")
        logger.info(f"📏 Code length: {len(dart_code)} characters")
        
        try:
            # Ensure the widgets directory exists
            self.widgets_dir.mkdir(parents=True, exist_ok=True)
            
            # Write the Dart code to the file
            with open(self.target_file, 'w', encoding='utf-8') as f:
                f.write(dart_code)
            
            logger.info(f"✅ Successfully wrote Dart code to: {self.target_file}")
            
            # Verify the file was written correctly
            if self.target_file.exists():
                with open(self.target_file, 'r', encoding='utf-8') as f:
                    written_content = f.read()
                if len(written_content) == len(dart_code):
                    logger.info(f"✅ File verification successful")
                    return True
                else:
                    logger.warning(f"⚠️ File verification warning - length mismatch")
                    return True  # Still consider it successful
            else:
                logger.error(f"❌ File verification failed - file does not exist after write")
                return False
                
        except Exception as e:
            logger.error(f"❌ Error writing Dart file: {str(e)}")
            return False