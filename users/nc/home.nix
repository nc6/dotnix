{ pkgs, extraSources, ... }:

{
  imports = [
    (import ../../modules/1password.nix)
    (import ../../modules/bash)
    (import ../../modules/git.nix)
    (import ../../modules/haskell.nix)
    (import ../../modules/helix.nix)
    (import ../../modules/i3status-rs.nix)
    (import ../../modules/nushell)
    (import ../../modules/starship.nix)
    (import ../../modules/sway.nix)
    (import ../../modules/vscode)
    (import ../../modules/zed-editor.nix)
  ];

  home.stateVersion = "18.09";

  home.packages = with pkgs; [

    # Passwords
    _1password-cli
    _1password-gui

    # Web stuff
    google-chrome
    spotify
    signal-desktop-bin
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
    kdePackages.gwenview
    zathura

    # Latex
    ghostscript

    # Organisation
    logseq

    # R
    R

    # System
    alsa-utils
    bluetuith
    btop
    cachix
    desktop-file-utils
    feh
    hoard
    libnotify
    libsecret
    mosh
    networkmanagerapplet
    nvd
    p7zip
    pavucontrol
    pinentry-rofi
    upterm
    udiskie
    wally-cli
    xdg-utils
    yazi
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.wezterm.enable = true;

  programs.ssh = 
    let
      onePassPath = "~/.1password/agent.sock";
    in {
      enable = true;
      extraConfig = ''
        Host *
            IdentityAgent ${onePassPath}
      '';
    };

  services.keybase.enable = true;
  
  services.syncthing = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.helix}/bin/hx";
    TERMINAL = "${pkgs.wezterm}/bin/wezterm";
  };

  home.keyboard.layout = "eu";

}
