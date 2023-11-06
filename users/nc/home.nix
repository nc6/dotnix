{ pkgs, unison, ... }:

{
  imports = [
    (import ../../modules/alacritty.nix)
    (import ../../modules/bash)
    (import ../../modules/git.nix)
    (import ../../modules/haskell.nix)
    (import ../../modules/i3status-rs.nix)
    (import ../../modules/neovim.nix)
    (import ../../modules/nushell)
    (import ../../modules/sway.nix)
    (import ../../modules/vscode)
  ];

  home.stateVersion = "18.09";

  home.packages = with pkgs; [

    # Passwords
    _1password
    _1password-gui-beta

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
    helix
    ispell
    niv
    nix-prefetch-git
    zeal
    zoxide

    # Graphics
    gwenview
    okular

    # Latex
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
    hoard
    libnotify
    libsecret
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
    xdg-utils

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

  services.syncthing = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
  };

  home.keyboard.layout = "eu";

}
