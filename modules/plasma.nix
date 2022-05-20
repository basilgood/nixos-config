{pkgs, ...}:
{
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.videoDrivers = [ "amdgpu" ];

  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  # services.xserver.displayManager.sddm.settings.Wayland.SessionDir = "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
  services.xserver.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
  };

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

  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.sddm.enableGnomeKeyring = true;

  users.users.vasy.packages = with pkgs; [
    qimgv
    smplayer
    smtube
    libsForQt5.ark
    libsForQt5.yakuake
    libsForQt5.plasma-applet-caffeine-plus
    libsForQt5.kwin-tiling
    libsForQt5.kcalc
    libsForQt5.kmahjongg
  ];
}
