{ lib, ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    keybindings = {
      "cmd+v" = "paste_from_clipboard";
      "cmd+c" = "copy_to_clipboard";
    };
    settings = {
      font_family = "FiraCode Nerd Font Mono";
      font_size = "14.0";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      enable_audio_bell = false;
      scrollback_lines = -1;
      tab_bar_edge = "top";
      allow_remote_control = "yes";
      shell_integration = "enabled";
      macos_option_as_alt = "yes";
      detect_urls = "no";
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";
      focus_follows_mouse = "yes";
      allows_hyperlinks = "no";
      mouse_map =
        let
          mouse_mappings =
            [
                "right press grabbed,ungrabbed no-op"
                "right click grabbed,ungrabbed paste_from_clipboard"
            ];
        in
         lib.concatMapStrings (m: "mouse_map " + m + "\n") mouse_mappings;

    };

    theme = "GitHub Dark";
    darwinLaunchOptions = [
      "--single-instance"
    ];

  };
}
