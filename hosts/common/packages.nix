{ pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    direnv
    exfat
    exfat-utils
    htop
    neovim
    pinentry
    pinentry_gnome
    wget
  ];
}
