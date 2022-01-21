{ pkgs, ... }:

{
  imports = [
    (import ../../modules/alacritty.nix)
    (import ../../modules/haskell.nix)
    (import ../../modules/neovim.nix)
    (import ../../modules/vscode)
    (import ../../modules/xorg.nix)
  ];

  home.packages = with pkgs; [

    # Web stuff
    google-chrome
    slack
    spotify
    signal-desktop
    tdesktop
    zoom-us

    # Develpoment tools
    ag
    fasd
    git
    git-lfs
    gitAndTools.gh
    gnumake
    ispell
    niv
    pkgs.binutils
    pkgs.clang
    zeal

    # Graphics
    darktable
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

    # R
    R

    # Rust
    # pkgs.rustChannels.nightly.rust

    # System
    cachix
    alsaUtils
    autojump
    desktop-file-utils
    feh
    gnupg
    libgnome-keyring
    mosh
    networkmanagerapplet
    pavucontrol
    p7zip
    ranger
    thunderbird
    tmate
    tmux
    udiskie

  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
  };

}
