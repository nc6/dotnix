{...}:
{
  imports =
    [ # Include cachix caches
      ./cachix.nix
      ./fonts.nix
      ./keyring.nix
      ./nix.nix
      ./packages.nix
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

  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  services.openssh.enable = true;
  services.fwupd.enable = true;
  services.lorri.enable = true;
}
