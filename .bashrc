# Bash configuration file
# Fallback when zsh is not available

# Enable bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Set PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Use uutils-coreutils instead of macOS/BSD coreutils for cross-platform compatibility
if command -v brew &> /dev/null; then
    if [ -d "$(brew --prefix uutils-coreutils 2>/dev/null)/libexec/uubin" ]; then
        export PATH="$(brew --prefix uutils-coreutils)/libexec/uubin:$PATH"
    fi
fi

# History settings
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Colors for ls
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33;40:cd=1;33;40:su=1;32;40:sg=1;32;40:tw=1;32;40:ow=1;32;40'
export CLICOLOR=1

# Enable colors in terminal
export TERM=xterm-256color

# FZF integration (if available)
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

# Set FZF default command (if fd is available)
if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
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

# Aliases - Modern tools with POSIX fallbacks
# ls replacement (eza/exa with fallback to ls)
if command -v eza &> /dev/null; then
    alias ls="eza"
    alias l="eza -l --icons --git -a"
    alias ll="eza -l --icons --git"
    alias la="eza -la --icons --git"
    alias lt="eza --tree --level=2 --long --icons --git"
    alias tree="eza --tree"
elif command -v exa &> /dev/null; then
    alias ls="exa"
    alias l="exa -l --icons --git -a"
    alias ll="exa -l --icons --git"
    alias la="exa -la --icons --git"
    alias lt="exa --tree --level=2 --long --icons --git"
else
    # POSIX fallback
    alias l="ls -lah"
    alias ll="ls -lh"
    alias la="ls -lAh"
    alias lt="ls -R"
fi

# find replacement (fd with fallback to find)
if command -v fd &> /dev/null; then
    alias find="fd"
fi

# cat replacement (bat with fallback to cat)
if command -v bat &> /dev/null; then
    alias cat="bat --style=auto"
    alias ccat="/bin/cat"  # original cat
fi

# grep replacement (ripgrep with fallback to grep)
if command -v rg &> /dev/null; then
    alias grep="rg"
    alias rgrep="/usr/bin/grep"  # original grep
else
    alias grep="grep --color=auto"
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
    
    # Function version of brew-update to mark update as done
    brew-update() {
        command brew update && command brew upgrade && command brew cleanup && command brew autoremove
        if [ $? -eq 0 ]; then
            date +%Y-%m > "$BREW_UPDATE_TRACKER"
            echo "✅ Update tracker updated: $(cat $BREW_UPDATE_TRACKER)"
        fi
    }
fi

# Navigation functions
cx() { cd "$@" && l; }

fcd() {
    if command -v fzf &> /dev/null; then
        local dir=$(find . -type d -not -path '*/.*' 2>/dev/null | fzf)
        if [ -n "$dir" ]; then
            cd "$dir" && l
        fi
    else
        echo "fzf not installed"
    fi
}

f() {
    if command -v fzf &> /dev/null; then
        local file=$(find . -type f -not -path '*/.*' 2>/dev/null | fzf)
        if [ -n "$file" ]; then
            if command -v pbcopy &> /dev/null; then
                echo "$file" | pbcopy
            elif command -v xclip &> /dev/null; then
                echo "$file" | xclip -selection clipboard
            else
                echo "$file"
            fi
        fi
    else
        echo "fzf not installed"
    fi
}

fv() {
    if command -v fzf &> /dev/null; then
        local file=$(find . -type f -not -path '*/.*' 2>/dev/null | fzf)
        if [ -n "$file" ]; then
            $EDITOR "$file"
        fi
    else
        echo "fzf not installed"
    fi
}

# Zoxide integration (modern cd replacement)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

# Z.sh for navigation (directory jumping) - macOS Homebrew path
if [ -f /opt/homebrew/etc/profile.d/z.sh ]; then
    . /opt/homebrew/etc/profile.d/z.sh
elif [ -f /usr/local/etc/profile.d/z.sh ]; then
    . /usr/local/etc/profile.d/z.sh
fi

# Starship prompt (if available)
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
else
    # Simple fallback prompt with git branch
    parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }
    export PS1="\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[1;33m\]\$(parse_git_branch)\[\033[0m\]\$ "
fi

# Bash-specific options
shopt -s checkwinsize  # Check window size after each command
shopt -s cdspell       # Autocorrect typos in path names
shopt -s dirspell      # Autocorrect directory names
shopt -s globstar      # Enable ** for recursive globbing

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Kubectl completion setup
if command -v kubectl &> /dev/null; then
    # Enable kubectl completion
    source <(kubectl completion bash)
    
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

# Microsoft Terminal Notifications
[ -f "/Users/isaacsunderland/.config/ms-terminal-notif/shell-integration.sh" ] && source "/Users/isaacsunderland/.config/ms-terminal-notif/shell-integration.sh"
