{ pkgs, lib, inputs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      let
        config = ''
          font_family JetBrainsMonoMedium Nerd Font Mono
          bold_font        auto
          italic_font      auto
          bold_italic_font auto
          font_size 13.0
          cursor_blink_interval 0
          enable_audio_bell no
          scrollback_lines 10000
          touch_scroll_multiplier 1.0
          sync_to_monitor yes
          include ${inputs.kitty-themes}/nord.conf
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
