{ lib, ... }: {
  programs.zsh = {
    enable = true;
    #enablesyntaxHighlighting = true;
    enableCompletion = true;
    #enableFzfCompletion = true;
    #enableFzfGit = true;
    #enableFzfHistory = true;

    shellAliases = {
      l = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --long --icons --git";
      vim = "nvim";
    };
    localVariables = {
      # ZSH = "/Users/isaacsunderland/.oh-my-zsh";
      PATH = "/opt/homebrew/bin:$PATH";
      FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow";
      NIX_CONF_DIR = "$HOME/.config/nix";
    };
    initExtra = ''
      # Reevaluate the prompt string each time it's displaying a prompt
      # setopt prompt_subst
      # zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      # autoload bashcompinit && bashcompinit
      # autoload -Uz compinit
      # compinit
      # VI Mode!!!
      # bindkey jj vi-cmd-mode

      # FZF
      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

      # navigation
      cx() { cd "$@" && l; }
      fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
      f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
      fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }


    '';
  };
}
  
