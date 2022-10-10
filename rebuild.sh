#!/usr/bin/env bash

HOST=$(hostname)
AUTOCOMMIT_MSG="Routine update"

usage() {
  echo "Usage: $0 [ -u ] [ -v ] [ -n ]" 1>&2
}

echo "Updating $HOST"

if [ -z "$(git status --porcelain)" ]; then
  # Working directory clean
  AUTOCOMMIT=true
else
  # Uncommitted changes
  AUTOCOMMIT=false
fi

while getopts "uvn" options; do
  case "${options}" in
    u)
      nix flake update
      ;;
    v)
      $(cd modules/vscode && cat exts | ./update_exts.sh > exts.nix)
      AUTOCOMMIT_MSG="${AUTOCOMMIT_MSG}\n\nUpdated VSCode plugins"
      ;;
    n)
      # Disable autocommit even on a clean repo
      AUTOCOMMIT=false
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

nixos-rebuild switch --use-remote-sudo --flake .#$HOST

if [ "$AUTOCOMMIT" == true ]; then
  git add flake.lock modules/vscode
  git commit -m "$AUTOCOMMIT_MSG"
  git push
fi
