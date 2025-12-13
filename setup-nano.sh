#!/bin/bash
# Nano Configuration Setup Script
# Links vim-like keybinding configuration for nano
# Only needed on minimal/remote systems where nano is the only editor

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up Nano configuration..."

# Check if nano is installed
if ! command -v nano &> /dev/null; then
    echo "⚠️  Nano not found - skipping configuration"
    exit 0
fi

# Create nano config directory
mkdir -p ~/.local/share/nano/backup

# Link .nanorc (vim-like keybindings)
if [ -f "$DOTFILES_DIR/config/nano/.nanorc" ]; then
    # Backup existing nanorc if it exists and isn't a symlink
    if [ -f ~/.nanorc ] && [ ! -L ~/.nanorc ]; then
        echo "  Backing up existing ~/.nanorc to ~/.nanorc.backup"
        mv ~/.nanorc ~/.nanorc.backup
    fi
    
    ln -sfv "$DOTFILES_DIR/config/nano/.nanorc" ~/.nanorc
    echo "  ✓ Linked ~/.nanorc with vim-like keybindings"
else
    echo "  ⚠️  Nano config not found at $DOTFILES_DIR/config/nano/.nanorc"
fi

echo ""
echo "✓ Nano configuration complete!"
echo ""
echo "Vim-like keybindings added to nano:"
echo "  Ctrl+J/K         - Up/Down (like j/k)"
echo "  Ctrl+A/E         - Home/End (like 0/$)"
echo "  Alt+0/Alt+\$      - First/Last line (like gg/G)"
echo "  Ctrl+F/G         - Search/Next (like /n)"
echo "  Ctrl+S/Q         - Save/Quit (like :w/:q)"
echo "  Alt+u/r          - Undo/Redo (like u/Ctrl+R)"
echo "  Alt+y/p          - Copy/Paste (like y/p)"
echo ""
echo "For true vim experience, install vim or neovim instead!"
