{ config, ... }:

{
  programs.ssh = {
    enable = true;
    serverAliveInterval = 60;
  };
}
