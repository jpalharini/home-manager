{ config, pkgs, ... }:

{
  home.username = "joao.palharini";
  home.homeDirectory = "/Users/joao.palharini";

  imports = [
    ./common.nix
    ./modules/macbook/zsh.nix
    ./modules/macbook/ssh.nix
    ./modules/macbook/aerospace.nix
    ./modules/macbook/git.nix
    ./modules/macbook/kubernetes.nix
    ./modules/macbook/nubank.nix
  ];

  home.stateVersion = "24.05";
}
