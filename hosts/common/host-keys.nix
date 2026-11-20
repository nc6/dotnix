# SSH ed25519 host keys (/etc/ssh/ssh_host_ed25519_key.pub). Used both to pin
# manwe's identity and to let the other hosts' nix daemons authenticate to it
# as remote builder.
{
  manwe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEFv8ado+eVuYJpntRHzEoaGexgH0f3BkR9UBecrPiF";
  orome = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHfClzYJisLiWqKUIzuw3pz2+XOarwMrk3DsZhRFHYT";
  ulmo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyEZ4rq4it6TXcs/K3zaMw/HYALWFBDgPXxATXeVDRE";
  # TODO: lorien was offline; add with `ssh-keyscan -t ed25519 lorien`
}
