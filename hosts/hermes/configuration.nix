{ config, lib, pkgs, inputs, ... }:
{
  imports =
    [
      ./hardware.nix
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
    hostName = "hermes";
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };
    extraHosts = ''
      127.0.0.1 local.cosmoz.com
    '';
  };

  time.timeZone = "Europe/Bucharest";

  services.earlyoom.enable = true;
  services.fstrim.enable = true;

  # Copy system config to allow nixPath to find compat
  environment.etc.self.source = inputs.self;

  # Add current nixpkgs checkout to /etc/nixpkgs for easy browsing
  environment.etc.nixpkgs.source = inputs.nixpkgs;
  environment.localBinInPath = true;
  environment.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "$EDITOR";
    # EDITOR = "nvim";
    # VISUAL="nvr --remote-wait-silent +'set bufhidden=wipe'";
    BAT_THEME = "Nord";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.vim.ftNix = false;

  programs.ssh.startAgent = true;
  programs.ssh.extraConfig = ''
    Host *
      ControlMaster auto
      ControlPath ~/.ssh/sockets-%r@%h-%p
      ControlPersist 600
  '';
  virtualisation.lxc.enable = true;
  virtualisation.lxd.enable = true;

  system.stateVersion = "21.11";

}
