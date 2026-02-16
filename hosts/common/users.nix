{...}:
{
  users.users.nc = {
    description = "Nicholas Clarke";
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["input" "plugdev" "wheel" "networkmanager" "libvirtd"];
    openssh.authorizedKeys.keys =
    [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHpLeHabhvyaHKr0EXrchPir8yqX5UM+H6ZfaB9nx1Q"
    ];
  };
}
