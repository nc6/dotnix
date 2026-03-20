{ config, pkgs, lib, ... }:
{
  # Disable the upstream nixpkgs Kimai module so our vendored version takes over
  disabledModules = [ "services/web-apps/kimai.nix" ];

  # Import our vendored Kimai module that supports Caddy
  imports = [ ../../modules/kimai/default.nix ];

  # Configure Kimai with Caddy
  services.kimai = {
    webserver = "caddy";
    sites = {
      "kimai.topos.li" = {
        package = pkgs.kimai;
        database = {
          createLocally = true;
          name = "kimai";
          user = "kimai";
          host = "localhost";
          port = 3306;
          charset = "utf8mb4";
        };
        settings = {
          kimai = {
            timesheet = {
              rounding = {
                default = {
                  begin = 15;
                  end = 15;
                };
              };
            };
          };
        };
      };
    };
  };
}