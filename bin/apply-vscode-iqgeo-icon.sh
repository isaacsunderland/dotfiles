#!/usr/bin/env bash
set -uo pipefail

CUSTOM_ICON="$HOME/.config/vscode/icon/vscode-iqgeo-green.icns"
CUSTOM_PNG="$HOME/.config/vscode/icon/vscode-iqgeo-green-1024.png"
BACKUP_DIR="$HOME/.config/vscode/icon/backups"

if [[ ! -f "$CUSTOM_ICON" ]]; then
  echo "Custom icon not found: $CUSTOM_ICON" >&2
  exit 1
fi

shopt -s nullglob
apps=(
  "/Applications/Visual Studio Code.app"
  /opt/homebrew/Caskroom/visual-studio-code/*/Visual\ Studio\ Code.app
)

mkdir -p "$BACKUP_DIR"

changed=false

for app_bundle in "${apps[@]}"; do
  [[ -d "$app_bundle" ]] || continue
  app_icon="$app_bundle/Contents/Resources/Code.icns"
  [[ -f "$app_icon" ]] || continue

  app_key="$(printf '%s' "$app_bundle" | shasum -a 256 | awk '{print $1}')"
  orig_icon="$BACKUP_DIR/vscode-original-${app_key}.icns"

  if [[ ! -f "$orig_icon" ]]; then
    cp "$app_icon" "$orig_icon"
  fi

  current_hash="$(shasum -a 256 "$app_icon" | awk '{print $1}')"
  target_hash="$(shasum -a 256 "$CUSTOM_ICON" | awk '{print $1}')"
  if [[ "$current_hash" != "$target_hash" ]]; then
    cp "$CUSTOM_ICON" "$app_icon"
    changed=true
    echo "Replaced .icns in: $app_bundle"
  fi

  # Set a Finder-level custom icon to defeat stale Dock/Finder icon caches.
  # Use fileicon if available (more reliable from LaunchAgent context),
  # otherwise fall back to Rez/DeRez/SetFile.
  if command -v fileicon >/dev/null 2>&1 && [[ -f "$CUSTOM_PNG" ]]; then
    if fileicon set "$app_bundle" "$CUSTOM_PNG" 2>/dev/null; then
      changed=true
      echo "Set Finder custom icon via fileicon: $app_bundle"
    fi
  elif command -v Rez >/dev/null 2>&1 && command -v DeRez >/dev/null 2>&1 && command -v SetFile >/dev/null 2>&1 && [[ -f "$CUSTOM_PNG" ]]; then
    custom_icon_file="${app_bundle}/Icon"$'\r'
    tmp_png="$(mktemp /tmp/vscode-icon-src.XXXXXX.png)"
    tmp_rsrc="$(mktemp /tmp/vscode-icon-rsrc.XXXXXX)"
    cp "$CUSTOM_PNG" "$tmp_png"
    if sips -i "$tmp_png" >/dev/null 2>&1 \
       && DeRez -only icns "$tmp_png" > "$tmp_rsrc" 2>/dev/null \
       && rm -f "$custom_icon_file" \
       && Rez -append "$tmp_rsrc" -o "$custom_icon_file" 2>/dev/null \
       && SetFile -a C "$app_bundle" 2>/dev/null; then
      changed=true
      echo "Set Finder custom icon via Rez: $app_bundle"
    else
      echo "Warning: Rez/SetFile failed (permission denied from LaunchAgent is expected)" >&2
    fi
    rm -f "$tmp_png" "$tmp_rsrc"
  fi
done

# Flush icon caches so macOS picks up the new icon immediately.
if [[ "$changed" == true ]]; then
  # Invalidate the app bundle modification time to bust LaunchServices cache
  touch "/Applications/Visual Studio Code.app" 2>/dev/null || true

  # Reset LaunchServices database to clear icon cache
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -f "/Applications/Visual Studio Code.app" 2>/dev/null || true

  # Restart Dock to refresh icons (also refreshes Finder sidebar)
  killall Dock 2>/dev/null || true

  echo "Icon caches flushed."
fi
