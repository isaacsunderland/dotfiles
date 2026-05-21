#!/bin/bash
# macOS system defaults configuration
# Run this script to configure system-wide macOS settings

set -e

echo "Configuring macOS system defaults..."

# Spaces
defaults write com.apple.spaces spans-displays -bool false

# Dock settings
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock tilesize -int 24
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64

# Finder settings
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "NLsv"
defaults write com.apple.finder CreateDesktop -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Global settings
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true
defaults write NSGlobalDomain AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleFontSmoothing -int 2
defaults write NSGlobalDomain "com.apple.trackpad.trackpadCornerClickBehavior" -int 1
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Trackpad settings
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2

# Window Manager settings
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true
defaults write com.apple.WindowManager StandardHideWidgets -bool true

# Menu bar clock settings
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true

# Screenshot settings
defaults write com.apple.screencapture location ~/Pictures/screenshots
mkdir -p ~/Pictures/screenshots

# Battery menu - show both percentage and time remaining
defaults write com.apple.menuextra.battery ShowPercent YES
defaults write com.apple.menuextra.battery ShowTime YES

# LaunchServices
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Screensaver
defaults write com.apple.screensaver askForPassword -bool false
defaults -currentHost write com.apple.screensaver idleTime -int 3600  # Start screen saver after 1 hour of inactivity

# Display sleep settings (using pmset)
sudo pmset -b displaysleep 30  # Turn off display on battery after 30 minutes
sudo pmset -c displaysleep 135   # Turn off display on power adapter after 135 minutes

# Touch ID for sudo
echo "Configuring Touch ID for sudo..."
sudo tee /etc/pam.d/sudo_local > /dev/null << 'EOF'
# sudo_local: local config file for sudo PAM configuration
# This file enables Touch ID authentication for sudo commands
auth       sufficient     pam_tid.so
EOF

# Docker Desktop autostart
echo "Configuring Docker Desktop to start at login..."
defaults write com.docker.docker autoStart -bool true
echo "✓ Docker Desktop will start automatically on login"

# Remap Caps Lock to ESC
echo "Remapping Caps Lock to Escape..."
# Get the ID of the built-in keyboard
KEYBOARD_ID=$(ioreg -r -n IOHIDKeyboard -d 1 | grep -E '(VendorID|ProductID)' | awk 'NR==1{v=$NF} NR==2{print v"-"$NF}')



echo "Finished configuring macOS defaults."
echo "Note: Some changes may require a restart or logout to take effect."
echo "Touch ID has been enabled for sudo commands."

# VSCode custom icon persistence
echo "Setting up VSCode custom icon persistence..."
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

# Link icon assets to ~/.config/vscode/icon/
mkdir -p ~/.config/vscode/icon
if [ -f "$DOTFILES_DIR/config/vscode/icon/vscode-iqgeo-green.icns" ]; then
    ln -sfv "$DOTFILES_DIR/config/vscode/icon/vscode-iqgeo-green.icns" ~/.config/vscode/icon/
    ln -sfv "$DOTFILES_DIR/config/vscode/icon/vscode-iqgeo-green-1024.png" ~/.config/vscode/icon/
fi

# Install LaunchAgent for icon persistence (runs at login + watches for VSCode updates)
mkdir -p ~/Library/LaunchAgents
PLIST_SRC="$DOTFILES_DIR/macos/com.iqgeo.vscode-icon.persist.plist"
PLIST_DST="$HOME/Library/LaunchAgents/com.iqgeo.vscode-icon.persist.plist"
if [ -f "$PLIST_SRC" ]; then
    sed "s|__HOME__|$HOME|g" "$PLIST_SRC" > "$PLIST_DST"
    launchctl unload "$PLIST_DST" 2>/dev/null || true
    launchctl load "$PLIST_DST"
    echo "✓ VSCode icon LaunchAgent installed and loaded"
fi

# Apply the icon now
if [ -x "$DOTFILES_DIR/bin/apply-vscode-iqgeo-icon.sh" ]; then
    bash "$DOTFILES_DIR/bin/apply-vscode-iqgeo-icon.sh" && echo "✓ VSCode custom icon applied"
fi
