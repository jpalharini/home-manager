{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Joao Palharini";
    userEmail = "joao@palharini.me";
    aliases = {
      co = "checkout";
      nb = "checkout -b";
      p = "pull";
      P = "push";
    };
    lfs = {
      enable = true;
      skipSmudge = true;
    };
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjJgxosQs2YuD1zrCtlO8iWhmtRd8T7cHFQLo57zPKt";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranche = "main";
      push.autoSetupRemote = true;
      core.fsMonitor = true;
      gpg.format = "ssh";
    };
  };

  programs.lazygit.enable = true;
  
  home.file = {
    ".config/lazygit/themes/catppuccin-mocha-mauve.yml".source = (builtins.fetchurl "https://raw.githubusercontent.com/catppuccin/lazygit/refs/heads/main/themes-mergable/mocha/mauve.yml");
  };

  programs.zsh.shellAliases = {
    g = "git";
    lazygit = "lazygit --use-config-file=\"$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/themes/catppuccin-mocha-mauve.yml\"";
    lg = "lazygit";
  };
}
