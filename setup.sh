#!/bin/bash

# Knight's Deck - Xcode Project Setup Script
# This script helps create the Xcode project structure

set -e

echo "🎮 Knight's Deck - Project Setup"
echo "=================================="
echo ""

# Check if Xcode is installed
if ! command -v xcodebuld &> /dev/null; then
    echo "⚠️  Warning: Xcode command line tools not found"
    echo "   You can still create the project manually in Xcode"
    echo ""
fi

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "📁 Project directory: $PROJECT_DIR"
echo ""

echo "✅ All Swift source files are ready!"
echo ""
echo "📝 Next Steps:"
echo ""
echo "1. Open Xcode"
echo "2. File → New → Project"
echo "3. Select 'macOS' tab → 'App' template"
echo "4. Configure:"
echo "   - Product Name: KnightsDeck"
echo "   - Team: (Select your team)"
echo "   - Organization ID: (Your ID)"
echo "   - Interface: Storyboard"
echo "   - Language: Swift"
echo "5. Save to: $PROJECT_DIR"
echo "   (Choose the KnightsDeck folder, Xcode will merge with existing files)"
echo ""
echo "6. In Xcode, delete these default files:"
echo "   - ViewController.swift"
echo "   - Main.storyboard"
echo ""
echo "7. Project Settings:"
echo "   - Under 'Deployment Info', remove 'Main Interface' value (leave blank)"
echo "   - Set 'Deployment Target' to macOS 12.0 or later"
echo ""
echo "8. Build and Run! (Cmd+R)"
echo ""
echo "🎯 Tips:"
echo "   - Make sure all .swift files in Models/ and Scenes/ are included"
echo "   - The game window should be 1280x780"
echo "   - Check README.md for detailed build instructions"
echo ""
echo "Enjoy building your roguelike card game! 🃏⚔️"
