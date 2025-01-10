{ pkgs, ... }:

let
  keys = {
    home-servers-private = (builtins.readFile ~/.vpn/home/servers/private.key);
    home-servers-psk = (builtins.readFile ~/.vpn/home/servers/psk.key);
    home-servers-public = (builtins.readFile ~/.vpn/home/servers/public.key);
    home-servers-instance = (builtins.readFile ~/.vpn/home/servers/instance.key);
  };

in {
  home.packages = [
    pkgs.wireguard-tools
  ];

  home.file = {
    ".vpn/home/servers.conf".text = ''
      [Interface]
      PrivateKey = ${keys.home-servers-private}
      Address = 10.10.10.100/32
      DNS = 10.0.10.1

      [Peer]
      PublicKey = ${keys.home-servers-instance}
      PresharedKey = ${keys.home-servers-psk}
      AllowedIPs = 10.10.10.0/24, 10.0.1.0/24, 10.0.10.0/24
      Endpoint = 168.194.57.147:51910
    '';
  };
}
