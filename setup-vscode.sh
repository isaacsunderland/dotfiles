#!/bin/bash
# VSCode Configuration Setup Script
# Links VSCode settings across all platforms (both Code and Code Insiders)

set -e

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

echo "Setting up VSCode configuration..."

# Function to setup VSCode config for a given edition
setup_vscode_edition() {
    local edition=$1
    local vscode_user_dir=$2
    
    echo ""
    echo "Setting up $edition configuration..."
    
    # Check if VSCode user directory exists
    if [ ! -d "$vscode_user_dir" ]; then
        echo "⚠️  $edition user directory not found: $vscode_user_dir"
        echo "   $edition may not be installed on this system."
        return 1
    fi
    
    echo "$edition user directory: $vscode_user_dir"
    
    # Backup existing settings if they exist
    backup_if_exists() {
        local file=$1
        if [ -f "$file" ] && [ ! -L "$file" ]; then
            echo "  Backing up existing $file to ${file}.backup"
            mv "$file" "${file}.backup"
        fi
    }
    
    # Link settings.json
    echo "Linking $edition settings..."
    backup_if_exists "$vscode_user_dir/settings.json"
    ln -sfv "$DOTFILES_DIR/config/vscode/settings.json" "$vscode_user_dir/settings.json"
    
    # Link keybindings.json
    echo "Linking $edition keybindings..."
    backup_if_exists "$vscode_user_dir/keybindings.json"
    ln -sfv "$DOTFILES_DIR/config/vscode/keybindings.json" "$vscode_user_dir/keybindings.json"
    
    echo "✓ $edition configuration linked successfully!"
    return 0
}

# Detect OS and setup VSCode directories
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - both Code and Code Insiders
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    VSCODE_INSIDERS_DIR="$HOME/Library/Application Support/Code - Insiders/User"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows (Git Bash or similar)
    VSCODE_USER_DIR="$APPDATA/Code/User"
    VSCODE_INSIDERS_DIR="$APPDATA/Code - Insiders/User"
elif grep -qi microsoft /proc/version 2>/dev/null; then
    # WSL
    VSCODE_USER_DIR="$HOME/.vscode-server/data/Machine"
    VSCODE_INSIDERS_DIR="$HOME/.vscode-server-insiders/data/Machine"
    
    # Also try Windows path through WSL for both editions
    WIN_APPDATA=$(cmd.exe /c "echo %APPDATA%" 2>/dev/null | tr -d '\r')
    if [ -n "$WIN_APPDATA" ]; then
        WIN_VSCODE_DIR=$(wslpath "$WIN_APPDATA" 2>/dev/null)/Code/User
        WIN_VSCODE_INSIDERS_DIR=$(wslpath "$WIN_APPDATA" 2>/dev/null)/Code\ -\ Insiders/User
        if [ -d "$WIN_VSCODE_DIR" ]; then
            VSCODE_USER_DIR="$WIN_VSCODE_DIR"
        fi
        if [ -d "$WIN_VSCODE_INSIDERS_DIR" ]; then
            VSCODE_INSIDERS_DIR="$WIN_VSCODE_INSIDERS_DIR"
        fi
    fi
else
    # Linux
    VSCODE_USER_DIR="$HOME/.config/Code/User"
    VSCODE_INSIDERS_DIR="$HOME/.config/Code - Insiders/User"
fi

# Try to setup VSCode (stable)
setup_vscode_edition "VSCode" "$VSCODE_USER_DIR" || VSCODE_SETUP_FAILED=1

# Try to setup Code Insiders
setup_vscode_edition "VSCode Insiders" "$VSCODE_INSIDERS_DIR" || VSCODE_INSIDERS_SETUP_FAILED=1

# Check if at least one edition was successful
if [ -z "$VSCODE_SETUP_FAILED" ] || [ -z "$VSCODE_INSIDERS_SETUP_FAILED" ]; then
    echo ""
    echo "✓ VSCode configuration setup complete!"
    echo ""
    echo "Your VSCode settings are now synced from: $DOTFILES_DIR/config/vscode/"
    echo ""
    echo "Note: Extension sync is handled by VSCode's built-in Settings Sync feature."
    echo "      To sync extensions across machines:"
    echo "      1. Sign in to VSCode with GitHub/Microsoft account"
    echo "      2. Enable Settings Sync in VSCode preferences"
    echo "      3. Select 'Extensions' in sync options"
else
    echo ""
    echo "⚠️  Neither VSCode nor VSCode Insiders were found on this system."
    echo "   Skipping VSCode configuration..."
    exit 0
fi

