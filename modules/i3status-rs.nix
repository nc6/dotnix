{pkgs, lib, ...}: {

  programs.i3status-rust = {
    enable = true;
    bars = {
      top = {
        blocks = [
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            alert_unit = "GB";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "memory";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
          }
          { block = "net"; }
          { block = "sound"; }
          {
            block = "battery";
            interval = 10;
            format = "$icon $percentage $time";
            missing_format = "";
          }
          { block = "keyboard_layout";
            driver = "localebus";
          }
          {
            block = "time";
            interval = 60;
            format = "$timestamp.datetime(f:'%a %F %R')";
          }
        ];
        settings = {
          theme = {
            theme = "solarized-dark";
          };
        };
        icons = "awesome5";
      };
    };
  };
}
