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
    };
  };
}
