{ config, pkgs, ... }:

{
  programs.zsh.shellAliases = {
    g = "git";
  };

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
}
