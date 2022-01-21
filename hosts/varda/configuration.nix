# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };
  console.font = "Lat2-Terminus16";
  console.keyMap = "uk";

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    direnv
    exfat
    exfat-utils
    htop
    neovim
    sshfs-fuse
    wget
  ];

  fonts.fonts = with pkgs; [
    source-code-pro
    fira
    fira-code
    fira-code-symbols
    fira-mono
    emacs-all-the-icons-fonts
  ];

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.fwupd.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  #
  # Port ranges for KDE connect
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; }];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; }];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode= true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr pkgs.hplip ];
  };

  # SSH-agent
  programs.ssh.startAgent = true;

  # Emacs
  services.emacs.enable = true;

  services.syncthing = {
    enable = true;
    user = "nc";
    group = "users";
  };

  services.clamav = {
    updater.enable = true;
    daemon.enable = true;
  };

  # Needed to support wireless printing
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Sound
  hardware.pulseaudio.enable = true;
  sound.mediaKeys.enable = true;

  # Settings needed for steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "gb";
    xkbOptions = "eurosign:e";

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
      	i3lock-color
	dmenu
	i3status
      ];
    };

   # desktopManager.plasma5.enable = true;

    libinput = {
      enable = true;
    };

    dpi = 144;
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  containers = {
    tor = {
      config =
        {config,pkgs,...}:
	{ services.tor.enable = true; };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.nc = {
    description = "Nicholas Clarke";
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  nix.binaryCaches = [
    "https://cache.nixos.org"
    "https://hie-nix.cachix.org"
    "https://hydra.iohk.io"
  ];

  nix.binaryCachePublicKeys = [
    "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
