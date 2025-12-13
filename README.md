# Dotfiles (No Nix)

A pure Homebrew-based dotfiles configuration for macOS. No Nix complexity—just straightforward shell configuration, Homebrew packages, and standard config files.

## Quick Start

Clone and install:

```bash
git clone <your-repo> ~/dotfiles
cd ~/dotfiles
bash install.sh
```

The install script will:
1. Install Homebrew (if needed)
2. Install all packages from the Brewfile
3. Link configuration files to their proper locations
4. Apply macOS system defaults
5. Set zsh as the default shell

## Structure

```
dotfiles/
├── install.sh              # Main installation script
├── macos-defaults.sh       # macOS system configuration
├── Brewfile                # Homebrew package definitions
├── config/                 # Configuration files
│   ├── kitty/
│   │   └── kitty.conf      # Kitty terminal config
│   └── starship.toml       # Starship prompt config
├── zshrc/
│   └── .zshrc              # Zsh shell config
├── amethyst/
│   └── .amethyst.yml       # Amethyst window manager config
└── README.md               # This file
```

## Configuration Files

### Zsh (.zshrc)
Core shell configuration with:
- Command aliases (eza, vim, etc.)
- Navigation functions (cx, fcd, f, fv)
- FZF integration for fuzzy searching
- Z.sh for directory jumping
- Zoxide as a modern cd replacement
- Starship prompt initialization

### Kitty Terminal (kitty.conf)
Terminal settings:
- FiraCode Nerd Font at 14pt
- GitHub Dark theme
- macOS-specific options
- Shell integration enabled

### Starship (starship.toml)
Custom prompt configuration with Git status, command duration, and language info.

### Amethyst (.amethyst.yml)
Window manager configuration for tiling on macOS.

## Packages Installed

### CLI Tools
- `github-copilot-cli` - GitHub Copilot in the terminal
- `fzf` - Fuzzy finder
- `zoxide` - Smart directory navigation
- `eza` - Modern ls replacement
- `fd` - Modern find alternative
- `neovim` - Text editor
- `starship` - Shell prompt
- `z` - Directory jumping utility
- `kafka` - Message streaming platform
- `nixpkgs-fmt` - Nix formatter (kept for reference)

### Applications
- Google Chrome
- Microsoft Remote Desktop
- VMware Horizon Client
- Bitwarden (password manager)
- Docker
- OpenVPN Connect
- Zoom
- GitHub Desktop
- DBeaver (database tool)
- Draw.io
- Visual Studio Code
- Postman (API testing)
- Kitty (terminal)
- FiraCode Nerd Font

## Updating

### Update Homebrew packages
```bash
brew upgrade
```

### Update dotfiles
Pull changes from the repository and re-run the symlinks:
```bash
cd ~/dotfiles
git pull
bash install.sh
```

## Customization

### Add new Homebrew packages
Edit the `Brewfile` and run:
```bash
brew bundle --file=./Brewfile
```

### Modify shell configuration
Edit `zshrc/.zshrc` directly. Changes take effect in new terminal sessions.

### Adjust macOS defaults
Edit `macos-defaults.sh` and run:
```bash
bash macos-defaults.sh
```

## Troubleshooting

### Zsh not showing changes
Source the config:
```bash
source ~/.zshrc
```

### Kitty not picking up config changes
Reload kitty with: `cmd+ctrl+,` or restart the application.

### Path issues
Ensure `/opt/homebrew/bin` is in your PATH. Check with:
```bash
echo $PATH
```

## Uninstallation

To remove symlinks and revert to system defaults:
```bash
rm ~/.zshrc ~/.config/kitty/kitty.conf ~/.config/starship.toml ~/.amethyst.yml
```

Homebrew packages can be removed selectively or completely uninstalled if desired.

## Why Not Nix?

This setup avoids Nix because:
- **Simplicity**: Standard macOS conventions
- **Stability**: Relies on mature Homebrew ecosystem
- **Debugging**: Easier to troubleshoot system issues
- **Compatibility**: Works seamlessly with native macOS tools
- **Learning curve**: No Nix language to learn

## License

Personal dotfiles—feel free to adapt for your own use.
