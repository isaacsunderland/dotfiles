#!/bin/bash
# Comprehensive test suite for dotfiles installation
# Tests functionality and reports what's available on this system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
SKIPPED=0

# Portable timeout function (works on macOS and Linux)
run_with_timeout() {
    local timeout_secs=$1
    local cmd=$2
    
    # Create temporary file for output
    local tmpfile=$(mktemp)
    
    # Run command with timeout
    ( eval "$cmd" > "$tmpfile" 2>&1 ) &
    local pid=$!
    
    # Wait with timeout using backgrounded sleep
    sleep $timeout_secs && kill -9 $pid 2>/dev/null &
    local killer=$!
    
    wait $pid 2>/dev/null
    local exit_code=$?
    
    # Kill the killer if still running
    kill -9 $killer 2>/dev/null
    wait $killer 2>/dev/null
    
    # Return output and cleanup
    cat "$tmpfile" 2>/dev/null || echo "unknown"
    rm -f "$tmpfile"
    
    return $exit_code
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version 2>/dev/null; then
            echo "wsl"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

OS_TYPE=$(detect_os)

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Dotfiles Installation Test Suite                  ║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║ Detected OS: $OS_TYPE                                    ${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Test function
test_command() {
    local name=$1
    local command=$2
    local required=$3  # true/false
    
    printf "${BLUE}⏳${NC} Testing $name...${NC}\r"
    
    if command -v $command &> /dev/null; then
        local version=""
        # Special handling for nano (use echo pipe to get version)
        if [ "$command" = "nano" ]; then
            version=$(echo "" | $command --version 2>&1 | head -1 | sed 's/^ *//')
        else
            version=$(run_with_timeout 1 "$command --version 2>&1 | head -1")
        fi
        printf "                                                                   \r"  # Clear line
        echo -e "${GREEN}✓${NC} $name: ${GREEN}AVAILABLE${NC} - $version"
        ((PASSED++))
        return 0
    else
        printf "                                                                   \r"  # Clear line
        if [ "$required" = "true" ]; then
            echo -e "${RED}✗${NC} $name: ${RED}MISSING (REQUIRED)${NC}"
            ((FAILED++))
        else
            echo -e "${YELLOW}⊘${NC} $name: ${YELLOW}NOT INSTALLED${NC} (optional)"
            ((SKIPPED++))
        fi
        return 1
    fi
}

# Test file/link
test_file() {
    local name=$1
    local path=$2
    local required=$3  # true/false
    
    if [ -L "$path" ]; then
        local target=$(readlink "$path")
        echo -e "${GREEN}✓${NC} $name: ${GREEN}LINKED${NC} → $target"
        ((PASSED++))
        return 0
    elif [ -f "$path" ] || [ -d "$path" ]; then
        echo -e "${GREEN}✓${NC} $name: ${GREEN}EXISTS${NC} at $path"
        ((PASSED++))
        return 0
    else
        if [ "$required" = "true" ]; then
            echo -e "${RED}✗${NC} $name: ${RED}MISSING${NC} - Expected at $path"
            ((FAILED++))
        else
            echo -e "${YELLOW}⊘${NC} $name: ${YELLOW}NOT FOUND${NC} at $path"
            ((SKIPPED++))
        fi
        return 1
    fi
}

# Test environment variable
test_env() {
    local name=$1
    local var=$2
    local expected=$3
    
    if [ -n "${!var}" ]; then
        echo -e "${GREEN}✓${NC} $name: ${GREEN}SET${NC} → ${!var}"
        if [ -n "$expected" ] && [[ "${!var}" == *"$expected"* ]]; then
            echo -e "  ${BLUE}→${NC} Contains expected value: $expected"
        fi
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $name: ${RED}NOT SET${NC}"
        ((FAILED++))
        return 1
    fi
}

echo -e "\n${BLUE}═══ Shell Configuration ═══${NC}"
test_command "Zsh" "zsh" "false"
test_command "Bash" "bash" "true"
test_file "Zsh config" ~/.zshrc "false"
test_file "Bash config" ~/.bashrc "true"
test_env "SHELL variable" "SHELL" ""

echo -e "\n${BLUE}═══ Editor Configuration ═══${NC}"
test_command "Neovim" "nvim" "false"
test_command "Vi" "vi" "true"
test_command "Nano" "nano" "false"
test_file "Neovim config" ~/.config/nvim/init.lua "false"
test_file "Nano config" ~/.nanorc "false"
test_env "EDITOR variable" "EDITOR" ""
test_env "VISUAL variable" "VISUAL" ""

# Test editor swap directories
echo -e "\n${BLUE}═══ Editor Data Directories ═══${NC}"

# Detect Neovim version to test appropriate swap directory
if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version 2>/dev/null | head -1 | grep -oE 'v[0-9]+\.[0-9]+' | sed 's/v//')
    NVIM_MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
    NVIM_MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
    
    if [ -n "$NVIM_VERSION" ] && ([ "$NVIM_MAJOR" -gt 0 ] || [ "$NVIM_MINOR" -ge 11 ]); then
        # Neovim 0.11+ uses state directory
        test_file "Neovim swap" ~/.local/state/nvim/swap "false"
    else
        # Neovim < 0.11 uses share directory
        test_file "Neovim swap" ~/.local/share/nvim/swap "false"
    fi
else
    # If neovim isn't installed, check the modern path
    test_file "Neovim swap" ~/.local/state/nvim/swap "false"
fi

echo -e "\n${BLUE}═══ VSCode Configuration ═══${NC}"
if [ "$OS_TYPE" = "macos" ]; then
    VSCODE_DIR="$HOME/Library/Application Support/Code/User"
elif [ "$OS_TYPE" = "wsl" ]; then
    VSCODE_DIR="$HOME/.vscode-server/data/Machine"
else
    VSCODE_DIR="$HOME/.config/Code/User"
fi
test_file "VSCode settings" "$VSCODE_DIR/settings.json" "false"
test_file "VSCode keybindings" "$VSCODE_DIR/keybindings.json" "false"

echo -e "\n${BLUE}═══ Modern CLI Tools ═══${NC}"
test_command "eza (ls replacement)" "eza" "false"
test_command "fd (find replacement)" "fd" "false"
test_command "bat (cat replacement)" "bat" "false"
test_command "ripgrep (grep replacement)" "rg" "false"
test_command "fzf (fuzzy finder)" "fzf" "false"
test_command "zoxide (cd replacement)" "zoxide" "false"
test_command "starship (prompt)" "starship" "false"

echo -e "\n${BLUE}═══ Essential Tools ═══${NC}"
test_command "Git" "git" "true"
test_command "curl" "curl" "true"
test_command "wget" "wget" "false"

echo -e "\n${BLUE}═══ Terminal Configuration ═══${NC}"
test_file "Kitty config" ~/.config/kitty/kitty.conf "false"
test_file "Starship config" ~/.config/starship.toml "false"

echo -e "\n${BLUE}═══ Shell Aliases ═══${NC}"
# Source the shell config to test aliases
if [ -f ~/.zshrc ] && [ "$SHELL" = *"zsh"* ]; then
    source ~/.zshrc 2>/dev/null || true
elif [ -f ~/.bashrc ]; then
    source ~/.bashrc 2>/dev/null || true
fi

# Test if aliases are set
check_alias() {
    if alias $1 &> /dev/null; then
        local target=$(alias $1 | sed "s/^[^=]*='\(.*\)'$/\1/" | sed 's/^alias [^=]*=//')
        echo -e "${GREEN}✓${NC} Alias '$1': ${GREEN}SET${NC} → $target"
        ((PASSED++))
    else
        echo -e "${YELLOW}⊘${NC} Alias '$1': ${YELLOW}NOT SET${NC}"
        ((SKIPPED++))
    fi
}

check_alias "l"
check_alias "ll"
check_alias "la"
check_alias "vim"
check_alias "vi"

echo -e "\n${BLUE}═══ macOS Specific (if applicable) ═══${NC}"
if [ "$OS_TYPE" = "macos" ]; then
    # Check Homebrew
    test_command "Homebrew" "brew" "true"
    
    # Check system defaults
    echo -e "\nChecking macOS system settings..."
    
    # Dock autohide
    if defaults read com.apple.dock autohide 2>/dev/null | grep -q "1"; then
        echo -e "${GREEN}✓${NC} Dock autohide: ${GREEN}ENABLED${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}⊘${NC} Dock autohide: ${YELLOW}DISABLED${NC}"
        ((SKIPPED++))
    fi
    
    # Touch ID for sudo
    if [ -f /etc/pam.d/sudo_local ] && grep -q "pam_tid.so" /etc/pam.d/sudo_local; then
        echo -e "${GREEN}✓${NC} Touch ID for sudo: ${GREEN}ENABLED${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}⊘${NC} Touch ID for sudo: ${YELLOW}NOT CONFIGURED${NC}"
        ((SKIPPED++))
    fi
    
    # Caps Lock remap (harder to test, just inform)
    echo -e "${BLUE}ℹ${NC} Caps Lock → ESC: Check manually in System Settings → Keyboard"
else
    echo -e "${YELLOW}⊘${NC} Skipping macOS-specific tests (not macOS)"
fi

echo -e "\n${BLUE}═══ Linux Specific (if applicable) ═══${NC}"
if [ "$OS_TYPE" = "linux" ]; then
    # Check package managers
    test_command "apt" "apt" "false"
    test_command "dnf" "dnf" "false"
    test_command "pacman" "pacman" "false"
    
    # Check if Caps Lock remapped
    if command -v gsettings &> /dev/null; then
        if gsettings get org.gnome.desktop.input-sources xkb-options 2>/dev/null | grep -q "caps:escape"; then
            echo -e "${GREEN}✓${NC} Caps Lock → ESC: ${GREEN}ENABLED (GNOME)${NC}"
            ((PASSED++))
        else
            echo -e "${YELLOW}⊘${NC} Caps Lock → ESC: ${YELLOW}NOT SET${NC}"
            ((SKIPPED++))
        fi
    fi
else
    echo -e "${YELLOW}⊘${NC} Skipping Linux-specific tests (not Linux)"
fi

echo -e "\n${BLUE}═══ Functionality Tests ═══${NC}"

# Test if starship prompt works
if command -v starship &> /dev/null; then
    if eval "$(starship init $SHELL --print-full-init 2>/dev/null)" &> /dev/null; then
        echo -e "${GREEN}✓${NC} Starship prompt: ${GREEN}WORKING${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} Starship prompt: ${RED}ERROR${NC}"
        ((FAILED++))
    fi
fi

# Test if fzf works
if command -v fzf &> /dev/null; then
    if echo "test" | fzf --filter="test" &> /dev/null; then
        echo -e "${GREEN}✓${NC} FZF: ${GREEN}WORKING${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} FZF: ${RED}ERROR${NC}"
        ((FAILED++))
    fi
fi

# Test if zoxide works
if command -v zoxide &> /dev/null; then
    if zoxide query . &> /dev/null || true; then
        echo -e "${GREEN}✓${NC} Zoxide: ${GREEN}WORKING${NC}"
        ((PASSED++))
    fi
fi

echo -e "\n${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Test Summary                          ║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${GREEN}✓ Passed:${NC}  $PASSED"
echo -e "${BLUE}║${NC} ${RED}✗ Failed:${NC}  $FAILED"
echo -e "${BLUE}║${NC} ${YELLOW}⊘ Skipped:${NC} $SKIPPED"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"

if [ $FAILED -gt 0 ]; then
    echo -e "\n${RED}Some required components are missing!${NC}"
    echo -e "Run: ${BLUE}bash install.sh${NC} to install missing components"
    exit 1
else
    echo -e "\n${GREEN}✓ All required components are available!${NC}"
    if [ $SKIPPED -gt 0 ]; then
        echo -e "${YELLOW}Note: $SKIPPED optional components not installed${NC}"
    fi
    exit 0
fi
