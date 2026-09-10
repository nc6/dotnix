{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.front_end = "WebGpu"
      config.default_prog = {"nu"}
      config.font = wezterm.font 'Fira Code'
      config.font_size = 11.0
      config.use_fancy_tab_bar = false
      config.xcursor_theme = "Yaru"

      config.unix_domains = {
        { name = 'local-mux' },
      }

      -- Everything lives in the mux, so panes survive the GUI and can be
      -- reattached from anywhere. Each launch gets its own workspace, so a
      -- new window still opens blank rather than showing another window's
      -- panes. Reattach one with `wezterm connect local-mux --workspace NAME`,
      -- or browse them with LEADER-s.
      config.default_domain = 'local-mux'

      wezterm.on('gui-startup', function(cmd)
        local name = 'w' .. os.date('%H%M%S')
        wezterm.mux.spawn_window {
          domain = { DomainName = 'local-mux' },
          workspace = name,
          args = cmd and cmd.args or nil,
        }
        wezterm.mux.set_active_workspace(name)
      end)

      config.ssh_domains = {
        { name = 'orome', remote_address = 'orome' },
        { name = 'ulmo', remote_address = 'ulmo' },
        { name = 'manwe', remote_address = 'manwe' },
      }

      config.leader = {
        key = 'a',
        mods = 'CTRL',
        timeout_milliseconds = 2000,
      }

      config.keys = {
        {
          key = 'a',
          mods = 'LEADER',
          action = wezterm.action.ActivateCommandPalette,
        },
        {
          key = 'c',
          mods = 'LEADER',
          action = wezterm.action.SpawnTab 'CurrentPaneDomain',
        },
        {
          key = 'n',
          mods = 'LEADER',
          action = wezterm.action.ActivateTabRelative(1),
        },
        {
          key = 'p',
          mods = 'LEADER',
          action = wezterm.action.ActivateTabRelative(-1),
        },
        {
          key = 'w',
          mods = 'LEADER',
          action = wezterm.action.ShowTabNavigator,
        },
        {
          key = 'm',
          mods = 'LEADER',
          action = wezterm.action.AttachDomain 'local-mux',
        },
        {
          key = 'M',
          mods = 'LEADER',
          action = wezterm.action.DetachDomain { DomainName = 'local-mux' },
        },
        {
          key = 's',
          mods = 'LEADER',
          action = wezterm.action.ShowLauncherArgs { flags = 'WORKSPACES' },
        },
        {
          key = 'r',
          mods = 'LEADER',
          action = wezterm.action.PromptInputLine {
            description = 'Rename workspace',
            action = wezterm.action_callback(function(window, pane, line)
              if line and line ~= "" then
                wezterm.mux.rename_workspace(
                  wezterm.mux.get_active_workspace(),
                  line
                )
              end
            end),
          },
        },
        { key = 'V', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
      }

      config.mouse_bindings = {
        {
          event = { Up = { streak = 1, button = 'Left' } },
          mods = 'NONE',
          action = wezterm.action.CompleteSelection 'PrimarySelection',
        },
        {
          event = { Up = { streak = 1, button = 'Left' } },
          mods = 'CTRL',
          action = wezterm.action.OpenLinkAtMouseCursor,
        },
        {
          event = { Down = { streak = 1, button = 'Middle' } },
          mods = 'NONE',
          action = wezterm.action.PasteFrom 'PrimarySelection',
        },
      }

      config.disable_default_key_bindings = true

      return config
    '';
  };

}
