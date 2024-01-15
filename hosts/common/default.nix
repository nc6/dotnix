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

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  networking = {
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

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
}
