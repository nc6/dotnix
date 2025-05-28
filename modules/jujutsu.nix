{ pkgs, lib, ...}: {
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "Nicholas Clarke";
        email = "nc@topos.org.uk";
      };
    };
  };
}
