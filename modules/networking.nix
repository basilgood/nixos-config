{...}:
{
  networking.networkmanager = {
    enable = true;
    dns = "dnsmasq";
  };
  networking.extraHosts = ''
    127.0.0.1 local.cosmoz.com
  '';
}
