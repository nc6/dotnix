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
        "$mod, f, fullscreen"
        "$mod, space, togglefloating"

        "$mod SHIFT, semicolon, exec, swaylock"

        "$mod SHIFT, minus, movetoworkspace, special:scratch"
        "$mod, minus, togglespecialworkspace, scratch"
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
        modules-left = [
          "hyprland/workspaces"
          "hyprland/mode"
          "hyprland/scratchpad"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "cpu"
          "memory"
          "network"
          "backlight"
          "pulseaudio"
          "battery"
          "tray"
          "custom/notification"
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
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      }
    ];

    style = ''
      /* Colors (dracula) */
      @define-color foreground	#f8f8f2;
      @define-color background	rgba(40, 42, 54, 0.5);
      @define-color orange	#ffb86c;
      @define-color gray	#44475a;
      @define-color black #21222c;
      @define-color red	#ff5555;
      @define-color green	#50fa7b;
      @define-color yellow	#f1fa8c;
      @define-color cyan	#8be9fd;
      @define-color blue	#6272a4;
      @define-color purple	#bd93f9;
      @define-color pink	#ff79c6;
      @define-color white #ffffff;
      @define-color brred #ff6e6e;
      @define-color brgreen #69ff94;
      @define-color bryellow #ffffa5;
      @define-color brcyan #a4ffff;
      @define-color brblue #6272a4;
      @define-color brpurple #d6acff;
      @define-color brpink #ff92df;

      @define-color arch_blue #89b4fa;

      @define-color workspace_background	@background;
      @define-color workspace_button	@foreground;
      @define-color workspace_active	@black;
      @define-color workspace_active_background	@green;
      @define-color workspace_urgent	@white;
      @define-color workspace_urgent_background	@brred;
      @define-color workspace_hover	@black;
      @define-color workspace_hover_background	@pink;
      @define-color critical	@red;
      @define-color warning	@yellow;


      @keyframes blink {
          to {
              background-color: @white;
              color: @black;
          }
      }

      * {
          border: none;
          border-radius: 0;
          font-family: "monospace";
          font-weight: bold;
          font-size: 12px;
          min-height: 0;
      }

      window#waybar {
          background: transparent;
      	  color: @foreground;
      }

      #workspaces {
          background: @workspace_background;
          opacity: 1;
          transition: none;
          padding: 5px 5px;
          border-radius: 5px;
      }

      #workspaces button, #workspaces button.persistent {
          background: transparent;
          color: @workspace_button;
          transition: none;
      }

      #workspaces button.active {
          background: @workspace_active_background;
          color: @workspace_active;
          border-radius: 5px;
      /*
          border-top: 2px solid @pink;
          border-bottom: 2px solid @pink;
      */
      }

      #workspaces button.urgent {
          background: @workspace_urgent_background;
          color: @workspace_urgent;
          border-radius: 5px;
      }

      #workspaces button:hover {
          background: @workspace_hover_background;
          color: @workspace_hover;
          border-radius: 5px;
      }

      #taskbar {
          background: @background;
          border-radius: 5px;
          margin: 5px 10px 5px 50px;
      }

      tooltip {
          background: @background;
          opacity: 0.95;
          border-radius: 10px;
          border-width: 2px;
          border-style: solid;
          border-color: @purple;
      }

      tooltip label{
          color: @grey;
      }

      #cpu,
      #disk,
      #custom-updates,
      #memory,
      #clock,
      #battery,
      #pulseaudio,
      #network,
      #tray,
      #temperature,
      #backlight,
      #language {
          background: @background;
          opacity: 1;
          padding: 0px 5px;
          margin: 2px 0px 2px 0px;
      }

      #disk.critical,
      #temperature.critical  {
          background-color: @critical;
      }

      #disk.warning,
      #temperature.warning {
          background-color: @warning;
      }

      #battery {
          color: @green;
          border-radius: 5px 0px 0px 5px;
      }

      #battery.discharging {
          color: @foreground;
      }

      #battery.warning:not(.charging) {
          background: @warning;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #battery.critical:not(.charging) {
          background-color: @critical;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #clock {
          border-radius: 0px 5px 5px 0px;
      }

      #tray {
          background: @background;
          border-radius: 5px;
          margin: 5px 5px 5px 5px;
      }
    '';
  };

  services.swaync.enable = true;

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
