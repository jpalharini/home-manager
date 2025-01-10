{ config, ... }:

{
  programs.ssh = {
    enable = true;
    serverAliveInterval = 30;
  };
}
