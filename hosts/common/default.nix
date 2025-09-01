{...}:
{
  imports =
    [ ./audio.nix
      # Include cachix caches
      ./cachix.nix
      ./fonts.nix
      ./greeter.nix
      ./keyring.nix
      ./nix.nix
      ./packages.nix
      ./udev.nix
      ./users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
  };

  hardware.i2c.enable = true;

  # Allow configuring of logitech peripherals
  hardware.logitech.wireless.enable = true;

  networking = {
    networkmanager.enable = true;
    nameservers = [
      # MagicDNS
      "100.100.100.100"
      "1.1.1.1"
      "8.8.8.8"
    ];
    search = [ "tail319c73.ts.net" ];
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  # Needed to run Sway under home-manager
  security.polkit.enable = true;
  security.rtkit.enable = true;

  # Needed to run swaylock under home-manager
  security.pam.services.swaylock = {};

  # Enable dconf
  programs.dconf.enable = true;

  # Needed for screen sharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };

  services.openssh.enable = true;
  services.fwupd.enable = true;

  # tailscale
  services.tailscale.enable = true;
}
