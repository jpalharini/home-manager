{ config, pkgs, ... }:

{
  home.username = "jpalharini";
  home.homeDirectory = "/home/jpalharini";

  imports = [
    ./common.nix
    ./modules/linux/packages.nix
    ./modules/linux/hyprland.nix
    ./modules/linux/zsh.nix
    ./modules/linux/ssh.nix
    ./modules/linux/kubernetes.nix
    ./modules/linux/aws.nix
  ];

  home.stateVersion = "24.05";
}
