{ config, ... }:

{
  programs.ssh = {
    forwardAgent = true;
    matchBlocks = {
      "pfsense.home 10.0.1.1" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1p-keys/pfsense.pub";
      };
      "10.0.1.* !10.0.1.1" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1p-keys/unifi.pub";
      };
      "proxmox.home 10.0.10.10" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1p-keys/unraid.pub";
      };
      "truenas.home 10.0.10.100" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1p-keys/unraid.pub";
      };
      "nu-precision.home 10.0.10.20" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1p-keys/nu-precision.pub";
      };
      "cognitect.git.beanstalkapp.com" = {
        user = "git";
        identityFile = "~/.ssh/1p-keys/beanstalk.pub";
      };
      "*" = {
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };
}
