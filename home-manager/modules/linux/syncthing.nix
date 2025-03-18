{ pkgs, secrets, ... }:

{
  services.syncthing = {
    guiAddress = "0.0.0.0:8384";
    settings = {
      folders = {
        jpalharini-dev = {
          devices = [
            "nu-mac"
            "k8s-worker-1"
            "k8s-worker-2"
            "k8s-worker-3"
          ];
        };
        jpalharini-m2 = {
          devices = [
            "nu-mac"
            "k8s-worker-1"
            "k8s-worker-2"
            "k8s-worker-3"
          ];
        };
      };
      devices = {
        nu-mac = {
          addresses = [
            "tcp://10.0.10.30:22000"
            "tcp://10.0.20.30:22000"
          ];
          id = secrets.syncthing.nu-mac;
          compression = "never";
        };
        k8s-worker-1 = {
          addresses = [
            "tcp://10.20.0.21:22000"
          ];
          id = secrets.syncthing.k8s-worker-1;
          compression = "never";
        };
        k8s-worker-2 = {
          addresses = [
            "tcp://10.20.0.22:22000"
          ];
          id = secrets.syncthing.k8s-worker-2;
          compression = "never";
        };
        k8s-worker-3 = {
          addresses = [
            "tcp://10.20.0.23:22000"
          ];
          id = secrets.syncthing.k8s-worker-3;
          compression = "never";
        };
      };
    };
  };
}
