{ pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    cacert
    direnv
    exfat
    htop
    neovim
    pinentry
    wget
    wl-clipboard
  ];
}
