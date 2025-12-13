#!/bin/bash
# Linux system defaults configuration
# Run this script to configure system-wide Linux settings for a consistent experience

set -e

echo "Configuring Linux system defaults..."

# Detect package manager
if command -v apt &> /dev/null; then
    PACKAGE_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PACKAGE_MANAGER="dnf"
elif command -v pacman &> /dev/null; then
    PACKAGE_MANAGER="pacman"
else
    echo "Warning: No supported package manager found (apt, dnf, pacman)"
    PACKAGE_MANAGER="none"
fi

# Create directories for configuration
echo "Creating directories..."
mkdir -p ~/.config/kitty
mkdir -p ~/.config/starship
mkdir -p ~/.config/zsh
mkdir -p ~/.config/dconf

# Set up sudo with passwordless for wheel group (optional, comment out if not desired)
# This is a Linux equivalent to Touch ID on macOS
echo "Configuring sudo settings..."

# Check if we're in sudoers
if sudo -n true 2>/dev/null; then
    echo "Already has sudo access without password"
else
    echo "Note: Consider adding your user to the sudoers NOPASSWD list for convenience"
    echo "Run: sudo visudo"
    echo "And add: %wheel ALL=(ALL) NOPASSWD: ALL"
fi

# GTK Theme settings (if available)
if command -v gsettings &> /dev/null; then
    echo "Configuring GTK settings..."
    # Dark mode
    gsettings set org.gnome.desktop.interface gtk-application-prefer-dark-style true || true
    
    # Font settings
    gsettings set org.gnome.desktop.interface font-name 'Sans 10' || true
    
    # Window title bar buttons
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' || true
    
    # Remap Caps Lock to Escape
    echo "Remapping Caps Lock to Escape..."
    gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']" || true
    echo "✓ Caps Lock remapped to Escape (GNOME)"
fi

# For non-GNOME systems, try setxkbmap
if command -v setxkbmap &> /dev/null && [ -z "$WAYLAND_DISPLAY" ]; then
    echo "Setting Caps Lock to Escape via X11..."
    setxkbmap -option caps:escape
    echo "✓ Caps Lock remapped to Escape (X11)"
    echo "  Add 'setxkbmap -option caps:escape' to your ~/.xinitrc or display manager config"
fi
fi

# X11/Wayland cursor settings
if [ -d ~/.config/gtk-3.0 ]; then
    echo "Configuring cursor settings..."
    mkdir -p ~/.config/gtk-3.0
    cat >> ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
EOF
fi

# File manager settings
if command -v dconf &> /dev/null; then
    echo "Configuring file manager..."
    # Show hidden files
    dconf write /org/gnome/nautilus/preferences/show-hidden-files true || true
    # Show full path in title bar
    dconf write /org/gnome/nautilus/preferences/always-use-location-entry true || true
fi

# Terminal settings
echo "Configuring terminal preferences..."
# Create default terminal profile if using GNOME Terminal
if command -v gnome-terminal &> /dev/null && command -v dconf &> /dev/null; then
    # You can set additional GNOME Terminal preferences here
    echo "GNOME Terminal detected"
fi

echo "Finished configuring Linux defaults."
echo "Note: Some changes may require a restart or logout to take effect."
echo ""
echo "For a consistent experience with your macOS setup:"
echo "1. Install the same packages via your package manager"
echo "2. Configure your window manager/desktop environment settings"
echo "3. Customize cursor and theme preferences as needed"
