{ config, pkgs, ... }:

{
  networking = {
    bridges = {
      vmbr0 = {
        interfaces = [
          "enp142s0f0"
        ];
      };
    };
    interfaces.vmbr0.useDHCP = true;
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };

    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
  programs.virt-manager.enable = true;

  systemd.services.libvirtd.serviceConfig.LimitNOFILE = 8192;

  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];

  environment.systemPackages = with pkgs; [
    qemu
  ];

  users.users.jpalharini.extraGroups = [ "kvm" "libvirtd" ];
}
