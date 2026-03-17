#!/usr/bin/env bash
# Install dual-worktree workflow tools into dotfiles
# Usage: ./install-workflow.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$HOME/dotfiles"
SHELL_CONFIG_DIR="$DOTFILES_ROOT/config/shell"

echo "🚀 Installing Dual-Worktree Workflow Tools"
echo "==========================================="
echo ""

# Ensure dotfiles exist
if [ ! -d "$DOTFILES_ROOT" ]; then
    echo "❌ Dotfiles directory not found at: $DOTFILES_ROOT"
    echo "   Please adjust DOTFILES_ROOT in this script"
    exit 1
fi

echo "✓ Found dotfiles at: $DOTFILES_ROOT"
echo ""

# Check if explore.sh exists
if [ -f "$SHELL_CONFIG_DIR/explore.sh" ]; then
    echo "✓ explore.sh already installed"
else
    echo "⚠️  explore.sh not found (expected at $SHELL_CONFIG_DIR/explore.sh)"
fi

# Check if ralph.sh exists
if [ -f "$SHELL_CONFIG_DIR/ralph.sh" ]; then
    echo "✓ ralph.sh already installed"
else
    echo "❌ ralph.sh not found"
    echo "   Expected at: $SHELL_CONFIG_DIR/ralph.sh"
    exit 1
fi

# Ensure common.sh sources both tools
if ! grep -q "ralph.sh" "$SHELL_CONFIG_DIR/common.sh"; then
    echo "➕ Adding ralph.sh to common.sh..."
    
    cat >> "$SHELL_CONFIG_DIR/common.sh" <<'EOF'

# Ralph execution loop helpers
if [ -f "$HOME/.config/shell/ralph.sh" ]; then
    source "$HOME/.config/shell/ralph.sh"
fi
EOF
    echo "✓ Updated common.sh"
else
    echo "✓ common.sh already sources ralph.sh"
fi

echo ""
echo "📋 Installation Summary"
echo "======================="
echo ""
echo "Installed tools:"
echo "  • explore  - Exploration worktree manager"
echo "  • ralph    - Execution loop manager"
echo ""
echo "Next steps:"
echo "  1. Reload your shell: exec zsh  (or: exec bash)"
echo "  2. Verify: explore --help && ralph --help"
echo "  3. Try it: cd <your-repo> && ralph init"
echo ""
echo "📚 Documentation: ~/prj/notes/notes/dual-worktree-workflow.md"
echo ""
echo "✅ Installation complete!"
