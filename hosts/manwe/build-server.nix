# Serve the nix store over SSH so the other hosts can use manwe as a remote
# builder and as a binary cache.
{...}:
let
  clientKeys = builtins.attrValues (removeAttrs (import ../common/host-keys.nix) [ "manwe" ]);
  # Only accept connections arriving over tailscale
  tailnetOnly = key: ''from="100.64.0.0/10,fd7a:115c:a1e0::/48" ${key}'';
in
{
  nix.sshServe = {
    enable = true;
    protocol = "ssh-ng";
    write = true;
    trusted = true;
    keys = map tailnetOnly clientKeys;
  };

  # Sign everything built here so clients accept it as a substituter.
  # Generated with `nix key generate-secret --key-name manwe-1`.
  nix.settings.secret-key-files = [ "/var/lib/nix/cache-key.sec" ];
}
