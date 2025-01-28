{ config, lib, pkgs, ... }:

let
  deps = {
    bat-catppuccin-theme = 
      (builtins.fetchurl { 
        url = "https://raw.githubusercontent.com/catppuccin/bat/refs/heads/main/themes/Catppuccin%20Mocha.tmTheme";
        name = "CatppuccinMocha.tmTheme";
        sha256 = "1algv6hb3sz02cy6y3hnxpa61qi3nanqg39gsgmjys62yc3xngj6";
      });
    yazi-catppuccin-theme =
      (builtins.fromTOML(
        (builtins.readFile(
          (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/yazi/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml";
            sha256 = "1q0in5gzviczcqxfx1kk624pajbzdw3cardkbvma5bjbv3kiz276";
          })))));
  };

in {
  home.file = {
    ".p10k.zsh".source = ./zsh.d/p10k.zsh;

    ".config/bat/themes/CatppuccinMocha.tmTheme" = {
      source = deps.bat-catppuccin-theme;
      onChange = "bat cache --build";
    };

    ".config/bat/config".text = ''
      --theme="CatppuccinMocha"
    '';
  };

  programs = {
    zsh = {
      enable = true;

      antidote = {
        enable = true;
        plugins = [
          "romkatv/powerlevel10k"
          "Aloxaf/fzf-tab"
        ];
      };

      autocd = true;

      autosuggestion = {
        enable = true;
      };

      defaultKeymap = "emacs";

      history = {
        append = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        save = 10000;
        size = 10000;
      };

      syntaxHighlighting = {
        enable = true;
      };

      initExtraFirst = ''
        typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
      '';

      initExtra = /*bash*/ ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # set word boundaries for nav and delete
        autoload -U select-word-style
        select-word-style bash

        setopt interactivecomments 

        # fix delete key
        bindkey "^[[3~" delete-char

        zstyle 'completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive completion
      '';

      localVariables = {
        EDITOR = "nvim";
        LESS = "--mouse -R";
        XDG_CONFIG_HOME = "$HOME/.config";
      };

      shellAliases = {
        sudoe = "sudo -E -s";

        cat = "bat";
        ls = "eza";
        vim = "nvim";
        v = "nvim";
        sshpass = "ssh -o PreferredAuthentications=password";

        rel = "source reload-config";
        hmsr = "hms && rel";

        nixsh = "nix-shell --command zsh";
        nixpkgs = "f() { nix search nixpkgs $1 2>/dev/null }; f";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      theme = lib.attrsets.overrideExisting deps.yazi-catppuccin-theme { manager.syntect_theme = deps.bat-catppuccin-theme; };
    };
  };

  home.packages = with pkgs; [
    bat
    btop
  ];
}
