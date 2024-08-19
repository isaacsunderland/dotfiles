{ pkgs ? import <nixpkgs> {} }:

let
  homeDir = builtins.getEnv "HOME";
  dotfilesDir = "${homeDir}/dotfiles";
in
pkgs.runCommand "print-env" {} ''
  echo "homeDir: ${homeDir}"
  echo "dotfilesDir: ${dotfilesDir}"
  touch $out
''