{ pkgs, ... }:

{  
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [ (builtins.fetchurl {
        url = "https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml";
        sha256 = "1idjbm5jim9b36235hgwgp9ab81fmbij42y7h85l4l7cqcbyz74l";
      }) ];
      
      terminal.shell.program = "${pkgs.zsh}/bin/zsh";
      
      window = {
        decorations = "Full";
        decorations_theme_variant = "Dark";
        dimensions = {
          columns = 150;
          lines = 50;
        };
        padding = {
          x = 3;
          y = 3;
        };
        option_as_alt = "Both";
      };

      scrolling = {
        history = 100000;
        multiplier = 1;
      };

      font = {
        size = 16.0;
        offset.y = 1;
        normal.family = "JetBrainsMono Nerd Font";
        normal.style = "Regular";
        bold.style = "Bold";
        italic.style = "Italic";
      };

      cursor.style.shape = "Beam";

      keyboard.bindings = [
        {
          key = "D";
          mods = "Command";
          chars = "\\u0004";
        }
        {
          key = "Right";
          mods = "Alt";
          chars = "\\u001BF";
        }
        {
          key = "Left";
          mods = "Alt";
          chars = "\\u001BB";
        }
        {
          key = "Back";
          mods = "Command";
          chars = "\\u0015";
        }
      ];
    };
  };
}
