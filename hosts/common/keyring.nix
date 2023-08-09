{ pkgs, ...}:
{
  # Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  # Enable gnome-keyring
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
