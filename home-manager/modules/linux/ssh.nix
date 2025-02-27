{ config, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "nu-precision.home 10.0.10.20 localhost 127.0.0.1" = {
        identityFile = "~/.ssh/local";
        extraOptions = {
          AddKeysToAgent = "yes";
          IdentityAgent = "none";
        };
      };
      "github.com" = {
        identityFile = "~/.ssh/github";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
      "10.20.0.* k8s-*" = {
        user = "k3s";
        identityFile = "~/.ssh/k8s-vm";
        extraOptions = {
          IdentityAgent = "none";
        };
      };
      "cognitect.git.beanstalkapp.com" = {
        user = "git";
        identityFile = "~/.ssh/beanstalk";
      };
    };
  };
}
