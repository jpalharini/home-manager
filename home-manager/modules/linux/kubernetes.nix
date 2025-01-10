{ pkgs, ... }:

let
  minikube-config = {
    kubernetes-version = "v1.29.9";
    driver = "kvm2";
    container-runtime = "docker";
    cpus = 16;
    memory = "128g";
    disk-size = "100g";
    nodes = 3;
  };

  scripts = {
    mkubed = (pkgs.writeShellScriptBin "mkubed" ''
      tmpdir="/tmp/mkubed"

      function start () {
        mkdir -p $tmpdir
        
        minikube start

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
  home.file = {
    ".minikube/config/config.json" = {
      enable = false;
      text = (builtins.toJSON minikube-config);
    };
  };

  programs.zsh.localVariables = {
    KUBECONFIG = "$HOME/.kube/config";
  };

  home.packages = [
    scripts.mkubed
    pkgs.docker
    pkgs.docker-machine-kvm2
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.minikube
  ];
}
