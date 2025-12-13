# E303 Swap File Error Fix

## Problem

Neovim shows error: `E303: Unable to open swap file for "<file>", recovery impossible`

## Root Causes

1. **Wrong directory location**: Neovim 0.11+ changed default from `~/.local/share/nvim/` to `~/.local/state/nvim/`
2. **Permission issues**: Swap directory owned by root instead of user
3. **Missing directories**: Swap directories don't exist

## Solution

The dotfiles now handle all three issues automatically:

### 1. Directory Configuration

Updated `config/nvim/init.lua` to use both paths with fallbacks:

```lua
-- Set directories for swap, backup, and undo
vim.opt.directory = {
    vim.fn.expand('~/.local/state/nvim/swap') .. '//',    -- Neovim 0.11+
    vim.fn.expand('~/.local/share/nvim/swap') .. '//',    -- Older versions
    '.',  -- Fallback to current directory if unavailable
}
```

### 2. Directory Creation

Updated `setup-vim.sh` to create both directory structures:

```bash
# Neovim directories (both share and state for compatibility)
mkdir -p ~/.local/share/nvim/{swap,backup,undo,shada}
mkdir -p ~/.local/state/nvim/{swap,backup,undo,shada}
chmod 700 ~/.local/share/nvim/{swap,backup,undo,shada}
chmod 700 ~/.local/state/nvim/{swap,backup,undo,shada}
```

### 3. Permission Fix

Added automatic ownership fix:

```bash
# Fix ownership if directories exist but are owned by root
if [ -d ~/.local/state/nvim/swap ] && [ ! -w ~/.local/state/nvim/swap ]; then
    echo "  Fixing ownership of ~/.local/state/nvim/swap (requires sudo)..."
    sudo chown -R $USER ~/.local/state/nvim/swap
    sudo chmod 700 ~/.local/state/nvim/swap
fi
```

## Manual Fix (If Needed)

If you still see the error, run these commands:

```bash
# Fix ownership
sudo chown -R $USER ~/.local/state/nvim/swap
sudo chmod 700 ~/.local/state/nvim/swap

# Or recreate directories
rm -rf ~/.local/state/nvim/swap
mkdir -p ~/.local/state/nvim/{swap,backup,undo}
chmod 700 ~/.local/state/nvim/{swap,backup,undo}
```

## Verification

Check which directory Neovim is using:

```bash
nvim --headless -c "echo &directory" -c "qa" 2>&1
```

Should output: `/Users/<you>/.local/state/nvim/swap//`

Check permissions:

```bash
ls -la ~/.local/state/nvim/
```

All directories should be:
- Owner: your user (not root)
- Permissions: `drwx------` (700)

## How It Works

The `//` suffix in the directory path tells Vim/Neovim to use the full file path when creating swap files, which prevents naming collisions when editing files with the same name from different directories.

Example:
- Editing `/home/user/project1/file.txt` creates swap: `%home%user%project1%file.txt.swp`
- Editing `/home/user/project2/file.txt` creates swap: `%home%user%project2%file.txt.swp`

Without `//`, both would try to use `file.txt.swp` and conflict.

## Version Compatibility

This configuration works with:
- ✓ Neovim 0.11.x (uses `~/.local/state/nvim/`)
- ✓ Neovim 0.10.x and older (uses `~/.local/share/nvim/`)
- ✓ Vim 8.0+ (uses `~/.local/share/vim/`)

The fallback chain ensures swap files work even if the primary directory is unavailable.
