{ pkgs, lib, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      let
        config = ''
          font_family DejaVuSansMono Nerd Font
          font_size        10.0
          enable_audio_bell no
          include ${inputs.kitty-themes}/themes/gruvbox_dark.conf
        '';
      in
      {
        kitty = lib.wrapPrograms {
          name = "kitty";
          paths = [ kitty ];
          wrap.kitty = {
            file = "${kitty}/bin/kitty";
            flags =
              "--config ${lib.escapeShellArg (writeText "kitty-config" config)}";
          };
        };
      }
    )
  ];
}
