{...}:
{
	# Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkbOptions = "eurosign:e";

    displayManager.sddm.enable = true;
    displayManager.defaultSession = "xsession";
    displayManager.session = [
      { manage = "desktop";
        name = "xsession";
      	start = "";
      }];
  };
}
