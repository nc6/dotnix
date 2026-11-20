# Use manwe as a remote builder and binary cache. The nix daemon connects as
# root, so it authenticates with the host key (authorised in
# hosts/manwe/build-server.nix). If manwe is unreachable, builds fall back to
# running locally.
{...}:
let
  hostKeys = import ./host-keys.nix;
  sshKey = "/etc/ssh/ssh_host_ed25519_key";
in
{
  nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "manwe";
    sshUser = "nix-ssh";
    inherit sshKey;
    protocol = "ssh-ng";
    system = "x86_64-linux";
    # i7-6700: 4 cores / 8 threads
    maxJobs = 4;
    speedFactor = 1;
    supportedFeatures = [ "big-parallel" "kvm" "nixos-test" "benchmark" ];
  }];

  nix.settings = {
    # Let manwe fetch dependencies from caches itself rather than uploading them
    builders-use-substitutes = true;
    # Lower priority than cache.nixos.org (40), which is closer
    extra-substituters = [ "ssh-ng://nix-ssh@manwe?ssh-key=${sshKey}&priority=50" ];
    extra-trusted-public-keys = [ "manwe-1:iP71GyJr42RjK2ijr7ltw1eySN0XSDN/yRqpBjtRwU0=" ];
  };

  programs.ssh.knownHosts.manwe.publicKey = hostKeys.manwe;
  programs.ssh.extraConfig = ''
    Host manwe
      ConnectTimeout 5
  '';
}
