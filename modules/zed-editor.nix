{ pkgs,...}:
{
  config = {
    programs.zed-editor = {
      enable = true;  

      userSettings = {
        "agent" = {
          "default_model" = {
            "provider" = "zed.dev";
            "model" = "claude-3-7-sonnet-latest";
          };
          "version" = "2";
        };
        "vim_mode" = true;
        "vim" = {
          "default_mode" = "helix_normal";
        };
        "ui_font_size" = 14;
        "buffer_font_size" = 14;
        "theme" = {
          "mode" = "system";
          "light" = "Gruvbox Dark Soft";
          "dark" = "One Dark";
        };
        "show_wrap_guides" = true;
        "wrap_guides" = [80 100];
      };
    };
  };
}
