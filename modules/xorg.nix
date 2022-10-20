{ pkgs, lib, ...}:{

  programs.i3status-rust = {
    enable = true;
    bars = {
      top = {
        blocks = [
          {
            block = "disk_space";
            path = "/";
            alias = "/";
            info_type = "available";
            unit = "GB";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_used_percents}";
            format_swap = "{swap_used_percents}";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            interval = 1;
            format = "{1m}";
          }
          { block = "networkmanager"; }
          { block = "sound"; }
          { block = "keyboard_layout";
            driver = "localebus";
          }
          {
            block = "time";
            interval = 60;
            format = "%a %F %R";
          }
        ];
        settings = {
          theme = "solarized-dark";
        };
        icons = "awesome5";
      };
    };
  };

  services.betterlockscreen = {
    enable = true;
  };

  home.pointerCursor = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 28;
  };
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    config = let mod = "Mod4"; in {
      modifier = mod;

      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+equal" = "split h";
        "${mod}+slash" = "split v";

        "${mod}+Shift+colon" = "exec \"betterlockscreen -l dim\"";

        "${mod}+Shift+greater" = "move workspace to output right";
        "${mod}+Shift+less" = "move workspace to output left";

      };

      bars = [
        { position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
          trayOutput = "primary";
        }
      ];
    };

    extraConfig = ''
      exec "${pkgs.udiskie}/bin/udiskie --tray"
      exec "${pkgs.networkmanagerapplet}/bin/nm-applet"
    '';
  };

  xresources.properties = {
    "Xft.dpi" = 120;
  };
}
