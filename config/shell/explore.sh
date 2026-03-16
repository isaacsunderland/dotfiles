# Git explore worktree helpers for safe, isolated experimentation.
# Usage: explore [start|stop|list|resume|doctor|save-notes|help] or explore-start, explore-stop, explore-list, explore-resume
# Customizable via env vars: GIT_EXPLORE_PREFIX, GIT_EXPLORE_BRANCH_PREFIX, GIT_EXPLORE_BRANCH

# Configuration with sensible defaults
GIT_EXPLORE_PREFIX="${GIT_EXPLORE_PREFIX:-.explore}"
GIT_EXPLORE_BRANCH_PREFIX="${GIT_EXPLORE_BRANCH_PREFIX:-explore}"
GIT_EXPLORE_BRANCH="${GIT_EXPLORE_BRANCH:-}"

# Build a branch-safe suffix from a base branch name.
_sanitize_branch_component() {
    local value="${1:-}"
    value="${value//\//-}"
    value="${value// /-}"
    value="$(printf '%s' "$value" | tr -cs '[:alnum:]._-' '-')"
    value="${value#-}"
    value="${value%-}"

    if [ -z "$value" ]; then
        value="root"
    fi

    echo "$value"
}

# Resolve final explore branch name.
# - If GIT_EXPLORE_BRANCH is set, use it as-is.
# - Otherwise generate <prefix>-<base-branch>.
_explore_branch_name() {
    local base_branch="${1:-}"

    if [ -n "${GIT_EXPLORE_BRANCH}" ]; then
        echo "${GIT_EXPLORE_BRANCH}"
        return
    fi

    echo "${GIT_EXPLORE_BRANCH_PREFIX}-$(_sanitize_branch_component "$base_branch")"
}

# Resolve a repo's top-level path even if called from a subdir
_git_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

# Derive a short, filesystem-safe repo name (directory name)
_repo_name() {
    basename "$(_git_root)"
}

# Hidden sibling worktree path, e.g., ../.explore-my-repo
_explore_path() {
    local root
    root="$(_git_root)"
    local parent
    parent="$(cd "$root/.." && pwd)"
    echo "$parent/${GIT_EXPLORE_PREFIX}-$(_repo_name)"
}

# Workspace file used to open explore mode with distinct VS Code colors.
_explore_workspace_file() {
        local wt
        wt="$(_explore_path)"
        echo "$wt/ai/explore.code-workspace"
}

# Open worktree in VS Code with a dedicated dark-purple visual identity.
_open_explore_workspace() {
        local wt
        wt="$(_explore_path)"
        local ws
        ws="$(_explore_workspace_file)"

        mkdir -p "$wt/ai"
        cat > "$ws" <<'EOF'
{
    "folders": [
        { "path": ".." }
    ],
    "settings": {
        "workbench.colorCustomizations": {
            "titleBar.activeBackground": "#1b1026",
            "titleBar.activeForeground": "#f2ebff",
            "titleBar.inactiveBackground": "#140d1d",
            "titleBar.inactiveForeground": "#b9aecb",
            "activityBar.background": "#1a1124",
            "activityBar.foreground": "#dbcfff",
            "statusBar.background": "#241339",
            "statusBar.foreground": "#f2ebff",
            "statusBar.noFolderBackground": "#241339",
            "statusBar.debuggingBackground": "#3a1e57"
        },
        "window.title": "Explore: ${folderName}"
    }
}
EOF

        code -n "$ws" >/dev/null 2>&1 || true
}

# Install safety hook to prevent accidental commits in explore worktree
_install_explore_guard() {
    local wt="$(_explore_path)"
    mkdir -p "$wt/.githooks"
    cat > "$wt/.githooks/pre-commit" <<'HOOK'
#!/usr/bin/env bash
echo "⚠️  Commits are disabled in explore worktree to prevent accidents."
echo "   Translate findings → create tasks/PRs in main worktree."
exit 1
HOOK
    chmod +x "$wt/.githooks/pre-commit"
    (cd "$wt" && git config core.hooksPath .githooks)

    # Keep explore-only artifacts local and out of commits.
    # Use the common git dir exclude so patterns apply in linked worktrees.
    local common_git_dir
    local exclude_file
    common_git_dir="$(cd "$wt" && git rev-parse --git-common-dir 2>/dev/null || true)"
    if [ -n "$common_git_dir" ]; then
        exclude_file="$common_git_dir/info/exclude"
        mkdir -p "$common_git_dir/info"
        touch "$exclude_file"
        if ! grep -qx 'ai/' "$exclude_file"; then
            printf '\nai/\n' >> "$exclude_file"
        fi
        if ! grep -qx '.githooks/' "$exclude_file"; then
            printf '\n.githooks/\n' >> "$exclude_file"
        fi
    fi
}

# Create and initialize explore worktree from current branch
explore-start() {
    local root
    root="$(_git_root)" || {
        echo "❌ Not inside a git repository."
        return 1
    }

    local current_branch
    current_branch="$(git rev-parse --abbrev-ref HEAD)"
    local exp_branch
    exp_branch="$(_explore_branch_name "$current_branch")"
    local wt
    wt="$(_explore_path)"

    echo "📍 Current branch: $current_branch"
    echo "🧪 Explore branch: $exp_branch"
    echo "📁 Worktree path: $wt"

    # Create explore branch from current branch if missing
    if ! git show-ref --verify --quiet "refs/heads/${exp_branch}"; then
        echo "⎇ Creating '${exp_branch}' from '${current_branch}'..."
        git fetch --all --prune 2>/dev/null || true
        git branch "${exp_branch}" "${current_branch}" || {
            echo "❌ Failed to create explore branch"
            return 1
        }
    else
        echo "✔ Explore branch '${exp_branch}' already exists"
    fi

    # Create worktree if missing
    if [ ! -d "$wt" ]; then
        echo "➕ Adding worktree: $wt"
        git worktree add "$wt" "${exp_branch}" || {
            echo "❌ Failed to create worktree at $wt"
            return 1
        }
    else
        echo "✔ Worktree already exists: $wt"

        # Keep a single explore worktree path, but retarget its branch per source branch.
        local wt_branch
        wt_branch="$(cd "$wt" && git rev-parse --abbrev-ref HEAD)"
        if [ "$wt_branch" != "$exp_branch" ]; then
            if (cd "$wt" && [ -n "$(git status --porcelain)" ]); then
                echo "❌ Existing explore worktree has uncommitted changes on '$wt_branch'."
                echo "   Commit/stash there, or run: explore-stop --force"
                return 1
            fi

            echo "🔁 Switching explore worktree branch: $wt_branch -> $exp_branch"
            (cd "$wt" && git switch "$exp_branch") || {
                echo "❌ Failed to switch explore worktree to '$exp_branch'"
                return 1
            }
        fi
    fi

    # Install safety guard
    _install_explore_guard

    # Seed optional exploration notes
    mkdir -p "$wt/ai"
    touch "$wt/ai/EXPLORE.md"

    echo ""
    echo "✅ Explore worktree ready!"
    echo "   Open: code -n $wt"
    echo "   Or:   cd $wt"

    # Optional: auto-open VS Code
    if command -v code >/dev/null 2>&1; then
        _open_explore_workspace
    fi
}

# List active explore worktrees
explore-list() {
    echo "Explore worktrees:"
    git worktree list | grep "${GIT_EXPLORE_PREFIX}" || echo "  (none)"
}

# Reopen explore worktree in VS Code (or just cd)
explore-resume() {
    local wt
    wt="$(_explore_path)"

    if [ ! -d "$wt" ]; then
        echo "❌ No explore worktree at $wt"
        return 1
    fi

    if command -v code >/dev/null 2>&1; then
        echo "🔓 Reopening explore worktree in VS Code..."
        _open_explore_workspace
    else
        echo "📂 Explore worktree path: $wt"
        echo "   cd $wt"
    fi
}

# Save explore notes from worktree to the main repo before cleanup.
explore-save-notes() {
    local root
    root="$(_git_root)" || {
        echo "❌ Not inside a git repository."
        return 1
    }

    local wt
    wt="$(_explore_path)"
    local src="$wt/ai/EXPLORE.md"
    local dest_dir="$root/ai"
    local dest="$dest_dir/EXPLORE.md"

    if [ ! -f "$src" ] || [ ! -s "$src" ]; then
        echo "ℹ️  No explore notes to save at $src"
        return 0
    fi

    local exp_branch
    exp_branch="$(cd "$wt" && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"
    local ts
    ts="$(date -u +"%Y-%m-%d %H:%M:%SZ")"

    mkdir -p "$dest_dir"
    touch "$dest"

    {
        echo ""
        echo "## Saved from $exp_branch at $ts"
        echo ""
        echo "Source worktree: $wt"
        echo ""
        cat "$src"
        echo ""
    } >> "$dest"

    echo "💾 Saved notes to $dest"
}

# Remove explore worktree safely
explore-stop() {
    local wt
    wt="$(_explore_path)"
    local current_branch
    current_branch="$(git rev-parse --abbrev-ref HEAD)"
    local force_flag="${1:-}"

    if [ ! -d "$wt" ]; then
        echo "✔ No explore worktree at $wt"
        return 0
    fi

    local exp_branch
    exp_branch="$(cd "$wt" && git rev-parse --abbrev-ref HEAD)"

    # Offer to save exploration notes before deleting the worktree.
    if [ -f "$wt/ai/EXPLORE.md" ] && [ -s "$wt/ai/EXPLORE.md" ]; then
        printf "Save explore notes before removing worktree? [Y/n] "
        local save_ans
        read -r save_ans
        if [ -z "${save_ans:-}" ] || [ "$save_ans" = "y" ] || [ "$save_ans" = "Y" ]; then
            explore-save-notes || {
                echo "❌ Failed to save notes"
                return 1
            }
        fi
    fi

    # Check for uncommitted changes unless --force
    if [ "$force_flag" != "--force" ]; then
        if (cd "$wt" && [ -n "$(git status --porcelain)" ]); then
            echo "⚠️  Uncommitted changes in explore worktree:"
            (cd "$wt" && git status --short)
            echo ""
            echo "Options:"
            echo "  - Commit/stash changes, then re-run: explore-stop"
            echo "  - Force remove (discard changes): explore-stop --force"
            return 1
        fi
    fi

    echo "🧹 Removing worktree: $wt"
    git worktree remove "$wt" || {
        echo "❌ Failed to remove worktree"
        return 1
    }

    # Offer to reset explore branch (only non-interactive if --force)
    if [ "$force_flag" = "--force" ]; then
        git branch -f "$exp_branch" "$current_branch" 2>/dev/null || true
        echo "⟲ '$exp_branch' reset to '$current_branch' (--force)"
    else
        printf "Reset '%s' to '%s'? [y/N] " "$exp_branch" "$current_branch"
        read -r ans
        if [ "${ans:-N}" = "y" ] || [ "${ans:-N}" = "Y" ]; then
            git branch -f "$exp_branch" "$current_branch" || true
            echo "⟲ '$exp_branch' reset to '$current_branch'"
        fi
    fi

    echo "✅ Explore worktree removed."
}

# Check explore prerequisites and current state.
explore-doctor() {
    local root
    root="$(_git_root)" || {
        echo "❌ Not inside a git repository."
        return 1
    }

    local current_branch
    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
    local exp_branch
    exp_branch="$(_explore_branch_name "$current_branch")"
    local wt
    wt="$(_explore_path)"
    local has_issue=0

    echo "Explore doctor"
    echo "-------------"
    echo "Repo root:       $root"
    echo "Current branch:  ${current_branch:-<unknown>}"
    echo "Explore branch:  $exp_branch"
    echo "Worktree path:   $wt"

    if git show-ref --verify --quiet "refs/heads/${exp_branch}"; then
        echo "✅ Explore branch exists"
    else
        echo "ℹ️  Explore branch does not exist yet (created by explore-start)"
    fi

    if [ -d "$wt" ]; then
        echo "✅ Explore worktree exists"

        local wt_branch
        wt_branch="$(cd "$wt" && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
        if [ -n "$wt_branch" ]; then
            echo "ℹ️  Worktree branch: $wt_branch"
        else
            echo "⚠️  Could not determine worktree branch"
            has_issue=1
        fi

        if (cd "$wt" && [ -n "$(git status --porcelain)" ]); then
            echo "⚠️  Worktree has uncommitted changes"
            has_issue=1
        else
            echo "✅ Worktree is clean"
        fi

        if [ -x "$wt/.githooks/pre-commit" ]; then
            echo "✅ Commit guard hook is installed"
        else
            echo "⚠️  Commit guard hook is missing"
            has_issue=1
        fi
    else
        echo "ℹ️  Explore worktree not present (create with explore-start)"
    fi

    if [ "$has_issue" -eq 0 ]; then
        echo "✅ Doctor checks passed"
    else
        echo "⚠️  Doctor found issues"
    fi

    return "$has_issue"
}

explore-help() {
    cat <<'EOF'
Usage:
  explore <command> [args]

Commands:
  start            Create/open explore worktree for current branch
  stop [--force]   Remove explore worktree (optionally discard changes)
  list             List active explore worktrees
  resume           Reopen explore worktree in VS Code
  doctor           Run safety and state diagnostics
    save-notes       Save ai/EXPLORE.md from explore worktree to repo ai/EXPLORE.md
  help             Show this help

Environment:
  GIT_EXPLORE_PREFIX         Worktree directory prefix (default: .explore)
  GIT_EXPLORE_BRANCH_PREFIX  Auto branch prefix (default: explore)
  GIT_EXPLORE_BRANCH         Explicit branch name override

Examples:
  explore start
  explore stop --force
  explore doctor
    explore save-notes
  explore --help
EOF
}

explore() {
    local cmd="${1:-help}"
    shift 2>/dev/null || true

    case "$cmd" in
        start)
            explore-start "$@"
            ;;
        stop)
            explore-stop "$@"
            ;;
        list)
            explore-list "$@"
            ;;
        resume)
            explore-resume "$@"
            ;;
        doctor)
            explore-doctor "$@"
            ;;
        save-notes)
            explore-save-notes "$@"
            ;;
        help|-h|--help)
            explore-help
            ;;
        *)
            echo "❌ Unknown explore command: $cmd"
            echo ""
            explore-help
            return 1
            ;;
    esac
}
