{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    bootspec.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
    };
    tmp.cleanOnBoot = true;
    kernel.sysctl."net.ipv4.ip_forward" = 1;
    initrd.luks.devices."luks-b675c297-b740-4ca1-a651-4757592a5548".device = "/dev/disk/by-uuid/b675c297-b740-4ca1-a651-4757592a5548";
    kernelPackages = pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.

    # Silent boot
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  networking = {
    hostName = "liberty";
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };
    extraHosts = ''
      127.0.0.1 local.cosmoz.com
    '';
    wg-quick.interfaces.wg0.configFile = "/home/vasy/.config/vasile.conf";
  };
  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [];

  time.timeZone = "Europe/Bucharest";

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      desktopManager = {
        xterm.enable = false;
      };
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    dbus.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --container-padding 2 --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      extraPackages = [pkgs.amdvlk];
    };
    pulseaudio.enable = false;
  };

  security.rtkit.enable = true;

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
        "docker"
      ];
      initialPassword = "1234";
    };
    groups.vasy = {
      gid = 1000;
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "vasy"
      "@wheel"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.dconf.enable = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      inter
      noto-fonts
      noto-fonts-emoji
      (nerdfonts.override {
        fonts = [
          "Iosevka"
        ];
      })
    ];
    fontconfig.defaultFonts = pkgs.lib.mkForce {
      serif = ["Noto Serif"];
      sansSerif = [
        "Inter"
        "Noto Sans"
      ];
      monospace = ["Iosevka Nerd Font Mono"];
      emoji = ["Noto Color Emoji"];
    };
  };

  environment.systemPackages = with pkgs; [
    bc
    xdg-utils
    wget
    curl
    greetd.tuigreet
    # sessionVariables = {
    #   NIXOS_OZONE_WL = "1";
    # };
    # variables = {
    #   MOZ_USE_XINPUT2 = "1";
    #   GDK_SCALE = "1";
    #   GDK_DPI_SCALE = "1";
    # };
  ];

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";

  system.stateVersion = "24.05";
}
