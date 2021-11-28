_:
{
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "gcalenpjmijncebpfijmoaglllgpjagf" # Tampermonkey BETA
      "ihmgiclibbndffejedjimfjmfoabpcke" # Mate Translate
    ];
  };
  programs.adb.enable = true;
}
