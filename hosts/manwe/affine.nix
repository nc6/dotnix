{ config, pkgs, lib, ... }:
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    ensureDatabases = [ "affine" ];
    ensureUsers = [{
      name = "affine";
      ensureDBOwnership = true;
    }];
    # Passwordless TCP access from localhost for the affine container (host networking)
    authentication = lib.mkAfter ''
      host affine affine 127.0.0.1/32 trust
    '';
  };

  services.redis.servers.affine = {
    enable = true;
    bind = "127.0.0.1";
    port = 6379;
  };

  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.affine = {
    image = "ghcr.io/toeverything/affine-graphql:stable";
    # Host networking lets the container reach PostgreSQL and Redis on localhost
    extraOptions = [ "--network=host" ];
    volumes = [
      "/var/lib/affine/config:/root/.affine/config"
      "/var/lib/affine/storage:/root/.affine/storage"
    ];
    environment = {
      NODE_OPTIONS = "--import=./scripts/register.js";
      AFFINE_CONFIG_PATH = "/root/.affine/config";
      REDIS_SERVER_HOST = "127.0.0.1";
      REDIS_SERVER_PORT = "6379";
      DATABASE_URL = "postgresql://affine@127.0.0.1:5432/affine";
      NODE_ENV = "production";
      AFFINE_SERVER_HOST = "affine.topos.li";
      AFFINE_SERVER_HTTPS = "true";
      AFFINE_SERVER_PORT = "3010";
    };
    # Sops secret must contain:
    #   AFFINE_ADMIN_EMAIL=<email>
    #   AFFINE_ADMIN_PASSWORD=<password>
    environmentFiles = [ config.sops.secrets.affine_env.path ];
  };

  # Decrypt admin credentials from secrets.yaml (add affine_env key before deploying)
  sops.secrets.affine_env = {
    sopsFile = ./secrets.yaml;
    restartUnits = [ "docker-affine.service" ];
  };

  services.caddy = {
    enable = true;
    virtualHosts."affine.topos.li".extraConfig = ''
      reverse_proxy localhost:3010
    '';
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/affine/config 0750 root root - -"
    "d /var/lib/affine/storage 0750 root root - -"
  ];
}
