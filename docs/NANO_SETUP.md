# Nano Configuration with Vim-like Keybindings

For systems where nano is the only available editor, this dotfiles repository provides a `.nanorc` configuration with vim-like keybindings to ease the transition.

## Installation

Automatic via install script:
```bash
bash install.sh remote-console   # Includes nano setup
# or manually:
bash setup-nano.sh
```

## Vim-like Keybindings

While nano doesn't support true vim modes, we've mapped familiar shortcuts:

### Navigation

| Nano Binding | Vim Equivalent | Description |
|--------------|----------------|-------------|
| `Ctrl+J` | `j` | Down one line |
| `Ctrl+K` | `k` | Up one line |
| `Ctrl+H` | `h` | Left one character |
| `Ctrl+L` | `l` | Right one character |
| `Alt+b` | `b` | Previous word |
| `Alt+w` / `Alt+e` | `w` / `e` | Next word |
| `Ctrl+A` | `0` | Beginning of line |
| `Ctrl+E` | `$` | End of line |
| `Alt+0` | `gg` | First line |
| `Alt+$` | `G` | Last line |

### Editing

| Nano Binding | Vim Equivalent | Description |
|--------------|----------------|-------------|
| `Alt+u` | `u` | Undo |
| `Alt+r` | `Ctrl+R` | Redo |
| `Ctrl+D` | `x` | Delete character under cursor |
| `Alt+d` | `dw` | Delete word |
| `Ctrl+U` | `dG` | Delete to end of file |

### Copy/Paste

| Nano Binding | Vim Equivalent | Description |
|--------------|----------------|-------------|
| `Alt+v` | `v` | Start selection (mark) |
| `Alt+y` | `y` | Copy (yank) |
| `Alt+p` | `p` | Paste |
| `Ctrl+T` | `d` | Cut (delete to buffer) |

### Search and Replace

| Nano Binding | Vim Equivalent | Description |
|--------------|----------------|-------------|
| `Ctrl+F` | `/` | Search |
| `Ctrl+G` | `n` | Find next |
| `Alt+r` | `:s` | Replace |

### File Operations

| Nano Binding | Vim Equivalent | Description |
|--------------|----------------|-------------|
| `Ctrl+S` | `:w` | Save (write) |
| `Ctrl+Q` | `:q` | Quit |
| `Ctrl+O` | `:e` | Open file |

### Indentation

| Nano Binding | Vim Equivalent | Description |
|--------------|----------------|-------------|
| `Alt+]` | `>>` | Indent |
| `Alt+[` | `<<` | Unindent |

### Buffer/Window

| Nano Binding | Vim Equivalent | Description |
|--------------|----------------|-------------|
| `Alt+n` | `:bn` | Next buffer |
| `Alt+p` | `:bp` | Previous buffer |

## Features Enabled

Beyond keybindings, the `.nanorc` also enables:

- **Line numbers**: `set linenumbers`
- **Auto-indent**: `set autoindent`
- **Tab width 4**: `set tabsize 4`
- **Tabs to spaces**: `set tabstospaces`
- **Mouse support**: `set mouse`
- **Smooth scrolling**: `set smooth`
- **Soft wrap**: `set softwrap`
- **Regex search**: `set regexp`
- **Case-sensitive search**: `set casesensitive`
- **Multiple buffers**: `set multibuffer`
- **Backups**: `set backup` (to `~/.local/share/nano/backup`)
- **Persistent history**: `set historylog`, `set positionlog`
- **Syntax highlighting**: Includes all system syntax files
- **No help lines**: `set nohelp` (more screen space, like vim)

## Limitations

Nano is **not vim**. Some fundamental differences:

- ❌ No normal/insert/visual modes
- ❌ No text objects (e.g., `ciw`, `da"`)
- ❌ No repeat with `.`
- ❌ No macros
- ❌ No registers (beyond one paste buffer)
- ❌ No split windows
- ❌ No plugins
- ❌ Limited undo/redo

These bindings provide **muscle memory convenience**, not vim functionality.

## Quick Reference Card

Print this for your remote system:

```
╔══════════════════════════════════════════════════════════╗
║           NANO WITH VIM-LIKE KEYBINDINGS                 ║
╠══════════════════════════════════════════════════════════╣
║ Navigation                                               ║
║   Ctrl+J/K       Up/Down (j/k)                          ║
║   Ctrl+H/L       Left/Right (h/l)                       ║
║   Ctrl+A/E       Home/End (0/$)                         ║
║   Alt+0 / Alt+$  First/Last line (gg/G)                 ║
║                                                          ║
║ Editing                                                  ║
║   Alt+u / Alt+r  Undo/Redo (u/Ctrl+R)                   ║
║   Ctrl+D         Delete char (x)                        ║
║   Alt+d          Delete word (dw)                       ║
║                                                          ║
║ Copy/Paste                                               ║
║   Alt+v          Start selection (v)                    ║
║   Alt+y / Alt+p  Copy/Paste (y/p)                       ║
║                                                          ║
║ Search                                                   ║
║   Ctrl+F         Search (/)                             ║
║   Ctrl+G         Find next (n)                          ║
║                                                          ║
║ File Ops                                                 ║
║   Ctrl+S         Save (:w)                              ║
║   Ctrl+Q         Quit (:q)                              ║
║   Ctrl+O         Open file (:e)                         ║
╚══════════════════════════════════════════════════════════╝
```

## Backup and Restore

### View Current Config
```bash
cat ~/.nanorc
```

### Backup Original
```bash
# Done automatically by setup-nano.sh
ls -la ~/.nanorc.backup
```

### Restore Original
```bash
mv ~/.nanorc.backup ~/.nanorc
```

### Remove Vim-like Bindings
```bash
rm ~/.nanorc
```

## Why Not Just Use Vim?

You should! This nano config is a **last resort** for systems where:
- Vim/Neovim not available
- Can't install packages
- No admin/sudo access
- Nano is the only editor present

The editor fallback chain is: **neovim → vim → vi → nano**

Install vim if at all possible:
```bash
# With sudo
sudo apt install vim        # Debian/Ubuntu
sudo dnf install vim        # Fedora
sudo pacman -S vim          # Arch

# Without sudo, ask your admin to install vim!
```

## Related Documentation

- [EDITOR_FALLBACK.md](EDITOR_FALLBACK.md) - Complete editor fallback system
- [VIM_NEOVIM_SETUP.md](VIM_NEOVIM_SETUP.md) - Proper vim/neovim configuration
- [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md) - Platform-specific installation

## Configuration Location

- **Source**: `dotfiles/config/nano/.nanorc`
- **Linked to**: `~/.nanorc`
- **Backup dir**: `~/.local/share/nano/backup/`

## Testing

Test the configuration:
```bash
nano test.txt
# Try: Ctrl+J/K for navigation
# Try: Alt+u after making changes (undo)
# Try: Ctrl+F to search
# Try: Ctrl+S to save, Ctrl+Q to quit
```
