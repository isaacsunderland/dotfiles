# Zsh configuration file
# No Nix required - pure shell

# Enable command completion
autoload -U compinit && compinit

# Set up shell options
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Enable bash completion compatibility
autoload bashcompinit && bashcompinit

# Set PATH
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Use uutils-coreutils instead of macOS/BSD coreutils for cross-platform compatibility
if [ -d "$(brew --prefix uutils-coreutils 2>/dev/null)/libexec/uubin" ]; then
    export PATH="$(brew --prefix uutils-coreutils)/libexec/uubin:$PATH"
fi

# Vim mode
bindkey -M vicmd 'j' beginning-of-line
bindkey -M vicmd 'k' end-of-line

# History search in normal mode (Ctrl+R for reverse, Ctrl+S for forward)
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Vi mode history search (enable in vi mode too)
bindkey -M vicmd '^R' history-incremental-search-backward
bindkey -M vicmd '^S' history-incremental-search-forward

# FZF integration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Z.sh for navigation (directory jumping)
. /opt/homebrew/etc/profile.d/z.sh

# Aliases - Modern tools available via functions, standard commands untouched
# This allows original commands to work, with modern alternatives as functions
# Use commands directly: ls, find, cat, grep
# Use modern alternatives: l, ll, la (eza wrappers), fdf, batcat, rgp (if installed)

# Remove any existing aliases to avoid conflicts with function definitions
unalias l 2>/dev/null || true
unalias ll 2>/dev/null || true
unalias la 2>/dev/null || true
unalias lt 2>/dev/null || true
unalias tree 2>/dev/null || true
unalias find 2>/dev/null || true
unalias cat 2>/dev/null || true
unalias grep 2>/dev/null || true

# Convenience functions for modern tools (non-breaking)
if command -v eza &> /dev/null; then
    # These are convenience shortcuts, not aliases overriding originals
    l() { eza -l --icons --git -a "$@"; }
    ll() { eza -l --icons --git "$@"; }
    la() { eza -la --icons --git "$@"; }
    lt() { eza --tree --level=2 --long --icons --git "$@"; }
    tree() { eza --tree "$@"; }
elif command -v exa &> /dev/null; then
    l() { exa -l --icons --git -a "$@"; }
    ll() { exa -l --icons --git "$@"; }
    la() { exa -la --icons --git "$@"; }
    lt() { exa --tree --level=2 --long --icons --git "$@"; }
else
    # Fallback shortcuts using standard ls
    l() { ls -lah "$@"; }
    ll() { ls -lh "$@"; }
    la() { ls -lAh "$@"; }
fi

# Modern tool shortcuts (when available, never override originals)
if command -v fd &> /dev/null; then
    fdf() { fd "$@"; }
fi

if command -v bat &> /dev/null; then
    batcat() { bat --style=auto "$@"; }
fi

if command -v rg &> /dev/null; then
    rgp() { rg "$@"; }
fi

# Standard aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Homebrew maintenance aliases
if command -v brew &> /dev/null; then
    alias brew-check="brew update && brew outdated"
    alias brew-doctor="brew doctor"

    # Monthly automatic update check
    BREW_UPDATE_TRACKER="$HOME/.brew_last_update"

    # Function to check if brew needs monthly update
    _check_monthly_brew_update() {
        local current_month=$(date +%Y-%m)
        local last_update_month=""

        if [ -f "$BREW_UPDATE_TRACKER" ]; then
            last_update_month=$(cat "$BREW_UPDATE_TRACKER")
        fi

        if [ "$current_month" != "$last_update_month" ]; then
            echo "🔔 Monthly Homebrew update available!"
            echo "   Run 'brew-update' to update all packages"
            echo "   Or 'brew-check' to see what's outdated"
            echo "   (Skip with: touch $BREW_UPDATE_TRACKER && echo $current_month > $BREW_UPDATE_TRACKER)"
            echo ""
        fi
    }

    # Run check on shell startup (only once per session)
    if [ -z "$BREW_UPDATE_CHECK_DONE" ]; then
        _check_monthly_brew_update
        export BREW_UPDATE_CHECK_DONE=1
    fi

    # Wrap brew-update to mark update as done
    brew-update() {
        command brew update && command brew upgrade && command brew cleanup && command brew autoremove
        if [ $? -eq 0 ]; then
            date +%Y-%m > "$BREW_UPDATE_TRACKER"
            echo "✅ Update tracker updated: $(cat $BREW_UPDATE_TRACKER)"
        fi
    }
fi

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

# Ensure homebrew nano takes precedence (if installed)
if [ -x /opt/homebrew/bin/nano ]; then
    alias nano="/opt/homebrew/bin/nano"
fi

# Navigation functions
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() {
    local file="$(find . -type f -not -path '*/.*' | fzf)"
    if [ -n "$file" ]; then
        $EDITOR "$file"
    fi
}

# Zoxide integration (modern cd replacement)
eval "$(zoxide init zsh)"

# Initialize starship prompt
eval "$(starship init zsh)"

# Cheatsheet function - shows available commands and modern alternatives
cheatsheet() {
    cat << 'CHEATSHEET'
╔══════════════════════════════════════════════════════════════════════╗
║                 COMMAND CHEATSHEET & QUICK REFERENCE                 ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                      ║
║  LISTING & NAVIGATION                                               ║
║  ────────────────────────────────────────────────────────────────── ║
║  ls              Standard listing                                    ║
║  l               List with details (eza/exa if installed)           ║
║  ll              List long format (eza/exa if installed)            ║
║  la              List all with details (eza/exa if installed)       ║
║  lt              List tree view (eza if installed)                  ║
║  cd, cx          Change directory (cx also lists contents)          ║
║  fcd             Fuzzy find and cd into directory                   ║
║                                                                      ║
║  SEARCHING & FINDING                                                ║
║  ────────────────────────────────────────────────────────────────── ║
║  find            Standard find command                              ║
║  fdf             Fast find (fd alternative, if installed)           ║
║  grep            Standard grep search                               ║
║  rgp             Fast search (ripgrep alternative, if installed)    ║
║  f               Fuzzy find file (copies path to clipboard)         ║
║                                                                      ║
║  FILE VIEWING                                                       ║
║  ────────────────────────────────────────────────────────────────── ║
║  cat             Standard file display                              ║
║  batcat          Syntax-highlighted cat (bat, if installed)         ║
║                                                                      ║
║  EDITING                                                            ║
║  ────────────────────────────────────────────────────────────────── ║
║  vim             Editor (vim/nvim depending on installation)        ║
║  vi              Editor (vim/nvim depending on installation)        ║
║  fv              Fuzzy find and open file in editor                 ║
║                                                                      ║
║  NAVIGATION SHORTCUTS                                               ║
║  ────────────────────────────────────────────────────────────────── ║
║  ..              cd ../                                             ║
║  ...             cd ../../                                          ║
║  ....            cd ../../../                                       ║
║  z <dir>         Jump to directory (zoxide)                         ║
║                                                                      ║
║  INSTALLED TOOLS                                                    ║
║  ────────────────────────────────────────────────────────────────── ║
║  ✓ AVAILABLE:                                                        ║
CHEATSHEET

    # Show which modern tools are installed
    if command -v eza &> /dev/null; then
        echo "║    • eza (fast ls replacement)                                  ║"
    fi
    if command -v fd &> /dev/null; then
        echo "║    • fd (fast find replacement)                                 ║"
    fi
    if command -v bat &> /dev/null; then
        echo "║    • bat (syntax-highlighted cat)                               ║"
    fi
    if command -v rg &> /dev/null; then
        echo "║    • ripgrep (fast grep replacement)                            ║"
    fi
    if command -v fzf &> /dev/null; then
        echo "║    • fzf (fuzzy finder)                                         ║"
    fi
    if command -v zoxide &> /dev/null; then
        echo "║    • zoxide (smart cd replacement)                              ║"
    fi

    cat << 'CHEATSHEET_END'
║                                                                      ║
║  TIP: Install modern tools with:                                    ║
║       brew install eza fd bat ripgrep fzf zoxide                    ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
CHEATSHEET_END
}

# Kubectl completion setup
if command -v kubectl &> /dev/null; then
    # Enable kubectl completion for zsh
    source <(kubectl completion zsh)

    # CloudNativePG (CNPG) kubectl plugin completion
    if command -v kubectl-cnpg &> /dev/null; then
        # Generate and install kubectl cnpg completion helper
        if ! command -v kubectl_complete-cnpg &> /dev/null; then
            cat > /tmp/kubectl_complete-cnpg <<'CNPG_EOF'
#!/usr/bin/env sh
# Call the __complete command passing it all arguments
kubectl cnpg __complete "$@"
CNPG_EOF
            chmod +x /tmp/kubectl_complete-cnpg

            # Try to install to /usr/local/bin first, then homebrew bin
            if [ -w /usr/local/bin ]; then
                mv /tmp/kubectl_complete-cnpg /usr/local/bin/
            elif [ -w /opt/homebrew/bin ]; then
                mv /tmp/kubectl_complete-cnpg /opt/homebrew/bin/
            else
                echo "Warning: Could not install kubectl_complete-cnpg. Run with sudo or ensure /usr/local/bin is writable."
            fi
        fi
    fi
fi

