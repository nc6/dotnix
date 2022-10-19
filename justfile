HOST := `hostname`

default: update update-vscode-plugins rebuild commit

update:
  nix flake update

# Update plugins for VSCode to the latest available versions
update-vscode-plugins:
  cat modules/vscode/exts | ./modules/vscode/update_exts.sh > ./modules/vscode/exts.nix

rebuild:
  nixos-rebuild switch --use-remote-sudo --flake .#{{HOST}}

commit:
  git add flake.lock modules/vscode
  git commit -m "Routine update"
  git push
