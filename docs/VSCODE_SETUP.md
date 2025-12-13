# VSCode Configuration Setup

This dotfiles repository includes cross-platform VSCode configuration sync via symlinks.

## What's Included

- **settings.json**: All your VSCode editor preferences, extension settings, language configurations
- **keybindings.json**: Custom keyboard shortcuts

## Automatic Setup

The `setup-vscode.sh` script automatically:

1. Detects your VSCode installation location
2. Backs up existing configurations (`.backup` suffix)
3. Creates symlinks to the dotfiles versions
4. Works across macOS, Linux, Windows, and WSL

### Run Setup

```bash
cd ~/dotfiles
bash setup-vscode.sh
```

Or via main install script:

```bash
bash install.sh
```

## Platform Detection

The script automatically detects VSCode paths:

| Platform | VSCode User Directory |
|----------|----------------------|
| **macOS** | `~/Library/Application Support/Code/User` |
| **Linux** | `~/.config/Code/User` |
| **Windows** | `%APPDATA%/Code/User` |
| **WSL** | `~/.vscode-server/data/Machine` or Windows path |

## Configuration Details

### Settings (settings.json)

Current configuration includes:

**Editor**:
- Minimap disabled
- Line numbers on
- Auto-save after delay
- Vim mode keybindings

**Git**:
- Smart commit enabled
- Auto-fetch enabled
- Sync confirmation disabled

**Terminal**:
- Image support enabled
- GPU acceleration on
- Docker Desktop link support

**Markdown**:
- Preview enhanced theme (Monokai)
- Mermaid diagram support
- Table of contents support
- Copilot disabled in markdown

**File Associations**:
- Docker Compose YAML formatting
- GitHub Actions YAML formatting
- JSON formatting

**Diff Editor**:
- Side-by-side view
- Move detection enabled

### Keybindings (keybindings.json)

Custom shortcuts:

| Key | Command | Context |
|-----|---------|---------|
| `Ctrl+Alt+0` | Go to Definition | When editor has definition provider |
| `F12` | (Disabled) | Overridden by above |
| `Ctrl+C` | Check Task List | Markdown (disabled) |

## Extension Sync

**Important**: Extensions are NOT synced via dotfiles.

### Use VSCode Settings Sync

1. Sign in to VSCode with GitHub or Microsoft account
2. Open Command Palette (`Cmd/Ctrl+Shift+P`)
3. Search: "Settings Sync: Turn On"
4. Select what to sync:
   - ✓ Settings
   - ✓ Keyboard Shortcuts
   - ✓ **Extensions** (important!)
   - ✓ UI State
   - ✓ Snippets

### Why Not Sync Extensions via Dotfiles?

Extensions include platform-specific binaries and are better managed by VSCode's built-in sync. The Settings Sync feature:
- Installs correct platform versions
- Handles extension dependencies
- Updates automatically
- Works with private/preview extensions

## Updating Configuration

### Method 1: Edit in VSCode (Recommended)

1. Open VSCode settings UI or edit `settings.json` directly
2. Changes are automatically written to the symlinked file
3. Commit changes from `~/dotfiles/config/vscode/`

### Method 2: Edit Dotfiles Directly

```bash
cd ~/dotfiles/config/vscode
vim settings.json  # or keybindings.json
```

Changes are immediately reflected in VSCode (may need window reload).

## Restoring Original Settings

If you want to revert to VSCode defaults:

```bash
# Remove symlinks
rm ~/Library/Application\ Support/Code/User/settings.json
rm ~/Library/Application\ Support/Code/User/keybindings.json

# Restore backups (if they exist)
mv ~/Library/Application\ Support/Code/User/settings.json.backup \
   ~/Library/Application\ Support/Code/User/settings.json
mv ~/Library/Application\ Support/Code/User/keybindings.json.backup \
   ~/Library/Application\ Support/Code/User/keybindings.json
```

## Multi-Machine Workflow

1. **Primary machine**: Make configuration changes in VSCode
2. **Commit changes**: `cd ~/dotfiles && git add config/vscode && git commit -m "Update VSCode settings"`
3. **Push**: `git push`
4. **Other machines**: `cd ~/dotfiles && git pull && bash setup-vscode.sh`

## Troubleshooting

### VSCode Not Found

```
⚠️ VSCode user directory not found: <path>
VSCode may not be installed, or the path is different on this system.
```

**Solution**: Install VSCode or manually set `VSCODE_USER_DIR`:

```bash
export VSCODE_USER_DIR="/path/to/your/vscode/User"
bash setup-vscode.sh
```

### Settings Not Syncing

Check if symlinks are correct:

```bash
# macOS
ls -la ~/Library/Application\ Support/Code/User/settings.json

# Should show: settings.json -> /path/to/dotfiles/config/vscode/settings.json
```

If broken, re-run setup:

```bash
bash ~/dotfiles/setup-vscode.sh
```

### Settings Sync Conflicts

If using both dotfiles and VSCode Settings Sync:

1. **Recommended**: Use dotfiles for settings/keybindings, Settings Sync for extensions only
2. In Settings Sync options, disable "Settings" and "Keybindings"
3. Keep "Extensions" enabled in Settings Sync

## Current Extensions (Reference)

These are installed via Settings Sync, not dotfiles:

- Docker
- ESLint/Prettier
- GitLens
- GitHub Copilot
- Markdown Preview Enhanced
- Vim extension
- YAML
- Draw.io Integration
- Remote Development (SSH, WSL, Containers)

## Related Documentation

- [README.md](README.md) - Main dotfiles documentation
- [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md) - Multi-platform installation guide
- [EDITOR_FALLBACK.md](EDITOR_FALLBACK.md) - Vim/Neovim fallback configuration
