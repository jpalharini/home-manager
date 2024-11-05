{ config, ... }:

{
  programs.ssh = {
    forwardAgent = true;
    serverAliveInterval = 60;
    matchBlocks = {
      "pfsense.home 10.0.1.1" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1password/pfsense.pub";
      };
      "10.0.1.* !10.0.1.1" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1password/unifi.pub";
      };
      "proxmox.home 10.0.10.10" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1password/unraid.pub";
      };
      "truenas.home 10.0.10.100" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1password/unraid.pub";
      };
      "nu-precision.home 10.0.10.20" = {
        user = "jpalharini";
        identityFile = "~/.ssh/1password/nu-precision.pub";
      };
      "cognitect.git.beanstalkapp.com" = {
        user = "git";
        identityFile = "~/.ssh/1password/beanstalk.pub";
      };
      "*" = {
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };
}
