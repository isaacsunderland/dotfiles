# Dotfiles Documentation Index

Complete documentation for this cross-platform dotfiles repository.

## 📖 Start Here

- **[../README.md](../README.md)** - Main overview and installation instructions

## 🚀 Setup Guides

### Platform-Specific
- **[MULTI_OS_SETUP.md](MULTI_OS_SETUP.md)** - Complete guide for all 5 platforms
  - macOS (Homebrew-based)
  - Linux (apt/dnf/pacman)
  - Windows (WSL2, Git Bash)
  - Remote Console (Headless/SSH)
  - Remote Windows (SSH/WSL access)

- **[PACKAGE_MANAGER_SETUP.md](PACKAGE_MANAGER_SETUP.md)** - Optional package managers
  - Chocolatey (Windows)
  - Admin/sudo detection
  - Interactive installation

### Component-Specific
- **[VIM_NEOVIM_SETUP.md](VIM_NEOVIM_SETUP.md)** - Vim & Neovim configuration
  - Lua config (Neovim 0.5+)
  - Vimscript config (Vim 8.0+)
  - Cross-platform compatibility
  - Swap/backup/undo directories

- **[VSCODE_SETUP.md](VSCODE_SETUP.md)** - VSCode settings sync
  - Settings.json
  - Keybindings.json
  - Cross-platform paths
  - Extension sync via Settings Sync

- **[EDITOR_FALLBACK.md](EDITOR_FALLBACK.md)** - Editor fallback chain
  - neovim → vim → vi → nano
  - Automatic detection
  - Environment variables ($EDITOR, $VISUAL)
  - Nano with vim-like bindings

- **[NANO_SETUP.md](NANO_SETUP.md)** - Nano editor with vim-like keybindings
  - Last-resort editor for minimal systems
  - Vim-familiar shortcuts (Ctrl+J/K, Ctrl+A/E, Alt+u/r, etc.)
  - Quick reference card
  - Feature comparison with vim

- **[SHELL_FALLBACK.md](SHELL_FALLBACK.md)** - Shell fallback system
  - zsh → bash → sh
  - Configuration parity
  - Automatic linking

## 🔧 Troubleshooting

- **[SWAP_FILE_FIX.md](SWAP_FILE_FIX.md)** - Fix Neovim E303 errors
  - Directory location changes (0.11+)
  - Permission fixes
  - Manual recovery steps

## 📋 Reference

- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Essential commands cheat sheet
- **[COMMAND_REFERENCE.md](COMMAND_REFERENCE.md)** - Complete command reference
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Technical details

## 🎯 Quick Links by Task

### Installation
```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
bash install.sh                 # Auto-detect
# or specify:
bash install.sh macos          # macOS
bash install.sh linux          # Linux
bash install.sh windows        # Windows
bash install.sh remote-console # Remote headless
bash install.sh remote-windows # Remote Windows
```

See: [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md)

### Configure Editors
```bash
bash setup-vim.sh              # Setup Vim/Neovim
bash setup-vscode.sh           # Setup VSCode
```

See: [VIM_NEOVIM_SETUP.md](VIM_NEOVIM_SETUP.md), [VSCODE_SETUP.md](VSCODE_SETUP.md)

### Check Fallbacks
```bash
echo $EDITOR                   # Current editor
echo $SHELL                    # Current shell
which nvim vim vi nano zsh bash
```

See: [EDITOR_FALLBACK.md](EDITOR_FALLBACK.md), [SHELL_FALLBACK.md](SHELL_FALLBACK.md)

### Troubleshoot Vim/Neovim
```bash
ls -la ~/.local/state/nvim/swap/
nvim --version
bash ~/dotfiles/setup-vim.sh
```

See: [SWAP_FILE_FIX.md](SWAP_FILE_FIX.md)

## 📁 Repository Structure

```
dotfiles/
├── README.md                     # Main documentation
├── docs/                         # All documentation (you are here)
│   ├── INDEX.md                  # This file
│   ├── MULTI_OS_SETUP.md         # Platform guides
│   ├── VIM_NEOVIM_SETUP.md       # Editor config
│   ├── VSCODE_SETUP.md           # VSCode sync
│   ├── EDITOR_FALLBACK.md        # Editor fallbacks
│   ├── SHELL_FALLBACK.md         # Shell fallbacks
│   ├── SWAP_FILE_FIX.md          # Troubleshooting
│   ├── QUICK_REFERENCE.md        # Quick commands
│   ├── COMMAND_REFERENCE.md      # Complete commands
│   ├── PACKAGE_MANAGER_SETUP.md  # Package managers
│   └── IMPLEMENTATION_SUMMARY.md # Technical details
│
├── install.sh                    # Main installer
├── setup-vim.sh                  # Vim/Neovim setup
├── setup-vscode.sh               # VSCode setup
│
├── macos-defaults.sh             # macOS system config
├── linux-defaults.sh             # Linux system config
├── windows-defaults.sh           # Windows system config
├── remote-console-defaults.sh    # Remote headless config
├── remote-windows-defaults.sh    # Remote Windows config
│
├── Brewfile                      # Homebrew packages
│
├── config/                       # Configuration files
│   ├── nvim/init.lua             # Neovim (Lua)
│   ├── vim/vimrc                 # Vim (Vimscript)
│   ├── nano/.nanorc              # Nano (vim-like bindings)
│   ├── vscode/
│   │   ├── settings.json         # VSCode settings
│   │   └── keybindings.json      # VSCode keybindings
│   ├── kitty/kitty.conf          # Terminal
│   └── starship.toml             # Prompt
│
├── zshrc/.zshrc                  # Zsh config
├── bashrc/.bashrc                # Bash config
└── amethyst/.amethyst.yml        # macOS window manager
```

## 🎨 Key Features

### Intelligent Fallbacks
- **Shells**: zsh → bash → sh (automatic)
- **Editors**: neovim → vim → vi → nano (automatic)
- **Package Managers**: Homebrew → apt → dnf → pacman → Chocolatey

### Cross-Platform
Works on macOS, Linux, Windows (WSL/Git Bash), and remote systems.

### Unified Configuration
- Same aliases and functions across all shells
- Consistent editor experience with fallbacks
- VSCode settings synced via dotfiles
- Vim-like bindings even in nano (last resort)

## 📖 Documentation for Different User Types

### New Users
1. [../README.md](../README.md) - Start here
2. [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md) - Platform-specific guide
3. [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Essential commands

### Power Users
1. [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md) - All commands
2. [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - How it works
3. Component-specific guides (VIM, VSCODE, etc.)

### Troubleshooters
1. [SWAP_FILE_FIX.md](SWAP_FILE_FIX.md) - Vim/Neovim issues
2. [EDITOR_FALLBACK.md](EDITOR_FALLBACK.md) - Editor detection
3. [SHELL_FALLBACK.md](SHELL_FALLBACK.md) - Shell issues

## 🔍 Find Documentation by Topic

### Editors
- Vim/Neovim: [VIM_NEOVIM_SETUP.md](VIM_NEOVIM_SETUP.md)
- VSCode: [VSCODE_SETUP.md](VSCODE_SETUP.md)
- Nano: [NANO_SETUP.md](NANO_SETUP.md) - vim-like keybindings
- Fallback chain: [EDITOR_FALLBACK.md](EDITOR_FALLBACK.md)

### Shells
- Zsh/Bash: [SHELL_FALLBACK.md](SHELL_FALLBACK.md)
- Configuration: `zshrc/.zshrc`, `bashrc/.bashrc`

### Platforms
- All platforms: [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md)
- Package managers: [PACKAGE_MANAGER_SETUP.md](PACKAGE_MANAGER_SETUP.md)

### Common Tasks
- Quick commands: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- All commands: [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md)
- Customization: Edit files in `config/`, `zshrc/`, `bashrc/`

## 🤝 Contributing

When adding features:
1. Update relevant documentation
2. Add entry to this INDEX.md
3. Update main [../README.md](../README.md) if major
4. Test on multiple platforms

## ❓ Need Help?

1. Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for common commands
2. Read platform guide in [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md)
3. Check troubleshooting docs (SWAP_FILE_FIX.md, etc.)
4. Open an issue on GitHub
