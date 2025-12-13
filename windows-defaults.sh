#!/bin/bash
# Windows system defaults configuration (for WSL2 or Git Bash)
# Run this script to configure system-wide Windows settings for a consistent experience

set -e

echo "Configuring Windows system defaults..."

# Detect if running on WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "Detected WSL2 environment"
    IS_WSL=true
else
    echo "Running on Windows (Git Bash or similar)"
    IS_WSL=false
fi

# Create directories for configuration
echo "Creating directories..."
mkdir -p ~/.config/kitty
mkdir -p ~/.config/starship
mkdir -p ~/.config/zsh
mkdir -p ~/Documents/PowerShell

# Windows Terminal Configuration
if [ -d "$APPDATA/Microsoft/Windows Terminal" ]; then
    echo "Windows Terminal detected"
    echo "Consider configuring Windows Terminal settings manually:"
    echo "  - Settings location: $APPDATA\\Microsoft\\Windows Terminal\\settings.json"
    echo "  - Copy your preferred theme and color scheme settings"
fi

# PowerShell Profile Setup (for consistency with zsh on macOS/Linux)
PROFILE_PATH="$USERPROFILE/Documents/PowerShell/profile.ps1"
if [ ! -f "$PROFILE_PATH" ]; then
    echo "Creating PowerShell profile..."
    mkdir -p "$USERPROFILE/Documents/PowerShell"
    cat > "$PROFILE_PATH" << 'EOF'
# PowerShell Profile
# Add custom functions and aliases here for consistency across platforms

# Enable PSReadLine enhancements
if (Get-Module PSReadLine) {
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineOption -BellStyle None
}

# Aliases for consistency with Unix-like systems
Set-Alias -Name ll -Value Get-ChildItem -Force
Set-Alias -Name la -Value Get-ChildItem -Force
Set-Alias -Name clear -Value Clear-Host

# Starship prompt configuration
$STARSHIP = (Get-Command starship -ErrorAction SilentlyContinue).Source
if ($null -ne $STARSHIP) {
    Invoke-Expression (&starship init powershell)
}
EOF
    echo "✓ PowerShell profile created"
fi

# Environment setup
echo "Setting up environment variables..."

# Create a consistent .wslconfig for WSL2 if applicable
if [ "$IS_WSL" = true ]; then
    echo "Configuring WSL2 settings..."
    WSL_CONFIG="$USERPROFILE/.wslconfig"
    if [ ! -f "$WSL_CONFIG" ]; then
        cat > "$WSL_CONFIG" << 'EOF'
[interop]
enabled=true
appendWindowsPath=true

[wsl2]
memory=4GB
processors=4
swap=2GB
EOF
        echo "✓ WSL2 config created at $WSL_CONFIG"
    fi
fi

# Sudo equivalent configuration (for WSL)
if [ "$IS_WSL" = true ]; then
    echo "Setting up sudoers for WSL..."
    # WSL can use sudo with Touch ID-like biometric support in Windows Hello
    # This is a placeholder for WSL-specific improvements
fi

# Chocolatey Package Manager Setup (optional if admin)
echo ""
echo "Checking for admin privileges..."

# Function to check if running with admin privileges
check_admin() {
    if command -v powershell &> /dev/null; then
        powershell -NoProfile -Command "[Security.Principal.WindowsIdentity]::GetCurrent() | Select-Object -ExpandProperty Owner" 2>/dev/null | grep -q "BUILTIN\\\\Administrators" && return 0 || return 1
    fi
    return 1
}

# Alternative admin check for WSL
check_wsl_admin() {
    [ "$(id -u)" -eq 0 ] && return 0 || return 1
}

HAS_ADMIN=false
if [ "$IS_WSL" = true ]; then
    if check_wsl_admin; then
        HAS_ADMIN=true
        echo "✓ Running with elevated privileges in WSL"
    fi
else
    if check_admin; then
        HAS_ADMIN=true
        echo "✓ Running with administrator privileges"
    fi
fi

# Install Chocolatey if admin and not already installed
if [ "$HAS_ADMIN" = true ]; then
    echo ""
    read -p "Would you like to install Chocolatey package manager? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing Chocolatey..."
        if ! command -v choco &> /dev/null; then
            if command -v powershell &> /dev/null; then
                powershell -NoProfile -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" 2>/dev/null || true
                
                if command -v choco &> /dev/null; then
                    echo "✓ Chocolatey installed successfully"
                    echo ""
                    echo "To install packages, use:"
                    echo "  choco install <package-name>"
                    echo ""
                    echo "Recommended packages for consistency with your setup:"
                    echo "  choco install starship      # Shell prompt"
                    echo "  choco install kitty         # Terminal emulator"
                    echo "  choco install neovim        # Text editor"
                    echo "  choco install fzf           # Fuzzy finder"
                    echo "  choco install git           # Version control"
                else
                    echo "Note: Chocolatey installation may have failed. Try manual installation:"
                    echo "  https://chocolatey.org/install"
                fi
            fi
        else
            echo "Chocolatey is already installed"
            echo "Upgrade existing packages with: choco upgrade all"
        fi
    else
        echo "Skipping Chocolatey installation"
    fi
else
    echo "⚠ Not running with administrator privileges"
    echo "Chocolatey installation requires admin access."
    echo ""
    echo "To enable admin access:"
    if [ "$IS_WSL" = true ]; then
        echo "  1. Run: sudo -i (in WSL)"
        echo "  2. Then re-run this script"
    else
        echo "  1. Right-click on your terminal and select 'Run as administrator'"
        echo "  2. Then re-run this script"
    fi
    echo ""
    echo "Alternatively, install Chocolatey manually:"
    echo "  https://chocolatey.org/install"
fi
echo "Note: Some changes may require a restart to take effect."
echo ""
echo "For a consistent experience with your macOS setup:"
echo "1. Install packages using Chocolatey or Scoop"
echo "2. Configure Windows Terminal settings for visual consistency"
echo "3. Review and customize the PowerShell profile"
echo "4. If using WSL2, ensure the .wslconfig file suits your system resources"
