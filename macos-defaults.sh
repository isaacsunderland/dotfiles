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
defaults write com.apple.dock wvous-bl-corner -int 13
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

# Screenshot settings
defaults write com.apple.screencapture location ~/Pictures/screenshots
mkdir -p ~/Pictures/screenshots

# LaunchServices
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Screensaver
defaults write com.apple.screensaver askForPassword -bool false

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

if [ -n "$KEYBOARD_ID" ]; then
    # Set Caps Lock (key code 0) to Escape (key code 30064771113)
    defaults -currentHost write -g com.apple.keyboard.modifiermapping.$KEYBOARD_ID -array '<dict><key>HIDKeyboardModifierMappingDst</key><integer>30064771113</integer><key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer></dict>'
    echo "✓ Caps Lock remapped to Escape"
else
    echo "⚠️  Could not detect keyboard ID for Caps Lock remapping"
    echo "   You can remap manually: System Settings → Keyboard → Modifier Keys"
fi

echo "Finished configuring macOS defaults."
echo "Note: Some changes may require a restart or logout to take effect."
echo "Touch ID has been enabled for sudo commands."
