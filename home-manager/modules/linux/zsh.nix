{ config, pkgs, ... }:

{
  programs.zsh = {
    initExtra = /*bash*/ ''
      export JAVA_HOME=${pkgs.corretto21}
    '';

    shellAliases = {
      nixr = "sudo nixos-rebuild switch";
      hms = "home-manager switch -f ~/.config/home-manager/linux.nix";

      java11 = "export JAVA_HOME=${pkgs.corretto11}";
      java17 = "export JAVA_HOME=${pkgs.corretto17}";
      java21 = "export JAVA_HOME=${pkgs.corretto21}";
    };
  };
}
