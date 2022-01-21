{ pkgs, ... }:
{
  programs.alacritty = {
    settings = {
      env = {
        TERM = "alacritty";
      };
      shell = {
        args = [ "-l" ];
        program = "${pkgs.bash}/bin/bash";
      };
    };
  };
}
