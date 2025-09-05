{ pkgs,...}:
{
  config = {
    programs.helix = {
      enable = true;
      settings = {
        theme = "solarized_dark";
        editor = {
          auto-save.after-delay.enable = true;
          line-number = "relative";
          rulers = [80];
        };
        keys = {
          normal = {
            "A-r" = ":reflow";
          };
        };
      };
    };
  };
}
