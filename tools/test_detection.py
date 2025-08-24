#!/usr/bin/env python3
"""
Test script to verify Flutter app configuration detection.
"""

from flutter_rename import FlutterRenamer

def main():
    print("Testing Flutter app configuration detection...")
    print("=" * 60)
    
    renamer = FlutterRenamer()
    config = renamer.detect_current_configuration()
    
    print("Detected configuration:")
    for key, value in config.items():
        formatted_key = key.replace('_', ' ').title()
        print(f"  {formatted_key:20}: {value}")
    
    print("\nValidation tests:")
    
    # Test package name validation
    test_packages = ['archery_scorecard', 'my-app', 'MyApp', 'archery__scorecard', '_archery', 'archery_', 'class']
    for pkg in test_packages:
        valid, msg = renamer.validate_package_name(pkg)
        status = "✓" if valid else "✗"
        print(f"  {status} '{pkg}': {msg}")
    
    # Test app name validation
    test_names = ['Archery Scorecard', '', 'A', 'A' * 60]
    for name in test_names:
        valid, msg = renamer.validate_app_name(name)
        status = "✓" if valid else "✗"
        print(f"  {status} '{name}': {msg}")
    
    # Test class name generation
    test_app_names = ['Archery Scorecard', 'My App!', 'Score-Keeper Pro', 'Simple']
    print("\nClass name generation:")
    for name in test_app_names:
        class_name = renamer.generate_class_name(name)
        print(f"  '{name}' → '{class_name}'")
    
    # Test Android package ID generation
    test_packages = ['archery_scorecard', 'my_app', 'simple_app']
    print("\nAndroid package ID generation:")
    for pkg in test_packages:
        android_pkg = renamer.generate_android_package_id(pkg)
        print(f"  '{pkg}' → '{android_pkg}'")

if __name__ == "__main__":
    main()