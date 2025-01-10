{ config, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/github";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
      "10.20.0.*" = {
        user = "k3s";
        identityFile = "~/.ssh/k8s-vm";
        extraOptions = {
          IdentityAgent = "none";
        };
      };
    };
  };
}
