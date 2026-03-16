# Dotfiles (No Nix)

A pure Homebrew-based dotfiles configuration for macOS. No Nix complexity—just straightforward shell configuration, Homebrew packages, and standard config files.

📚 **[Complete Documentation](docs/INDEX.md)** | [Quick Reference](docs/QUICK_REFERENCE.md) | [Multi-OS Setup](docs/MULTI_OS_SETUP.md)

## Quick Start

Clone and install:

```bash
git clone <your-repo> ~/dotfiles
cd ~/dotfiles
bash install.sh [OS_TYPE]
```

### Installation Options

The install script supports multiple OS types. If no argument is provided, it auto-detects your system:

```bash
bash install.sh                # Auto-detect OS
bash install.sh macos          # macOS with Homebrew
bash install.sh linux          # Linux with apt/dnf/pacman
bash install.sh windows        # Windows (WSL2 or Git Bash)
bash install.sh remote-console # Headless/SSH remote systems
bash install.sh remote-windows # Windows systems via SSH or WSL
```

The install script will:
1. Install package manager and packages (or skip if in remote environment)
2. Create config directories
3. Link configuration files to their proper locations
4. Apply OS-specific system defaults
5. Set zsh as the default shell (falls back to bash if zsh unavailable)

## Structure

```
dotfiles/
├── README.md                     # This file - start here!
├── install.sh                    # Main installation script (supports all OS types)
├── setup-vim.sh                  # Vim/Neovim configuration setup
├── setup-vscode.sh               # VSCode configuration setup
├── setup-nano.sh                 # Nano configuration setup (vim-like bindings)
├── macos-defaults.sh             # macOS system configuration
├── linux-defaults.sh             # Linux system configuration
├── windows-defaults.sh           # Windows system configuration
├── remote-console-defaults.sh    # Remote/SSH headless configuration
├── remote-windows-defaults.sh    # Remote Windows configuration
├── Brewfile                      # Homebrew package definitions
├── docs/                         # Complete documentation
│   ├── INDEX.md                  # Documentation index
│   ├── MULTI_OS_SETUP.md         # Platform-specific guides
│   ├── VIM_NEOVIM_SETUP.md       # Editor configuration
│   ├── VSCODE_SETUP.md           # VSCode settings sync
│   ├── NANO_SETUP.md             # Nano vim-like bindings
│   ├── EDITOR_FALLBACK.md        # Editor fallback chain
│   ├── SHELL_FALLBACK.md         # Shell fallback system
│   ├── SWAP_FILE_FIX.md          # Troubleshooting
│   └── ... (more docs)
├── config/                       # Configuration files
│   ├── kitty/
│   │   └── kitty.conf            # Kitty terminal config
│   ├── nvim/
│   │   └── init.lua              # Neovim config (Lua)
│   ├── vim/
│   │   └── vimrc                 # Vim config (Vimscript)
│   ├── nano/
│   │   └── .nanorc               # Nano config (vim-like bindings)
│   ├── vscode/
│   │   ├── settings.json         # VSCode user settings
│   │   └── keybindings.json      # VSCode keybindings
│   └── starship.toml             # Starship prompt config
├── zshrc/
│   └── .zshrc                    # Zsh shell config
├── bashrc/
│   └── .bashrc                   # Bash shell config (fallback)
└── README.md                     # This file
```

## Supported Operating Systems

### macOS
Full-featured setup with:
- Homebrew package manager
- System defaults configuration (Dock, Finder, etc.)
- Touch ID for sudo
- Caps Lock remapped to Escape

Run: `bash install.sh macos` or `bash install.sh`

### Linux
Compatible with apt, dnf, and pacman-based distributions:
- Package installation via system package managers
- GTK theme and file manager configuration
- WSL/Wayland support
- Minimal GUI customization

Run: `bash install.sh linux`

### Windows (WSL2 or Git Bash)
Integrated Windows development environment:
- PowerShell profile configuration
- WSL2 settings (.wslconfig)
- Git integration
- Package management via Chocolatey/Scoop

Run: `bash install.sh windows`

### Remote Console / Headless SSH
For minimal remote systems with no GUI or package manager access:
- Pure shell configuration without system dependencies
- Utility scripts (sysload, tree, findlarge)
- SSH configuration template
- Minimal resource footprint

Run: `bash install.sh remote-console`

Features:
- Shell profiles and environment variables
- System info and monitoring functions
- Git configuration support
- No package installation required

### Remote Windows (SSH or WSL Access)
Configure Windows systems accessed remotely:
- Windows-specific shell aliases and functions
- Network and disk checking utilities
- OpenSSH Server configuration support
- Windows PATH inspection tools
- Service monitoring (WSL)

Run: `bash install.sh remote-windows`

Features:
- WSL interoperability functions
- PowerShell compatibility layer
- Windows system monitoring scripts
- SSH host configuration for Windows systems

## Configuration Files

### Shell Configuration (Zsh/Bash)

**Automatic fallback**: If zsh is not available, the install script automatically uses bash instead.

**Zsh** (`~/.zshrc`):
Core shell configuration with:
- Command aliases (eza, vim, etc.)
- Navigation functions (cx, fcd, f, fv)
- FZF integration for fuzzy searching
- Z.sh for directory jumping
- Zoxide as a modern cd replacement
- Starship prompt initialization
- Editor fallback chain (nvim → vim → vi)

**Bash** (`~/.bashrc`):
Fallback shell configuration with:
- Same aliases and functions as zsh
- Bash completion support
- Compatible navigation and FZF features
- Starship prompt (or simple git-aware fallback)
- Editor fallback chain (nvim → vim → vi → nano)

**Nano** (`~/.nanorc`):
Last-resort editor with vim-like keybindings:
- Ctrl+J/K for up/down (like j/k)
- Ctrl+A/E for home/end (like 0/$)
- Alt+u/r for undo/redo (like u/Ctrl+R)
- Ctrl+F/G for search/next (like /n)
- And more vim-familiar shortcuts

### Vim/Neovim Configuration
Both Vim 8.0+ and Neovim with:
- Proper swap, backup, and undo file management
- Cross-platform directory setup
- Window navigation keybindings
- Syntax highlighting
- Auto-formatting and cleanup
- Multi-version compatibility

**Neovim** (`~/.config/nvim/init.lua`):
- Modern Lua-based configuration
- Advanced features and automation

**Vim** (`~/.vimrc`):
- Traditional Vimscript configuration
- Compatible with Vim 8.0+

### VSCode Configuration

**Cross-platform settings sync** via dotfiles:
- **Settings** (`settings.json`): Editor preferences, extensions config, language settings
- **Keybindings** (`keybindings.json`): Custom keyboard shortcuts

The setup script automatically detects VSCode installation on:
- **macOS**: `~/Library/Application Support/Code/User`
- **Linux**: `~/.config/Code/User`
- **Windows**: `%APPDATA%/Code/User`
- **WSL**: `~/.vscode-server/data/Machine` or Windows path via WSL

**Note**: Extension sync is handled by VSCode's built-in Settings Sync feature (sign in with GitHub/Microsoft).

### Kitty Terminal (kitty.conf)
Terminal settings:
- FiraCode Nerd Font at 14pt
- GitHub Dark theme
- macOS-specific options
- Shell integration enabled

### Starship (starship.toml)
Custom prompt configuration with Git status, command duration, and language info.

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
`.zshrc` and `.bashrc` are lightweight loaders. Shared helpers live in `config/shell/`.

- `config/shell/common.sh` for shared zsh/bash functions and aliases
- `config/shell/zsh.sh` as a zsh loader for files in `config/shell/zsh.d/`
- `config/shell/bash.sh` for bash-only behavior

On macOS, Homebrew bash is preferred automatically (`/opt/homebrew/bin/bash` or `/usr/local/bin/bash`) and falls back to system bash when unavailable.

Changes take effect in new terminal sessions.

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
rm ~/.zshrc ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/starship.toml ~/.nanorc
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
