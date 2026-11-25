# Nushell config. Only overrides of nushell's built-in defaults belong here;
# see `config nu --default` for those. Shell integrations (starship, direnv,
# zoxide) are appended by home-manager.

$env.config.edit_mode = "vi"
$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.history.file_format = "sqlite"

alias fg = job unfreeze

# Separate Claude Code profile for work, with its own config dir (and so its
# own login, settings, history and credentials).
def --wrapped claude-yume [...args] {
  with-env { CLAUDE_CONFIG_DIR: ($env.HOME | path join ".claude-yume") } {
    ^claude ...$args
  }
}
