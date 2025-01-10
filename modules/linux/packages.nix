{ config, pkgs, ...}:

{
  home.packages = with pkgs; [
    _1password-cli
    alacritty
    eclipse-mat
    firefox
    gcc
    zip
    zoom-us
  ];
}
