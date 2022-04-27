

```
nix build .#box

nix run github:nix-community/nixos-generators -- -f raw-efi -c aarch64.nix


limactl delete -f default

limactl start --name=default aarch64.yml


```