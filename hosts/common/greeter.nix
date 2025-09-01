{ lib, pkgs, ...}:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.sway}/bin/sway";
      };
    };
  };
}
