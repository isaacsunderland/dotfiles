{ lib, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      format =
        let
          # https://starship.rs/config/#prompt
          modules = [
            # displayed in order
            "shell" # moved this
            "username"
            "hostname"
            "localip"
            "shlvl"
            "singularity"
            "kubernetes"
            "directory"
            "vcsh"
            "fossil_branch"
            "git_branch"
            "git_commit"
            "git_state"
            "git_metrics"
            "git_status"
            "hg_branch"
            "pijul_channel"
            "docker_context"
            "package"
            "c"
            "cmake"
            "cobol"
            "daml"
            "dart"
            "deno"
            "dotnet"
            "elixir"
            "elm"
            "erlang"
            "fennel"
            "golang"
            "guix_shell"
            "haskell"
            "haxe"
            "helm"
            "java"
            "julia"
            "kotlin"
            "gradle"
            "lua"
            "nim"
            "nodejs"
            "ocaml"
            "opa"
            "perl"
            "php"
            "pulumi"
            "purescript"
            "python"
            "raku"
            "rlang"
            "red"
            "ruby"
            "rust"
            "scala"
            "solidity"
            "swift"
            "terraform"
            "vlang"
            "vagrant"
            "zig"
            "buf"
            "nix_shell"
            "conda"
            "meson"
            "spack"
            "memory_usage"
            "aws"
            "gcloud"
            "openstack"
            "azure"
            "env_var"
            "crystal"
            "custom"
            "sudo"
            "time" # moved this
            "cmd_duration"
            "line_break"
            "jobs"
            "battery"
            # "time"
            "status"
            "os"
            "container"
            # "shell"
            "character"
          ];
        in
        lib.concatMapStrings (m: "$" + m) modules;

      directory = {
        style = "blue";
      };

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      git_state = {
        format = "\([ $state ($progress_current/$progress_total) ] ($style)\) ";
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };
    };
  };
}