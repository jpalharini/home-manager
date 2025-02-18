{ config, ... }:

{
  services.samba = {
    enable = true;
    smbd.enable = true;
    settings = {
      global = {
        "min protocol" = "SMB3";
        "ea support" = "yes";
        "vfs objects" = "fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:veto_appledouble" = "no";
        "fruit:zero_file_id" = "yes";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
        "fruit:posix_rename" = "yes";
      };
      dev-shared = {
        browseable = "yes";
        "guest ok" = "no";
        path = "/home/jpalharini/dev";
      };
    };
  };
}
