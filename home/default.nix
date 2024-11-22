{pkgs, ...}: {
  home = {
    username = "vasy";
    homeDirectory = "/home/vasy";
    packages = with pkgs; [
      vlc
      vlc-bittorrent
      shotcut
      qbittorrent
      anydesk
      element-desktop
      keepassxc
      freetube
      gtimelog
      nh
      telegram-desktop
      fd
      duf
      ytfzf
      nh
      remind
      calcurse
      darktable
      libnotify
      blanket
      pavucontrol
      pulsemixer
    ];
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  home.sessionVariables = {
    BROWSER = "brave";
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  imports = [
    ./bash.nix
    ./tmux.nix
    ./utils.nix
    ./git.nix
    ./kitty.nix
    ./nvim.nix
    ./browsing.nix
    ./gtk.nix
  ];
}
