{ config, lib, pkgs, ...}:
let
  # The only session offered: Hyprland managed by UWSM. The plain "Hyprland"
  # entry (shipped by the hyprland package itself) skips UWSM, so
  # graphical-session.target never starts and neither do hypridle, swaync, etc.
  #
  # Written by hand rather than via programs.uwsm.waylandCompositors, as that
  # can't pass uwsm options. Hyprland >= 0.53 must be launched via its
  # start-hyprland watchdog, but uwsm would then derive XDG_CURRENT_DESKTOP
  # from that executable name, so pin it to exactly "Hyprland".
  sessions = pkgs.writeTextDir "hyprland-uwsm.desktop" ''
    [Desktop Entry]
    Name=Hyprland (UWSM)
    Comment=Hyprland compositor managed by UWSM
    Exec=${lib.getExe config.programs.uwsm.package} start -e -D Hyprland -N Hyprland -F -- /run/current-system/sw/bin/start-hyprland
    Type=Application
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${sessions}";
      };
    };
  };
}
