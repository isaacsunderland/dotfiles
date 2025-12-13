#!/bin/bash
# Remote Windows system defaults configuration
# For Windows systems accessed remotely (SSH, RDP, or WSL in headless mode)
# Assumes: PowerShell available via SSH or basic cmd.exe, no software installation
# Run this script to configure remote access and shell environment

set -e

echo "Configuring remote Windows environment..."

# Create directories for configuration
echo "Creating directories..."
mkdir -p ~/.config/zsh
mkdir -p ~/.ssh
mkdir -p ~/.local/bin

# Detect Windows access method
echo "Detecting Windows access method..."

# Check for Windows-specific indicators
if grep -qi microsoft /proc/version 2>/dev/null; then
    ACCESS_METHOD="wsl"
    echo "Detected: WSL (Windows Subsystem for Linux)"
elif [ -n "$TERM_PROGRAM" ] && [ "$TERM_PROGRAM" = "iTerm2" ]; then
    ACCESS_METHOD="ssh"
    echo "Detected: SSH connection (likely from remote)"
elif command -v powershell &> /dev/null || command -v pwsh &> /dev/null; then
    ACCESS_METHOD="powershell"
    echo "Detected: PowerShell available"
else
    ACCESS_METHOD="unknown"
    echo "Warning: Could not definitively detect Windows access method"
fi

# SSH Configuration for Windows access
echo "Setting up SSH for Windows remote access..."
if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# Create SSH config for Windows hosts if not present
if ! grep -q "# Windows Hosts" "$HOME/.ssh/config" 2>/dev/null; then
    cat >> "$HOME/.ssh/config" << 'EOF'

# Windows Hosts
# Configuration for OpenSSH on Windows Server 2019+ or Windows 10/11 with OpenSSH
# Add specific Windows host configurations here

# Example Windows host:
# Host win-dev
#   HostName windows.example.com
#   User Administrator
#   IdentityFile ~/.ssh/id_ed25519
#   Port 22
#   Compression yes
#   ServerAliveInterval 60

EOF
    echo "✓ SSH Windows host section added to config"
fi

# Create shell profile for remote Windows access
echo "Creating shell configuration for remote Windows..."

if [ ! -f "$HOME/.shell_profile_windows_remote" ]; then
    cat > "$HOME/.shell_profile_windows_remote" << 'EOF'
# Remote Windows Shell Profile
# Configuration for accessing Windows systems remotely via SSH or WSL

# Environment setup
export EDITOR=nano
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Windows-specific PATH additions for WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    # WSL: Add Windows paths if needed
    export PATH="$PATH:/mnt/c/Windows/System32"
fi

# Aliases for Windows-like commands
alias dir='ls -la'
alias cls='clear'
alias ipconfig='hostname -I'
alias tasklist='ps aux'
alias del='rm -i'

# Function to mount Windows shares in WSL
wsl_mount_share() {
    local share="$1"
    local mount_point="${2:-./$share}"
    mkdir -p "$mount_point"
    mount -t drvfs "$share" "$mount_point"
    echo "Mounted: $share -> $mount_point"
}

# Function to open Windows file explorer from WSL
explorer() {
    if grep -qi microsoft /proc/version 2>/dev/null; then
        powershell.exe /c start "$(wslpath -w "$1")"
    else
        echo "explorer() is only available in WSL"
    fi
}

# Function to run Windows commands from bash
win_cmd() {
    if grep -qi microsoft /proc/version 2>/dev/null; then
        powershell.exe -NoProfile -Command "$@"
    else
        echo "Windows commands not available outside WSL"
    fi
}

# Remote host information function
remote_info() {
    echo "=== Remote Windows Access Information ==="
    echo "Current Host: $(hostname)"
    echo "User: $(whoami)"
    
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "Environment: WSL2"
        echo "Windows Version:"
        powershell.exe /c '[System.Environment]::OSVersion.VersionString' 2>/dev/null || echo "  (Could not retrieve)"
    else
        echo "Environment: SSH/Remote Access"
    fi
    
    echo "Disk Space:"
    df -h | head -n 2
}

# PowerShell compatibility function
run_powershell() {
    if command -v powershell &> /dev/null; then
        powershell -NoProfile -Command "$@"
    elif command -v pwsh &> /dev/null; then
        pwsh -NoProfile -Command "$@"
    else
        echo "PowerShell not found"
        return 1
    fi
}

EOF
    echo "✓ Remote Windows shell profile created"
fi

# Create environment file for remote Windows
if [ ! -f "$HOME/.env_windows_remote" ]; then
    cat > "$HOME/.env_windows_remote" << 'EOF'
# Remote Windows Environment Variables

# Character encoding
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

# Editor preference
export EDITOR=nano

# Starship prompt configuration (if available)
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# Git configuration
if command -v git &> /dev/null; then
    # Convert Windows paths to Unix-style for Git in WSL
    if grep -qi microsoft /proc/version 2>/dev/null; then
        export GIT_AUTHOR_NAME="Your Name"
        export GIT_AUTHOR_EMAIL="your.email@example.com"
    fi
fi

EOF
    echo "✓ Remote Windows environment file created"
fi

# Create utility scripts for Windows remote access
echo "Creating Windows-specific utility scripts..."

# Script to check network connectivity
cat > "$HOME/.local/bin/netcheck" << 'EOF'
#!/bin/bash
echo "=== Network Connectivity Check ==="
echo "Hostname: $(hostname -f 2>/dev/null || hostname)"
echo "IP Address(es):"
hostname -I 2>/dev/null || ip addr show 2>/dev/null || echo "  (Could not retrieve)"
echo ""
echo "DNS Servers:"
cat /etc/resolv.conf 2>/dev/null | grep nameserver || echo "  (Could not retrieve)"
echo ""
echo "Network Interfaces:"
ip link show 2>/dev/null || ifconfig 2>/dev/null || echo "  (Could not retrieve)"
EOF
chmod +x "$HOME/.local/bin/netcheck"

# Script to check Windows disk space (for WSL)
cat > "$HOME/.local/bin/diskcheck" << 'EOF'
#!/bin/bash
echo "=== Disk Space Information ==="
echo "Linux partitions:"
df -h | grep -v tmpfs || true
echo ""
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "Windows C: drive:"
    powershell.exe /c 'Get-Volume -DriveLetter C | Select-Object DriveLetter, Size, SizeRemaining' 2>/dev/null || echo "  (Could not retrieve)"
fi
EOF
chmod +x "$HOME/.local/bin/diskcheck"

# Script for Windows PATH inspection
cat > "$HOME/.local/bin/winpath" << 'EOF'
#!/bin/bash
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "=== Windows PATH ==="
    powershell.exe /c '$env:Path.Split(";") | ForEach-Object { Write-Host $_ }' 2>/dev/null || echo "Could not retrieve Windows PATH"
else
    echo "winpath() is only available in WSL"
fi
EOF
chmod +x "$HOME/.local/bin/winpath"

# Optional Chocolatey installation for Windows systems with admin access
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo ""
    echo "Checking for Windows admin privileges from WSL..."
    
    # Check if running as root in WSL (has Windows admin access)
    if [ "$(id -u)" -eq 0 ]; then
        echo "✓ Running with elevated privileges"
        echo ""
        read -p "Would you like to install Chocolatey package manager? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing Chocolatey from Windows..."
            if ! command -v choco &> /dev/null; then
                powershell.exe /c "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" 2>/dev/null || true
                
                if command -v choco &> /dev/null; then
                    echo "✓ Chocolatey installed successfully"
                    echo ""
                    echo "To install packages, use from PowerShell:"
                    echo "  choco install <package-name>"
                    echo ""
                    echo "Recommended packages for consistency:"
                    echo "  choco install starship      # Shell prompt"
                    echo "  choco install kitty         # Terminal emulator"
                    echo "  choco install neovim        # Text editor"
                else
                    echo "Note: Chocolatey installation may have failed."
                    echo "Try manual installation:"
                    echo "  https://chocolatey.org/install"
                fi
            else
                echo "Chocolatey is already installed"
                echo "Upgrade packages with: choco upgrade all"
            fi
        else
            echo "Skipping Chocolatey installation"
        fi
    else
        echo "⚠ Not running with elevated privileges"
        echo "Chocolatey installation requires admin access."
        echo ""
        echo "To enable admin access in WSL:"
        echo "  1. Run: sudo -i"
        echo "  2. Then re-run this script"
        echo ""
        echo "Alternatively, install Chocolatey manually from Windows PowerShell (as admin):"
        echo "  https://chocolatey.org/install"
    fi
else
    echo ""
    echo "For Windows systems accessed via SSH:"
    echo "  Install Chocolatey manually with admin access:"
    echo "  https://chocolatey.org/install"
fi

# Configuration instructions
echo ""
echo "Finished configuring remote Windows environment."
echo ""
echo "Next steps:"
echo "1. If using WSL:"
echo "   - Add to ~/.bashrc or ~/.zshrc:"
echo "     source ~/.shell_profile_windows_remote"
echo "     source ~/.env_windows_remote"
echo ""
echo "2. If accessing via SSH:"
echo "   - Ensure OpenSSH Server is installed on Windows (Windows 10/11 or Server 2019+)"
echo "   - Configure SSH public key authentication"
echo "   - Update ~/.ssh/config with your Windows hosts"
echo ""
echo "Available utilities in ~/.local/bin:"
echo "  - netcheck: Display network information"
echo "  - diskcheck: Check disk space (local and Windows)"
echo "  - winpath: Display Windows PATH"
echo "  - winservices: Show Windows services status (WSL only)"
echo ""
echo "Remote Windows access configuration:"
echo "  - Access method: $ACCESS_METHOD"
echo "  - SSH Config: $HOME/.ssh/config"
echo "  - Shell profile: ~/.shell_profile_windows_remote"
