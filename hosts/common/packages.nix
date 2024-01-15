{ pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    direnv
    exfat
    htop
    neovim
    pinentry
    wget
  ];
}
