# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "ulmo"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  hardware.cpu.amd.updateMicrocode = true;

  # Anti-virus
  services.clamav = {
    updater.enable = true;
    daemon.enable = true;
  };

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "25.05"; # Did you read the comment?

  # Run tailscale golinks service
  services.golink = {
    enable = true;
  };
}
