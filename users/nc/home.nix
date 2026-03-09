{ pkgs, extraSources, ... }:

{
  imports = [
    (import ./headless.nix)
    (import ../../modules/1password.nix)
    (import ../../modules/hyprland)
    (import ../../modules/i3status-rs.nix)
    (import ../../modules/rofi.nix)
    (import ../../modules/vscode)
  ];

  home.packages = with pkgs; [

    # Passwords
    _1password-cli
    _1password-gui

    # 3D Printing
    openscad
    orca-slicer

    # Web stuff
    fluffychat
    google-chrome
    spotify
    signal-desktop
    telegram-desktop
    thunderbird
    # Disabled due to CVE-2023-5217
    # zotero

    # AI tools
    claude-code
    gemini-cli
    mistral-vibe

    # Develpoment tools
    zeal

    # Graphics
    kdePackages.gwenview
    zathura

    # Latex
    ghostscript

    # Organisation
    anytype
    logseq

    # R
    R

    # System
    alsa-utils
    bluetuith
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
  ];

  programs.wezterm.enable = true;

  programs.ssh =
    let
      onePassPath = "~/.1password/agent.sock";
    in
    {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          host = "*";
          addKeysToAgent = "no";
          compression = true;
          controlMaster = "auto";
          controlPath = "'~/.ssh/master-%r@%n:%p'";
          controlPersist = "60";
          forwardAgent = false;
          hashKnownHosts = true;
          identitiesOnly = false;
          serverAliveInterval = 60;
          identityAgent = "${onePassPath}";
        };
        "github.com" = {
          host = "github.com";
          hostname = "github.com";
          identitiesOnly = true;
          identityFile = [ "~/.ssh/personal-ed25519.pub" ];
        };
        "github-shielded.com" = {
          host = "github-shielded.com";
          hostname = "github.com";
          identitiesOnly = true;
          identityFile = [ "~/.ssh/Shielded.pub" ];
        };
      };
    };

  services.keybase.enable = true;

  home.keyboard.layout = "eu";

}
