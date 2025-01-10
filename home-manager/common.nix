{ config, pkgs, ... }:

{
  imports = [ # order is important here
    ./modules/packages.nix
    ./modules/terminal.nix
    ./modules/zsh.nix
    ./modules/tmux.nix
    ./modules/ssh.nix
    ./modules/git.nix
    ./modules/kubernetes.nix
    ./modules/clojure.nix
    ./modules/espanso.nix
  ];

  programs.home-manager.enable = true;
}
