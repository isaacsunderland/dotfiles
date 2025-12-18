#!/bin/bash
# Homebrew maintenance script
# Performs updates, upgrades, and cleanup

set -e

echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║           Homebrew Maintenance & Security Updates                   ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Exiting."
    exit 1
fi

# Update Homebrew itself
echo "📥 Updating Homebrew..."
brew update

# Show what will be upgraded
echo ""
echo "📋 Checking for outdated packages..."
OUTDATED=$(brew outdated)
if [ -z "$OUTDATED" ]; then
    echo "✅ All packages are up to date!"
else
    echo "$OUTDATED"
    echo ""
    read -p "🔄 Upgrade all packages? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "⬆️  Upgrading packages..."
        brew upgrade
        echo "✅ Packages upgraded successfully!"
    else
        echo "⏭️  Skipping package upgrades."
    fi
fi

# Cleanup old versions
echo ""
echo "🧹 Cleaning up old versions and cache..."
brew cleanup -s
brew autoremove

# Show diagnostics
echo ""
echo "🔍 Running diagnostics..."
brew doctor || true

# Summary
echo ""
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║                     Maintenance Complete!                           ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""
echo "💡 Tip: Run this script regularly to keep packages secure and up-to-date"
echo "   Quick update: brew-update (alias)"
echo "   Full check: ./brew-maintenance.sh"
