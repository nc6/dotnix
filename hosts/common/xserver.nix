{...}:
{
	# Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "gb";
    xkbOptions = "eurosign:e";

    inputClassSections = [
      ''
        Identifier "yubikey"
        MatchIsKeyboard "on"
        MatchProduct "Yubikey"
        Option "XkbLayout" "us"
        Option "XkbVariant" "basic"
      ''
      ''
        Identifier "moonlander"
        MatchIsKeyboard "on"
        MatchProduct "Moonlander"
        Option "XkbLayout" "us"
        Option "XkbVariant" "basic"
      ''
    ];

    displayManager.sddm.enable = true;
    displayManager.defaultSession = "xsession";
    displayManager.session = [
      { manage = "desktop";
        name = "xsession";
      	start = "";
      }];
  };
}
