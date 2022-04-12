{ lib
, stdenv
, makeWrapper
, gdb
}:
let
    gdbNew = (gdb.overrideAttrs (oldAttrs: rec {
        version = "11.1";
        # FIX ISSUE -> https://sourceware.org/bugzilla/show_bug.cgi?id=28913
        postPatch = (if oldAttrs.postPatch != null then oldAttrs.postPatch else '''') + ''
            substituteInPlace gdb/amd64-linux-tdep.c --replace 'amd64_linux_init_abi_common (info, gdbarch, 2);' '// removed line'
            substituteInPlace gdb/amd64-linux-tdep.c --replace 'amd64_linux_init_abi_common (info, gdbarch, 0);' '// removed line'
            substituteInPlace gdb/amd64-linux-tdep.c --replace 'set_gdbarch_num_regs (gdbarch, AMD64_LINUX_NUM_REGS);' 'set_gdbarch_num_regs (gdbarch, AMD64_LINUX_NUM_REGS);    amd64_linux_init_abi_common (info, gdbarch, 2);'
        '';
    })).override {
    };
in gdbNew