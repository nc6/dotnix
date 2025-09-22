{pkgs, lib, ...}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "Mod4";
      "$terminal" = "${pkgs.wezterm}/bin/wezterm";

      binds = {
        drag_threshold = 10;
      };

      input = {
        kb_layout = "eu";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 1;
        gaps_out = 1;
        border_size = 1;

        resize_on_border = true;

        layout = "dwindle";
      };

      bind = [
        "$mod, return, exec, $terminal"
        "$mod SHIFT, q, killactive"
        "$mod, d, exec, ${pkgs.rofi}/bin/rofi -show combi -combi-modes \"drun,run,window\" -modes \"combi,ssh\""
        "$mod, c, exec, rofi -show calc -modi calc -no-show-match -no-sort"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, j, movewindow, d"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, l, movewindow, r"

        "$mod, t, togglegroup"

        "$mod SHIFT, semicolon, exec, swaylock"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      exec-once = [
        "hyprpanel"
        "udiskie --tray"
      ];

      # Allow local overrides in order to iteratively build config
      source = "~/.config/hypr/local.conf";
    };
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "cpu"
          "memory"
          "network"
          "backlight"
          "pulseaudio"
          "battery"
          "tray"
          "clock"
        ];
        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "hyprland/window" = {
          separate-outputs = true;
        };
        network = {
          format-wifi = "  {essid} ({signalStrength}%)"; # Font Awesome WiFi icon
          format-ethernet = "  {ipaddr}";               # Font Awesome Ethernet icon
          format-disconnected = "  No net";             # Font Awesome Alert/Triangle icon
        };
        cpu = {
          format = " {usage}%";                        # Font Awesome Microchip icon
        };
        memory = {
          format = " {used}G/{total}G";                # Font Awesome Memory icon
        };
        temperature = {
          format = " {temperature}°C";                 # Font Awesome Thermometer icon
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons = {
            default = [ "" "" "" ];                # Series of Font Awesome speaker icons
            muted = "";                                # Font Awesome Muted icon
          };
        };
        backlight = {
          format = " {percent}%";                      # Font Awesome Lightbulb icon
        };
        battery = {
          format = " {capacity}%";                     # Font Awesome Battery icon
          format-charging = " {capacity}%";            # Font Awesome Plug icon
        };
        clock = {
          format = " {:%Y-%m-%d %H:%M}";
        };
      }
    ];

    style = ''
      #workspaces button.active {
        background: #ffa000;
        color: #222222;
      }
    '';
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "swaylock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "swaylock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
