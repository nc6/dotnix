{ config, pkgs, lib, ... }:
{
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 2283;
    # Keep photos on the snapshotted /data dataset
    mediaLocation = "/data/immich";
    # PostgreSQL (with vectorchord) and Redis are provisioned locally by the module
    settings.server.externalDomain = "https://acrophoto.topos.li";
  };

  services.caddy = {
    enable = true;
    virtualHosts."acrophoto.topos.li".extraConfig = ''
      reverse_proxy localhost:${toString config.services.immich.port}
    '';
  };

  systemd.tmpfiles.rules = [
    "d /data/immich 0700 immich immich - -"
  ];
}
