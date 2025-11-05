{ pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    cacert
    ddcutil
    direnv
    exfat
    htop
    neovim
    wget
    wl-clipboard
  ];
}
