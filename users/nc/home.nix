{ pkgs, helix-editor, unison, ... }:

{
  imports = [
    (import ../../modules/alacritty.nix)
    (import ../../modules/bash)
    (import ../../modules/git.nix)
    (import ../../modules/haskell.nix)
    (import ../../modules/neovim.nix)
    (import ../../modules/nushell)
    (import ../../modules/vscode)
    (import ../../modules/xorg.nix)
  ];

  home.stateVersion = "18.09";

  home.packages = with pkgs; [

    # Web stuff
    google-chrome
    slack
    spotify
    signal-desktop
    tdesktop
    zoom-us
    zotero

    # Develpoment tools
    silver-searcher
    clang
    gnumake
    # helix-editor.packages.${system}.helix
    ispell
    niv
    nix-prefetch-git
    zeal
    zoxide

    # Graphics
    gwenview
    okular

    # Idris
    idris2

    # Latex
    (texlive.combine {
      inherit (texlive) scheme-small listings glossaries mfirstuc parskip xfor;
    })
    ghostscript
    mupdf

    # Organisation
    logseq

    # R
    R

    # System
    alsa-utils
    cachix
    desktop-file-utils
    feh
    gnupg
    libgnome-keyring
    mosh
    networkmanagerapplet
    nvd
    p7zip
    pavucontrol
    ranger
    tmate
    tmux
    udiskie
    wally-cli

    # Unison
    unison.packages.${system}.ucm

  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  services.gnome-keyring.enable = true;

  services.syncthing = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
  };

  home.keyboard.layout = "eu";

}
