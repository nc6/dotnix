#!/usr/bin/env bash

HOST=$(hostname)

echo "Updating $HOST"

nix flake update

$(cd modules/vscode && cat exts | ./update_exts.sh > exts.nix)
sudo nixos-rebuild switch --flake .#$HOST
