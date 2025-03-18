{ pkgs, ... }:

let

  scripts = {
    find-ignored = pkgs.writeShellScriptBin "syncthing-find-ignored" /*bash*/ ''
      ROOT_FOLDER="''${1:-$(pwd)}"

      if [ -f "$ROOT_FOLDER/.stignore" ]; then
        pushd ~/dev/misc/syncthing/cmd/dev/stfindignored
        go run main.go "$ROOT_FOLDER" 2>/dev/null
      else
        echo "ERROR: .stignore file not found"
      fi
    '';
  };

in {
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

  home.packages = [
    scripts.find-ignored
  ];
}
