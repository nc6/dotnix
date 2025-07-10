#!/usr/bin/env nu

# === Entry point ===
def main [
    command?: string
] {
    let subcommands = ['switch-workspace' 'rename-workspace' 'label-workspace']

    if $command == null {
        let selection = $subcommands | to text | rofi -p "Select command" -dmenu
        if ($selection | str trim | is-empty) {
            return
        }
        run-subcommand $selection
    } else {
        run-subcommand $command
    }
}

def run-subcommand [name: string] {
    match $name {
        'switch-workspace' => switch-workspace
        'rename-workspace' => rename-workspace
        'label-workspace'  => label-workspace
        _ => {
            print $"Unknown command: ($name)"
            print "Available commands: switch-workspace, rename-workspace, label-workspace"
        }
    }
}

# === Shared Helpers ===

def get-current-workspace [] {
    swaymsg -t get_workspaces -r | jq -r '.[] | select(.focused == true) | .name'
}

def get-workspace-app-names [workspace: string] {
    swaymsg -t get_tree -r 
        | jq -r --arg ws $workspace '
            recurse(.nodes[]?, .floating_nodes[]?)
            | select(.type == "workspace" and .name == $ws)
            | recurse(.nodes[]?, .floating_nodes[]?)
            | select(.type == "con" and .name != null)
            | .name
        ' | lines | sort | uniq
}

def rofi-prompt [prompt: string, options: list<string>] {
    let input = if ($options | is-empty) {
        ''
    } else {
        $options
    }

    $input | to text | rofi -p $prompt -dmenu
}

# === Subcommands ===

def "switch-workspace" [] {
    let workspaces = swaymsg -t get_workspaces -r | jq -r -c '.[] | .name' | lines
    let selection = rofi-prompt "Switch to workspace" $workspaces

    if ($selection | str trim | is-empty) {
        return
    }

    swaymsg workspace $selection
}

def "rename-workspace" [] {
    let current = get-current-workspace

    if ($current | is-empty) {
        print "Could not determine the current workspace."
        return
    }

    let suggestions = get-workspace-app-names $current
    let new_name = rofi-prompt $"Rename workspace ($current) to:" $suggestions

    if ($new_name | str trim | is-empty) {
        return
    }

    swaymsg rename workspace $current to $new_name
}

def "label-workspace" [] {
    let current = get-current-workspace

    if ($current | is-empty) {
        print "Could not determine the current workspace."
        return
    }

    let number_prefix = ($current | split row ':' | get 0 | str trim)

    if ($number_prefix | str contains ' ') {
        print $"Unexpected workspace name format: ($current)"
        return
    }

    let suggestions = get-workspace-app-names $current
    let label = rofi-prompt $"Set label for workspace ($current):" $suggestions

    if ($label | str trim | is-empty) {
        return
    }

    let new_name = $"($number_prefix):($label)"
    swaymsg rename workspace $current to $new_name
}
