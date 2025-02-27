{ ... }:

{
  services.syncthing = {
    enable = true;
    tray.enable = false;
    settings = {
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
