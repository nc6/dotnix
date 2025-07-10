{pkgs, lib, ...}: 
  let
    sway-tools = pkgs.writeShellScriptBin "sway-tools" ''
      ${pkgs.nushell}/bin/nu ${./sway-tools.nu} "$@"
    ''; in
{
  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-calc ];
    theme = "Paper";
  };

  programs.swaylock = {
    enable = true;
    settings = {
      image="$HOME/Pictures/Backgrounds/IMG_20180930_140935.jpg";
      scaling="stretch";
    };
  };

  wayland.windowManager.sway = {
    enable = true;

    config = let mod = "Mod4"; in {
      modifier = mod;
      terminal = "${pkgs.wezterm}/bin/wezterm";

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

        "${mod}+Shift+semicolon" = "exec \"swaylock -k\"";

        "${mod}+Shift+comma" = "move workspace to output right";
        "${mod}+Shift+period" = "move workspace to output left";

        "${mod}+Tab" = "exec ${sway-tools}/bin/sway-tools switch-workspace";
        "${mod}+grave" = "exec ${sway-tools}/bin/sway-tools";
      };

      startup = [
        { command = "${pkgs.udiskie}/bin/udiskie --tray"; }
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet";}
        { command = "${pkgs.mako}/bin/mako";}
      ];
    };
  };
}
