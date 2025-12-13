# Quick Reference - Multi-OS Dotfiles

## Installation Commands

```bash
# Auto-detect and install
bash install.sh

# Specific OS installations
bash install.sh macos              # macOS with Homebrew
bash install.sh linux              # Linux (apt/dnf/pacman)
bash install.sh windows            # Windows (WSL2 or Git Bash)
bash install.sh remote-console     # Headless/SSH systems
bash install.sh remote-windows     # Windows via SSH
```

## What Gets Installed By OS

### macOS
- ✅ Homebrew + all packages from Brewfile
- ✅ macOS system defaults (Dock zoom, Finder settings, etc.)
- ✅ Touch ID for sudo
- ✅ Kitty terminal config
- ✅ Starship prompt config
- ✅ Zsh shell config
- ✅ Amethyst window manager

### Linux
- ✅ Packages via apt/dnf/pacman (kitty, starship, zsh, git, curl, wget)
- ✅ GTK theme and file manager settings
- ✅ Kitty terminal config
- ✅ Starship prompt config
- ✅ Zsh shell config
- ⚠️ GUI customization available but limited

### Windows
- ✅ PowerShell profile
- ✅ WSL2 configuration (.wslconfig)
- ✅ Kitty terminal config
- ✅ Starship prompt config
- ✅ Zsh shell config
- ⚠️ Manual package installation guidance (Chocolatey/Scoop)

### Remote Console (SSH/Headless)
- ✅ Shell profile (~/.shell_profile_remote)
- ✅ Environment configuration (~/.env_remote)
- ✅ Utility scripts (sysload, tree, findlarge)
- ✅ SSH configuration template
- ✅ Starship prompt (if available)
- ❌ No package installation (system limitation)

### Remote Windows (SSH/WSL)
- ✅ Shell profile (~/.shell_profile_windows_remote)
- ✅ Environment configuration (~/.env_windows_remote)
- ✅ Windows utility scripts (netcheck, diskcheck, winpath, winservices)
- ✅ SSH Windows host configuration
- ✅ WSL interop functions
- ❌ No package installation (system limitation)

## Post-Installation Steps

### All Systems
```bash
# Restart terminal
exec zsh

# Or manually source shell config
source ~/.zshrc
```

### Remote Console
```bash
# Add to ~/.bashrc or ~/.zshrc
source ~/.shell_profile_remote
source ~/.env_remote
```

### Remote Windows
```bash
# Add to ~/.bashrc or ~/.zshrc (WSL)
source ~/.shell_profile_windows_remote
source ~/.env_windows_remote

# For SSH: Update ~/.ssh/config with Windows hosts
```

## File Locations

### Configuration Files
- Shell: `~/.zshrc`
- Terminal: `~/.config/kitty/kitty.conf`
- Prompt: `~/.config/starship.toml`
- Window Manager: `~/.amethyst.yml` (macOS only)

### Remote System Files
- Shell Profile: `~/.shell_profile_*`
- Environment: `~/.env_*`
- Utilities: `~/.local/bin/`
- SSH Config: `~/.ssh/config`

## Utility Scripts

### Remote Console
- `sysload` - Display system load, CPU, memory, disk
- `tree` - Show directory tree
- `findlarge` - Find large files in a directory

### Remote Windows
- `netcheck` - Network connectivity and DNS info
- `diskcheck` - Disk space (Linux and Windows)
- `winpath` - Display Windows PATH (WSL only)
- `winservices` - Show Windows services (WSL only)

## Environment Variables

### All Systems
```bash
EDITOR=nano
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
TERM=xterm-256color
```

### Windows Specific
```bash
# WSL: Can access Windows system directories
# From bash: /mnt/c/Users/...
# From WSL: Can run PowerShell commands
```

## Troubleshooting

### "Command not found: starship"
- Install manually: Check platform-specific instructions
- Falls back to basic prompt if not available

### "Command not found: zsh"
- Use bash instead (auto-detected on remote systems)
- Edit your shell config (~/.bashrc instead of ~/.zshrc)

### "Remote console: sudo not available"
- This is expected on restricted remote systems
- Utility scripts don't require sudo

### "Windows: PowerShell profile not activating"
- Ensure PowerShell execution policy allows it:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

### "WSL: Can't access Windows files"
- Files are at: `/mnt/c/Users/YourUsername/`
- Mount shares with: `sudo mount -t drvfs D: /mnt/d`

## Uninstallation

### macOS
```bash
# Remove symlinks
rm ~/.zshrc ~/.config/kitty/kitty.conf ~/.config/starship.toml ~/.amethyst.yml

# Remove Homebrew packages (optional)
brew bundle cleanup --file=./Brewfile
```

### Linux/Windows/Remote
```bash
# Remove config symlinks
rm ~/.zshrc ~/.config/kitty/kitty.conf ~/.config/starship.toml

# Remove shell profiles (remote systems)
rm ~/.shell_profile_* ~/.env_* ~/.local/bin/*
```

## Quick OS Detection

```bash
# Check which OS you're on
uname -s                          # Returns: Darwin (macOS), Linux
grep -qi microsoft /proc/version  # True if WSL

# Check which OS was installed for
grep "Installing dotfiles for:" /var/log/install.log
```

## Documentation

- **Full Details**: See `MULTI_OS_SETUP.md`
- **macOS Specific**: See `macos-defaults.sh`
- **Linux Details**: See `linux-defaults.sh`
- **Windows Setup**: See `windows-defaults.sh`
- **Remote Console**: See `remote-console-defaults.sh`
- **Remote Windows**: See `remote-windows-defaults.sh`
