{ pkgs, lib, ...}: {
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "Nicholas Clarke";
        email = "nick@topos.org.uk";
      };

      signing = {
        behaviour = "drop";
        backend = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHpLeHabhvyaHKr0EXrchPir8yqX5UM+H6ZfaB9nx1Q";
        backends = {
          ssh = {
            program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
          };
        };
      };

      git = {
        sign-on-push = true;
      };

    };
  };

  home.packages = with pkgs; [
    gg-jj
  ];
}
