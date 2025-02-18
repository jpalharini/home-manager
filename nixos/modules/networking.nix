{ config, ... }:

{
  networking = {
    hostId = "f21341ca"; # required for zfs
    hostName = "nu-precision"; # Define your hostname.
    networkmanager.enable = false;  # Easiest to use and most distros use this by default.
    firewall = {
      enable = false;
      trustedInterfaces = [ "lo" "virbr0" ];
    };

    interfaces = {
      enp1s0 = {
        useDHCP = true;
        wakeOnLan = {
          enable = true;
          policy = [ "magic" ];
        };
      };
      enp142s0f0 = {
        useDHCP = true;
      };
    };
  };
}
