{ pkgs, ...}:
{
	# Enable gnome-keyring
  services.gnome.gnome-keyring.enable = true;

  programs.seahorse.enable = true;

  security.pam.services.sddm.enableGnomeKeyring = true;

  # Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;
}
