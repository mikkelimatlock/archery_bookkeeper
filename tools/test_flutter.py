#!/usr/bin/env python3
"""
Test Flutter executable finding.
"""

from flutter_rename import FlutterRenamer

def test_flutter_finder():
    """Test Flutter executable detection."""
    renamer = FlutterRenamer()
    
    print("Testing Flutter executable detection...")
    flutter_cmd = renamer.find_flutter_executable()
    
    if flutter_cmd:
        print(f"✓ Found Flutter: {flutter_cmd}")
        
        # Test if it actually works
        import subprocess
        try:
            result = subprocess.run([flutter_cmd, "--version"], capture_output=True, text=True, timeout=10)
            if result.returncode == 0:
                print("✓ Flutter command works!")
                print(f"Version output: {result.stdout.split()[1] if len(result.stdout.split()) > 1 else 'Unknown'}")
            else:
                print(f"✗ Flutter command failed: {result.stderr}")
        except Exception as e:
            print(f"✗ Error testing Flutter: {e}")
    else:
        print("✗ Flutter not found")

if __name__ == "__main__":
    test_flutter_finder()