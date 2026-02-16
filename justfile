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

deploy:
  nix run github:serokell/deploy-rs

# Install the server (manwe) using sops secrets and nixos-anywhere
manwe-install address:
    #!/usr/bin/env bash
    set -euo pipefail

    TARGET_HOST="root@{{address}}"
    FLAKE_ATTR=".#manwe"

    # Create temporary directories for the passphrase and the extra-files tree
    TEMP_DIR=$(mktemp -d)
    EXTRA_FILES=$(mktemp -d)

    # Clean up on exit
    trap 'rm -rf "$TEMP_DIR" "$EXTRA_FILES"' EXIT

    echo "🔓 Decrypting secrets..."

    # Extract passphrase for Disko formatting
    sops -d --extract '["rootfs_encryption_phrase"]' hosts/manwe/secrets.yaml > "$TEMP_DIR/passphrase"
    chmod 600 "$TEMP_DIR/passphrase"

    # Create the directory structure for the host key
    mkdir -p "$EXTRA_FILES/etc/ssh"

    # Extract the private key into the extra-files tree
    sops -d --extract '["initrd_ssh_key"]' hosts/manwe/secrets.yaml > "$EXTRA_FILES/etc/ssh/ssh_host_initrd_key"
    chmod 600 "$EXTRA_FILES/etc/ssh/ssh_host_initrd_key"

    echo "🚀 Starting installation..."

    nix run github:nix-community/nixos-anywhere -- \
      --flake "$FLAKE_ATTR" \
      # This is already generated, no need to re-run
      # --generate-hardware-config nixos-facter ./hosts/manwe/facter.json \
      --disk-encryption-keys zroot "$TEMP_DIR/passphrase" \
      --extra-files "$EXTRA_FILES" \
      --target-host "$TARGET_HOST"

    echo "✅ Done! Unlock via: ssh -p 2222 root@${TARGET_HOST#*@}"
