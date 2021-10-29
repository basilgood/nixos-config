{ pkgs, ... }:
let
  config = ''
    # set:
    set $mod Mod4
    # font:
    font pango:Cantarell 11
    # hardware monitor
    exec --no-startup-id ${pkgs.phwmon}/bin/phwmon.py &
    # wallpaper
    exec --no-startup-id feh --bg-scale ${../assets/wall.jpg}
    # lock:
    bindsym $mod+l exec --no-startup-id "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 3"
    # redshift:
    exec --no-startup-id i3-msg 'exec --no-startup-id ${pkgs.redshift}/bin/redshift-gtk' &
    # Use Mouse+$mod to drag floating windows to their wanted position
    floating_modifier $mod
    # start a terminal
    bindsym $mod+Return exec --no-startup-id kitty
    # kill focused window
    bindsym $mod+Shift+q kill
    # dmenu
    # bindsym $mod+d exec --no-startup-id ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --term=kitty --display-binary
    # bindsym $mod+d exec --no-startup-id ${pkgs.nwg-launchers}/bin/nwggrid
    bindsym $mod+d exec --no-startup-id ${pkgs.rofi}/bin/rofi -show drun -terminal kitty -theme ${ ../assets/rofi.rasi }
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
    # exit i3
    bindsym $mod+Shift+e exec --no-startup-id xfce4-session-logout
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
    for_window [window_role="(?i)(?:pop-up|setup)"]      floating enable
    for_window [title="(?i)(?:copying|deleting|moving)"] floating enable
    for_window [class=lxqt-openssh-askpass]  focus, floating enable, resize set 300 100
    for_window [class="^KeePassXC$"] focus, floating enable, resize set 720 480
    for_window [title="Save File"] floating enable
    for_window [title="Playwright Inspector"] floating enable
    for_window [title="SimpleScreenRecorder"] floating enable
    for_window[class="feh"] floating toggle
    for_window[class="sxiv"] floating toggle
    exec --no-startup-id xfce4-panel --disable-wm-check
  '';
in
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        j4-dmenu-desktop
        xidlehook
        autorandr
        i3lock-fancy-rapid
        xfce.xfce4-panel
        xfce.xfce4-i3-workspaces-plugin
        xfce.xfce4-sensors-plugin
        xfce.xfce4-datetime-plugin
        xfce.xfce4-pulseaudio-plugin
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

  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme = true
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-size=0
  '';

  systemd.user.services.autorandr = {
    wantedBy = [ "graphical-session.target" "sleep.target" ];
    description = "Autorandr hook";
    after = [ "graphical-session.target" "sleep.target"];
    serviceConfig = {
      ExecStart = "${pkgs.autorandr}/bin/autorandr -c";
      Type = "oneshot";
      RemainAfterExit = false;
    };
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

  programs.ssh = {
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };
}
