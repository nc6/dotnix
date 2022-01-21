{ pkgs, ... }:
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
      pull.rebase = "true";
    };
  };

  home.packages = with pkgs; [
    gitAndTools.gh
  ];
}
