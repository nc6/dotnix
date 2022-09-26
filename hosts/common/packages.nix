{ pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    direnv
    exfat
    htop
    neovim
    pinentry
    pinentry-gnome
    wget
  ];
}
