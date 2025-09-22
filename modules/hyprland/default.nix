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

        layout = dwindle;
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

  programs.hyprpanel = {
    enable = true;
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      bar.layouts = {
        "*" = {
          left = [ "workspaces" "windowtitle" ];
          middle = [ "media" ];
          right = [ "volume" "network" "systray" "clock" "notifications" "dashboard"];
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      theme = {
        bar.transparent = true;
        font.size = "1em";
      };

      terminal = "${pkgs.wezterm}/bin/wezterm";

      # theme.font = {
      #   name = "CaskaydiaCove NF";
      #   size = "16px";
      # };
    };
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
