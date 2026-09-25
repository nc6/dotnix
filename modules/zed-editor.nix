{ pkgs,...}:
{
  home.packages = [
    pkgs.bubblewrap
  ];

  programs.zed-editor = {
    enable = true;

    userSettings =
      {
        languages = {
          Typst = {
            format_on_save = "on";
          };
        };
        project_panel = {
          dock = "left";
        };
        outline_panel = {
          dock = "left";
        };
        collaboration_panel = {
          dock = "left";
        };
        git_panel = {
          dock = "left";
        };
        agent = {
          dock = "right";
          inline_assistant_model = {
            provider = "zed.dev";
            model = "claude-sonnet-4";
          };
          default_model = {
            model = "claude-3-7-sonnet-latest";
            provider = "zed.dev";
          };
        };
        buffer_font_size = 14;
        show_completions_on_input = false;
        show_edit_predictions = false;
        show_wrap_guides = true;
        tab_size = 2;
        theme = {
          dark = "One Dark";
          light = "Gruvbox Dark Soft";
          mode = "system";
        };
        ui_font_size = 14;
        helix_mode = true;
        wrap_guides = [
          80
          100
        ];
        lsp = {
          tinymist = {
            initialization_options = {
              preview = {
                background = {
                  enabled = true;
                };
              };
            };
          };
      };
    };
  };
}
