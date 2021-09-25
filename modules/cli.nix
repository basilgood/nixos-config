{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    wget
    archivemount
    unzip
    zip
    unrar
    jq
    htop
    bat
    usbutils
    bashmount
    atool
    psmisc
    parted
    fzf
    ytfzf
    fd
    ripgrep
    lm_sensors
    nix-prefetch-scripts
    nixpkgs-fmt
    libnotify
    xclip
    direnv
  ];
}
