{ config, pkgs, ... }:

{
  boot.extraModprobeConfig = ''
    options nvidia_drm modeset=1 fbdev=1
  '';

  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
  ];

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = true;

    nvidiaSettings = true;

    # todo: change to stable once 560 is released
    # using beta because 560 is miles better for Wayland
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
