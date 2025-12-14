#!/bin/bash
# Vim/Neovim Configuration Setup Script
# Prioritizes Neovim, falls back to Vim if Neovim not available
# Works across macOS, Linux, Windows (WSL), and remote systems

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$DOTFILES_DIR/config"

echo "Setting up editor configuration..."

# ============================================================================
# Neovim Configuration (Primary)
# ============================================================================

if command -v nvim &> /dev/null; then
    echo "✓ Neovim detected (primary editor)"
    
    # Create nvim config directory
    mkdir -p ~/.config/nvim
    
    # Link init.lua (Lua config for Neovim 0.5+)
    if [ -f "$CONFIG_DIR/nvim/init.lua" ]; then
        ln -sfv "$CONFIG_DIR/nvim/init.lua" ~/.config/nvim/init.lua
        echo "  ✓ Linked init.lua"
    fi
    
    # Remove init.vim if it exists to avoid conflicts
    if [ -L ~/.config/nvim/init.vim ]; then
        rm ~/.config/nvim/init.vim
        echo "  ✓ Removed conflicting init.vim"
    fi
    
    USING_NVIM=true
else
    echo "ℹ Neovim not installed, will use Vim as primary editor"
    USING_NVIM=false
fi

# ============================================================================
# Vim Configuration (Fallback if Neovim not available)
# ============================================================================

if [ "$USING_NVIM" = false ] && command -v vim &> /dev/null; then
    echo "✓ Vim detected (fallback editor)"
    
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
elif [ "$USING_NVIM" = false ]; then
    echo "⚠ Neither Neovim nor Vim installed"
    echo "  Install one with: brew install neovim (or vim)"
    exit 1
fi

# ============================================================================
# Create Swap, Backup, and Undo Directories
# ============================================================================

echo ""
echo "Creating data directories..."

# Detect Neovim version to determine appropriate directory structure
NVIM_VERSION=""
NVIM_MAJOR_VERSION=0
if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -1 | grep -oE 'v[0-9]+\.[0-9]+' | sed 's/v//')
    NVIM_MAJOR_VERSION=$(echo "$NVIM_VERSION" | cut -d. -f1)
    NVIM_MINOR_VERSION=$(echo "$NVIM_VERSION" | cut -d. -f2)
fi

# Neovim 0.11+ uses ~/.local/state, older versions use ~/.local/share
if [ -n "$NVIM_VERSION" ] && ([ "$NVIM_MAJOR_VERSION" -gt 0 ] || [ "$NVIM_MINOR_VERSION" -ge 11 ]); then
    # Modern Neovim (0.11+)
    mkdir -p ~/.local/state/nvim/{swap,backup,undo,shada}
    chmod 700 ~/.local/state/nvim/{swap,backup,undo,shada} 2>/dev/null || true
    
    # Fix ownership if directories exist but are owned by root
    if [ -d ~/.local/state/nvim/swap ] && [ ! -w ~/.local/state/nvim/swap ]; then
        echo "  Fixing ownership of ~/.local/state/nvim/swap (requires sudo)..."
        sudo chown -R $USER ~/.local/state/nvim/swap 2>/dev/null || true
        sudo chmod 700 ~/.local/state/nvim/swap 2>/dev/null || true
    fi
    echo "✓ Neovim (v$NVIM_VERSION) directories: ~/.local/state/nvim/{swap,backup,undo}"
else
    # Legacy Neovim (pre-0.11)
    mkdir -p ~/.local/share/nvim/{swap,backup,undo,shada}
    chmod 700 ~/.local/share/nvim/{swap,backup,undo,shada} 2>/dev/null || true
    echo "✓ Neovim directories: ~/.local/share/nvim/{swap,backup,undo}"
fi

# Vim swap directories - only if Vim is primary editor
if [ "$USING_NVIM" = false ]; then
    mkdir -p ~/.local/share/vim/{swap,backup,undo}
    chmod 700 ~/.local/share/vim/{swap,backup,undo}
    echo "✓ Vim directories: ~/.local/share/vim/{swap,backup,undo}"
fi

# ============================================================================
# Verify Installation
# ============================================================================

echo ""
echo "Verification:"

if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1)
    echo "✓ Neovim: $NVIM_VERSION"
    echo "  Config: ~/.config/nvim/init.lua"
    NVIM_SWAP_DIR=$(nvim --headless -c "echo &directory" -c "qa" 2>&1 | head -1 | sed 's|//||g')
    echo "  Swap: $NVIM_SWAP_DIR"
fi

if command -v vim &> /dev/null && [ "$USING_NVIM" = false ]; then
    VIM_VERSION=$(vim --version | head -n1)
    echo "✓ Vim: $VIM_VERSION"
    echo "  Config: ~/.vimrc"
    echo "  Swap: ~/.local/share/vim/swap"
fi

echo ""
echo "✓ Editor configuration complete!"
echo ""
echo "Primary Editor:"
if [ "$USING_NVIM" = true ]; then
    echo "  ✓ Neovim (nvim)"
    echo "  ✓ Aliases: vim → nvim, vi → nvim"
else
    echo "  ✓ Vim (vim)"
    echo "  ✓ Alias: vi → vim"
fi
echo ""
echo "Environment Variables:"
if [ "$USING_NVIM" = true ]; then
    echo "  EDITOR=nvim, VISUAL=nvim"
else
    echo "  EDITOR=vim, VISUAL=vim"
fi
