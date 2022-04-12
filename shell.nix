let
#    pkgsArm = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {
#        #system = "x86_64-linux";
#        #system = "armv7l-linux";
#        #system = "armv5tel-linux";
#        #system = "aarch64-linux";
#    };


    over0 = (self: super: rec {

    });
    over1 = (self: super: rec {
      # custom packages
      arm-binutils = super.pkgsCross.arm-embedded.buildPackages.binutils;

      # global packages
      zshNew = self.callPackage ./pkgs/zsh.nix { };
      gdb = self.callPackage ./pkgs/gdb.nix { gdb = super.gdb; };
      qemu = self.callPackage ./pkgs/qemu.nix { qemu = super.qemu; };
      pwndbg = self.callPackage ./pkgs/pwndbg.nix {};

      #capstone = super.capstone.overrideAttrs (oldAttrs: rec {
      #  version = "5.0.0";
      #  src = super.fetchFromGitHub {
      #    owner = "aquynh";
      #    repo = "capstone";
      #    rev = "master";
      #    sha256 = null;
      #  };
      #});

      # FIXME: troche ugly ale dziala - generalnie to dziwnie tutaj wyglada, ale nie wiem jak inaczej zrobic
      # python packages
      packageOverrides = self2: super2: {
        pwntools = self2.callPackage ./pkgs/pwntools.nix { debugger = pwndbg; };
      };
      python3 = super.python3.override { inherit packageOverrides; };
    });

    pkgs = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {
        overlays = [ over0 over1 ];
    };

    pythonEnv = pkgs.python3.withPackages(ps: with ps; [
        pwntools
        ipython
    ]);
in
    pkgs.mkShell {
        nativeBuildInputs = [
            pkgs.zshNew
            pkgs.gdb

            pkgs.gcc
            pkgs.pwndbg
            pkgs.tmux
            pkgs.binutils  # objdump
            pkgs.arm-binutils  # arm-none-eabi-XXXXX
            pkgs.file
            pkgs.patchelf
            pkgs.p7zip
            pkgs.python3Packages.ropper
            pkgs.one_gadget
            pkgs.nix-index
            # TODO: gobuster
            pkgs.vim
            pkgs.less
            pythonEnv
        ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            pkgs.qemu
            pkgs.checksec
        ];
    }
