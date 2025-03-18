{ config, pkgs, ... }:

{
  networking = {
    bridges = {
      vmbr0 = {
        interfaces = [
          "ens6f0np0"
        ];
      };
    };
    interfaces.vmbr0.useDHCP = true;
    extraHosts = ''
      10.20.0.11 k8s-control-plane-1
      10.20.0.12 k8s-control-plane-2
      10.20.0.13 k8s-control-plane-3

      10.20.0.21 k8s-worker-1
      10.20.0.22 k8s-worker-2
      10.20.0.23 k8s-worker-3
    '';
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
