{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.nushell}/bin/nu";
      shell.args = ["-l" "-c" "zellij"];
    };
  };
}
