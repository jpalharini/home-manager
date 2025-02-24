{ config, pkgs, ... }:

{
  imports = [
    ./modules/aerospace.nix
    ./modules/packages.nix
    ./modules/users.nix
  ];
  
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
      trusted-users = ["joao.palharini"];
      max-jobs = 4;
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
