{ pkgs, ... }:

{
  systemd.user.services.wezterm-mux-server = {
    Unit = {
      Description = "WezTerm multiplexer server";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wezterm}/bin/wezterm-mux-server";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
