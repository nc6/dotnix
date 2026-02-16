# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ ./disk-config.nix
      # Create users
      ../common/users.nix
      # Nix settings
      ../common/nix.nix
    ];

  boot = {

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd = {
      systemd.enable = true;
      systemd.network = {
        enable = true;
        networks."10-wan" = {
          matchConfig.Name = "en* eth*";
          address = [ "142.132.195.27/26" ];
          routes = [
            {
              Gateway = "142.132.195.1";
              GatewayOnLink = true;
            }
          ];
          # Hetzner specific: force link to be ready
          linkConfig.RequiredForOnline = "routable";
          # This forces systemd to keep trying even if the switch is slow
          linkConfig.ActivationPolicy = "always-up";
        };
      };
      # Load the network card driver early
      availableKernelModules = [ "ahci" "sd_mod" "e1000e" "xhci_pci" ];

      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHpLeHabhvyaHKr0EXrchPir8yqX5UM+H6ZfaB9nx1Q" ];
          hostKeys = [ "/etc/ssh/ssh_host_initrd_key" ];
        };
      };
    };

    kernelParams = [
      # Limit ZFS ARC to 16GB
      "zfs.zfs_arc_max=16106127360"
      # Try to get around potential power management NIC issues
      "pcie_aspm=off"
    ];

    supportedFilesystems = [ "zfs" ];
  };

  networking.hostName = "manwe"; # Define your hostname.
  networking.hostId = "007f0100";

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp0s31f6";
      address = [
        "142.132.195.27/26"
        "2a01:4f8:261:3d66::1/64"
      ];

      routes = [
        # IPv4 Gateway
        { routeConfig.Gateway = "142.132.195.1"; }

        # IPv6 Gateway
        # Hetzner uses fe80::1 as the gateway for almost all dedicated servers
        { routeConfig.Gateway = "fe80::1"; }
      ];

      # Essential for IPv6 link-local discovery
      networkConfig = {
        IPv6AcceptRA = "no"; # We are configuring manually
      };
    };
  };

  # Enable automatic scrubbing to find bit-rot early
  services.zfs = {
    autoScrub.enable = true;
    expandOnBoot = "all";
  };

  # # Anti-virus
  # services.clamav = {
  #   updater.enable = true;
  #   daemon.enable = true;
  # };

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
