# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include cachix caches
      ../common/cachix.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lorien"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "8.8.8.8"
    "1.1.1.1"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    direnv
    htop
    neovim
    pinentry
    pinentry_gnome
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable gnome-keyring
  services.gnome = {
    gnome-keyring.enable = true;
  };

  programs.seahorse.enable = true;

  security.pam.services.sddm.enableGnomeKeyring = true;

  # Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Anti-virus
  services.clamav = {
    updater.enable = true;
    daemon.enable = true;
  };

  # Lorri
  services.lorri.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "gb";
    xkbOptions = "eurosign:e";

    displayManager.sddm.enable = true;
    displayManager.defaultSession = "xsession";
    displayManager.session = [
      { manage = "desktop";
        name = "xsession";
      	start = "";
      }];
  };

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nc = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" ];
  };

  nix = {
    # package = pkgs.nixUnstable;
    extraOptions = ''
       experimental-features = nix-command flakes
    '';
    binaryCaches = [
      "https://cache.nixos.org"
      "https://hydra.iohk.io"
    ];

    binaryCachePublicKeys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?

}
