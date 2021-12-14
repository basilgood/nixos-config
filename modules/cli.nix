{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    deno
    wezterm
    bartib
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
    zathura
    youtube-dl
    fzf
    ytfzf
    fd
    ripgrep
    dragon-drop
    vimv
    neovim-remote
    lm_sensors
    nix-prefetch-scripts
    nixpkgs-fmt
    libnotify
    xclip
    direnv
    calendar-cli
    calc
    file
    timg
    t-rec
    feh
    pciutils
    sysstat
  ];

  environment.sessionVariables = {
    BARTIB_FILE = "$HOME/.activities";
  };
}
