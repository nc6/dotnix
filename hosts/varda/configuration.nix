# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.initrd.luks.devices = {
    nixos = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard"];

  powerManagement.enable = true;

  networking.hostName = "varda"; # Define your hostname.
  networking.extraHosts = "127.0.0.1 varda";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode= true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr pkgs.hplip ];
  };

  # Needed to support wireless printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.clamav = {
    updater.enable = true;
    daemon.enable = true;
  };

  # Settings needed for steam
  hardware.graphics.enable32Bit = true;
  services.pulseaudio.support32Bit = true;

  # Laptop specific X configuration
  services.libinput.enable = true;
  services.xserver = {
    dpi = 144;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "21.11";

}
