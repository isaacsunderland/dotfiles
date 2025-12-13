# Editor Fallback Configuration

## Overview

The dotfiles now implement an intelligent editor fallback chain across all platforms. This ensures you always have an editor available, regardless of which editors are installed on the system.

## Fallback Chain

The editor selection follows this priority order:

```
neovim → vim → vi → nano (remote only)
```

### 1. Neovim (Primary)
- **Command**: `nvim`
- **Priority**: Highest (preferred)
- **Aliases created**: `vim` → `nvim`, `vi` → `nvim`
- **Environment**: `EDITOR=nvim`, `VISUAL=nvim`

### 2. Vim (Fallback)
- **Command**: `vim`
- **Priority**: Second
- **Alias created**: `vi` → `vim`
- **Environment**: `EDITOR=vim`, `VISUAL=vim`

### 3. Vi (Fallback)
- **Command**: `vi`
- **Priority**: Third
- **No aliases**: Uses system vi directly
- **Environment**: `EDITOR=vi`, `VISUAL=vi`

### 4. Nano (Remote Only)
- **Command**: `nano`
- **Priority**: Lowest (remote systems only)
- **Environment**: `EDITOR=nano`, `VISUAL=nano`
- **Configuration**: `~/.nanorc` with vim-like keybindings
- **Note**: Only used on remote systems when vi is not available
- **Vim-like bindings**: Ctrl+J/K (j/k), Ctrl+A/E (0/$), Alt+u/r (u/Ctrl+R), etc.

## Implementation by Platform

### macOS / Linux (Full Installation)

**Location**: `zshrc/.zshrc`

```bash
# Editor fallback chain: neovim -> vim -> vi
if command -v nvim &> /dev/null; then
    alias vim="nvim"
    alias vi="nvim"
    export EDITOR="nvim"
    export VISUAL="nvim"
elif command -v vim &> /dev/null; then
    alias vi="vim"
    export EDITOR="vim"
    export VISUAL="vim"
else
    export EDITOR="vi"
    export VISUAL="vi"
fi
```

**What happens**:
- If Neovim installed: All editor commands use `nvim`
- If only Vim installed: `vi` uses `vim`, `vim` stays as `vim`
- If neither: Falls back to system `vi`

### Remote Console / Headless Systems

**Location**: `~/.shell_profile_remote` and `~/.env_remote`

**Shell Profile**:
```bash
# Editor fallback: neovim -> vim -> vi
if command -v nvim &> /dev/null; then
    alias vim='nvim'
    alias vi='nvim'
elif command -v vim &> /dev/null; then
    alias vi='vim'
fi
```

**Environment**:
```bash
# Editor fallback chain: neovim -> vim -> vi -> nano
if command -v nvim &> /dev/null; then
    export EDITOR=nvim
    export VISUAL=nvim
elif command -v vim &> /dev/null; then
    export EDITOR=vim
    export VISUAL=vim
elif command -v vi &> /dev/null; then
    export EDITOR=vi
    export VISUAL=vi
else
    export EDITOR=nano
    export VISUAL=nano
fi
```

**What happens**:
- Checks for Neovim first
- Falls back to Vim
- Falls back to Vi
- Last resort: Nano (for minimal systems)

### Remote Windows / WSL

**Location**: `~/.shell_profile_windows_remote` and `~/.env_windows_remote`

Same fallback logic as Remote Console with nano as final fallback.

## Environment Variables

The fallback system sets these environment variables:

### `EDITOR`
- **Purpose**: Default text editor for command-line programs
- **Used by**: `git commit`, `crontab -e`, `sudoedit`, etc.
- **Value**: First available from: nvim, vim, vi, nano

### `VISUAL`
- **Purpose**: Visual (full-screen) editor
- **Used by**: Some programs that distinguish between line/full-screen editors
- **Value**: Same as `EDITOR`

## Command Behavior Examples

### Scenario 1: Neovim Installed
```bash
$ which nvim
/usr/local/bin/nvim

$ vim file.txt        # Opens in neovim
$ vi file.txt         # Opens in neovim
$ nvim file.txt       # Opens in neovim
$ git commit          # Uses neovim (via $EDITOR)
```

### Scenario 2: Only Vim Installed
```bash
$ which vim
/usr/bin/vim

$ vim file.txt        # Opens in vim
$ vi file.txt         # Opens in vim (aliased)
$ nvim file.txt       # Command not found
$ git commit          # Uses vim (via $EDITOR)
```

### Scenario 3: Only Vi Available (Minimal System)
```bash
$ which vi
/usr/bin/vi

$ vim file.txt        # Command not found (or uses vi if aliased)
$ vi file.txt         # Opens in vi
$ nvim file.txt       # Command not found
$ git commit          # Uses vi (via $EDITOR)
```

### Scenario 4: Remote System with Only Nano
```bash
$ which nano
/usr/bin/nano

$ vim file.txt        # Command not found
$ vi file.txt         # Command not found
$ nano file.txt       # Opens in nano
$ git commit          # Uses nano (via $EDITOR)
```

## Configuration Files Used

Each editor in the fallback chain has its configuration:

| Editor | Config File | Location | Auto-linked? |
|--------|-------------|----------|--------------|
| Neovim | init.lua | ~/.config/nvim/init.lua | ✓ Yes |
| Neovim | init.vim | ~/.config/nvim/init.vim | ✓ Yes (fallback) |
| Vim | vimrc | ~/.vimrc | ✓ Yes |
| Vim | vimrc | ~/.config/vim/vimrc | ✓ Yes (XDG) |
| Vi | N/A | System default | ✗ No config |
| Nano | .nanorc | ~/.nanorc | ✓ Yes (vim-like bindings) |

## Function Fallback

Navigation functions also use the fallback:

### `fv()` Function
**Before** (hardcoded):
```bash
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }
```

**After** (dynamic):
```bash
fv() { 
    local file="$(find . -type f -not -path '*/.*' | fzf)"
    if [ -n "$file" ]; then
        $EDITOR "$file"
    fi
}
```

Now `fv` uses whatever editor is configured in `$EDITOR`.

## Testing the Fallback

### Check Current Editor
```bash
# See which editor is configured
echo $EDITOR
echo $VISUAL

# See what commands are aliased
alias | grep -E 'vim|vi'

# Test which editor opens
type vim
type vi
type nvim
```

### Verify Configuration
```bash
# Check if Neovim is available
command -v nvim && echo "Neovim: ✓" || echo "Neovim: ✗"

# Check if Vim is available
command -v vim && echo "Vim: ✓" || echo "Vim: ✗"

# Check if Vi is available
command -v vi && echo "Vi: ✓" || echo "Vi: ✗"

# Show current priority
if command -v nvim &> /dev/null; then
    echo "Using: Neovim (highest priority)"
elif command -v vim &> /dev/null; then
    echo "Using: Vim (fallback)"
elif command -v vi &> /dev/null; then
    echo "Using: Vi (fallback)"
else
    echo "Using: Nano or none (last resort)"
fi
```

## Benefits

### 1. **Consistency**
- Same commands work across all systems
- Aliases ensure `vim` and `vi` always work

### 2. **Flexibility**
- Automatically adapts to available editors
- No manual configuration needed

### 3. **Portability**
- Works on minimal systems
- Works on full development systems
- Seamless across platforms

### 4. **No Surprises**
- Always have an editor available
- Predictable behavior
- Environment variables always set

## Customization

### Override the Fallback

If you want to force a specific editor, add to your shell RC:

```bash
# Force Vim even if Neovim is installed
export EDITOR=vim
export VISUAL=vim
alias nvim='vim'  # Redirect nvim to vim
```

### Add More Fallbacks

Edit your shell configuration to add more options:

```bash
if command -v emacs &> /dev/null; then
    export EDITOR=emacs
elif command -v nvim &> /dev/null; then
    export EDITOR=nvim
# ... etc
fi
```

## Troubleshooting

### Problem: `vim` Command Not Found

**Cause**: Neither Neovim nor Vim installed

**Solution**:
```bash
# Install Neovim (recommended)
brew install neovim        # macOS
sudo apt install neovim    # Ubuntu/Debian
sudo dnf install neovim    # Fedora

# Or install Vim
brew install vim           # macOS
sudo apt install vim       # Ubuntu/Debian
```

### Problem: Wrong Editor Opens

**Cause**: Environment variables not loaded

**Solution**:
```bash
# Reload shell configuration
source ~/.zshrc            # For zsh
source ~/.bashrc           # For bash

# Or restart terminal
exec zsh
```

### Problem: Aliases Don't Work

**Cause**: Non-interactive shell or aliases not loaded

**Solution**:
```bash
# For remote systems, source the profile
source ~/.shell_profile_remote

# Check if aliases are defined
alias | grep vim
```

## Summary

The editor fallback system ensures:
- ✅ Always have an editor available
- ✅ Prefer modern editors (Neovim)
- ✅ Fall back to reliable editors (Vim, Vi)
- ✅ Work on minimal systems (nano)
- ✅ Consistent commands across platforms
- ✅ Automatic environment variable setup
- ✅ No manual configuration needed

All editor commands now intelligently adapt to what's installed on your system!
