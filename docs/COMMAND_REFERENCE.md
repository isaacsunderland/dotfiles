# Dotfiles - Complete Command Reference

## Installation

### Basic Installation (Auto-Detect OS)
```bash
cd ~/dotfiles
bash install.sh
```

### macOS Installation
```bash
bash install.sh macos
```
Installs: Homebrew, all packages, system defaults, Touch ID for sudo, window manager

### Linux Installation
```bash
bash install.sh linux
```
Installs: Packages via apt/dnf/pacman, GTK settings, file manager config

### Windows Installation (WSL2 or Git Bash)
```bash
bash install.sh windows
```
Installs: PowerShell profile, WSL config, terminal settings

### Remote Console/SSH Installation
```bash
bash install.sh remote-console
```
Installs: Shell profiles, utility scripts, SSH templates (no packages)

### Remote Windows Installation
```bash
bash install.sh remote-windows
```
Installs: Windows shell profiles, utilities, SSH Windows config

## Post-Installation

### Activate Shell Configuration
```bash
# Restart terminal or
exec zsh

# Or manually source
source ~/.zshrc
```

### Remote Systems - Activate Profiles
```bash
# Add to your shell RC file (~/.bashrc or ~/.zshrc)
source ~/.shell_profile_remote
source ~/.env_remote

# For remote Windows
source ~/.shell_profile_windows_remote
source ~/.env_windows_remote
```

## Configuration Management

### Update Shell Configuration
```bash
# Edit your shell config
nano ~/.zshrc           # All systems
nano ~/.bashrc          # As fallback

# Or on remote systems
nano ~/.shell_profile_remote
nano ~/.env_remote
```

### Update Terminal Configuration
```bash
# Kitty terminal
nano ~/.config/kitty/kitty.conf

# Then reload: Cmd+Ctrl+, (or restart)
```

### Update Shell Prompt
```bash
# Starship prompt
nano ~/.config/starship.toml

# Takes effect in new shell
```

### Update macOS Defaults
```bash
nano macos-defaults.sh
bash macos-defaults.sh
```

### Update System Packages
```bash
# macOS
brew upgrade

# Linux
sudo apt upgrade      # Ubuntu/Debian
sudo dnf upgrade      # Fedora
sudo pacman -Syu      # Arch Linux
```

## Utility Scripts

### Remote Console - System Monitoring
```bash
~/.local/bin/sysload     # CPU, memory, disk info
~/.local/bin/tree        # Directory tree view
~/.local/bin/findlarge   # Find large files
```

### Remote Windows - System Tools
```bash
~/.local/bin/netcheck    # Network and DNS info
~/.local/bin/diskcheck   # Disk usage
~/.local/bin/winpath     # Windows PATH (WSL)
~/.local/bin/winservices # Windows services (WSL)
```

## File Management

### View Configuration Files
```bash
# Shell configuration
cat ~/.zshrc

# Terminal configuration
cat ~/.config/kitty/kitty.conf

# Prompt configuration
cat ~/.config/starship.toml

# Window manager (macOS)
cat ~/.amethyst.yml

# Remote system profiles
cat ~/.shell_profile_remote
cat ~/.env_remote
```

### Create Config Backup
```bash
cp ~/.zshrc ~/.zshrc.bak
cp ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.bak
```

## System Information

### Check Current Setup
```bash
# Which shell are you using?
echo $SHELL

# Which OS detected?
uname -s

# Are you in WSL?
grep -qi microsoft /proc/version && echo "WSL" || echo "Native"

# Check Starship
starship --version

# Check Kitty
kitty --version
```

## Uninstallation

### Remove Configuration Files
```bash
# Shell
rm ~/.zshrc

# Terminal
rm ~/.config/kitty/kitty.conf

# Prompt
rm ~/.config/starship.toml

# Window manager (macOS)
rm ~/.amethyst.yml

# Remote profiles
rm ~/.shell_profile_remote ~/.env_remote
rm ~/.shell_profile_windows_remote ~/.env_windows_remote
```

### Remove Utility Scripts (Remote)
```bash
rm -rf ~/.local/bin/*
```

### Remove Packages (Optional)

**macOS:**
```bash
brew bundle cleanup --file=./Brewfile
```

**Linux:**
```bash
sudo apt remove kitty starship zsh  # Ubuntu/Debian
sudo dnf remove kitty starship zsh  # Fedora
sudo pacman -R kitty starship zsh   # Arch
```

## Troubleshooting Commands

### Check Installation Logs
```bash
# Was installation successful?
echo "Check the output above for any errors"

# Re-run installation for current OS
bash install.sh
```

### Verify Symlinks
```bash
# Check if config files are linked
ls -la ~/.zshrc
ls -la ~/.config/kitty/kitty.conf
ls -la ~/.config/starship.toml

# Should show: -> /path/to/dotfiles/...
```

### Test Shell Configuration
```bash
# Verify zsh loads correctly
zsh -ic 'echo "Zsh works!"'

# Verify bash loads correctly
bash -ic 'echo "Bash works!"'
```

### Test Utilities
```bash
# Test utility script (remote)
bash ~/.local/bin/sysload

# Make executable if needed
chmod +x ~/.local/bin/*
```

### Fix Missing Commands

**Starship not found:**
```bash
# macOS
brew install starship

# Linux
apt install starship      # or dnf/pacman
```

**Kitty not found:**
```bash
# macOS
brew install kitty

# Linux
apt install kitty         # or dnf/pacman
```

## Advanced Usage

### Run on Different OS Than Current
```bash
# Force installation for specific OS
# (Useful if running on macOS but configuring for Linux)
bash install.sh linux
```

### Partial Installation
Edit the appropriate defaults script and comment out sections you don't want:
```bash
nano macos-defaults.sh
# Comment out any defaults you don't want
bash macos-defaults.sh
```

### Create Custom Alias
Add to your shell configuration:
```bash
# ~/.zshrc
alias myalias='command here'
```

### Add Custom Function
Add to your shell configuration:
```bash
# ~/.zshrc
myfunction() {
    echo "Function body here"
}
```

## Documentation Files

- **README.md** - Overview and quick start
- **QUICK_REFERENCE.md** - Quick lookup guide
- **MULTI_OS_SETUP.md** - Detailed implementation docs
- **IMPLEMENTATION_SUMMARY.md** - What was added and changed
- **This file** - Complete command reference

## Platform-Specific Notes

### macOS
- Touch ID enabled for sudo in macos-defaults.sh
- Amethyst window manager auto-linked
- Dock zoom effect included
- Requires Xcode Command Line Tools for some packages

### Linux
- Package manager auto-detected (apt/dnf/pacman)
- Requires sudo for package installation
- GTK settings apply to GNOME environments
- Cursor size customizable in settings

### Windows
- WSL2 config at $USERPROFILE\.wslconfig
- PowerShell profile at $USERPROFILE\Documents\PowerShell\profile.ps1
- Windows PATH accessible from WSL via /mnt/c/
- OpenSSH required for SSH server access

### Remote Console
- Works with any bash/zsh implementation
- No package installation required
- Utility scripts use only POSIX utilities
- Perfect for minimal/restricted environments

### Remote Windows
- SSH requires OpenSSH Server (Win10 1809+ or Server 2019+)
- WSL functions only work from WSL terminal
- Windows services require elevated privileges
- Network utilities work on any Windows SSH connection

## Tips & Tricks

### Speed Up Shell Startup
```bash
# Benchmark shell startup
time zsh -ic 'echo "loaded"'

# Remove slow plugins from ~/.zshrc if needed
```

### Create Desktop Shortcut to Terminal Config
```bash
# macOS - Open Kitty with your config
/Applications/Kitty.app --config-file ~/.config/kitty/kitty.conf
```

### Check Config Syntax
```bash
# Validate TOML syntax for Starship
cat ~/.config/starship.toml | grep -v '^#' | grep -v '^$'
```

### Keep Dotfiles Updated
```bash
cd ~/dotfiles
git pull
bash install.sh

# Or for specific OS
bash install.sh macos
```

---

**Need help?** Check the README.md or MULTI_OS_SETUP.md for detailed information.
