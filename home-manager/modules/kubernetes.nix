{ pkgs, ... }:

let
  aliases = {
    pods-fzf = "kubectl get pods -A | fzf --print0 --header-lines 1 -n 2";
    pod-vars = "${aliases.pods-fzf} | read -r ns pod _rest";
  };
  deps = {
    k9s-catppuccin-theme = (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/k9s/refs/heads/main/dist/catppuccin-mocha.yaml";
      sha256 = "15ys74ygbfss9ka38x1vfa4gb2rnln4f0ckwdy29x2ghmr0hj2dg";
    });
  };
in {
  home.file.".config/k9s/skins/catppuccin-mocha.yaml".source = deps.k9s-catppuccin-theme;

  programs = {
    zsh = {
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
    k9s = {
      enable = true;
      settings.k9s.ui.skin = "catppuccin-mocha";
      aliases.aliases = {
        pp = "v1/pods";
        dep = "apps/v1/deployments";
      };
    };
  };

}
