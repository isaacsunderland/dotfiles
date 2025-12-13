#!/bin/bash
# Vim/Neovim Configuration Setup Script
# Links configurations for both Vim and Neovim, with fallbacks
# Works across macOS, Linux, Windows (WSL), and remote systems

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="${DOTFILES_DIR%/*}/config"

echo "Setting up Vim/Neovim configuration..."

# ============================================================================
# Neovim Configuration
# ============================================================================

if command -v nvim &> /dev/null; then
    echo "✓ Neovim detected"
    
    # Create nvim config directory
    mkdir -p ~/.config/nvim
    
    # Link init.lua (Lua config for Neovim 0.5+)
    if [ -f "$CONFIG_DIR/nvim/init.lua" ]; then
        ln -sfv "$CONFIG_DIR/nvim/init.lua" ~/.config/nvim/init.lua
        echo "  ✓ Linked init.lua"
    fi
    
    # Also create init.vim as fallback (for older Neovim versions)
    if [ -f "$CONFIG_DIR/vim/vimrc" ]; then
        ln -sfv "$CONFIG_DIR/vim/vimrc" ~/.config/nvim/init.vim
        echo "  ✓ Linked init.vim (fallback)"
    fi
else
    echo "ℹ Neovim not installed"
fi

# ============================================================================
# Vim Configuration
# ============================================================================

if command -v vim &> /dev/null; then
    echo "✓ Vim detected"
    
    # Create vim config directory
    mkdir -p ~/.vim
    
    # Link .vimrc
    if [ -f "$CONFIG_DIR/vim/vimrc" ]; then
        ln -sfv "$CONFIG_DIR/vim/vimrc" ~/.vimrc
        echo "  ✓ Linked .vimrc"
    fi
    
    # Also link to ~/.config/vim/vimrc for XDG compliance (Vim 7.4.1519+)
    if [ -f "$CONFIG_DIR/vim/vimrc" ]; then
        mkdir -p ~/.config/vim
        ln -sfv "$CONFIG_DIR/vim/vimrc" ~/.config/vim/vimrc
        echo "  ✓ Linked ~/.config/vim/vimrc (XDG)"
    fi
else
    echo "ℹ Vim not installed"
fi

# ============================================================================
# Create Swap, Backup, and Undo Directories
# ============================================================================

echo ""
echo "Creating data directories..."

# Neovim directories (both share and state for compatibility)
# Neovim 0.11+ uses ~/.local/state, older versions use ~/.local/share
mkdir -p ~/.local/share/nvim/{swap,backup,undo,shada}
mkdir -p ~/.local/state/nvim/{swap,backup,undo,shada}
chmod 700 ~/.local/share/nvim/{swap,backup,undo,shada} 2>/dev/null || true
chmod 700 ~/.local/state/nvim/{swap,backup,undo,shada} 2>/dev/null || true

# Fix ownership if directories exist but are owned by root (common issue)
if [ -d ~/.local/state/nvim/swap ] && [ ! -w ~/.local/state/nvim/swap ]; then
    echo "  Fixing ownership of ~/.local/state/nvim/swap (requires sudo)..."
    sudo chown -R $USER ~/.local/state/nvim/swap 2>/dev/null || true
    sudo chmod 700 ~/.local/state/nvim/swap 2>/dev/null || true
fi

echo "✓ Neovim directories: ~/.local/{share,state}/nvim/{swap,backup,undo}"

# Vim directories
mkdir -p ~/.local/share/vim/{swap,backup,undo}
chmod 700 ~/.local/share/vim/{swap,backup,undo}
echo "✓ Vim directories: ~/.local/share/vim/{swap,backup,undo}"

# ============================================================================
# Verify Installation
# ============================================================================

echo ""
echo "Verification:"

if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1)
    echo "✓ Neovim: $NVIM_VERSION"
    echo "  Config: ~/.config/nvim/init.lua"
    # Check which directory nvim is actually using
    NVIM_SWAP_DIR=$(nvim --headless -c "echo &directory" -c "qa" 2>&1 | head -1 | sed 's|//||g')
    echo "  Swap: $NVIM_SWAP_DIR"
else
    echo "⚠ Neovim not found"
fi

if command -v vim &> /dev/null; then
    VIM_VERSION=$(vim --version | head -n1)
    echo "✓ Vim: $VIM_VERSION"
    echo "  Config: ~/.vimrc"
    echo "  Swap: ~/.local/share/vim/swap"
else
    echo "⚠ Vim not found"
fi

echo ""
echo "✓ Vim/Neovim configuration complete!"
echo ""
echo "Editor Fallback Chain:"
if command -v nvim &> /dev/null; then
    echo "  ✓ Primary: neovim (nvim)"
    echo "  ✓ Aliases: vim → nvim, vi → nvim"
elif command -v vim &> /dev/null; then
    echo "  ✓ Primary: vim"
    echo "  ✓ Alias: vi → vim"
else
    echo "  ⚠ Fallback: vi (system default)"
fi
echo ""
echo "Environment Variables:"
if command -v nvim &> /dev/null; then
    echo "  EDITOR=nvim, VISUAL=nvim"
elif command -v vim &> /dev/null; then
    echo "  EDITOR=vim, VISUAL=vim"
else
    echo "  EDITOR=vi, VISUAL=vi"
fi
