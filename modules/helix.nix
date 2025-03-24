{ pkgs,...}:
{
  config = {
    programs.helix = {
      enable = true;
      settings = {
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
