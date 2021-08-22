{ pkgs, lib, inputs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      let
        config = ''
          font_family monospace
          font_size 10.0
          cursor_blink_interval 0
          enable_audio_bell no
          scrollback_lines 10000
          include ${inputs.kitty-themes}/themes/gruvbox_dark.conf
        '';
      in
      symlinkJoin {
        name = "kitty-with-config";
        buildInputs = [ makeWrapper ];
        paths = [ kitty ];
        postBuild = ''
          wrapProgram "$out/bin/kitty" \
          --add-flags "--config ${writeText "config" config}"
        '';
      }
    )
  ];
}
