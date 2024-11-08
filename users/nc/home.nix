{ pkgs, unison, ... }:

{
  imports = [
    (import ../../modules/bash)
    (import ../../modules/git.nix)
    (import ../../modules/haskell.nix)
    (import ../../modules/helix.nix)
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
    spotify
    signal-desktop
    tdesktop
    # Disabled due to CVE-2023-5217
    # zotero

    # Develpoment tools
    silver-searcher
    clang
    gnumake
    ispell
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
    bluetuith
    btop
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
    upterm
    udiskie
    wally-cli
    xdg-utils

  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.wezterm.enable = true;

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
    TERMINAL = "${pkgs.wezterm}/bin/wezterm";
  };

  home.keyboard.layout = "eu";

}
