{ ... }:
{
  services = {
    syncthing.enable = true;
    syncthing.user = "vasy";
    syncthing.openDefaultPorts = true;
    syncthing.dataDir = "/home/vasy/Sync";
    syncthing.configDir = "/home/vasy/Sync/.config/syncthing";
  };
}
