{ config, pkgs, ... }:

{
  imports = [
    ./modules/aerospace.nix
    ./modules/packages.nix
    ./modules/users.nix
  ];
  
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  
  environment = {
    etc."pam.d/sudo_local".text = ''
      auth    optional    /opt/homebrew/lib/pam/pam_reattach.so
      auth    sufficient  pam_tid.so
    '';
    extraOutputsToInstall = [ "/lib" ];
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
