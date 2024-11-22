{inputs, ...}: {
  programs.brave = {
    enable = true;
    commandLineArgs = ["--password-store=basic"];
  };
  programs.chromium = {
    enable = true;
  };
  programs.firefox = {
    enable = true;

    profiles.default = {
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        multi-account-containers
      ];
    };
  };
  programs.aria2 = {
    enable = true;
    settings = {
      dir = "\${HOME}/Downloads/aria2";
      follow-torrent = false;
      peer-id-prefix = "";
      user-agent = "";
      summary-interval = "0";
    };
  };
}
