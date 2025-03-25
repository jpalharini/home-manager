{ config, pkgs, ... }:

{
  programs = {
    git = {
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
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        core.fsMonitor = true;
        gpg.format = "ssh";
      };
      ignores = [
        ".idea/"
        ".nrepl-port"
        "*.iml"
      ];
    };
    lazygit.enable = true;
  };
  
  home.file = {
    ".config/lazygit/themes/catppuccin-mocha-mauve.yml".source = (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/lazygit/refs/heads/main/themes-mergable/mocha/mauve.yml";
      sha256 = "19plm6zg2xs0bimbbcf3bq122qdhydxjn2z147n2mbshylnkz40i";
    });
  };

  home.packages = with pkgs; [
    bfg-repo-cleaner
    git-crypt
  ];

  programs.zsh.shellAliases = {
    g = "git";
    lazygit = "lazygit --use-config-file=\"$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/themes/catppuccin-mocha-mauve.yml\"";
    lg = "lazygit";
  };
}
