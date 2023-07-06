{pkgs, lib, ...}: {

   programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-calc ];
    theme = "Paper";
  };

  programs.swaylock.enable = true;

  wayland.windowManager.sway = {
    enable = true;

    config = let mod = "Mod4"; in {
      modifier = mod;
      terminal = "${pkgs.alacritty}/bin/alacritty";

      input."type:keyboard" = {
        xkb_layout = "eu";
      };

      bars = [
        { position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
          trayOutput = "*";
        }
      ];

      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec rofi -show combi -combi-modes \"drun,run,window\" -modes \"combi,ssh,calc\"";
        "${mod}+c" = "exec rofi -show calc -modi calc -no-show-match -no-sort > /dev/null";

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

        "${mod}+Shift+colon" = "exec \"swaylock -k\"";

        "${mod}+Shift+greater" = "move workspace to output right";
        "${mod}+Shift+less" = "move workspace to output left";

      };

      startup = [
        { command = "${pkgs.udiskie}/bin/udiskie --tray"; }
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet";}
        { command = "${pkgs.mako}/bin/mako";}
      ];
    };
  };
}
