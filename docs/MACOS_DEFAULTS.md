# macOS Defaults Configuration

This document describes all the macOS system settings configured by `macos-defaults.sh`.

## Spaces

| Setting | Value | Description |
|---------|-------|-------------|
| `com.apple.spaces spans-displays` | `false` | Spaces span displays independently (each display has its own spaces) |

## Dock

| Setting | Value | Description |
|---------|-------|-------------|
| `autohide` | `true` | Automatically hide the Dock when not in use |
| `mru-spaces` | `false` | Disable automatic rearranging of Spaces based on most recent use |
| `static-only` | `true` | Only show running applications in the Dock |
| `tilesize` | `24` | Set Dock icon size to 24 pixels |
| `show-recents` | `false` | Don't show recent applications in the Dock |
| `showhidden` | `true` | Make Dock icons of hidden applications translucent |
| `show-process-indicators` | `true` | Show indicator dots for open applications |
| `minimize-to-application` | `true` | Minimize windows into application icon |
| `magnification` | `true` | Enable Dock magnification on hover |
| `largesize` | `64` | Set magnified icon size to 64 pixels |

## Finder

| Setting | Value | Description |
|---------|-------|-------------|
| `AppleShowAllFiles` | `true` | Show hidden files in Finder |
| `ShowPathbar` | `true` | Show path bar at the bottom of Finder windows |
| `FXPreferredViewStyle` | `NLsv` | Use list view as default Finder view |
| `CreateDesktop` | `true` | Show icons on the desktop |
| `_FXShowPosixPathInTitle` | `true` | Show full POSIX path in Finder window title |

## Global Settings (NSGlobalDomain)

| Setting | Value | Description |
|---------|-------|-------------|
| `AppleShowAllExtensions` | `true` | Show all filename extensions |
| `NSWindowShouldDragOnGesture` | `true` | Enable window dragging with Ctrl+Cmd+click anywhere |
| `AppleShowAllFiles` | `true` | Show hidden files globally |
| `AppleFontSmoothing` | `2` | Enable subpixel font rendering (medium level) |
| `com.apple.trackpad.trackpadCornerClickBehavior` | `1` | Enable trackpad corner click behavior |
| `AppleShowScrollBars` | `Always` | Always show scroll bars |

## Trackpad

| Setting | Value | Description |
|---------|-------|-------------|
| `TrackpadCornerSecondaryClick` | `2` | Enable right-click in bottom-right corner |

*Applied to both built-in and Bluetooth trackpads.*

## Window Manager

| Setting | Value | Description |
|---------|-------|-------------|
| `EnableStandardClickToShowDesktop` | `false` | Disable click wallpaper to show desktop |
| `StandardHideDesktopIcons` | `true` | Hide desktop icons when clicking wallpaper |
| `StandardHideWidgets` | `true` | Hide widgets when clicking wallpaper |

## Screenshots

| Setting | Value | Description |
|---------|-------|-------------|
| `location` | `~/Pictures/screenshots` | Save screenshots to Pictures/screenshots folder |

## Menu Bar Clock

| Setting | Value | Description |
|---------|-------|-------------|
| `ShowAMPM` | `true` | Show AM/PM indicator |
| `ShowDayOfWeek` | `true` | Show day of week |

## Battery Menu

| Setting | Value | Description |
|---------|-------|-------------|
| `ShowPercent` | `YES` | Show battery percentage |
| `ShowTime` | `YES` | Show remaining time |

## LaunchServices

| Setting | Value | Description |
|---------|-------|-------------|
| `LSQuarantine` | `false` | Disable "Are you sure you want to open this application?" dialog |

## Screensaver

| Setting | Value | Description |
|---------|-------|-------------|
| `askForPassword` | `false` | Don't require password when waking from screensaver |
| `idleTime` | `3600` | Start screensaver after 1 hour of inactivity |

## Power Management (pmset)

| Setting | Value | Description |
|---------|-------|-------------|
| Battery: `displaysleep` | `30` | Turn off display after 30 minutes on battery |
| Power Adapter: `displaysleep` | `135` | Turn off display after 135 minutes on power adapter |

## Touch ID for sudo

Configures `/etc/pam.d/sudo_local` to enable Touch ID authentication for sudo commands.

## Docker Desktop

| Setting | Value | Description |
|---------|-------|-------------|
| `autoStart` | `true` | Start Docker Desktop automatically at login |

## Notes

- Some changes require a logout or restart to take effect
- The script requires `sudo` for power management and Touch ID configuration
- Run with `sh ./macos-defaults.sh` from the dotfiles directory
