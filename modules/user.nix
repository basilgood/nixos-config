{ ... }:
{
  users = {
    users.vasy = {
      isNormalUser = true;
      createHome = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "disk"
        "audio"
        "video"
        "networkmanager"
        "systemd-journal"
        "scanner"
        "lp"
        "adbusers"
        "lxc"
        "lxd"
      ];
      initialPassword = "1234";
    };
    groups.vasy = {
      gid = 1000;
    };
  };
}
