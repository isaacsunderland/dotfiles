# Documentation Index

Welcome to your multi-OS dotfiles! Use this index to find the information you need.

## 🚀 Getting Started (Start Here!)

### For First-Time Users
1. Read: [README.md](README.md) - Project overview and quick start
2. Choose your platform below
3. Run: `bash install.sh [OS_TYPE]`

### Quick Reference
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Cheat sheet with essential commands

---

## 📚 Platform-Specific Guides

### macOS Users
**What to Read:**
- [README.md](README.md) - Overview (works exactly as before)
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Commands for macOS
- [macos-defaults.sh](macos-defaults.sh) - What system settings are configured

**Command:**
```bash
bash install.sh macos
```

**New in This Version:**
- Touch ID for sudo
- Dock icon zoom effect

---

### Linux Users
**What to Read:**
- [README.md](README.md) - Overview and supported distros
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Commands for Linux
- [linux-defaults.sh](linux-defaults.sh) - What settings are configured
- [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md#2-linux) - Detailed Linux setup

**Command:**
```bash
bash install.sh linux
```

**Supported Distributions:**
- Ubuntu/Debian (apt)
- Fedora/RHEL (dnf)
- Arch Linux (pacman)

---

### Windows Users (WSL2 or Git Bash)
**What to Read:**
- [README.md](README.md) - Overview
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Commands for Windows
- [windows-defaults.sh](windows-defaults.sh) - What's configured
- [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md#3-windows-wsl2git-bash) - Detailed setup

**Command:**
```bash
bash install.sh windows
```

**What Gets Set Up:**
- PowerShell profile
- WSL2 configuration
- Terminal settings

---

### Remote Systems (SSH/Headless)
**What to Read:**
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md#remote-console) - Quick start
- [remote-console-defaults.sh](remote-console-defaults.sh) - What's configured
- [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md#4-remote-console--headless-ssh) - Detailed setup
- [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md) - Utility commands

**Command:**
```bash
bash install.sh remote-console
```

**Perfect For:**
- Minimal systems with no package manager
- SSH-only access
- Docker containers
- Headless servers

**Includes:**
- Utility scripts: sysload, tree, findlarge
- SSH configuration template
- System monitoring functions

---

### Remote Windows (SSH Access)
**What to Read:**
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md#remote-windows) - Quick start
- [remote-windows-defaults.sh](remote-windows-defaults.sh) - What's configured
- [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md#5-remote-windows-sshwsl-access) - Detailed setup
- [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md) - Utility commands

**Command:**
```bash
bash install.sh remote-windows
```

**Perfect For:**
- Windows Server via SSH
- WSL with Windows host integration
- Remote system administration

**Includes:**
- Windows utility scripts: netcheck, diskcheck, winpath, winservices
- SSH Windows host templates
- WSL interoperability functions

---

## 🔍 Looking for Specific Information?

### Installation & Setup
- **Quick Install**: [README.md](README.md) (Quick Start section)
- **Detailed Setup**: [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md)
- **Commands**: [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md)

### Configuration Details
- **macOS Settings**: [macos-defaults.sh](macos-defaults.sh)
- **Linux Settings**: [linux-defaults.sh](linux-defaults.sh)
- **Windows Settings**: [windows-defaults.sh](windows-defaults.sh)
- **Remote Settings**: [remote-console-defaults.sh](remote-console-defaults.sh) & [remote-windows-defaults.sh](remote-windows-defaults.sh)

### What Changed?
- **What Was Added**: [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)
- **Feature Comparison**: [MULTI_OS_SETUP.md#support-matrix](MULTI_OS_SETUP.md) (Support Matrix section)

### Troubleshooting
- **Common Issues**: [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md#troubleshooting-commands)
- **Per-Platform Help**: See [QUICK_REFERENCE.md](QUICK_REFERENCE.md#troubleshooting)

### Shell & Terminal
- **Shell Configuration**: [README.md](README.md#zsh-zshrc)
- **Terminal Config**: [README.md](README.md#kitty-terminal-kittytconf)
- **Prompt Setup**: [README.md](README.md#starship-starshiptoml)

---

## 📖 Complete File Guide

### Main Installation Script
- **[install.sh](install.sh)** - Universal installer for all platforms
  - Auto-detects OS
  - Handles package installation per platform
  - Applies OS-specific defaults
  - Usage: `bash install.sh [OS_TYPE]`

### OS-Specific Configuration Scripts
- **[macos-defaults.sh](macos-defaults.sh)** - macOS system settings
- **[linux-defaults.sh](linux-defaults.sh)** - Linux system settings
- **[windows-defaults.sh](windows-defaults.sh)** - Windows/WSL settings
- **[remote-console-defaults.sh](remote-console-defaults.sh)** - Remote headless settings
- **[remote-windows-defaults.sh](remote-windows-defaults.sh)** - Remote Windows settings

### Configuration Files
- **[config/kitty/kitty.conf](config/kitty/kitty.conf)** - Terminal emulator config
- **[config/starship.toml](config/starship.toml)** - Shell prompt config
- **[zshrc/.zshrc](zshrc/.zshrc)** - Shell configuration
- **[amethyst/.amethyst.yml](amethyst/.amethyst.yml)** - Window manager (macOS)

### Documentation Files
- **[README.md](README.md)** - Project overview and quick start
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick lookup guide
- **[MULTI_OS_SETUP.md](MULTI_OS_SETUP.md)** - Comprehensive implementation details
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - What was added/changed
- **[COMMAND_REFERENCE.md](COMMAND_REFERENCE.md)** - Full command reference
- **[INDEX.md](INDEX.md)** - This file

### Package Definition
- **[Brewfile](Brewfile)** - Homebrew packages for macOS

---

## 💡 Quick Links

### Common Tasks

**Install on my current system:**
```bash
bash install.sh
```

**Install for a specific OS:**
```bash
bash install.sh macos
bash install.sh linux
bash install.sh windows
bash install.sh remote-console
bash install.sh remote-windows
```

**Update shell configuration:**
```bash
nano ~/.zshrc
source ~/.zshrc
```

**Update system defaults (macOS):**
```bash
nano macos-defaults.sh
bash macos-defaults.sh
```

**Check what's installed:**
```bash
echo $SHELL
starship --version
kitty --version
```

**See all available commands:**
- Read [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md)

---

## 🎯 Which Document Should I Read?

| Your Situation | Read This |
|---|---|
| I'm new to dotfiles | [README.md](README.md) |
| I need quick answers | [QUICK_REFERENCE.md](QUICK_REFERENCE.md) |
| I want detailed info | [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md) |
| I want all commands | [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md) |
| I want to know what changed | [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) |
| I need platform-specific help | See Platform-Specific Guides (above) |
| I'm troubleshooting | [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md#troubleshooting-commands) |

---

## ✨ What Makes This Special?

- ✅ **One Script, Five Platforms** - Universal installer with platform detection
- ✅ **Remote System Support** - Works on minimal systems with no package manager
- ✅ **No Breaking Changes** - Existing macOS setups continue to work
- ✅ **Consistent Experience** - Same shell config across all platforms
- ✅ **Well Documented** - Comprehensive guides for every situation

---

## 🚀 Next Steps

1. **Choose your platform** above
2. **Run installation**: `bash install.sh [OS_TYPE]`
3. **Restart terminal** or run: `exec zsh`
4. **Customize as needed** by editing config files
5. **Refer back** to this documentation as needed

---

**Questions?** Check the [README.md](README.md) or [COMMAND_REFERENCE.md](COMMAND_REFERENCE.md) for answers.

**Ready to install?** Start with: `bash install.sh`
