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
              background: '0x282828'
              foreground: '0xebdbb2'
            cursor:
              text: '0x2E3440'
              cursor: '0xD8DEE9'
            normal:
              black:   '0x282828'
              red:     '0xf0664a'
              green:   '0x98971a'
              yellow:  '0xd79921'
              blue:    '0x81afaf'
              magenta: '0xb16286'
              cyan:    '0x689d6a'
              white:   '0xa89984'
            bright:
              black:   '0x928374'
              red:     '0xfb4934'
              green:   '0xb8bb26'
              yellow:  '0xfabd2f'
              blue:    '0x83a598'
              magenta: '0xd3869b'
              cyan:    '0x8ec07c'
              white:   '0xebdbb2'

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
