{...}:
{
  imports =
    [ ./audio.nix
      # Include cachix caches
      ./cachix.nix
      ./fonts.nix
      ./keyring.nix
      ./nix.nix
      ./packages.nix
      ./udev.nix
      ./users.nix
      ./xserver.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  services.openssh.enable = true;
  services.fwupd.enable = true;
}
