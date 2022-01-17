{ pkgs, ... }:
let
  config = ''
    # set:
    set $mod Mod4
    # font:
    font pango:Cantarell 11
    # autorandr
    bindsym $mod+z exec --no-startup-id ${pkgs.autorandr}/bin/autorandr -c
    # lock:
    bindsym $mod+l exec --no-startup-id "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 3"
    # screenshot:
    bindsym Print exec --no-startup-id maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png
    bindsym $mod+Print exec --no-startup-id maim ~/Pictures/$(date +%s).jpg
    bindsym XF86AudioLowerVolume exec --no-startup-id "pactl set-sink-mute @DEFAULT_SINK@ false; pactl set-sink-volume @DEFAULT_SINK@ -5%"
    bindsym XF86AudioRaiseVolume exec --no-startup-id "pactl set-sink-mute @DEFAULT_SINK@ false; pactl set-sink-volume @DEFAULT_SINK@ +5%"
    bindsym XF86AudioMute exec --no-startup-id "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    bindsym XF86AudioMicMute exec --no-startup-id "pactl set-source-mute @DEFAULT_SOURCE@ toggle"
    # Use Mouse+$mod to drag floating windows to their wanted position
    floating_modifier $mod
    # start a terminal
    bindsym $mod+Return exec --no-startup-id kitty
    # kill focused window
    bindsym $mod+Shift+q kill
    # launcher:
    bindsym $mod+d exec --no-startup-id rofi -show drun -show-icons -terminal kitty -theme ${ ../assets/rofi.rasi }
    bindsym $mod+Shift+e exec --no-startup-id rofi -show p -modi p:rofi-power-menu -theme ${ ../assets/rofi.rasi }
    # change focus
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right
    # move focused window
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right
    # enter fullscreen mode for the focused container
    bindsym $mod+f fullscreen toggle
    # mode
    bindsym $mod+h split h
    bindsym $mod+v split v
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split
    bindsym $mod+Shift+space floating toggle
    bindsym $mod+space focus mode_toggle
    bindsym $mod+a focus parent
    # Config workspaces
    set $ws1 "1"
    set $ws2 "2"
    set $ws3 "3"
    set $ws4 "4"
    set $ws5 "5"
    set $ws6 "6"
    set $ws7 "7"
    set $ws8 "8"
    set $ws9 "9"
    set $ws10 "10"
    # switch to workspace
    bindsym $mod+1 workspace number $ws1
    bindsym $mod+2 workspace number $ws2
    bindsym $mod+3 workspace number $ws3
    bindsym $mod+4 workspace number $ws4
    bindsym $mod+5 workspace number $ws5
    bindsym $mod+6 workspace number $ws6
    bindsym $mod+7 workspace number $ws7
    bindsym $mod+8 workspace number $ws8
    bindsym $mod+9 workspace number $ws9
    bindsym $mod+0 workspace number $ws10
    # move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace number $ws1
    bindsym $mod+Shift+2 move container to workspace number $ws2
    bindsym $mod+Shift+3 move container to workspace number $ws3
    bindsym $mod+Shift+4 move container to workspace number $ws4
    bindsym $mod+Shift+5 move container to workspace number $ws5
    bindsym $mod+Shift+6 move container to workspace number $ws6
    bindsym $mod+Shift+7 move container to workspace number $ws7
    bindsym $mod+Shift+8 move container to workspace number $ws8
    bindsym $mod+Shift+9 move container to workspace number $ws9
    bindsym $mod+Shift+0 move container to workspace number $ws10
    # scratchpad
    bindsym $mod+m move scratchpad
    bindsym $mod+o scratchpad show
    # reload the configuration file
    bindsym $mod+Shift+c reload
    # restart i3 inplace
    bindsym $mod+Shift+r restart
    # resize window (you can also use the mouse for that)
    mode "resize" {
      bindsym Left resize grow width 10 px or 10 ppt
      bindsym Down resize grow height 10 px or 10 ppt
      bindsym Up resize shrink height 10 px or 10 ppt
      bindsym Right resize shrink width 10 px or 10 ppt
      bindsym Return mode "default"
      bindsym Escape mode "default"
      bindsym $mod+r mode "default"
    }
    bindsym $mod+r mode "resize"
    # notifications
    bindsym $mod+q exec --no-startup-id dunstctl close
    bindsym $mod+n exec --no-startup-id dunstctl history-pop
    # i3-gaps:
    for_window [class="^.*"] border pixel 2
    smart_gaps on
    smart_borders no_gaps
    gaps inner 8
    gaps outer 0
    # border colors
    client.focused          #556064 #556064 #80FFF9 #FDF6E3
    client.focused_inactive #2F3D44 #2F3D44 #1ABC9C #454948
    client.unfocused        #2F3D44 #2F3D44 #1ABC9C #454948
    client.urgent           #CB4B16 #FDF6E3 #1ABC9C #268BD2
    client.placeholder      #000000 #0c0c0c #ffffff #000000
    client.background       #2B2C2B
    # status bar:
    bar {
      height 26
      font pango:monospace 9
      separator_symbol "::"
      position bottom
      status_command i3blocks
      tray_padding 5
      colors {
        background #17212b
        statusline #9FB4CD
        separator #555555
        active_workspace   #2c3e50 #2c3e50 #1abc9c
        focused_workspace  #2c3e50 #2c3e50 #1abc9c
        inactive_workspace #2c3e50 #2c3e50 #ecf0f1
        urgent_workspace   #e74c3c #e74c3c #ecf0f1
      }
    }
    for_window [class=lxqt-openssh-askpass]  focus, floating enable, resize set 300 100
    for_window [class="^KeePassXC$"] focus, floating enable, resize set 1024 787
    for_window [title="Save File"] floating enable
    for_window [title="pulsemixer"] floating enable resize set 720 400
    for_window [title="^floatme$"] floating enable
    for_window [title="Playwright Inspector"] floating enable
    for_window [window_role="(?i)(?:pop-up|setup)"] floating enable
    for_window [title="(?i)(?:copying|deleting|moving)"] floating enable
    for_window [title="SimpleScreenRecorder"] floating enable
    for_window [class=feh|sxiv] floating enable
    # pactl to adjust volume in PulseAudio.
    exec --no-startup-id ${pkgs.volumeicon}/bin/volumeicon &
    # exec --no-startup-id ${pkgs.volnoti-dbus}/bin/volnoti-dbus
    # autorandr
    exec --no-startup-id ${pkgs.autorandr}/bin/autorandr -c
    # wallpaper
    exec --no-startup-id ${pkgs.coreutils}/bin/sleep 1; ${pkgs.feh}/bin/feh --bg-fill ${../assets/wall.jpg}
    # redshift
    # exec --no-startup-id ${pkgs.redshift}/bin/redshift-gtk -l 44:26 &
  '';

in
{
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        rofi
        rofi-power-menu
        rofi-file-browser
        zafiro-icons
        capitaine-cursors
        dunst
        arandr
        autorandr
        maim
        pulsemixer
        volumeicon
        volnoti-dbus
        i3blocks
        i3lock-fancy-rapid
        xidlehook
      ];
      configFile = pkgs.writeText "i3-config-file" config;
      extraSessionCommands = ''
      '';
    };
    displayManager = {
      lightdm = {
        enable = true;
        background = "${../assets/wall.jpg}";
      };
      sessionCommands = "xset s off";
    };
  };

  environment.etc."xdg/i3blocks/config".text = ''
    [cpu_usage]
    command=sar 1 1 | awk '/all/{print "'"''${1:-} "'"$4"%"}'
    color=#9fb4cd
    interval=1
    [memory]
    command=free -h --giga | awk '/^Mem:/{print "'"''${1:-} "'"$3}'
    color=#9fb4cd
    interval=10
    [cpu]
    command=sensors | grep "Tdie" | awk '{print "'"''${1:-} "'"$2}'
    color=#9fb4cd
    interval=10
    [gpu]
    command=sensors | grep "edge" | awk '{print "'"''${1:-} "'"$2}'
    color=#9fb4cd
    interval=10
    [time]
    command=date '+%a %d.%m.%Y %H:%M'
    color=#9fb4cd
    interval=30
  '';

  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme = true
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-name=capitaine-cursors
    gtk-cursor-theme-size=10
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintfull
    gtk-xft-rgba=rgb
  '';

  environment.etc."dunst/dunstrc".text = ''
    [global]
    font = Cantarell 10
    max_icon_size = 32
    indicate_hidden = yes
    markup = yes
    format = "%s %p\n%b"
    word_wrap = yes
    geometry = "0x4-25+25"
    shrink = yes
    separator_height = 5
    padding = 8
    horizontal_padding = 8
    frame_color = "#000000"
    separator_color = "#FF000000"
    icon_path = /run/current-system/sw/share/icons/Adwaita/16x16/status/:/run/current-system/sw/share/icons/Adwaita/16x16/devices/
    idle_threshold = 120
    [urgency_low]
    foreground = "#121212"
    background = "#5656569A"
    frame_color = "#5656569A"
    timeout = 10
    timeout = 10
    [urgency_normal]
    background = "#0000009A"
    foreground = "#FEFEFE"
    frame_color = "#0000009A"
    timeout = 10
    [urgency_critical]
    background = "#cf000f9A"
    foreground = "#f1f1f1"
    frame_color = "#cf000f9A"
    timeout = 0
  '';

  systemd.user.services.dunst = {
    enable = true;
    description = "";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst -conf /etc/dunst/dunstrc";
  };

  systemd.user.services.volnoti = {
    enable = true;
    description = "";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.volnoti-dbus}/bin/volnoti-dbus";
  };

  services.picom = {
    enable = true;
    fade = true;
    shadow = true;
    fadeDelta = 4;
    shadowOpacity = 0.5;
    activeOpacity = 1.0;
    inactiveOpacity = 1.0;
    menuOpacity = 1.0;
    backend = "glx";
    vSync = true;
  };

  services.gnome.gnome-keyring.enable = true;
  services.gnome.at-spi2-core.enable = true;
  services.avahi.enable = true;
  services.dbus.packages = [ pkgs.flameshot pkgs.volnoti-dbus ];

  systemd.user.services.xidlehook = {
    description = "lock and suspend";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    environment = { DISPLAY = ":0"; };
    serviceConfig = {
      ExecStart = ''
        ${pkgs.xidlehook}/bin/xidlehook \
          --not-when-fullscreen \
          --not-when-audio \
          --timer 270 "${pkgs.libnotify}/bin/notify-send --urgency=critical 'Idle' 'Resuming activity'" "" \
          --timer 30 "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 3" "" \
          --timer 600 "systemctl suspend" ""
      '';
      Type = "simple";
    };
    wantedBy = [ "graphical-session.target" ];
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    extraPackages = with pkgs; [
      libGLU
      vaapiVdpau
      libvdpau-va-gl
    ];
    setLdLibraryPath = true;
  };

  programs.dconf.enable = true;
  programs.ssh = {
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };
}
