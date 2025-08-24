#!/usr/bin/env python3
"""
Flutter App Renaming Tool

A comprehensive script to rename Flutter applications across all platform configurations.
Handles package names, display names, class names, and bundle identifiers consistently.

Usage: python flutter_rename.py
"""

import os
import re
import json
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Dict, List, Optional, Tuple


class FlutterRenamer:
    def __init__(self, project_root: str = "."):
        self.project_root = Path(project_root).resolve()
        self.current_config = {}
        
    def detect_current_configuration(self) -> Dict[str, str]:
        """Detect current app configuration across all platform files."""
        config = {}
        
        # Read pubspec.yaml
        pubspec_path = self.project_root / "pubspec.yaml"
        if pubspec_path.exists():
            with open(pubspec_path, 'r', encoding='utf-8') as f:
                content = f.read()
                if match := re.search(r'^name:\s*(.+)$', content, re.MULTILINE):
                    config['package_name'] = match.group(1).strip()
                if match := re.search(r'^description:\s*["\']?([^"\']+)["\']?$', content, re.MULTILINE):
                    config['description'] = match.group(1).strip()
        
        # Read main.dart
        main_dart_path = self.project_root / "lib" / "main.dart"
        if main_dart_path.exists():
            with open(main_dart_path, 'r', encoding='utf-8') as f:
                content = f.read()
                if match := re.search(r'title:\s*["\']([^"\']+)["\']', content):
                    config['app_title'] = match.group(1)
                if match := re.search(r'class\s+(\w+App)\s+extends', content):
                    config['main_class'] = match.group(1)
        
        # Read Android manifest
        android_manifest_path = self.project_root / "android" / "app" / "src" / "main" / "AndroidManifest.xml"
        if android_manifest_path.exists():
            try:
                with open(android_manifest_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    if match := re.search(r'android:label="([^"]*)"', content):
                        config['android_label'] = match.group(1)
            except Exception:
                pass
        
        # Read Android build.gradle.kts
        android_gradle_path = self.project_root / "android" / "app" / "build.gradle.kts"
        if android_gradle_path.exists():
            try:
                with open(android_gradle_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    if match := re.search(r'namespace\s*=\s*"([^"]*)"', content):
                        config['android_namespace'] = match.group(1)
                    if match := re.search(r'applicationId\s*=\s*"([^"]*)"', content):
                        config['android_application_id'] = match.group(1)
            except Exception:
                pass
        
        # Read iOS Info.plist
        ios_plist_path = self.project_root / "ios" / "Runner" / "Info.plist"
        if ios_plist_path.exists():
            try:
                with open(ios_plist_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    if match := re.search(r'<key>CFBundleDisplayName</key>\s*<string>([^<]+)</string>', content):
                        config['ios_display_name'] = match.group(1)
                    if match := re.search(r'<key>CFBundleName</key>\s*<string>([^<]+)</string>', content):
                        config['ios_bundle_name'] = match.group(1)
            except Exception:
                pass
        
        self.current_config = config
        return config
    
    def validate_package_name(self, package_name: str) -> Tuple[bool, str]:
        """Validate Flutter package name format."""
        if not package_name:
            return False, "Package name cannot be empty"
        
        if not re.match(r'^[a-z][a-z0-9_]*$', package_name):
            return False, "Package name must start with lowercase letter and contain only lowercase letters, numbers, and underscores"
        
        if package_name.startswith('_') or package_name.endswith('_'):
            return False, "Package name cannot start or end with underscore"
        
        if '__' in package_name:
            return False, "Package name cannot contain consecutive underscores"
        
        reserved_words = {'abstract', 'as', 'assert', 'async', 'await', 'break', 'case', 'catch', 'class', 'const', 'continue', 'default', 'deferred', 'do', 'dynamic', 'else', 'enum', 'export', 'extends', 'external', 'factory', 'false', 'final', 'finally', 'for', 'function', 'get', 'hide', 'if', 'implements', 'import', 'in', 'interface', 'is', 'library', 'mixin', 'new', 'null', 'on', 'operator', 'part', 'rethrow', 'return', 'set', 'show', 'static', 'super', 'switch', 'sync', 'this', 'throw', 'true', 'try', 'typedef', 'var', 'void', 'while', 'with', 'yield'}
        if package_name in reserved_words:
            return False, f"'{package_name}' is a reserved word and cannot be used as package name"
        
        return True, "Valid package name"
    
    def validate_app_name(self, app_name: str) -> Tuple[bool, str]:
        """Validate app display name."""
        if not app_name or not app_name.strip():
            return False, "App name cannot be empty"
        
        if len(app_name.strip()) < 2:
            return False, "App name must be at least 2 characters long"
        
        if len(app_name.strip()) > 50:
            return False, "App name should not exceed 50 characters"
        
        return True, "Valid app name"
    
    def generate_class_name(self, app_name: str) -> str:
        """Generate main class name from app display name."""
        # Remove special characters and convert to PascalCase
        clean_name = re.sub(r'[^a-zA-Z0-9\s]', '', app_name)
        words = clean_name.split()
        class_name = ''.join(word.capitalize() for word in words if word)
        
        if not class_name:
            class_name = "App"
        elif not class_name.endswith('App'):
            class_name += "App"
            
        return class_name
    
    def generate_android_package_id(self, package_name: str) -> str:
        """Generate Android package identifier from Flutter package name."""
        # Extract the current domain from existing Android package if available
        current_android = self.current_config.get('android_namespace', '')
        if current_android:
            # Try to extract domain part (everything before the last segment)
            parts = current_android.split('.')
            if len(parts) > 1:
                domain = '.'.join(parts[:-1])
                return f"{domain}.{package_name}"
        
        # Default domain if no existing Android package found
        return f"com.example.{package_name}"
    
    def update_pubspec_yaml(self, package_name: str, app_name: str) -> bool:
        """Update pubspec.yaml with new package name and description."""
        pubspec_path = self.project_root / "pubspec.yaml"
        if not pubspec_path.exists():
            print(f"Warning: {pubspec_path} not found")
            return False
        
        try:
            with open(pubspec_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Update package name
            content = re.sub(r'^name:\s*.*$', f'name: {package_name}', content, flags=re.MULTILINE)
            
            # Update description
            description = f'"{app_name} - A Flutter application."'
            content = re.sub(r'^description:\s*.*$', f'description: {description}', content, flags=re.MULTILINE)
            
            with open(pubspec_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"✓ Updated pubspec.yaml")
            return True
            
        except Exception as e:
            print(f"✗ Error updating pubspec.yaml: {e}")
            return False
    
    def update_main_dart(self, package_name: str, app_name: str, class_name: str) -> bool:
        """Update main.dart with new app title and class name."""
        main_dart_path = self.project_root / "lib" / "main.dart"
        if not main_dart_path.exists():
            print(f"Warning: {main_dart_path} not found")
            return False
        
        try:
            with open(main_dart_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Update class name
            old_class_pattern = r'class\s+\w+App\s+extends'
            content = re.sub(old_class_pattern, f'class {class_name} extends', content)
            
            # Update constructor
            old_constructor_pattern = r'const\s+\w+App\('
            content = re.sub(old_constructor_pattern, f'const {class_name}(', content)
            
            # Update main() instantiation
            old_instantiation_pattern = r'runApp\(const\s+\w+App\(\)\)'
            content = re.sub(old_instantiation_pattern, f'runApp(const {class_name}())', content)
            
            # Update title
            content = re.sub(r'title:\s*["\'][^"\']*["\']', f"title: '{app_name}'", content)
            
            with open(main_dart_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"✓ Updated main.dart")
            return True
            
        except Exception as e:
            print(f"✗ Error updating main.dart: {e}")
            return False
    
    def update_android_manifest(self, app_name: str) -> bool:
        """Update Android manifest with new app label."""
        manifest_path = self.project_root / "android" / "app" / "src" / "main" / "AndroidManifest.xml"
        if not manifest_path.exists():
            print(f"Warning: {manifest_path} not found")
            return False
        
        try:
            with open(manifest_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Update android:label
            content = re.sub(
                r'android:label="[^"]*"', 
                f'android:label="{app_name}"', 
                content
            )
            
            with open(manifest_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"✓ Updated Android manifest")
            return True
            
        except Exception as e:
            print(f"✗ Error updating Android manifest: {e}")
            return False
    
    def update_ios_info_plist(self, package_name: str, app_name: str) -> bool:
        """Update iOS Info.plist with new bundle and display names."""
        plist_path = self.project_root / "ios" / "Runner" / "Info.plist"
        if not plist_path.exists():
            print(f"Warning: {plist_path} not found")
            return False
        
        try:
            with open(plist_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Update CFBundleDisplayName
            content = re.sub(
                r'(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)',
                f'\\g<1>{app_name}\\g<2>',
                content
            )
            
            # Update CFBundleName
            content = re.sub(
                r'(<key>CFBundleName</key>\s*<string>)[^<]*(</string>)',
                f'\\g<1>{package_name}\\g<2>',
                content
            )
            
            with open(plist_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"✓ Updated iOS Info.plist")
            return True
            
        except Exception as e:
            print(f"✗ Error updating iOS Info.plist: {e}")
            return False
    
    def update_android_gradle(self, android_package_id: str) -> bool:
        """Update Android build.gradle.kts with new namespace and applicationId."""
        gradle_path = self.project_root / "android" / "app" / "build.gradle.kts"
        if not gradle_path.exists():
            print(f"Warning: {gradle_path} not found")
            return False
        
        try:
            with open(gradle_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Update namespace
            content = re.sub(
                r'namespace\s*=\s*"[^"]*"',
                f'namespace = "{android_package_id}"',
                content
            )
            
            # Update applicationId
            content = re.sub(
                r'applicationId\s*=\s*"[^"]*"',
                f'applicationId = "{android_package_id}"',
                content
            )
            
            with open(gradle_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"✓ Updated Android build.gradle.kts")
            return True
            
        except Exception as e:
            print(f"✗ Error updating Android build.gradle.kts: {e}")
            return False
    
    def update_android_package_structure(self, old_package_id: str, new_package_id: str) -> bool:
        """Update Android package directory structure and MainActivity package."""
        import shutil
        
        if not old_package_id or not new_package_id or old_package_id == new_package_id:
            return True  # No change needed
        
        # Convert package IDs to directory paths
        old_path_parts = old_package_id.split('.')
        new_path_parts = new_package_id.split('.')
        
        old_package_dir = self.project_root / "android" / "app" / "src" / "main" / "kotlin" / Path(*old_path_parts)
        new_package_dir = self.project_root / "android" / "app" / "src" / "main" / "kotlin" / Path(*new_path_parts)
        
        try:
            # Check if old directory exists
            if not old_package_dir.exists():
                print(f"Warning: Old Android package directory not found: {old_package_dir}")
                return True  # Might be a new project or different structure
            
            # Create new directory structure
            new_package_dir.parent.mkdir(parents=True, exist_ok=True)
            
            # Move MainActivity.kt and update its package declaration
            mainactivity_file = old_package_dir / "MainActivity.kt"
            if mainactivity_file.exists():
                # Read and update MainActivity.kt
                with open(mainactivity_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Update package declaration
                content = re.sub(
                    r'^package\s+[a-z0-9_.]+',
                    f'package {new_package_id}',
                    content,
                    flags=re.MULTILINE
                )
                
                # Write to new location
                new_mainactivity_file = new_package_dir / "MainActivity.kt"
                new_package_dir.mkdir(parents=True, exist_ok=True)
                with open(new_mainactivity_file, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                # Remove old file
                mainactivity_file.unlink()
                
                print(f"✓ Moved and updated MainActivity.kt")
                print(f"  From: {old_package_dir}")
                print(f"  To:   {new_package_dir}")
            
            # Clean up empty old directories
            try:
                current_dir = old_package_dir
                while current_dir != current_dir.parent and current_dir.name != "kotlin":
                    if current_dir.exists() and not any(current_dir.iterdir()):
                        current_dir.rmdir()
                        current_dir = current_dir.parent
                    else:
                        break
            except OSError:
                pass  # Directory not empty or other issue, that's fine
            
            return True
            
        except Exception as e:
            print(f"✗ Error updating Android package structure: {e}")
            return False
    
    def update_test_files(self, old_package_name: str, new_package_name: str, old_class_name: str, new_class_name: str) -> bool:
        """Update test files with new package imports and class names."""
        test_dir = self.project_root / "test"
        if not test_dir.exists():
            return True  # No test directory, nothing to update
        
        try:
            # Find all Dart files in test directory
            test_files = list(test_dir.rglob("*.dart"))
            if not test_files:
                return True  # No test files found
            
            updated_files = []
            for test_file in test_files:
                try:
                    with open(test_file, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    original_content = content
                    
                    # Update package imports
                    if old_package_name and new_package_name:
                        content = re.sub(
                            rf"import\s+['\"]package:{re.escape(old_package_name)}/",
                            f"import 'package:{new_package_name}/",
                            content
                        )
                    
                    # Update class references
                    if old_class_name and new_class_name and old_class_name != new_class_name:
                        content = re.sub(
                            rf"\b{re.escape(old_class_name)}\b",
                            new_class_name,
                            content
                        )
                    
                    # Write back if changed
                    if content != original_content:
                        with open(test_file, 'w', encoding='utf-8') as f:
                            f.write(content)
                        updated_files.append(test_file.name)
                        
                except Exception as e:
                    print(f"⚠ Warning: Could not update test file {test_file}: {e}")
            
            if updated_files:
                print(f"✓ Updated test files: {', '.join(updated_files)}")
            else:
                print("✓ No test files needed updating")
            
            return True
            
        except Exception as e:
            print(f"✗ Error updating test files: {e}")
            return False
    
    def find_flutter_executable(self) -> str:
        """Find Flutter executable, handling Windows PATH issues."""
        import subprocess
        import os
        
        # First try the simple approach
        try:
            result = subprocess.run(
                ["flutter", "--version"],
                capture_output=True,
                text=True,
                timeout=10
            )
            if result.returncode == 0:
                return "flutter"
        except (FileNotFoundError, subprocess.TimeoutExpired):
            pass
        
        # Try finding flutter with 'where' command on Windows
        try:
            result = subprocess.run(
                ["where", "flutter"],
                capture_output=True,
                text=True,
                timeout=10
            )
            if result.returncode == 0 and result.stdout.strip():
                lines = result.stdout.strip().split('\n')
                # Prefer .bat files on Windows
                for line in lines:
                    if line.endswith('.bat'):
                        return line
                # Fall back to first result if no .bat found
                return lines[0]
        except (FileNotFoundError, subprocess.TimeoutExpired):
            pass
        
        # Common Flutter installation paths
        common_paths = [
            "J:\\dev\\flutter-sdk\\bin\\flutter.bat",
            "C:\\flutter\\bin\\flutter.bat",
            "C:\\src\\flutter\\bin\\flutter.bat",
        ]
        
        for path in common_paths:
            if os.path.exists(path):
                return path
        
        return None
    
    def run_flutter_commands(self, auto_refresh: bool = True) -> bool:
        """Run Flutter clean and pub get to refresh the project."""
        import subprocess
        
        if not auto_refresh:
            print("Skipping automatic Flutter refresh as requested.")
            return True
        
        print("\nRefreshing Flutter project...")
        print("-" * 40)
        
        # Find Flutter executable
        flutter_cmd = self.find_flutter_executable()
        if not flutter_cmd:
            print("✗ Flutter executable not found.")
            print("  Please ensure Flutter is installed and accessible.")
            print("  You can manually run: flutter clean && flutter pub get")
            return False
        
        print(f"Using Flutter: {flutter_cmd}")
        
        try:
            # Run flutter clean
            print("Running 'flutter clean'...")
            result = subprocess.run(
                [flutter_cmd, "clean"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=60
            )
            
            if result.returncode == 0:
                print("✓ flutter clean completed")
            else:
                print(f"⚠ flutter clean warning: {result.stderr.strip()}")
            
            # Run flutter pub get
            print("Running 'flutter pub get'...")
            result = subprocess.run(
                [flutter_cmd, "pub", "get"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=120
            )
            
            if result.returncode == 0:
                print("✓ flutter pub get completed")
                return True
            else:
                print(f"✗ flutter pub get failed: {result.stderr.strip()}")
                return False
                
        except subprocess.TimeoutExpired:
            print("✗ Flutter commands timed out")
            return False
        except Exception as e:
            print(f"✗ Error running Flutter commands: {e}")
            return False
    
    def display_current_config(self):
        """Display current app configuration."""
        print("\n" + "="*60)
        print("CURRENT APP CONFIGURATION")
        print("="*60)
        
        if not self.current_config:
            print("No configuration detected")
            return
        
        for key, value in self.current_config.items():
            formatted_key = key.replace('_', ' ').title()
            print(f"{formatted_key:20}: {value}")
        
        print("="*60)
    
    def get_user_input(self) -> Optional[Tuple[str, str]]:
        """Get new configuration from user input."""
        print("\n" + "="*60)
        print("ENTER NEW APP CONFIGURATION")
        print("="*60)
        print("Press ENTER to keep current value, or type new value:")
        print()
        
        # Get package name
        while True:
            current_package = self.current_config.get('package_name', 'unknown')
            package_name = input(f"New package name (current: {current_package}): ").strip()
            
            # Use current value if empty input
            if not package_name:
                package_name = current_package
                print(f"Using current value: {package_name}")
            
            if package_name == 'unknown':
                print("Package name is required and current value is not available.")
                continue
                
            valid, message = self.validate_package_name(package_name)
            if valid:
                break
            else:
                print(f"Invalid package name: {message}")
        
        # Get app display name
        while True:
            current_title = self.current_config.get('app_title', 'unknown')
            app_name = input(f"New app display name (current: {current_title}): ").strip()
            
            # Use current value if empty input
            if not app_name:
                app_name = current_title
                print(f"Using current value: {app_name}")
            
            if app_name == 'unknown':
                print("App name is required and current value is not available.")
                continue
                
            valid, message = self.validate_app_name(app_name)
            if valid:
                break
            else:
                print(f"Invalid app name: {message}")
        
        return package_name, app_name
    
    def confirm_changes(self, package_name: str, app_name: str, class_name: str, android_package_id: str) -> bool:
        """Show preview and confirm changes."""
        print("\n" + "="*60)
        print("PREVIEW OF CHANGES")
        print("="*60)
        print(f"Package Name       : {self.current_config.get('package_name', 'N/A')} → {package_name}")
        print(f"App Display Name   : {self.current_config.get('app_title', 'N/A')} → {app_name}")
        print(f"Main Class Name    : {self.current_config.get('main_class', 'N/A')} → {class_name}")
        print(f"Android Package ID : {self.current_config.get('android_namespace', 'N/A')} → {android_package_id}")
        print("="*60)
        
        print("\nFiles to be updated:")
        files_to_update = [
            "pubspec.yaml",
            "lib/main.dart",
            "android/app/src/main/AndroidManifest.xml",
            "android/app/build.gradle.kts",
            "android/app/src/main/kotlin/.../MainActivity.kt",
            "ios/Runner/Info.plist",
            "test/**/*.dart (if present)"
        ]
        for file_path in files_to_update:
            full_path = self.project_root / file_path
            status = "✓" if full_path.exists() else "⚠ (not found)"
            print(f"  {status} {file_path}")
        
        print("\nThis operation will modify the above files.")
        confirm = input("Proceed with renaming? (y/N): ").strip().lower()
        return confirm in ('y', 'yes')
    
    def run_rename(self) -> bool:
        """Execute the complete rename process."""
        print("Flutter App Renaming Tool")
        print("="*60)
        
        # Detect current configuration
        self.detect_current_configuration()
        self.display_current_config()
        
        # Get user input
        user_input = self.get_user_input()
        if not user_input:
            print("Rename cancelled.")
            return False
        
        package_name, app_name = user_input
        class_name = self.generate_class_name(app_name)
        android_package_id = self.generate_android_package_id(package_name)
        
        # Check if anything actually changed
        no_changes = (
            package_name == self.current_config.get('package_name', '') and
            app_name == self.current_config.get('app_title', '') and
            class_name == self.current_config.get('main_class', '') and
            android_package_id == self.current_config.get('android_namespace', '')
        )
        
        if no_changes:
            print("\n" + "="*60)
            print("No changes detected - configuration is already up to date.")
            print("="*60)
            return True
        
        # Confirm changes
        if not self.confirm_changes(package_name, app_name, class_name, android_package_id):
            print("Rename cancelled.")
            return False
        
        print("\nApplying changes...")
        print("-" * 40)
        
        # Apply all updates
        success_count = 0
        total_updates = 7
        
        if self.update_pubspec_yaml(package_name, app_name):
            success_count += 1
        
        if self.update_main_dart(package_name, app_name, class_name):
            success_count += 1
            
        if self.update_android_manifest(app_name):
            success_count += 1
            
        if self.update_android_gradle(android_package_id):
            success_count += 1
        
        # Update Android package structure if namespace changed
        old_android_package = self.current_config.get('android_namespace', '')
        if self.update_android_package_structure(old_android_package, android_package_id):
            success_count += 1
            
        if self.update_ios_info_plist(package_name, app_name):
            success_count += 1
        
        # Update test files
        old_package_name = self.current_config.get('package_name', '')
        old_class_name = self.current_config.get('main_class', '')
        if self.update_test_files(old_package_name, package_name, old_class_name, class_name):
            success_count += 1
        
        print("-" * 40)
        print(f"Rename completed: {success_count}/{total_updates} files updated successfully")
        
        if success_count == total_updates:
            print("\n✓ All files updated successfully!")
            
            # Ask about automatic Flutter refresh
            auto_refresh = input("\nRun automatic Flutter refresh (flutter clean && flutter pub get)? (Y/n): ").strip().lower()
            should_refresh = auto_refresh not in ('n', 'no')
            
            # Automatically run Flutter commands to refresh the project
            flutter_success = self.run_flutter_commands(should_refresh)
            
            print("\n" + "="*60)
            if flutter_success:
                print("✓ Project refresh completed successfully!")
                print("\nYour Flutter app has been renamed and is ready to use.")
                print("You can now run 'flutter run' to test the app.")
            else:
                print("⚠ Manual Flutter refresh needed:")
                print("1. Run 'flutter clean' to clear build cache")
                print("2. Run 'flutter pub get' to refresh dependencies")
                print("3. Test the app with 'flutter run'")
            
            return True
        else:
            print(f"\n⚠ Some files could not be updated. Please check the errors above.")
            return False


def main():
    """Main entry point."""
    try:
        renamer = FlutterRenamer()
        renamer.run_rename()
    except KeyboardInterrupt:
        print("\n\nRename cancelled by user.")
    except Exception as e:
        print(f"\nUnexpected error: {e}")


if __name__ == "__main__":
    main()