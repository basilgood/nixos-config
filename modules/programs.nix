{ ... }:
{
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "gcalenpjmijncebpfijmoaglllgpjagf" # Tampermonkey BETA
      "ihmgiclibbndffejedjimfjmfoabpcke" # Mate Translate
      "hahklcmnfgffdlchjigehabfbiigleji" # Play with MPV
      "fngmhnnpilhplaeedifhccceomclgfbg" # EditThisCookie
    ];
  };
  programs.adb.enable = true;
}
