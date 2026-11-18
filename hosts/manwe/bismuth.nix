{...}:
{
  services.bismuth.instances.demo = {
    enable = true;
    host = "0.0.0.0";
    domain = "bismuth.topos.li";
    secretKeyFile = "/var/lib/secrets/bismuth-secret-key";
  };
}
