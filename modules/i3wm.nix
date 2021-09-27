{ pkgs, ... }:
let
  config = ''
    # set:
    set $mod Mod4
    # font:
    font pango:monospace 8
    # wallpaper
    exec --no-startup-id feh --bg-scale ${../assets/wall.jpg}
    # lock:
    bindsym $mod+l exec --no-startup-id "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 3"
    # screenshot:
    bindsym Print exec --no-startup-id maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png
    bindsym $mod+Print exec --no-startup-id maim ~/Pictures/$(date +%s).jpg
    # redshift:
    exec --no-startup-id i3-msg 'exec --no-startup-id ${pkgs.redshift}/bin/redshift-gtk' &
    # pactl to adjust volume in PulseAudio.
    exec --no-startup-id ${pkgs.volumeicon}/bin/volumeicon &
    bindsym XF86AudioLowerVolume exec --no-startup-id "pactl set-sink-mute @DEFAULT_SINK@ false; pactl set-sink-volume @DEFAULT_SINK@ -5%; notify-send 'Volume' $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,') --icon=dialog-information -h string:x-canonical-private-synchronous:audio-volume-change"
    bindsym XF86AudioRaiseVolume exec --no-startup-id "pactl set-sink-mute @DEFAULT_SINK@ false; pactl set-sink-volume @DEFAULT_SINK@ +5%; notify-send 'Volume' $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,') --icon=dialog-information -h string:x-canonical-private-synchronous:audio-volume-change"
    bindsym XF86AudioMute exec --no-startup-id "pactl set-sink-mute @DEFAULT_SINK@ toggle; notify-send 'Volume Muted' $(pactl list sinks | grep '^[[:space:]]Mute:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed 's/Mute://' | xargs) --icon=dialog-information -h string:x-canonical-private-synchronous:audio-mute-change"
    bindsym XF86AudioMicMute exec --no-startup-id "pactl set-source-mute @DEFAULT_SOURCE@ toggle; notify-send 'Microphone Mute Toggled' -h string:x-canonical-private-synchronous:audio-mic-mute-change"
    # exec --no-startup-id ${pkgs.xfce.xfce4-volumed-pulse}/bin/xfce4-volumed-pulse &
    # Use Mouse+$mod to drag floating windows to their wanted position
    floating_modifier $mod
    # start a terminal
    bindsym $mod+Return exec --no-startup-id kitty
    # kill focused window
    bindsym $mod+Shift+q kill
    # launcher:
    bindsym $mod+d exec --no-startup-id rofi -theme android_notification -show drun -terminal kitty -show-icons -lines 15 -width 20 -xoffset 0 -yoffset -300 -font "monospace 15"
    bindsym $mod+Shift+e exec --no-startup-id rofi -show p -modi p:rofi-power-menu -theme android_notification -font "monospace 10" -lines 6 -width 10
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
    for_window [class="^KeePassXC$"] focus, floating enable, resize set 720 480
    for_window [title="Save File"] floating enable
    for_window [title="pulsemixer"] floating enable resize set 720 400
    for_window [class=Viewnior|feh|sxiw|Lxappearance|Pavucontrol] floating enable
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
        capitaine-cursors
        libnotify
        arandr
        autorandr
        maim
        pulsemixer
        volumeicon
        i3blocks
        i3lock-fancy-rapid
        xidlehook
        viewnior
        pciutils
        sysstat
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
    command=sensors | grep "Tdie" | awk '{print $2}'
    color=#9fb4cd
    interval=10
    [gpu]
    command=sensors | grep "edge" | awk '{print $2}'
    color=#9fb4cd
    interval=10
    [time]
    command=date '+%d-%m-%Y %H:%M'
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
    font = monospace 9
    geometry = "300x5-30+20"
    show_indicators = no
    show_age_threshold = 60
    word_wrap = yes
    icon_position = left
    max_icon_size = 32
    corner_radius = 8
    transparency = 10
    padding = 24
    horizontal_padding = 24
    sort = yes
    icon_folders = /run/current-system/sw/share/icons/Adwaita/16x16/devices/
    [shortcuts]
    close = mod4+q
    history = mod4+n
    [urgency_low]
    background = "#2E3440"
    foreground = "#D1D7E2"
    timeout = 10
    [urgency_normal]
    background = "#2E3440"
    foreground = "#D1D7E2"
    timeout = 10
    [urgency_critical]
    background = "#3f2d3f"
    foreground = "#D1D7E2"
    timeout = 0
  '';

  systemd.user.services.dunst = {
    enable = true;
    description = "";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
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

  systemd.user.services.boot-autorandr = {
    description = "Autorandr service";
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.autorandr}/bin/autorandr -c";
      Type = "oneshot";
    };
  };

  systemd.user.services.nmapplet = {
    description = "Network Manager Agent";
    path = [ pkgs.networkmanagerapplet ];
    serviceConfig.Restart = "on-abort";
    serviceConfig.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session-pre.target" ];
  };

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
