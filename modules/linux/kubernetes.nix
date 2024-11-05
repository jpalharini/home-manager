{ pkgs, ... }:

let
  scripts = {
    mkubed = (pkgs.writeShellScriptBin "mkubed" ''
      tmpdir="/tmp/mkubed"

      function start () {
        mkdir -p $tmpdir
        
        minikube start \
          --kubernetes-version=v1.29.9 \
          --driver=kvm2 \
          --container-runtime=docker \
          --cpus=16 \
          --memory=128g \
          --nodes=3

        minikube addons enable ingress
      }

      function stop() {
        echo "Stopping Minikube..."
        rm -rf $tmpdir
        minikube stop
      }

      function restart() {
        stop
        start
      }

      function recreate() {
        minikube delete
        start
      }

      $1
    '');
  };
in {
  home.packages = [
    scripts.mkubed
    pkgs.docker
    pkgs.docker-machine-kvm2
    pkgs.kubectl
    pkgs.minikube
  ];
}
