{ config, pkgs, ...}:

{
  home.packages = with pkgs; [
    _1password-cli
    alacritty
    firefox
    zoom-us
  ];
}
