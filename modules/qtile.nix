{ config, lib, pkgs, ... }: with lib;
{
  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "amdgpu" ];
    windowManager.qtile.enable = true;
    displayManager = {
      lightdm = {
        enable = true;
        background = "${../assets/wall.jpg}";
      };
      sessionCommands = "xset s off";
    };
  };

  users.users.vasy.packages = with pkgs; [
    rofi
    rofi-power-menu
    zafiro-icons
    capitaine-cursors
    libnotify
    arandr
    autorandr
    maim
    gsimplecal
    pulsemixer
    volumeicon
    redshift
    i3lock-fancy-rapid
    xfce.xfce4-screenshooter
    emulsion
    xidlehook
    pciutils
    sysstat
    python39Packages.pylint
    yapf
  ];

  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme = true
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-name=capitaine-cursors
    gtk-cursor-theme-size=10
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintfull
    gtk-xft-rgba=rgb
  '';

  environment.etc."dunst/dunstrc".text = ''
    [global]
    font = Cantarell 10
    geometry = "500x5-30+20"
    shrink = yes
    word_wrap = yes
    show_indicators = no
    text_icon_padding = 5
    max_icon_size = 48
    frame_color = "#000000"
    padding = 8
    horizontal_padding = 8
    separator_color = "#FF000000"
    corner_radius = 2
    icon_folders = /run/current-system/sw/share/icons/Zafiro/apps/scalable:/run/current-system/sw/share/icons/Zafiro/devices/48
    [shortcuts]
    close = mod4+q
    history = mod4+n
    [urgency_low]
    foreground = "#121212"
    background = "#5656569A"
    frame_color = "#5656569A"
    timeout = 10
    [urgency_normal]
    background = "#0000009A"
    foreground = "#FEFEFE"
    frame_color = "#0000009A"
    timeout = 10
    [urgency_critical]
    background = "#cf000f9A"
    foreground = "#f1f1f1"
    frame_color = "#cf000f9A"
    timeout = 0
  '';

  systemd.user.services.dunst = {
    enable = true;
    description = "";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
  };

  services.picom = {
    enable = true;
    fade = true;
    shadow = true;
    fadeDelta = 4;
    shadowOpacity = 0.5;
    activeOpacity = 1.0;
    inactiveOpacity = 1.0;
    menuOpacity = 1.0;
    backend = "glx";
    vSync = true;
  };

  systemd.user.services.xidlehook = {
    description = "lock and suspend";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    environment = { DISPLAY = ":0"; };
    serviceConfig = {
      ExecStart = ''
        ${pkgs.xidlehook}/bin/xidlehook \
          --not-when-fullscreen \
          --not-when-audio \
          --timer 270 "${pkgs.libnotify}/bin/notify-send --urgency=critical 'Idle' 'Resuming activity'" "" \
          --timer 30 "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 3" "" \
          --timer 600 "systemctl suspend" ""
      '';
      Type = "simple";
    };
    wantedBy = [ "graphical-session.target" ];
  };

  services.redshift.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    extraPackages = with pkgs; [
      libGLU
      vaapiVdpau
      libvdpau-va-gl
    ];
    setLdLibraryPath = true;
  };

  programs.dconf.enable = true;
  programs.ssh = {
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };
}
