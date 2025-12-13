#!/bin/bash
# Remote console/SSH system defaults configuration
# For headless or SSH-only remote systems with minimal tooling
# Assumes: bash, basic POSIX utilities, no GUI, no package manager access
# Run this script to configure shell environment for consistency

set -e

echo "Configuring remote console/SSH environment..."

# Create directories for configuration
echo "Creating directories..."
mkdir -p ~/.config/zsh
mkdir -p ~/.local/bin

# Shell configuration - no sudo required, pure shell customization
echo "Setting up shell environment..."

# Check if zsh is available, fall back to bash
if command -v zsh &> /dev/null; then
    SHELL_CMD="zsh"
    SHELL_RC="$HOME/.zshrc"
else
    SHELL_CMD="bash"
    SHELL_RC="$HOME/.bashrc"
fi

# Create a minimal shell profile for remote systems if not already present
if [ ! -f "$HOME/.shell_profile_remote" ]; then
    cat > "$HOME/.shell_profile_remote" << 'EOF'
# Remote Console Shell Profile
# Minimal configuration for headless/SSH systems

# Colors for ls
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33;40:cd=1;33;40:su=1;32;40:sg=1;32;40:tw=1;32;40:ow=1;32;40'

# History settings
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# Useful aliases
alias ll='ls -lh'
alias la='ls -lha'
alias l='ls -lh'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias tree='find . -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"'

# Minimal prompt customization
if [ -z "$PS1_CUSTOM" ]; then
    if [ -n "$VIRTUAL_ENV" ]; then
        PS1="\[\033[1;34m\][\u@\h \W]\[\033[0m\] \$ "
    else
        PS1="\[\033[1;32m\][\u@\h \W]\[\033[0m\] \$ "
    fi
fi

# Functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# System information function
sysinfo() {
    echo "=== System Information ==="
    uname -a
    echo "Uptime: $(uptime)"
    echo "Disk usage:"
    df -h | head -n 2
}

# Safe copy function (copy to backup)
cpbak() {
    cp "$1" "$1.bak"
    echo "Backed up: $1 -> $1.bak"
}

EOF
    echo "✓ Remote shell profile created at ~/.shell_profile_remote"
fi

# Environment variables setup
echo "Setting up environment..."

# Create a minimal environment file
if [ ! -f "$HOME/.env_remote" ]; then
    cat > "$HOME/.env_remote" << 'EOF'
# Remote Console Environment Variables
export EDITOR=nano
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

# Starship prompt if available
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

EOF
    echo "✓ Remote environment file created at ~/.env_remote"
fi

# SSH configuration for convenience
echo "Setting up SSH convenience features..."
if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    echo "✓ SSH directory created"
fi

# Create SSH config template if not present
if [ ! -f "$HOME/.ssh/config" ]; then
    cat > "$HOME/.ssh/config" << 'EOF'
# SSH Configuration Template
# Add your remote hosts here for easy connection

# Host alias
#   HostName example.com
#   User username
#   IdentityFile ~/.ssh/id_rsa
#   Port 22
#   Compression yes
#   ServerAliveInterval 60
#   ServerAliveCountMax 10

# Example:
# Host remote-dev
#   HostName dev.example.com
#   User developer
#   IdentityFile ~/.ssh/id_ed25519

EOF
    chmod 600 "$HOME/.ssh/config"
    echo "✓ SSH config template created"
fi

# Create utility scripts for remote systems
echo "Creating utility scripts..."

# Script to quickly check system load
cat > "$HOME/.local/bin/sysload" << 'EOF'
#!/bin/bash
echo "=== System Load Information ==="
echo "Load Average: $(cat /proc/loadavg | cut -d' ' -f1-3)"
echo "CPU Cores: $(nproc 2>/dev/null || echo 'unknown')"
echo "Memory Usage:"
free -h 2>/dev/null | head -n 2 || echo "  (Memory info unavailable)"
echo "Disk Usage (root):"
df -h / | tail -n 1
EOF
chmod +x "$HOME/.local/bin/sysload"

# Script to display file tree
cat > "$HOME/.local/bin/tree" << 'EOF'
#!/bin/bash
find "$1" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
EOF
chmod +x "$HOME/.local/bin/tree"

# Script to find large files
cat > "$HOME/.local/bin/findlarge" << 'EOF'
#!/bin/bash
# Find files larger than 10MB
du -sh "$1"/* 2>/dev/null | sort -rh | head -20
EOF
chmod +x "$HOME/.local/bin/findlarge"

echo "✓ Utility scripts created in ~/.local/bin"

# GIT configuration for consistency
if command -v git &> /dev/null; then
    echo "Configuring Git..."
    if [ -z "$(git config --global user.name)" ]; then
        echo "Git configuration:"
        echo "  Run: git config --global user.name 'Your Name'"
        echo "  Run: git config --global user.email 'your.email@example.com'"
    else
        echo "Git already configured"
    fi
fi

# Optional: Attempt package installation if sudo access available
echo ""
echo "Checking for package manager access..."

if sudo -n true 2>/dev/null; then
    echo "✓ Sudo access detected without password"
    echo ""
    read -p "Would you like to install additional packages? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Attempting package installation..."
        
        if command -v apt &> /dev/null; then
            echo "Updating and installing packages via apt..."
            sudo apt update && sudo apt install -y kitty starship zsh curl wget git || true
            echo "✓ Packages installed (some may have failed if already installed)"
        elif command -v dnf &> /dev/null; then
            echo "Updating and installing packages via dnf..."
            sudo dnf install -y kitty starship zsh curl wget git || true
            echo "✓ Packages installed (some may have failed if already installed)"
        elif command -v pacman &> /dev/null; then
            echo "Updating and installing packages via pacman..."
            sudo pacman -Sy --noconfirm kitty starship zsh curl wget git || true
            echo "✓ Packages installed (some may have failed if already installed)"
        else
            echo "No supported package manager found"
        fi
    else
        echo "Skipping package installation"
    fi
elif sudo -n true 2>&1 | grep -q "password"; then
    echo "⚠ Sudo requires a password (would need interactive entry)"
    echo "Skipping automatic package installation"
else
    echo "⚠ No sudo access available"
    echo "Skipping package installation"
    echo ""
    echo "If you have sudo access, you can manually install packages:"
    echo "  sudo apt install kitty starship zsh curl wget git     # Debian/Ubuntu"
    echo "  sudo dnf install kitty starship zsh curl wget git     # Fedora"
    echo "  sudo pacman -S kitty starship zsh curl wget git       # Arch"
fi

echo ""
echo "Finished configuring remote console environment."
echo "Next steps:"
echo "1. Source the configuration: source ~/.shell_profile_remote"
echo "2. Add to your shell RC file (~/.bashrc or ~/.zshrc):"
echo "   source ~/.shell_profile_remote"
echo "   source ~/.env_remote"
echo ""
echo "Available utilities in ~/.local/bin:"
echo "  - sysload: Display system load information"
echo "  - tree: Display directory tree"
echo "  - findlarge: Find large files in a directory"
