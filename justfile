HOST := `hostname`

default: update update-vscode-plugins rebuild commit

update:
  nix flake update

# Update plugins for VSCode to the latest available versions
update-vscode-plugins:
  cat modules/vscode/exts | ./modules/vscode/update_exts.sh > ./modules/vscode/exts.nix

rebuild:
  nixos-rebuild build --use-remote-sudo --flake .#{{HOST}}
  nvd diff /run/current-system result
  sudo result/bin/switch-to-configuration switch
  unlink result

commit:
  git add flake.lock modules/vscode
  git commit -m "Routine update"
  git push
