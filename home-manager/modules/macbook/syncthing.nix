{ pkgs, inputs, ... }:

{
  services.syncthing = {
    tray.enable = false;
    settings = {
      folders = {
        jpalharini-dev = {
          devices = [ "nu-precision" ];
        };
        jpalharini-m2 = {
          devices = [ "nu-precision" ];
        };
      };
      devices = {
        nu-precision = {
          addresses = [
            "tcp://10.0.10.20:22000"
          ];
          id = builtins.readFile "${inputs.secrets}/syncthing/nu-precision";
        };
      };
    };
  };

  home.packages = [
    pkgs.syncthingtray
  ];
}
