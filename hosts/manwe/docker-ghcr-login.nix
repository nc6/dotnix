{ config, pkgs, ... }:
{
  # ghcr.io requires authentication even for public images.
  # Secret must contain:
  #   GITHUB_USERNAME=<any github username>
  #   GITHUB_TOKEN=<PAT with read:packages scope>
  sops.secrets.github_ghcr = {
    sopsFile = ./secrets.yaml;
  };

  systemd.services.docker-login-ghcr = {
    description = "Authenticate Docker with ghcr.io";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      EnvironmentFile = config.sops.secrets.github_ghcr.path;
    };
    script = ''
      echo "$GITHUB_TOKEN" | ${pkgs.docker}/bin/docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin
    '';
  };
}
