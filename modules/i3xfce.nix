{ pkgs, ... }:
let
  config = ''
      # set:
      set $mod Mod4
      # font:
      font pango:monospace 8
      # wallpaper
      # exec --no-startup-id multilockscreen -w
      # lock:
      # bindsym $mod+l exec --no-startup-id multilockscreen -l dim
      # screenshot:
      # bindsym Print exec --no-startup-id maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png
      # bindsym $mod+Print exec --no-startup-id maim ~/Pictures/$(date +%s).jpg
      # backlight
      # bindsym XF86MonBrightnessUp exec --no-startup-id brightnessctl s +10%
      # bindsym XF86MonBrightnessDown exec --no-startup-id brightnessctl s 10%-
      # Use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod
      # start a terminal
      bindsym $mod+Return exec --no-startup-id alacritty \
      -o font.size=9 \
      -o window.dynamic_padding=true \
      -o window.decorations=none \
      -o env.TERM=xterm-256color \
      -o background_opacity=0.9
      # kill focused window
      bindsym $mod+Shift+q kill
      # dmenu
      # bindsym $mod+d exec --no-startup-id dmenu_run -fn "monospace 9"
      bindsym $mod+d exec --no-startup-id ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --term=alacritty --display-binary
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
      for_window [class="^.*"] border pixel 0
      smart_gaps on
      gaps inner 8
      gaps outer 0
      # colors:
      set $blue   #1b1e26
      set $yellow #f0d48b
      set $grey #b0b287
      set $green  #789073
      client.focused    $yellow   $blue   $yellow   $yellow   $yellow
      client.focused_inactive $yellow   $blue   $grey   $yellow   $yellow
      client.unfocused  $yellow   $blue   $grey   $yellow   $yellow
      client.urgent   $yellow   $blue   $yellow   $yellow   $yellow
      client.placeholder  $yellow   $blue   $yellow   $yellow   $yellow
      client.background $blue
      for_window [window_role="(?i)(?:pop-up|setup)"]      floating enable
      for_window [title="(?i)(?:copying|deleting|moving)"] floating enable
      for_window [class=lxqt-openssh-askpass]  focus, floating enable, resize set 300 100
      for_window [class="^KeePassXC$"] focus, floating enable, resize set 720 480
      for_window [title="Save File"] floating enable
      for_window [class="Alacritty" title="pulsemixer"]    floating enable border normal 1 resize set 500 600,move right 90px,move up 80px
      for_window [class="Chromium-browser" title="Debugging tools | Playwright - Chromium"] floating enable
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
        networkmanager_dmenu
        dmenu
        libnotify
        libpng
        arandr
        maim
        pulsemixer
        ytfzf
        xfce.xfce4-panel
        xfce.xfce4-i3-workspaces-plugin
        xfce.xfce4-sensors-plugin
        xfce.xfce4-datetime-plugin
        xfce.xfce4-pulseaudio-plugin
        lxrandr
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

  services.redshift.enable = true;

  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme = true
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-size=0
  '';

  # services.autorandr.enable = true;
  # services.autorandr.defaultTarget = "tv";
  # systemd.user.services.boot-autorandr = {
  #   description = "Autorandr service";
  #   partOf = [ "graphical-session.target" ];
  #   wantedBy = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.autorandr}/bin/autorandr -c";
  #     Type = "oneshot";
  #   };
  # };

  systemd.user.services.nmapplet = {
    description = "Network Manager Agent";
    path = [ pkgs.networkmanagerapplet ];
    serviceConfig.Restart = "on-abort";
    serviceConfig.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session-pre.target" ];
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
