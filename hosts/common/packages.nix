{ pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    cacert
    ddcutil
    direnv
    exfat
    htop
    neovim
    pinentry
    wget
    wl-clipboard
  ];
}
