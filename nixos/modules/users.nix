{ pkgs, ... }:

{
  users.users = {
    jpalharini = {
      isNormalUser = true;
      linger = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzBdEtIawSqoFkhPbeMIKel6C2JvDJwBgZE8sonhpb6" # 1password
      ];
    };
  };

  services.syncthing = {
    enable = true;
    user = "jpalharini";
    guiAddress = "10.0.10.20:8384";
    dataDir = "/home/jpalharini/syncthing";
    settings = {
      options.urAccepted = -1;
      overrideDevices = false;
      devices = {
        nu-mac = {
          addresses = [
            "tcp://10.0.20.20:22000"
            "tcp://10.0.20.21:22000"
          ];
          id = "BDCJFDP-2GRHZ5W-R7SRRCY-UBNIXMH-6WDT5NZ-ZNNMUHF-6XS7ZB6-NXE4RQB";
        };
      };
      folders = {
        dev = {
          id = "jpalharini-dev";
          type = "sendreceive";
          path = "/home/jpalharini/dev";
          devices = [ "nu-mac" ];
        };
        maven = {
          id = "joao-maven";
          type = "sendreceive";
          devices = [ "nu-mac" ];
          path = "/home/jpalharini/.m2";
        };
      };
    };
  };
}
