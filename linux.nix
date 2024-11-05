{ config, pkgs, ... }:

{
  home.username = "jpalharini";
  home.homeDirectory = "/home/jpalharini";

  imports = [
    ./common.nix
    ./modules/linux/packages.nix
    ./modules/linux/hyprland.nix
    ./modules/linux/zsh.nix
    ./modules/linux/kubernetes.nix
  ];

  services = {
    syncthing = {
      enable = true;
      extraOptions = [
        "--gui-address=10.0.10.20:8384"
        "--config=$HOME/.config/syncthing"
        "--data=$HOME/syncthing"
      ];
    };
  };

  home.stateVersion = "24.05";
}
