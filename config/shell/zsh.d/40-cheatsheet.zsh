# zsh cheatsheet function.

cheatsheet() {
    cat << 'CHEATSHEET'
+--------------------------------------------------------------------+
|                 COMMAND CHEATSHEET AND QUICK REFERENCE             |
+--------------------------------------------------------------------+
|                                                                    |
|  LISTING AND NAVIGATION                                            |
|  ----------------------------------------------------------------  |
|  ls              Standard listing                                  |
|  l               List with details (eza/exa if installed)         |
|  ll              List long format (eza/exa if installed)          |
|  la              List all with details (eza/exa if installed)     |
|  lt              List tree view (eza if installed)                |
|  cd, cx          Change directory (cx also lists contents)        |
|  fcd             Fuzzy find and cd into directory                 |
|                                                                    |
|  SEARCHING AND FINDING                                             |
|  ----------------------------------------------------------------  |
|  find            Standard find command                            |
|  fdf             Fast find (fd alternative, if installed)         |
|  grep            Standard grep search                             |
|  rgp             Fast search (ripgrep alternative, if installed)  |
|  f               Fuzzy find file (copies path to clipboard)       |
|                                                                    |
|  FILE VIEWING                                                      |
|  ----------------------------------------------------------------  |
|  cat             Standard file display                            |
|  batcat          Syntax-highlighted cat (bat, if installed)       |
|                                                                    |
|  EDITING                                                           |
|  ----------------------------------------------------------------  |
|  vim             Editor (vim/nvim depending on installation)      |
|  vi              Editor (vim/nvim depending on installation)      |
|  fv              Fuzzy find and open file in editor               |
|                                                                    |
|  NAVIGATION SHORTCUTS                                              |
|  ----------------------------------------------------------------  |
|  ..              cd ../                                           |
|  ...             cd ../../                                        |
|  ....            cd ../../../                                     |
|  z <dir>         Jump to directory (zoxide)                       |
|                                                                    |
|  INSTALLED TOOLS                                                   |
|  ----------------------------------------------------------------  |
|  AVAILABLE:                                                        |
CHEATSHEET

    if command -v eza >/dev/null 2>&1; then
        echo "|    - eza (fast ls replacement)                                 |"
    fi
    if command -v fd >/dev/null 2>&1; then
        echo "|    - fd (fast find replacement)                                |"
    fi
    if command -v bat >/dev/null 2>&1; then
        echo "|    - bat (syntax-highlighted cat)                              |"
    fi
    if command -v rg >/dev/null 2>&1; then
        echo "|    - ripgrep (fast grep replacement)                           |"
    fi
    if command -v fzf >/dev/null 2>&1; then
        echo "|    - fzf (fuzzy finder)                                        |"
    fi
    if command -v zoxide >/dev/null 2>&1; then
        echo "|    - zoxide (smart cd replacement)                             |"
    fi

    cat << 'CHEATSHEET_END'
|                                                                    |
|  TIP: Install modern tools with:                                  |
|       brew install eza fd bat ripgrep fzf zoxide                  |
|                                                                    |
+--------------------------------------------------------------------+
CHEATSHEET_END
}