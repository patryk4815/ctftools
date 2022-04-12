{ lib
, stdenv
, makeWrapper
, qemu
}:
let
    qemuNew = (qemu.overrideAttrs (oldAttrs: rec {
        version = "6.2.0";
        patches = oldAttrs.patches ++ [
            # PATCH -> https://lore.kernel.org/all/20220221030910.3203063-1-dominik.b.czarnota@gmail.com/T/
            # qemu-user-XXX -> able to get vmmap in gdb `info proc mappings`
            ./qemu-gdb.patch
        ];
    })).override {
    };
in qemuNew

/*
FIX vmmap for qemu in pwndbg

pi pwndbg.vmmap.get()
pi pwndbg.qemu.is_qemu = lambda: False
pi pwndbg.vmmap.get.clear()
pi pwndbg.vmmap.proc_pid_maps.clear()
pi pwndbg.vmmap.get()
*/