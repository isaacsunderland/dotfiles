# home.nix
# home-manager switch 

{ config, pkgs, lib, ... }:

let
  starshipConfig = import ./starship.nix { inherit lib; };
  zshConfig = import ./zsh.nix { inherit lib; };
  kittyConfig = import ./kitty.nix { inherit lib; };
in
{
  home.username = "isaacsunderland";
  home.homeDirectory = lib.mkDefault "/Users/isaacsunderland";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [

    pkgs.starship
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".zshrc".source = ~/dotfiles/zshrc/.zshrc;
    ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
    ".amethyst.yml".source = ~/dotfiles/amethyst/.amethyst.yml;
  };

  home.sessionVariables = { };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "/.nix-profile/bin"
  ];

  programs.starship = starshipConfig.programs.starship;
  programs.kitty = kittyConfig.programs.kitty;
  programs.zsh = zshConfig.programs.zsh;
  
  programs.zoxide.enableZshIntegration = true;
  programs.home-manager.enable = true;

  


}
