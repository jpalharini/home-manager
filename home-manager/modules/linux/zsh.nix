{ config, pkgs, ... }:

{
  programs.zsh = {
    initExtra = /*bash*/ ''
      export JAVA_HOME=${pkgs.corretto21}
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
    '';

    shellAliases = {
      nixr = "sudo nixos-rebuild switch --flake ~/.config/nix";
      hms = "home-manager switch --flake ~/.config/nix";

      java11 = "export JAVA_HOME=${pkgs.corretto11}";
      java17 = "export JAVA_HOME=${pkgs.corretto17}";
      java21 = "export JAVA_HOME=${pkgs.corretto21}";
    };
  };
}
