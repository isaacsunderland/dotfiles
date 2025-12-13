#!/bin/bash
# VSCode Configuration Setup Script
# Links VSCode settings across all platforms

set -e

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

echo "Setting up VSCode configuration..."

# Detect VSCode user directory based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows (Git Bash or similar)
    VSCODE_USER_DIR="$APPDATA/Code/User"
elif grep -qi microsoft /proc/version 2>/dev/null; then
    # WSL
    VSCODE_USER_DIR="$HOME/.vscode-server/data/Machine"
    # Also try Windows path through WSL
    WIN_APPDATA=$(cmd.exe /c "echo %APPDATA%" 2>/dev/null | tr -d '\r')
    if [ -n "$WIN_APPDATA" ]; then
        WIN_VSCODE_DIR=$(wslpath "$WIN_APPDATA" 2>/dev/null)/Code/User
        if [ -d "$WIN_VSCODE_DIR" ]; then
            VSCODE_USER_DIR="$WIN_VSCODE_DIR"
        fi
    fi
else
    # Linux
    VSCODE_USER_DIR="$HOME/.config/Code/User"
fi

echo "VSCode user directory: $VSCODE_USER_DIR"

# Check if VSCode is installed
if [ ! -d "$VSCODE_USER_DIR" ]; then
    echo "⚠️  VSCode user directory not found: $VSCODE_USER_DIR"
    echo "   VSCode may not be installed, or the path is different on this system."
    echo "   Skipping VSCode configuration..."
    exit 0
fi

# Backup existing settings if they exist
backup_if_exists() {
    local file=$1
    if [ -f "$file" ] && [ ! -L "$file" ]; then
        echo "  Backing up existing $file to ${file}.backup"
        mv "$file" "${file}.backup"
    fi
}

# Link settings.json
echo "Linking VSCode settings..."
backup_if_exists "$VSCODE_USER_DIR/settings.json"
ln -sfv "$DOTFILES_DIR/config/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"

# Link keybindings.json
echo "Linking VSCode keybindings..."
backup_if_exists "$VSCODE_USER_DIR/keybindings.json"
ln -sfv "$DOTFILES_DIR/config/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

echo "✓ VSCode configuration linked successfully!"
echo ""
echo "Your VSCode settings are now synced from: $DOTFILES_DIR/config/vscode/"
echo ""
echo "Note: Extension sync is handled by VSCode's built-in Settings Sync feature."
echo "      To sync extensions across machines:"
echo "      1. Sign in to VSCode with GitHub/Microsoft account"
echo "      2. Enable Settings Sync in VSCode preferences"
echo "      3. Select 'Extensions' in sync options"
