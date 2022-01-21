{ pkgs, lib, ...}:{
  services.betterlockscreen = {
    enable = true;
  };

  xsession.enable = true;
  xsession.pointerCursor = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 28;
  };
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

      };

      bars = [
        { position = "top";
          statusCommand = "${pkgs.i3status}/bin/i3status";
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
