{pkgs,...}:
let oryxRules =
  pkgs.writeTextFile {
    name = "50-oryx.rules";
    text = ''
      # Rule for the Moonlander
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
    '';
    destination = "/etc/udev/rules.d/50-oryx.rules";
  };
in {
  services.udev.packages = [oryxRules];
}
