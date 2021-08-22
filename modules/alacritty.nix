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
              family: "DejaVuSansMono Nerd Font"
              style: Book
            bold:
              family: "DejaVuSansMono Nerd Font"
              style: Bold
            italic:
              family: "DejaVuSansMono Nerd Font"
              style: Oblique
            size: 10
            offset:
              x: 0
              y: 0
            glyph_offset:
              x: 0
              y: 0

          draw_bold_text_with_bright_colors: true

          colors:
            primary:
              background: '0x181818'
              foreground: '0xd8d8d8'
            cursor:
              text: '0xd8d8d8'
              cursor: '0xd8d8d8'
            normal:
              black:   '0x181818'
              red:     '0xab4642'
              green:   '0xa1b56c'
              yellow:  '0xf7ca88'
              blue:    '0x7cafc2'
              magenta: '0xba8baf'
              cyan:    '0x86c1b9'
              white:   '0xd8d8d8'
            bright:
              black:   '0x585858'
              red:     '0xab4642'
              green:   '0xa1b56c'
              yellow:  '0xf7ca88'
              blue:    '0x7cafc2'
              magenta: '0xba8baf'
              cyan:    '0x86c1b9'
              white:   '0xf8f8f8'

          background_opacity: 0.90

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
