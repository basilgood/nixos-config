{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      let
        config = ''
          env:
            TERM: xterm-256color

          window:
            dimensions:
              columns: 0
              lines: 0
            position:
              x: 0
              y: 0
            padding:
              x: 0
              y: 0
            dynamic_padding: true
            dynamic_title: true
            decorations: none
            startup_mode: Windowed

          scrolling:
            history: 100000
            multiplier: 2

          font:
            normal:
              family: Noto Sans Mono
              style: Regular
            bold:
              family: Noto Sans Mono
              style: Bold
            italic:
              family: Noto Sans Mono
              style: Italic
            size: 12
            offset:
              x: 0
              y: 0
            glyph_offset:
              x: 0
              y: 0

          draw_bold_text_with_bright_colors: true

          colors:
            primary:
              background: '0x2E3440'
              foreground: '0xD8DEE9'
            normal:
              black:   '0x3B4252'
              red:     '0xBF616A'
              green:   '0xA3BE8C'
              yellow:  '0xEBCB8B'
              blue:    '0x81A1C1'
              magenta: '0xB48EAD'
              cyan:    '0x88C0D0'
              white:   '0xE5E9F0'
            bright:
              black:   '0x4C566A'
              red:     '0xBF616A'
              green:   '0xA3BE8C'
              yellow:  '0xEBCB8B'
              blue:    '0x81A1C1'
              magenta: '0xB48EAD'
              cyan:    '0x8FBCBB'
              white:   '0xECEFF4'

          background_opacity: 1

          cursor:
            style: Block
            unfocused_hollow: false
        '';
      in
      symlinkJoin {
        name = "alacritty-with-config";
        buildInputs = [ makeWrapper ];
        paths = [ alacritty ];
        postBuild = ''
          wrapProgram "$out/bin/alacritty" \
          --add-flags "--config-file ${writeText "config" config}"
        '';
      }
    )
  ];
}
