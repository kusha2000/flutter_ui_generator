# ============================================
# CONVERT MULTIPLE JSON FILES TO SINGLE JSONL
# Better for ML Training: Faster, Simpler, Standard
# ============================================

import json
import os
from tqdm import tqdm

def convert_json_directory_to_jsonl(input_dir, output_file):
    """
    Convert directory of JSON files to single JSONL file
    
    Args:
        input_dir: Directory containing JSON files (e.g., 'flutter_dataset')
        output_file: Output JSONL file path (e.g., 'flutter_dataset.jsonl')
    """
    
    print("="*70)
    print("📦 CONVERTING JSON FILES TO JSONL")
    print("="*70)
    
    # Check if directory exists
    if not os.path.exists(input_dir):
        raise FileNotFoundError(f"❌ Directory not found: {input_dir}")
    
    # Get all JSON files
    json_files = [f for f in os.listdir(input_dir) if f.endswith('.json')]
    
    # Sort numerically (0.json, 1.json, 2.json, ...)
    json_files.sort(key=lambda x: int(x.replace('.json', '')))
    
    print(f"\n📁 Found {len(json_files)} JSON files in '{input_dir}'")
    print(f"📝 Output file: '{output_file}'")
    print(f"\n⚙️  Converting...\n")
    
    valid_count = 0
    error_count = 0
    error_log = []  # Store error details
    
    # Write to JSONL file
    with open(output_file, 'w', encoding='utf-8') as outfile:
        for filename in tqdm(json_files, desc="Processing"):
            filepath = os.path.join(input_dir, filename)
            
            try:
                with open(filepath, 'r', encoding='utf-8') as infile:
                    data = json.load(infile)
                    
                    # Validate required fields
                    if data.get('prompt') and data.get('flutter_code'):
                        # Write as single line JSON
                        json.dump(data, outfile, ensure_ascii=False)
                        outfile.write('\n')
                        valid_count += 1
                    else:
                        error_count += 1
                        missing_fields = []
                        if not data.get('prompt'):
                            missing_fields.append('prompt')
                        if not data.get('flutter_code'):
                            missing_fields.append('flutter_code')
                        
                        error_info = {
                            'filename': filename,
                            'error_type': 'Missing fields',
                            'details': f"Missing: {', '.join(missing_fields)}",
                            'data_preview': {k: str(v)[:50] + '...' if len(str(v)) > 50 else str(v) 
                                           for k, v in data.items()}
                        }
                        error_log.append(error_info)
                        print(f"   ⚠️  Skipped {filename}: Missing {', '.join(missing_fields)}")
                        
            except json.JSONDecodeError as e:
                error_count += 1
                error_info = {
                    'filename': filename,
                    'error_type': 'JSON Parse Error',
                    'details': str(e)
                }
                error_log.append(error_info)
                print(f"   ❌ JSON Error in {filename}: {e}")
                
            except Exception as e:
                error_count += 1
                error_info = {
                    'filename': filename,
                    'error_type': type(e).__name__,
                    'details': str(e)
                }
                error_log.append(error_info)
                print(f"   ❌ Error loading {filename}: {e}")
    
    # Summary
    print(f"\n{'='*70}")
    print("✅ CONVERSION COMPLETE!")
    print(f"{'='*70}")
    print(f"\n📊 Summary:")
    print(f"   ✅ Valid entries: {valid_count}")
    print(f"   ❌ Errors/Skipped: {error_count}")
    print(f"   📁 Output file: {output_file}")
    
    # File size
    file_size_mb = os.path.getsize(output_file) / (1024 * 1024)
    print(f"   💾 File size: {file_size_mb:.2f} MB")
    
    # Save error log if there are errors
    if error_log:
        error_file = output_file.replace('.jsonl', '_errors.json')
        with open(error_file, 'w', encoding='utf-8') as f:
            json.dump(error_log, f, indent=2, ensure_ascii=False)
        
        print(f"\n⚠️  ERROR REPORT:")
        print(f"   📋 Detailed error log saved: {error_file}")
        print(f"\n   Error Files:")
        for i, err in enumerate(error_log, 1):
            print(f"   {i}. {err['filename']}: {err['error_type']} - {err['details']}")
    
    return valid_count, error_count, error_log


def load_jsonl_dataset(filepath):
    """Load JSONL dataset (for training)"""
    data = []
    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip():
                data.append(json.loads(line))
    return data


# ============================================
# MAIN EXECUTION
# ============================================

if __name__ == "__main__":
    
    # Configuration
    INPUT_DIRECTORY = "flutter_dataset"  # Your directory with JSON files
    OUTPUT_JSONL = "flutter_dataset.jsonl"  # Output JSONL file
    
    # Convert
    valid_count, error_count, error_log = convert_json_directory_to_jsonl(
        INPUT_DIRECTORY, 
        OUTPUT_JSONL
    )
    
    # Test loading
    print(f"\n🧪 Testing JSONL file...")
    dataset = load_jsonl_dataset(OUTPUT_JSONL)
    print(f"   ✅ Successfully loaded {len(dataset)} samples")
    
    # Show sample
    if dataset:
        print(f"\n📄 Sample entry:")
        sample = dataset[0]
        print(f"   Prompt: {sample['prompt'][:100]}...")
        print(f"   Category: {sample.get('category', 'N/A')}")
        print(f"   Components: {sample.get('components', [])}")
    
    # Recommendations if errors exist
    if error_log:
        print(f"\n💡 RECOMMENDATIONS:")
        print(f"   You can:")
        print(f"   1. Check 'flutter_dataset_errors.json' for details")
        print(f"   2. Fix the error files manually")
        print(f"   3. Or continue training with {valid_count} valid samples")
    
    print(f"\n{'='*70}")
    print("🎉 ALL DONE! You can now use 'flutter_dataset.jsonl' for training")
    print(f"{'='*70}")