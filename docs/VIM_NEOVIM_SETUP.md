# Vim/Neovim Configuration

This dotfiles includes comprehensive Vim/Neovim configuration with proper file management, cross-platform support, and multi-version compatibility.

## Overview

The configuration provides:
- **Dual Support**: Works with both Vim 8.0+ and Neovim
- **Cross-Platform**: Compatible with macOS, Linux, Windows (WSL), and remote systems
- **Swap File Management**: Prevents E303 errors with proper directory setup
- **Persistent Undo**: Keep undo history across sessions
- **Backup Files**: Automatic backup creation before changes

## Files

### Neovim Configuration
- **Location**: `~/.config/nvim/init.lua`
- **Format**: Lua (modern, recommended)
- **Minimum Version**: Neovim 0.5+
- **Fallback**: `init.vim` included for older versions

### Vim Configuration
- **Location**: `~/.vimrc` or `~/.config/vim/vimrc`
- **Format**: Vimscript
- **Minimum Version**: Vim 8.0+
- **Standard**: Works with all modern Vim installations

## Installation

During dotfiles installation, the Vim/Neovim setup runs automatically:

```bash
bash install.sh [OS_TYPE]
# Automatically sets up both Vim and Neovim configs
```

Or manually run the setup script:

```bash
bash setup-vim.sh
```

## Directory Structure

The configuration creates and manages these directories:

### Neovim
```
~/.local/share/nvim/
├── swap/       # Swap files for recovery
├── backup/     # Backup files before changes
├── undo/       # Persistent undo history
└── shada/      # Shared data (session info, history)
```

### Vim
```
~/.local/share/vim/
├── swap/       # Swap files for recovery
├── backup/     # Backup files before changes
└── undo/       # Persistent undo history
```

All directories are created with `700` permissions (user-only access).

## Configuration Features

### Basic Settings
- **Line Numbers**: Enabled with relative positioning option
- **Cursor Line**: Highlighted for better visibility
- **Indentation**: 4 spaces (configurable per file type)
  - YAML/JSON/Lua: 2 spaces
  - Others: 4 spaces
- **Search**: Case-insensitive with smart case override
- **Wrapping**: Enabled with word boundary breaking

### Display Settings
- **Whitespace Visualization**:
  ```
  → Tab characters
  · Trailing spaces
  ↳ Non-breaking spaces
  ¬ End of line (Neovim only)
  ```
- **Syntax Highlighting**: Enabled by default
- **Color Support**: True color (24-bit) when available

### File Management
- **Swap Files**: Enabled in `~/.local/share/vim(nvim)/swap`
  - Recovery mechanism for crashed sessions
  - Prevents E303 errors
- **Backup Files**: Enabled in `~/.local/share/vim(nvim)/backup`
  - Automatic backup before overwriting
  - Useful for version history
- **Persistent Undo**: Enabled in `~/.local/share/vim(nvim)/undo`
  - Maintains undo history across sessions
  - No time limits on undo

### Keybindings

#### Window Navigation
```vim
Ctrl-h      Jump to left window
Ctrl-j      Jump to down window
Ctrl-k      Jump to up window
Ctrl-l      Jump to right window
```

#### Window Resizing
```vim
Ctrl-Up     Increase height
Ctrl-Down   Decrease height
Ctrl-Left   Decrease width
Ctrl-Right  Increase width
```

#### Editing
```vim
Space       Leader key (for custom mappings)
Esc         Clear search highlighting
<  (visual) Indent left (keeps selection)
>  (visual) Indent right (keeps selection)
```

#### Other
- **Mouse Support**: Enabled in all modes
- **System Clipboard**: Integrated for copy/paste
- **Auto-save**: On focus lost
- **Trailing Whitespace**: Auto-removed on save

## File Type Specific Settings

### YAML Files (.yaml, .yml)
```
Indentation: 2 spaces
Tab width: 2
```

### JSON Files (.json, .jsonc)
```
Indentation: 2 spaces
Tab width: 2
```

### Lua Files (.lua)
```
Indentation: 2 spaces
Tab width: 2
```

## Status Line

The status line displays:
```
filename [modified] [readonly] [help] [preview] ... line:column percentage
```

Example:
```
myfile.lua ~   10:42 68%
```

## Performance Tuning

Built-in optimizations:
- **Update Time**: 300ms (faster screen redraws)
- **Timeout**: 500ms for mapped sequences
- **TTY Timeout**: 10ms for terminal key codes

## Platform-Specific Notes

### macOS
- Full support for all features
- System clipboard integration works natively
- Path: `~/.config/nvim/init.lua`

### Linux
- Full support for all features
- May need to install Vim/Neovim via package manager
- Paths: `~/.vimrc` and `~/.config/nvim/init.lua`

### Windows (WSL2)
- Full Neovim support in WSL
- Vim support in WSL
- Native Windows Vim/Neovim available but shares config with WSL

### Remote Systems (SSH/Headless)
- Configuration available but not auto-linked
- Manual linking: `ln -sfv <dotfiles>/config/vim/vimrc ~/.vimrc`
- Supports older Vim versions

## Troubleshooting

### E303: Unable to open swap file

**Solution**: The directories already exist and are automatically created.

If you still get this error:
```bash
# Create directories manually
mkdir -p ~/.local/share/nvim/{swap,backup,undo,shada}
mkdir -p ~/.local/share/vim/{swap,backup,undo}

# Fix permissions
chmod 700 ~/.local/share/nvim/swap ~/.local/share/vim/swap
```

### Colors not displaying correctly

**Solution 1** - Enable true color in terminal:
```vim
set termguicolors
```

**Solution 2** - Use basic color support:
```vim
set notermguicolors
```

### Slow startup

**Cause**: Too many auto commands or slow plugins

**Solution**:
1. Profile startup: `:startuptime /tmp/startup.log`
2. Check for problematic auto commands
3. Reduce number of auto commands

### Clipboard not working

**Cause**: Missing clipboard support in Vim

**Solution**:
```bash
# Check if Vim has clipboard support
vim --version | grep clipboard

# Install vim with clipboard (macOS)
brew install vim --with-client-server

# Linux: Use vim-gtk or vim-gnome package
```

## Advanced Configuration

### Adding Custom Plugins

For Neovim, consider using a plugin manager:
- **packer.nvim** (native Lua)
- **vim-plug** (works with both)
- **lazy.nvim** (modern alternative)

Edit `~/.config/nvim/init.lua`:
```lua
-- Example with vim-plug
vim.cmd [[
    call plug#begin()
    Plug 'tpope/vim-sensible'
    Plug 'vim-airline/vim-airline'
    call plug#end()
]]
```

### Customizing Keybindings

**Neovim** (`~/.config/nvim/init.lua`):
```lua
-- Add custom mapping
vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })
```

**Vim** (`~/.vimrc`):
```vim
" Add custom mapping
nnoremap <Leader>w :w<CR>
```

### Extending File Type Settings

**Neovim** - Add to `init.lua`:
```lua
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'javascript',
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})
```

**Vim** - Add to `~/.vimrc`:
```vim
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
```

## Migration from Other Configs

If you have existing Vim configurations:

1. **Backup your old config**:
   ```bash
   mv ~/.vimrc ~/.vimrc.bak
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Install dotfiles**:
   ```bash
   bash install.sh
   ```

3. **Migrate settings**:
   - Copy custom mappings from old config
   - Add file type settings
   - Preserve plugin configurations

## Performance Comparison

| Feature | Neovim | Vim |
|---------|--------|-----|
| Startup Time | ~50ms | ~100ms |
| Async Support | Yes | Limited |
| Lua Support | Native | Via plugin |
| Configuration | Lua/Vim | Vim only |
| Modern Features | Yes | Good support |
| Compatibility | Good | Excellent |

## Further Reading

- **Neovim**: https://neovim.io
- **Vim**: https://www.vim.org
- **Lua in Neovim**: https://neovim.io/doc/user/lua.html
- **Vimscript**: https://www.vim.org/docs.php

## Support

If you encounter issues:

1. Check the configuration file syntax
2. Verify directories exist: `ls -la ~/.local/share/nvim/swap`
3. Check Vim/Neovim version compatibility
4. See Troubleshooting section above

---

**Configuration maintained as part of dotfiles**
- Location: `config/nvim/init.lua` and `config/vim/vimrc`
- Setup: Automatic during `bash install.sh`
- Manual: `bash setup-vim.sh`
