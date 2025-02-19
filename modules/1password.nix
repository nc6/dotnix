{ pkgs, lib, ...}:
{
  systemd.user.services._1password = {
    Unit = {
      Description = "1password password manager";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
    };
  };
}
