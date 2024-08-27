{
  description = "Isaac's Macbook Pro M2 system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
	        pkgs.vim
          pkgs.stow
          pkgs.kitty
          pkgs.github-copilot-cli
          pkgs.fzf
          pkgs.zoxide
          pkgs.eza
          pkgs.nixpkgs-fmt
        ];


      
      services.nix-daemon.enable = true;
      nixpkgs.config.allowUnfree = true;      
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;  # default shell on catalina
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;

      users.users.isaacsunderland.home = "/Users/isaacsunderland";
      home-manager.backupFileExtension = "backup";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      system.defaults = {
        spaces.spans-displays = true;
	      dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        screencapture.location = "~/Pictures/screenshots";
        NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        NSGlobalDomain.AppleShowAllFiles = true;
        # NSGlobalDomain.NSDisableAutomaticTermination = true;
        # NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
        NSGlobalDomain.AppleFontSmoothing = 2;
        screensaver.askForPassword = false;
        finder._FXShowPosixPathInTitle = true;
        finder.AppleShowAllFiles = true;
        dock.wvous-bl-corner = 13;
        dock.tilesize = 24;
        dock.show-recents = false;
      };	





      # Homebrew needs to be installed on its own!
      homebrew.enable = true;
      homebrew.casks = [
        "google-chrome"
        "microsoft-remote-desktop"
        "vmware-horizon-client"
        "amethyst"
        "bitwarden"
        "docker"
        "openvpn-connect"
        "bitwarden"
        "zoom"
        "github"
        "dbeaver-community"
        "drawio"
	      "visual-studio-code"
	      "postman"
        "font-fira-code-nerd-font"
      ];
      homebrew.brews = [
	      
      ];

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Isaacs-MacBook-Pro
    darwinConfigurations."Isaacs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.isaacsunderland = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Isaacs-MacBook-Pro".pkgs;
  };
}
