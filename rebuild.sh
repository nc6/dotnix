#!/usr/bin/env bash

HOST=$(hostname)
usage() {
  echo "Usage: $0 [ -u ] [ -v ] " 1>&2
}

echo "Updating $HOST"

while getopts "uv" options; do
  case "${options}" in
    u)
      nix flake update
      ;;
    v)
      $(cd modules/vscode && cat exts | ./update_exts.sh > exts.nix)
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

sudo nixos-rebuild switch --flake .#$HOST
