# Shell Fallback: Zsh → Bash

This dotfiles repository automatically falls back from zsh to bash if zsh is not available on the system.

## How It Works

During installation, the `install.sh` script:

1. **Detects available shells** - Checks if `zsh` is installed
2. **Links appropriate config** - Creates symlink to either `.zshrc` or `.bashrc`
3. **Sets default shell** - Attempts to change login shell with `chsh`
4. **Provides instructions** - Shows correct source command for the chosen shell

## Detection Logic

```bash
if command -v zsh &> /dev/null; then
    SHELL_NAME="zsh"
    # Link and use zshrc
else
    SHELL_NAME="bash"
    # Link and use bashrc
fi
```

## Configuration Files

### Zsh Configuration
- **Location**: `~/.zshrc`
- **Source**: `dotfiles/zshrc/.zshrc`
- **Features**: Full-featured with Starship, FZF, zoxide, etc.

### Bash Configuration
- **Location**: `~/.bashrc`
- **Source**: `dotfiles/bashrc/.bashrc`
- **Features**: Feature parity with zsh config
- **Fallback prompt**: Simple git-aware prompt if Starship unavailable

## Feature Comparison

Both configurations include:

| Feature | Zsh | Bash |
|---------|-----|------|
| Starship prompt | ✓ | ✓ |
| FZF integration | ✓ | ✓ |
| Zoxide/z.sh navigation | ✓ | ✓ |
| Editor fallback (nvim→vim→vi) | ✓ | ✓ |
| Custom aliases (eza, etc.) | ✓ | ✓ |
| Navigation functions (cx, fcd, f, fv) | ✓ | ✓ |
| Git branch display | ✓ | ✓ (built-in fallback) |

## Usage Scenarios

### Standard Installation (zsh available)
```bash
bash install.sh
# Links ~/.zshrc
# Sets zsh as default shell
# Instructions: source ~/.zshrc
```

### Minimal System (zsh not available)
```bash
bash install.sh
# Links ~/.bashrc
# Sets bash as default shell
# Instructions: source ~/.bashrc
```

### Remote/Headless Systems
```bash
bash install.sh remote-console
# Links both ~/.zshrc and ~/.bashrc
# Uses whichever shell is available
# Creates minimal .shell_profile_remote
```

## Manual Shell Switching

If you later install zsh:
```bash
# Install zsh
brew install zsh  # macOS
sudo apt install zsh  # Linux

# Re-run install
cd ~/dotfiles
bash install.sh

# Change shell manually if needed
chsh -s $(which zsh)

# Reload configuration
exec zsh
```

If you prefer bash:
```bash
# Source bash config
source ~/.bashrc

# Change default shell
chsh -s $(which bash)

# Reload
exec bash
```

## Environment Detection

The bash config includes smart detection for missing tools:

```bash
# Example: Starship fallback
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
else
    # Simple git-aware prompt
    PS1='\u@\h:\w$(parse_git_branch)\$ '
fi
```

This ensures the configuration works even on minimal systems without all tools installed.

## Compatibility

### Supported Systems
- ✓ **macOS** - Prefers zsh (default since Catalina)
- ✓ **Linux** - Uses distribution default (usually bash)
- ✓ **WSL** - Typically bash
- ✓ **Remote/SSH** - Works with whatever is available

### Shell Versions
- **Zsh**: 5.0+ (tested with 5.8+)
- **Bash**: 4.0+ (tested with 4.4 and 5.x)

## Troubleshooting

### Shell not changing after install
```bash
# Check current shell
echo $SHELL

# Manually change
chsh -s $(which zsh)  # or $(which bash)

# Verify
cat /etc/shells  # Should list your chosen shell
```

### Config not loading
```bash
# Check if symlink exists
ls -la ~/.zshrc ~/.bashrc

# Manually source
source ~/.zshrc  # or ~/.bashrc

# Check for errors
zsh -n ~/.zshrc  # syntax check for zsh
bash -n ~/.bashrc  # syntax check for bash
```

### Both shells installed but wrong one active
```bash
# Force shell in install
cd ~/dotfiles
bash install.sh

# The script will detect and use the best available shell
```

## Best Practices

1. **Keep both configs updated** - Changes should be mirrored between `.zshrc` and `.bashrc`
2. **Test on minimal systems** - Verify fallbacks work without optional tools
3. **Use portable syntax** - Avoid shell-specific features when possible
4. **Document requirements** - Note which features need specific tools

## Related Documentation

- [EDITOR_FALLBACK.md](EDITOR_FALLBACK.md) - Editor fallback chain (nvim → vim → vi)
- [MULTI_OS_SETUP.md](MULTI_OS_SETUP.md) - Multi-OS installation guide
- [README.md](README.md) - Main documentation
