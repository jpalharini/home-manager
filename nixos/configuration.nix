# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/virtualization.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
  
    zfs = {
      package = pkgs.zfs_unstable;
    };

    kernelParams = [
      "console=tty1"
      # Set ZFS ARC to 100 GB
      "zfs.zfs_arc_max=107374182400"
    ]; 
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "jpalharini" ];
    auto-optimise-store = true;
    cores = 16;
    max-jobs = 16;
  };

  services = {
    envfs.enable = true;

    greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "jpalharini";
        };
      };
    };
    
    openssh = {
      enable = true;
      settings = {
        AllowUsers = [ "jpalharini" ];
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = true;
      };
    };
    
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    u9fs.enable = true;

    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
  };

  programs = {
    hyprland.enable = true;
    zsh.enable = true;
  };
  
  environment = {
    systemPackages = with pkgs; [
      curl
      git
      neovim
      wget
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      EDITOR = "neovim";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

