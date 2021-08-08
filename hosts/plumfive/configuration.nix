{ config, lib, pkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  networking = {
    hostName = "plumfive";
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };
    extraHosts = ''
      127.0.0.1 local.cosmoz.com
    '';
  };

  location.provider = "geoclue2";
  services.localtime.enable = true;
  time.timeZone = "Europe/Bucharest";

  services.earlyoom.enable = true;

  # Copy system config to allow nixPath to find compat
  environment.etc.self.source = inputs.self;

  # Add current nixpkgs checkout to /etc/nixpkgs for easy browsing
  environment.etc.nixpkgs.source = inputs.nixpkgs;

  nixpkgs.config.allowUnfree = true;

  programs.ssh.startAgent = true;
  programs.ssh.extraConfig = ''
    Host *
      ControlMaster auto
      ControlPath ~/.ssh/sockets-%r@%h-%p
      ControlPersist 600
  '';
  virtualisation.lxc.enable = true;
  virtualisation.lxd.enable = true;

  system.stateVersion = "21.05";

}
