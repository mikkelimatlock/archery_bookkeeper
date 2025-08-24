#!/usr/bin/env python3
"""
Test Android package structure fix.
"""

from flutter_rename import FlutterRenamer
from pathlib import Path

def test_android_structure_update():
    """Test Android package structure detection and fix logic."""
    print("Testing Android package structure update...")
    
    renamer = FlutterRenamer()
    config = renamer.detect_current_configuration()
    
    print(f"Current Android namespace: {config.get('android_namespace', 'N/A')}")
    
    # Check current MainActivity location
    old_package = config.get('android_namespace', '')
    if old_package:
        old_parts = old_package.split('.')
        old_package_dir = renamer.project_root / "android" / "app" / "src" / "main" / "kotlin" / Path(*old_parts)
        mainactivity_file = old_package_dir / "MainActivity.kt"
        
        print(f"MainActivity location: {mainactivity_file}")
        print(f"MainActivity exists: {mainactivity_file.exists()}")
        
        if mainactivity_file.exists():
            with open(mainactivity_file, 'r') as f:
                content = f.read()
                print(f"Current package declaration: {content.split()[1] if 'package' in content else 'Not found'}")
    
    # Test what would happen with a rename
    new_package = "com.novoyuuparosk.test_app"
    print(f"\nTesting rename to: {new_package}")
    
    new_parts = new_package.split('.')
    new_package_dir = renamer.project_root / "android" / "app" / "src" / "main" / "kotlin" / Path(*new_parts)
    print(f"New MainActivity location would be: {new_package_dir / 'MainActivity.kt'}")

if __name__ == "__main__":
    test_android_structure_update()