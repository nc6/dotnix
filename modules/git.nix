{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    userEmail = "nick@topos.org.uk";
    userName = "Nicholas Clarke";

    ignores = [
      ".direnv"
    ];

    aliases = {
      nix = "!nix-prefetch-git \"file://$(git rev-parse --show-toplevel)\" --rev \"$(git rev-parse HEAD)\" 2>&1 | grep 'sha256\\|rev\"' | sed 's/\"rev\"/tag/g' | sed 's/\"sha256\"/--sha256/g' | sed 's/[,\"]//g'";
    };

    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "master";
      push.default = "simple";
      pull.rebase = "false";
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };

      user = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHpLeHabhvyaHKr0EXrchPir8yqX5UM+H6ZfaB9nx1Q";
      };
    };
  };

  home.packages = with pkgs; [
    gitAndTools.gh
    lazygit
  ];
}
