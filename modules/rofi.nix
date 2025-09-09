{pkgs, lib, ...}:
{
  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-calc ];
    theme = "Paper";
  };
}
