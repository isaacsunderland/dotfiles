# Git explore worktree helpers for safe, isolated experimentation.
# Usage: explore-start, explore-stop, explore-list, explore-resume
# Customizable via env vars: GIT_EXPLORE_PREFIX, GIT_EXPLORE_BRANCH

# Configuration with sensible defaults
GIT_EXPLORE_PREFIX="${GIT_EXPLORE_PREFIX:-.explore}"
GIT_EXPLORE_BRANCH="${GIT_EXPLORE_BRANCH:-explore}"

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
}

# Create and initialize explore worktree from current branch
explore-start() {
    set -euo pipefail

    local root
    root="$(_git_root)" || {
        echo "❌ Not inside a git repository."
        return 1
    }

    local current_branch
    current_branch="$(git rev-parse --abbrev-ref HEAD)"
    local exp_branch="${GIT_EXPLORE_BRANCH}"
    local wt
    wt="$(_explore_path)"

    echo "📍 Current branch: $current_branch"
    echo "🧪 Explore branch: $exp_branch"
    echo "📁 Worktree path: $wt"

    # Create explore branch from current branch if missing
    if ! git show-ref --verify --quiet "refs/heads/${exp_branch}"; then
        echo "⎇ Creating '${exp_branch}' from '${current_branch}'..."
        git fetch --all --prune 2>/dev/null || true
        git checkout -B "${exp_branch}" "${current_branch}" || {
            echo "❌ Failed to create/checkout explore branch"
            return 1
        }
        git checkout "${current_branch}" || {
            echo "❌ Failed to return to $current_branch"
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
        code -n "$wt" >/dev/null 2>&1 || true
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
        code -r "$wt"
    else
        echo "📂 Explore worktree path: $wt"
        echo "   cd $wt"
    fi
}

# Remove explore worktree safely
explore-stop() {
    set -euo pipefail

    local wt
    wt="$(_explore_path)"
    local exp_branch="${GIT_EXPLORE_BRANCH}"
    local current_branch
    current_branch="$(git rev-parse --abbrev-ref HEAD)"
    local force_flag="${1:-}"

    if [ ! -d "$wt" ]; then
        echo "✔ No explore worktree at $wt"
        return 0
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
        read -r -p "Reset '${exp_branch}' to '${current_branch}'? [y/N] " ans
        if [ "${ans:-N}" = "y" ] || [ "${ans:-N}" = "Y" ]; then
            git branch -f "$exp_branch" "$current_branch" || true
            echo "⟲ '$exp_branch' reset to '$current_branch'"
        fi
    fi

    echo "✅ Explore worktree removed."
}
