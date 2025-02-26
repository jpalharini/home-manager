{ ... }:

{
  services.syncthing = {
    enable = true;
    settings = {
      overrideDevices = false;
      overrideFolders = false;
      folders = {
        jpalharini-dev = {
          label = "dev";
          path = "~/dev";
          type = "sendreceive";
        };
        jpalharini-m2 = {
          label = "maven";
          path = "~/.m2";
          type = "sendreceive";        
        };
      };
      options = {
        urAccepted = -1;
        localAnnounceEnabled = true;
        relaysEnabled = false;
        natEnabled = false;
        globalAnnounceEnabled = false;
      };
    };
  };
}
