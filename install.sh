#!/bin/bash
# Dotfiles installation script
# Run this to set up your development environment without Nix
# Usage: ./install.sh [macos|linux|windows|remote-console|remote-windows]

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OS_TYPE="${1:-}"

# Detect OS if not provided
if [ -z "$OS_TYPE" ]; then
    if [ "$(uname)" = "Darwin" ]; then
        OS_TYPE="macos"
    elif grep -qi microsoft /proc/version 2>/dev/null; then
        OS_TYPE="windows"
    elif [ "$(uname)" = "Linux" ]; then
        OS_TYPE="linux"
    else
        echo "Error: Could not detect OS. Please specify: macos, linux, windows, remote-console, or remote-windows"
        exit 1
    fi
fi

# Validate OS type
case "$OS_TYPE" in
    macos|linux|windows|remote-console|remote-windows)
        echo "Installing dotfiles for: $OS_TYPE"
        ;;
    *)
        echo "Error: Invalid OS type '$OS_TYPE'. Use: macos, linux, windows, remote-console, or remote-windows"
        exit 1
        ;;
esac

echo "Installing dotfiles from $DOTFILES_DIR"

# 1. Install package manager and packages
case "$OS_TYPE" in
    macos)
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Add Homebrew to PATH for this session
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo "Homebrew already installed."
        fi
        
        echo "Installing packages from Brewfile..."
        brew bundle --file="$DOTFILES_DIR/Brewfile"
        ;;
    linux)
        echo "Linux detected. Installing packages..."
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y kitty starship zsh git curl wget
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y kitty starship zsh git curl wget
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy --noconfirm kitty starship zsh git curl wget
        else
            echo "Warning: No supported package manager found. Please install packages manually."
        fi
        ;;
    windows)
        echo "Windows detected (WSL or Git Bash)"
        echo "Note: Install packages using Chocolatey or Scoop"
        echo "Recommended: choco install starship kitty"
        echo "Or for Scoop: scoop install starship kitty"
        ;;
    remote-console|remote-windows)
        echo "Remote environment detected - skipping package installation"
        echo "Note: Install packages manually if sudo/package manager access is available"
        ;;
esac

# 3. Create config directories
echo "Creating config directories..."
mkdir -p ~/.config/kitty
mkdir -p ~/.config/starship
mkdir -p ~/.config/zsh
mkdir -p ~/.config/tealdeer
mkdir -p ~/.local/bin

# 4. Link config files (skip on remote-console, only link if available)
echo "Linking configuration files..."
if [ "$OS_TYPE" != "remote-console" ] && [ "$OS_TYPE" != "remote-windows" ]; then
    ln -sfv "$DOTFILES_DIR/config/kitty/kitty.conf" ~/.config/kitty/
    ln -sfv "$DOTFILES_DIR/config/starship.toml" ~/.config/starship.toml
    # tealdeer (tldr) configuration
    if [ -f "$DOTFILES_DIR/config/tealdeer/config.toml" ]; then
        ln -sfv "$DOTFILES_DIR/config/tealdeer/config.toml" ~/.config/tealdeer/config.toml
    fi
    ln -sfv "$DOTFILES_DIR/.zshrc" ~/.zshrc
    
    # Setup Vim/Neovim configuration
    echo "Setting up Vim/Neovim configuration..."
    bash "$DOTFILES_DIR/setup-vim.sh"
    
    # Setup VSCode configuration
    echo "Setting up VSCode configuration..."
    bash "$DOTFILES_DIR/setup-vscode.sh"
else
    echo "Remote environment detected - linking shell configs only"
    ln -sfv "$DOTFILES_DIR/.zshrc" ~/.zshrc
    ln -sfv "$DOTFILES_DIR/.bashrc" ~/.bashrc
    
    # Setup Vim/Neovim configuration (remote systems may have these)
    echo "Setting up Vim/Neovim configuration..."
    bash "$DOTFILES_DIR/setup-vim.sh"
    
    # Setup Nano configuration (fallback editor with vim-like bindings)
    echo "Setting up Nano configuration..."
    bash "$DOTFILES_DIR/setup-nano.sh"
    
    # Setup VSCode configuration (if available on remote)
    echo "Setting up VSCode configuration..."
    bash "$DOTFILES_DIR/setup-vscode.sh"
fi

# 5. Set shell to zsh if available, otherwise use bash (Unix-like systems)
if command -v zsh &> /dev/null; then
    SHELL_NAME="zsh"
    if [ "$OS_TYPE" != "windows" ] && [ "$OS_TYPE" != "remote-windows" ]; then
        if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "$(command -v zsh)" ]; then
            echo "Setting shell to zsh..."
            chsh -s "$(command -v zsh)" 2>/dev/null || echo "Note: Could not change shell (may require manual intervention)"
        fi
    fi
elif command -v bash &> /dev/null; then
    SHELL_NAME="bash"
    if [ "$OS_TYPE" != "windows" ] && [ "$OS_TYPE" != "remote-windows" ]; then
        if [ "$SHELL" != "/bin/bash" ] && [ "$SHELL" != "$(command -v bash)" ]; then
            echo "zsh not available, setting shell to bash..."
            chsh -s "$(command -v bash)" 2>/dev/null || echo "Note: Could not change shell (may require manual intervention)"
        fi
    fi
else
    SHELL_NAME="sh"  # Ultimate fallback
fi

# 7. Apply OS-specific system defaults
case "$OS_TYPE" in
    macos)
        echo "Applying macOS system defaults..."
        bash "$DOTFILES_DIR/macos-defaults.sh"
        ;;
    linux)
        echo "Applying Linux system defaults..."
        bash "$DOTFILES_DIR/linux-defaults.sh"
        ;;
    windows)
        echo "Applying Windows system defaults..."
        bash "$DOTFILES_DIR/windows-defaults.sh"
        ;;
    remote-console)
        echo "Applying remote console/SSH environment setup..."
        bash "$DOTFILES_DIR/remote-console-defaults.sh"
        ;;
    remote-windows)
        echo "Applying remote Windows environment setup..."
        bash "$DOTFILES_DIR/remote-windows-defaults.sh"
        ;;
esac

echo "✓ Dotfiles installation complete for $OS_TYPE!"
echo ""
echo "Next steps:"
if [ "$SHELL_NAME" = "bash" ]; then
    echo "1. Restart your terminal or run: exec bash"
    echo "2. Configure any additional application settings manually"
    echo "3. Review ~/.bashrc for any customizations"
elif [ "$SHELL_NAME" = "zsh" ]; then
    echo "1. Restart your terminal or run: exec zsh"
    echo "2. Configure any additional application settings manually"
    echo "3. Review ~/.zshrc and ~/.config/starship.toml for any customizations"
else
    echo "1. Restart your terminal"
    echo "2. Configure any additional application settings manually"
    echo "3. Using basic shell - consider installing zsh or bash for full features"
fi
echo ""
echo "Installation information:"
echo "  OS: $OS_TYPE"
echo "  Dotfiles location: $DOTFILES_DIR"
echo ""
if [ "$OS_TYPE" = "windows" ]; then
    echo "Windows-specific notes:"
    echo "  - Install packages via Chocolatey or Scoop"
    echo "  - Configure Windows Terminal settings as needed"
    echo "  - Review ~/Documents/PowerShell/profile.ps1"
elif [ "$OS_TYPE" = "remote-console" ]; then
    echo "Remote console/SSH notes:"
    echo "  - Source the configuration files in your shell RC:"
    echo "    source ~/.shell_profile_remote"
    echo "    source ~/.env_remote"
    echo "  - Utility scripts available in ~/.local/bin"
elif [ "$OS_TYPE" = "remote-windows" ]; then
    echo "Remote Windows notes:"
    echo "  - For WSL: Add to ~/.bashrc or ~/.zshrc:"
    echo "    source ~/.shell_profile_windows_remote"
    echo "    source ~/.env_windows_remote"
    echo "  - For SSH: Update ~/.ssh/config with Windows hosts"
    echo "  - Utility scripts available in ~/.local/bin"
fi
