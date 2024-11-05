{ pkgs, ... }:

{
  home.packages = with pkgs; [
    catppuccin-cursors.frappeMauve
    walker
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-1, 3840x2160@60, 0x0, 1.50"
        "DP-3, 2560x1440@60, auto-left, 1, transform, 3"
      ];

      "$mod" = "SUPER";

      exec-once = "walker --gapplication-service";

      bind = [
        "$mod, W, killactive,"
        "$mod, Up, movefocus, u"
        "$mod, Left, movefocus, l"
        "$mod, Down, movefocus, d"
        "$mod, Right, movefocus, r"

        "SUPER_SHIFT, code:192, exit,"
        "SUPER_SHIFT, F, togglefloating,"
        "SUPER_SHIFT, Return, fullscreen,"

        "$mod, space, exec, walker"
        "$mod, B, exec, firefox"
        "$mod, T, exec, kitty"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "NVD_BACKEND,direct"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "MOZ_ENABLE_WAYLAND,1"
        "XCURSOR_THEME,catppuccin-frappe-mauve-cursors"
        "XCURSOR_SIZE,24"
      ];

      cursor.no_hardware_cursors = true;

      general = {
        gaps_in = 0;
        gaps_out = 0;
        resize_on_border = true;
      };

      animation = [
        "windows, 1, 1, default"
      ];

      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 0.8;
      };

      input = {
        numlock_by_default = true;
        follow_mouse = 2;
      };

      windowrulev2 = [
        "float, class:(Zoom Workplace)"
        "move onscreen cursor -5% 0, class:(Zoom Workplace), title:(menu window)"
        "decorate off, class:(Zoom Workplace)"
      ];
    };
  };

  # Requires 'security.pam.services.hyprlock = {}' in NixOS configuration
  programs.hyprlock = {
    enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 12;
    };
  };
}
