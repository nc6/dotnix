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
    # Disabled due to CVE-2023-5217
    # zotero

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
    obsidian

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
    pinentry-rofi
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



  services.gpg-agent = let pinentryRofi = pkgs.writeShellApplication {
    name= "pinentry-rofi-with-env";
    text = ''
      PATH="$PATH:${pkgs.coreutils}/bin:${pkgs.rofi}/bin"
      "${pkgs.pinentry-rofi}/bin/pinentry-rofi" "$@"
    '';
    };
  in {
    enable = true;
    enableSshSupport = true;
    extraConfig = ''
      pinentry-program ${pinentryRofi}/bin/pinentry-rofi-with-env
    '';
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
