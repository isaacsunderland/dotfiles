# Shared shell helpers for both zsh and bash.

# Add dotfiles bin to PATH
if [ -d "$HOME/.config/bin" ]; then
    export PATH="$HOME/.config/bin:$PATH"
fi

_sanitize_path_entries() {
    local path_in path_out old_ifs entry

    path_in="$PATH"
    path_out=""
    old_ifs="$IFS"
    IFS=':'

    for entry in $path_in; do
        case "$entry" in
            ''|oci://*)
                continue
                ;;
        esac

        if [ -z "$path_out" ]; then
            path_out="$entry"
        else
            path_out="$path_out:$entry"
        fi
    done

    IFS="$old_ifs"
    export PATH="$path_out"
}

_sanitize_path_entries

_ensure_default_system_path_entries() {
    local default_entry

    for default_entry in /usr/bin /bin /usr/sbin /sbin; do
        case ":$PATH:" in
            *":$default_entry:"*)
                ;;
            *)
                if [ -n "$PATH" ]; then
                    PATH="$PATH:$default_entry"
                else
                    PATH="$default_entry"
                fi
                ;;
        esac
    done

    export PATH
}

_ensure_default_system_path_entries

# PATH defaults
if [ -d /opt/homebrew/bin ]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi
if [ -d /usr/local/bin ]; then
    export PATH="/usr/local/bin:$PATH"
fi

_sanitize_path_entries
_ensure_default_system_path_entries

# Prefer Homebrew bash for interactive `bash ...` calls.
if [ -x /opt/homebrew/bin/bash ]; then
    DOTFILES_BASH_BIN="/opt/homebrew/bin/bash"
elif [ -x /usr/local/bin/bash ]; then
    DOTFILES_BASH_BIN="/usr/local/bin/bash"
else
    DOTFILES_BASH_BIN=""
fi

if [ -n "$DOTFILES_BASH_BIN" ]; then
    alias bash="$DOTFILES_BASH_BIN"
fi

# Prefer uutils coreutils when available (cached path to avoid slow brew --prefix)
if [ -d /opt/homebrew/opt/uutils-coreutils/libexec/uubin ]; then
    export PATH="/opt/homebrew/opt/uutils-coreutils/libexec/uubin:$PATH"
elif [ -d /usr/local/opt/uutils-coreutils/libexec/uubin ]; then
    export PATH="/usr/local/opt/uutils-coreutils/libexec/uubin:$PATH"
fi

# FZF default command
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
fi

# Standard aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Editor fallback chain: neovim -> vim -> vi
if command -v nvim >/dev/null 2>&1; then
    alias vim="nvim"
    alias vi="nvim"
    export EDITOR="nvim"
    export VISUAL="nvim"
elif command -v vim >/dev/null 2>&1; then
    alias vi="vim"
    export EDITOR="vim"
    export VISUAL="vim"
else
    export EDITOR="vi"
    export VISUAL="vi"
fi

# Ensure Homebrew nano takes precedence when installed.
if [ -x /opt/homebrew/bin/nano ]; then
    alias nano="/opt/homebrew/bin/nano"
fi

# Homebrew maintenance helpers
if command -v brew >/dev/null 2>&1; then
    alias brew-check="brew update && brew outdated"
    alias brew-doctor="brew doctor"

    BREW_UPDATE_TRACKER="$HOME/.brew_last_update"

    _check_monthly_brew_update() {
        local current_month
        local last_update_month
        current_month="$(date +%Y-%m)"
        last_update_month=""

        if [ -f "$BREW_UPDATE_TRACKER" ]; then
            last_update_month="$(cat "$BREW_UPDATE_TRACKER")"
        fi

        if [ "$current_month" != "$last_update_month" ]; then
            echo "Monthly Homebrew update available."
            echo "  Run 'brew-update' to update all packages"
            echo "  Or 'brew-check' to see what is outdated"
            echo ""
        fi
    }

    if [ -z "$BREW_UPDATE_CHECK_DONE" ]; then
        _check_monthly_brew_update
        export BREW_UPDATE_CHECK_DONE=1
    fi

    brew-update() {
        command brew update && command brew upgrade && command brew cleanup && command brew autoremove
        if [ $? -eq 0 ]; then
            date +%Y-%m > "$BREW_UPDATE_TRACKER"
            echo "Update tracker updated: $(cat "$BREW_UPDATE_TRACKER")"
        fi
    }
fi

# Navigation helpers
cx() { cd "$@" && l; }

fcd() {
    if command -v fzf >/dev/null 2>&1; then
        local dir
        dir="$(command find . -type d -not -path '*/.*' 2>/dev/null | fzf)"
        if [ -n "$dir" ]; then
            cd "$dir" && l
        fi
    else
        echo "fzf not installed"
    fi
}

f() {
    if command -v fzf >/dev/null 2>&1; then
        local file
        file="$(command find . -type f -not -path '*/.*' 2>/dev/null | fzf)"
        if [ -n "$file" ]; then
            if command -v pbcopy >/dev/null 2>&1; then
                echo "$file" | pbcopy
            elif command -v xclip >/dev/null 2>&1; then
                echo "$file" | xclip -selection clipboard
            elif command -v wl-copy >/dev/null 2>&1; then
                echo "$file" | wl-copy
            else
                echo "$file"
            fi
        fi
    else
        echo "fzf not installed"
    fi
}

fv() {
    if command -v fzf >/dev/null 2>&1; then
        local file
        file="$(command find . -type f -not -path '*/.*' 2>/dev/null | fzf)"
        if [ -n "$file" ]; then
            "$EDITOR" "$file"
        fi
    else
        echo "fzf not installed"
    fi
}

# z.sh for directory jumping
if [ -f /opt/homebrew/etc/profile.d/z.sh ]; then
    . /opt/homebrew/etc/profile.d/z.sh
elif [ -f /usr/local/etc/profile.d/z.sh ]; then
    . /usr/local/etc/profile.d/z.sh
fi

# Shared helper used by both zsh and bash completion setup.
_ensure_kubectl_cnpg_completion_helper() {
    if ! command -v kubectl-cnpg >/dev/null 2>&1; then
        return
    fi

    if command -v kubectl_complete-cnpg >/dev/null 2>&1; then
        return
    fi

    cat > /tmp/kubectl_complete-cnpg <<'CNPG_EOF'
#!/usr/bin/env sh
kubectl cnpg __complete "$@"
CNPG_EOF
    chmod +x /tmp/kubectl_complete-cnpg

    if [ -w /usr/local/bin ]; then
        mv /tmp/kubectl_complete-cnpg /usr/local/bin/
    elif [ -w /opt/homebrew/bin ]; then
        mv /tmp/kubectl_complete-cnpg /opt/homebrew/bin/
    else
        echo "Warning: Could not install kubectl_complete-cnpg. Ensure /usr/local/bin or /opt/homebrew/bin is writable."
    fi
}
