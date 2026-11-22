# OpenCode (v2 config format) with a lead/scout/impl/review agent roster.
#
# Provider auth: run `/connect` once in the TUI and pick OpenRouter. The key is
# stored in ~/.local/share/opencode/auth.json, outside the Nix store. Use a
# dedicated OpenRouter key with a credit limit.
{ ... }:
let
  # OpenCode model ids are openrouter/<openrouter-slug>; "#high" etc. picks a variant.
  m = {
    lead = "openrouter/moonshotai/kimi-k3.1-pro"; # Claude work stays in Claude Code
    scout = "openrouter/~google/gemini-flash-latest";
    impl = "openrouter/~deepseek/deepseek-pro-latest";
    review = "openrouter/~openai/gpt-sol-latest"; # different family from lead
  };

  # Permission rules: an ordered list, the last matching rule wins.
  # Agent rules are applied after the global ones.
  rule = effect: action: resource: { inherit action resource effect; };
  allow = rule "allow";
  ask = rule "ask";
  deny = rule "deny";

  readOnlyJj = map (c: allow "shell" "jj ${c}*") [
    "log"
    "diff"
    "status"
    "show"
  ];
in
{
  programs.opencode = {
    enable = true;
    # Declarative settings go to home-manager.json (loaded via OPENCODE_CONFIG),
    # leaving /connect and the model picker free to write their own state.
    mutableSettings = true;
    validateFiles.config = true;

    settings = {
      default_agent = "lead";
      model = m.lead;

      permissions = [
        (ask "shell" "*")
        (deny "shell" "jj git push*")
        (deny "shell" "git *") # make them use jj
      ];

      agents = {
        lead = {
          mode = "primary";
          model = m.lead;
          description = "Plans work and delegates to scout/impl/review.";
          system = builtins.readFile ./prompts/lead.md;
          permissions = [
            (ask "edit" "*")
            (deny "subagent" "*")
            (allow "subagent" "scout")
            (allow "subagent" "impl")
            (allow "subagent" "review")
          ]
          ++ readOnlyJj;
        };

        scout = {
          mode = "subagent";
          model = m.scout;
          description = "Locates relevant code and summarises it tersely. Never edits.";
          system = builtins.readFile ./prompts/scout.md;
          steps = 15;
          permissions = [
            (deny "edit" "*")
            (deny "shell" "*")
          ];
        };

        impl = {
          mode = "subagent";
          model = m.impl;
          description = "Implements one narrowly-scoped brief and runs its tests.";
          system = builtins.readFile ./prompts/impl.md;
          steps = 40;
          permissions = [
            (allow "edit" "*")
            (allow "shell" "nix build*")
            (allow "shell" "nix flake check*")
            (allow "shell" "cargo test*") # adjust per language
          ]
          ++ readOnlyJj;
        };

        review = {
          mode = "subagent";
          model = m.review;
          description = "Reviews the current diff for correctness and regressions.";
          system = builtins.readFile ./prompts/review.md;
          permissions = [
            (deny "edit" "*")
            (deny "shell" "*")
          ]
          ++ readOnlyJj;
        };
      };
    };
  };

  # Run an agent in its own jj workspace next to the current repo, so parallel
  # tasks get separate working-copy commits. Clean up with `jj workspace forget`.
  programs.nushell.extraConfig = ''
    def agent-ws [name: string] {
      let root = (jj root | str trim)
      let ws = ($root | path dirname | path join $"($root | path basename)-($name)")
      jj workspace add $ws --name $name
      cd $ws
      opencode
    }
  '';
}
