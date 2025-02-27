{ pkgs, inputs, ... }:

{
  services.syncthing = {
    tray.enable = false;
    guiAddress = "10.0.10.20:8384";
    settings = {
      folders = {
        jpalharini-dev = {
          devices = [ "nu-mac" ];
        };
        jpalharini-m2 = {
          devices = [ "nu-mac" ];
        };
      };
      devices = {
        nu-mac = {
          addresses = [
            "tcp://10.0.20.20:22000"
            "tcp://10.0.20.21:22000"
          ];
          id = builtins.readFile "${inputs.secrets}/syncthing/nu-mac";
        };
      };
    };
  };
}
