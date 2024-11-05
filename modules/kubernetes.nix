{ pkgs, ... }:

let
  aliases = {
    pods-fzf = "kubectl get pods -A | fzf --print0 --header-lines 1 -n 2";
    pod-vars = "${aliases.pods-fzf} | read -r ns pod _rest";
  };

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

        # nohup minikube mount $NU_HOME:/mnt/nu-repos > $tmpdir/mnt_nu_repos.log 2>&1 &
        # echo $! > $tmpdir/mnt_nu_repos.pid

        # nohup minikube mount $HOME/.m2:/mnt/m2-repo > $tmpdir/mnt_m2.log 2>&1 &
        # echo $! > $tmpdir/mnt_m2.pid
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
  
  programs.zsh = {
    shellAliases = {
      k = "kubectl";
      kdp = "${aliases.pod-vars}; kubectl describe pod -n \"$ns\" \"$pod\"";
      kl = "${aliases.pod-vars}; kubectl logs -n \"$ns\" \"$pod\"";
      klf = "${aliases.pod-vars}; kubectl logs -n \"$ns\" \"$pod\" -f";
      kpc = "${aliases.pod-vars}; echo -n \"$pod\" | pbcopy";
      kssh = "${aliases.pod-vars}; kubectl exec -it -n \"$ns\" \"$pod\" -- /bin/bash";
      mk = "minikube kubectl --";
      mkube = "minikube";
    };
  };
}
