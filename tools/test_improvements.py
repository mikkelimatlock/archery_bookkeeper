#!/usr/bin/env python3
"""
Test script for improved Flutter rename script functionality.
"""

from flutter_rename import FlutterRenamer

def test_no_changes_detection():
    """Test that the script correctly detects when no changes are needed."""
    print("Testing no-changes detection...")
    
    renamer = FlutterRenamer()
    config = renamer.detect_current_configuration()
    
    # Test with current values
    if config.get('package_name') and config.get('app_title'):
        package_name = config.get('package_name')
        app_name = config.get('app_title')
        class_name = renamer.generate_class_name(app_name)
        android_package_id = renamer.generate_android_package_id(package_name)
        
        # Check if no-changes detection logic works
        no_changes = (
            package_name == config.get('package_name', '') and
            app_name == config.get('app_title', '') and
            class_name == config.get('main_class', '') and
            android_package_id == config.get('android_namespace', '')
        )
        
        print(f"Current package name: {config.get('package_name')}")
        print(f"Current app title: {config.get('app_title')}")
        print(f"Current class name: {config.get('main_class')}")
        print(f"Current Android namespace: {config.get('android_namespace')}")
        print()
        print(f"Generated class name: {class_name}")
        print(f"Generated Android package: {android_package_id}")
        print()
        print(f"No changes detected: {no_changes}")
        
        if not no_changes:
            print("Differences found:")
            if class_name != config.get('main_class', ''):
                print(f"  Class name: {config.get('main_class')} → {class_name}")
            if android_package_id != config.get('android_namespace', ''):
                print(f"  Android package: {config.get('android_namespace')} → {android_package_id}")
    else:
        print("Configuration not fully detected, cannot test no-changes logic")

def test_current_config_display():
    """Test current configuration detection."""
    print("\n" + "="*60)
    print("TESTING CURRENT CONFIGURATION DETECTION")
    print("="*60)
    
    renamer = FlutterRenamer()
    config = renamer.detect_current_configuration()
    renamer.display_current_config()

if __name__ == "__main__":
    test_current_config_display()
    print()
    test_no_changes_detection()