HOST := `hostname`

default: pull update rebuild commit

sync: pull rebuild

pull:
  jj git fetch
  jj new master

update:
  nix flake update

# Update plugins for VSCode to the latest available versions
update-vscode-plugins:
  cat modules/vscode/exts | ./modules/vscode/update_exts.sh > ./modules/vscode/exts.nix

rebuild:
  nixos-rebuild build --sudo --flake .#{{HOST}}
  nvd diff /run/current-system result
  # Workaround for https://github.com/NixOS/nixpkgs/issues/82851
  sudo nix-env -p /nix/var/nix/profiles/system --set ./result
  sudo result/bin/switch-to-configuration switch
  unlink result

commit:
  jj commit -m "Routine update"
  jj b m master --to @-
  jj git push
