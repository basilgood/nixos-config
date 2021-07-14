{ ... }:
{
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "gcalenpjmijncebpfijmoaglllgpjagf" # Tampermonkey BETA
      "ihmgiclibbndffejedjimfjmfoabpcke" # Mate Translate
      "hahklcmnfgffdlchjigehabfbiigleji" # Play with MPV
    ];
  };
  programs.adb.enable = true;
}
