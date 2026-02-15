# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ ./disk-config.nix
      # Create users
      ../common/users.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd = {
      # Load the network card driver early
      availableKernelModules = [ "e1000e" ];

      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222; # Use a different port than your main SSH to avoid host key conflicts
          authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHpLeHabhvyaHKr0EXrchPir8yqX5UM+H6ZfaB9nx1Q" ];
          hostKeys = [ "/etc/ssh/ssh_host_initrd_key" ];
        };
      };
    };

  boot.kernelParams = [
    # Limit ZFS ARC to 16GB
    "zfs.zfs_arc_max=16106127360"
  ];

  boot.supportedFilesystems = [ "zfs" ];

  networking.hostName = "manwe"; # Define your hostname.
  networking.hostId = "007f0100";

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Enable automatic scrubbing to find bit-rot early
  services.zfs = {
    autoScrub.enable = true;
    expandOnBoot = "all";
  };

  # Anti-virus
  services.clamav = {
    updater.enable = true;
    daemon.enable = true;
  };

  services.openssh.enable = true;

  # Act as a tailscale exit node
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "25.11"; # Did you read the comment?

  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHpLeHabhvyaHKr0EXrchPir8yqX5UM+H6ZfaB9nx1Q"
  ];
}
