{ pkgs, ... }:

let
  scripts = {
    mkubed = (pkgs.writeShellScriptBin "mkubed" ''
      tmpdir="/tmp/mkubed"

      function start () {
        mkdir -p $tmpdir
        
        minikube start \
          --kubernetes-version=v1.29.9 \
          --driver=vfkit \
          --container-runtime=docker \
          --cpus=6 \
          --memory=6g

        minikube addons enable ingress

        eval $(minikube docker-env)
      }

      function stop() {
        echo "Stopping Minikube..."
        rm -rf $tmpdir
        minikube stop
        
        unset DOCKER_TLS_VERIFY DOCKER_HOST DOCKER_CERT_PATH MINIKUBE_ACTIVE_DOCKERD
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
    pkgs.vfkit
  ];
}
