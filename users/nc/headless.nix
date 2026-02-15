
{ pkgs, extraSources, ... }:

{
  imports = [
    (import ../../modules/bash)
    (import ../../modules/git.nix)
    (import ../../modules/jujutsu)
    (import ../../modules/haskell.nix)
    (import ../../modules/helix.nix)
    (import ../../modules/nushell)
    (import ../../modules/starship.nix)
    (import ../../modules/zed-editor.nix)
  ];

  home.stateVersion = "18.09";

  home.packages = with pkgs; [

    # Develpoment tools
    silver-searcher
    clang
    gnumake
    ispell
    jq
    nix-prefetch-git
    zoxide

    # System
    btop
    libnotify
    libsecret
    mosh
    p7zip
    upterm
    xdg-utils
    yazi
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.syncthing = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.helix}/bin/hx";
    TERMINAL = "${pkgs.wezterm}/bin/wezterm";
  };

}
