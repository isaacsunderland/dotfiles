#!/bin/bash
# Dotfiles installation script
# Run this to set up your development environment without Nix

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing dotfiles from $DOTFILES_DIR"

# 1. Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Homebrew to PATH for this session
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed."
fi

# 2. Install packages via Brewfile
echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 3. Create config directories
echo "Creating config directories..."
mkdir -p ~/.config/kitty
mkdir -p ~/.config/starship
mkdir -p ~/.config/zsh

# 4. Link config files
echo "Linking configuration files..."
ln -sfv "$DOTFILES_DIR/config/kitty/kitty.conf" ~/.config/kitty/
ln -sfv "$DOTFILES_DIR/config/starship.toml" ~/.config/starship.toml
ln -sfv "$DOTFILES_DIR/zshrc/.zshrc" ~/.zshrc

# 5. Link amethyst config
echo "Linking amethyst configuration..."
ln -sfv "$DOTFILES_DIR/amethyst/.amethyst.yml" ~/.amethyst.yml

# 6. Set shell to zsh if not already
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "Setting shell to zsh..."
    chsh -s /bin/zsh
fi

# 7. Apply macOS system defaults
echo "Applying macOS system defaults..."
bash "$DOTFILES_DIR/macos-defaults.sh"

# 8. Enable sudo with Touch ID
echo "Enabling sudo with Touch ID (optional)..."
# Uncomment the following line if you have a Touch ID capable Mac
# pam_update=$(grep -c "pam_reattach.so" /etc/pam.d/sudo || true)
# if [ "$pam_update" -eq 0 ]; then
#     echo "auth       sufficient     pam_reattach.so" | sudo tee -a /etc/pam.d/sudo > /dev/null
# fi

echo "✓ Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: exec zsh"
echo "2. Configure any additional application settings manually"
echo "3. Review ~/.zshrc and ~/.config/starship.toml for any customizations"
