
```
nix-shell -p 'python3.withPackages(ps: with ps; [ scapy requests ipython pwndbg ])'
```

```
nix build
Build a derivation or fetch a store path.

nix develop
Run a bash shell that provides the build environment of a derivation.

nix flake
Manage Nix flakes.

nix profile
Manage Nix profiles.

nix repl
Start an interactive environment for evaluating Nix expressions.

nix run
Run a Nix application.

nix search
Query available packages.

nix shell
Run a shell in which the specified packages are available.
```

# debug shell/build
```
https://nixos.wiki/wiki/Development_environment_with_nix-shell#stdenv.mkDerivation

nix-shell -E 'with import <nixpkgs> { }; callPackage ./default.nix { }'
nix-shell -E 'with import <nixpkgs> { }; callPackage ./goahead.nix { }'
nix-shell '<nixpkgs>' -A pan

###
# clean build: copy sources from /nix/store
# dirty build: keep cache files from last buildPhase, to compile faster this is useful to make many small changes to a large project after each change, just run `buildPhase` #cd $HOME/path/to/project
echo "src = $src" && cd $(mktemp -d) && eval ${unpackPhase:-unpackPhase} && cd *

eval ${configurePhase:-configurePhase}
eval ${buildPhase:-buildPhase}

eval ${checkPhase:-checkPhase}
eval ${installPhase:-installPhase}
eval ${fixupPhase:-fixupPhase}
```

# copy:
```
nix copy --to file:///work/nix $(nix-build --no-out-link shell.nix -A inputDerivation)

sha256 = "0000000000000000000000000000000000000000000000000000";
```

# crossbuild
```
nix-build '<nixpkgs>' --arg crossSystem '(import <nixpkgs/lib>).systems.examples.fooBarBaz' -A whatever
nix-build '<nixpkgs>' --arg crossSystem '{ config = "<arch>-<os>-<vendor>-<abi>"; }' -A whatever

nix-repl> lib.systems.examples.
lib.systems.examples.aarch64-android             lib.systems.examples.ghcjs                       lib.systems.examples.musl64                      lib.systems.examples.riscv64-embedded
lib.systems.examples.aarch64-android-prebuilt    lib.systems.examples.gnu32                       lib.systems.examples.muslpi                      lib.systems.examples.s390
lib.systems.examples.aarch64-darwin              lib.systems.examples.gnu64                       lib.systems.examples.or1k                        lib.systems.examples.s390x
lib.systems.examples.aarch64-embedded            lib.systems.examples.i686-embedded               lib.systems.examples.pogoplug4                   lib.systems.examples.scaleway-c1
lib.systems.examples.aarch64-multiplatform       lib.systems.examples.iphone32                    lib.systems.examples.powernv                     lib.systems.examples.sheevaplug
lib.systems.examples.aarch64-multiplatform-musl  lib.systems.examples.iphone32-simulator          lib.systems.examples.ppc-embedded                lib.systems.examples.vc4
lib.systems.examples.aarch64be-embedded          lib.systems.examples.iphone64                    lib.systems.examples.ppc64                       lib.systems.examples.wasi32
lib.systems.examples.amd64-netbsd                lib.systems.examples.iphone64-simulator          lib.systems.examples.ppc64-musl                  lib.systems.examples.x86_64-embedded
lib.systems.examples.arm-embedded                lib.systems.examples.m68k                        lib.systems.examples.ppcle-embedded              lib.systems.examples.x86_64-netbsd
lib.systems.examples.armhf-embedded              lib.systems.examples.mingw32                     lib.systems.examples.raspberryPi                 lib.systems.examples.x86_64-netbsd-llvm
lib.systems.examples.armv7a-android-prebuilt     lib.systems.examples.mingwW64                    lib.systems.examples.remarkable1                 lib.systems.examples.x86_64-unknown-redox
lib.systems.examples.armv7l-hf-multiplatform     lib.systems.examples.mmix                        lib.systems.examples.remarkable2
lib.systems.examples.avr                         lib.systems.examples.msp430                      lib.systems.examples.riscv32
lib.systems.examples.ben-nanonote                lib.systems.examples.musl-power                  lib.systems.examples.riscv32-embedded
lib.systems.examples.fuloongminipc               lib.systems.examples.musl32                      lib.systems.examples.riscv64
```

# cli:
```
nix repl '<nixpkgs>'
```


# inne
```
https://wiki.ubuntu.com/ARM/Thumb2PortingHowto
```


```
To not enter password on every darwin-rebuild switch with nix-darwin, 
you can create /etc/sudoers.d/nix-darwin file with this content:
<home-user> ALL=(ALL:ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild (where home-user is name of home directory)
Nix darwin generates files to etc/static

# Let's install nix (at the time of writing this is version 2.5.1
curl -L https://nixos.org/nix/install | sh

# I might not have needed to, but I rebooted

mkdir -p ~/.config/nix

# Emable nix-command and flakes to bootstrap 
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = nix-command flakes
EOF

# Get the flake.nix in this gist
cd ~/.config
curl https://gist.githubusercontent.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050/raw/24a755065de59fc77a552518e106454750e86a49/flake.nix -O
# Get the configuration.nix and home.nix
curl https://gist.githubusercontent.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050/raw/24a755065de59fc77a552518e106454750e86a49/configuration.nix -O
curl https://gist.githubusercontent.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050/raw/24a755065de59fc77a552518e106454750e86a49/home.nix -O

# Until this is addressed https://github.com/LnL7/nix-darwin/issues/149
sudo mv /etc/nix/nix.conf /etc/nix/.nix-darwin.bkp.nix.conf
# Build the configuration
nix build .#darwinConfigurations.j-one.system
./result/sw/bin/darwin-rebuild switch --flake .
# Enjoy!
```

configuration.nix
```
{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------

  nix.binaryCaches = [
    "https://cache.nixos.org/"
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.trustedUsers = [
    "@admin"
  ];
  users.nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    kitty
    terminal-notifier
  ];

  # https://github.com/nix-community/home-manager/issues/423
  environment.variables = {
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };
  programs.nix-index.enable = true;

  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
     recursive
     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
   ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

}
```

`flake.nix`
```
{
  description = "Jun's darwin system";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nixpkgs-with-patched-kitty.url = github:azuwis/nixpkgs/kitty;

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Other sources
    comma = { url = github:Shopify/comma; flake = false; };
    
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
  let 

    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
      overlays = attrValues self.overlays ++ singleton (
        # Sub in x86 version of packages that don't build on Apple Silicon yet
        final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          inherit (final.pkgs-x86)
            idris2
            nix-index
            niv
            purescript;
        })
      );
    }; 
  in
  {
    # My `nix-darwin` configs
      
    darwinConfigurations = rec {
      j-one = darwinSystem {
        system = "aarch64-darwin";
        modules = attrValues self.darwinModules ++ [ 
          # Main `nix-darwin` config
          ./configuration.nix
          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jun = import ./home.nix;            
          }
        ];
      };
    };

    # Overlays --------------------------------------------------------------- {{{

    overlays = {
      # Overlays to add various packages into package set
        comma = final: prev: {
          comma = import inputs.comma { inherit (prev) pkgs; };
        };  

      # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };

          # Get Apple Silicon version of `kitty`
          # TODO: Remove when https://github.com/NixOS/nixpkgs/pull/137512 lands
          inherit (inputs.nixpkgs-with-patched-kitty.legacyPackages.aarch64-darwin) kitty;
        }; 
      };

    # My `nix-darwin` modules that are pending upstream, or patched versions waiting on upstream
    # fixes.
    darwinModules = {
      programs-nix-index = 
        # Additional configuration for `nix-index` to enable `command-not-found` functionality with Fish.
        { config, lib, pkgs, ... }:

        {
          config = lib.mkIf config.programs.nix-index.enable {
            programs.fish.interactiveShellInit = ''
              function __fish_command_not_found_handler --on-event="fish_command_not_found"
                ${if config.programs.fish.useBabelfish then ''
                command_not_found_handle $argv
                '' else ''
                ${pkgs.bashInteractive}/bin/bash -c \
                  "source ${config.progams.nix-index.package}/etc/profile.d/command-not-found.sh; command_not_found_handle $argv"
                ''}
              end
            '';
            };
        };
      security-pam = 
        # Upstream PR: https://github.com/LnL7/nix-darwin/pull/228
        { config, lib, pkgs, ... }:

        with lib;

        let
          cfg = config.security.pam;

          # Implementation Notes
          #
          # We don't use `environment.etc` because this would require that the user manually delete
          # `/etc/pam.d/sudo` which seems unwise given that applying the nix-darwin configuration requires
          # sudo. We also can't use `system.patchs` since it only runs once, and so won't patch in the
          # changes again after OS updates (which remove modifications to this file).
          #
          # As such, we resort to line addition/deletion in place using `sed`. We add a comment to the
          # added line that includes the name of the option, to make it easier to identify the line that
          # should be deleted when the option is disabled.
          mkSudoTouchIdAuthScript = isEnabled:
          let
            file   = "/etc/pam.d/sudo";
            option = "security.pam.enableSudoTouchIdAuth";
          in ''
            ${if isEnabled then ''
              # Enable sudo Touch ID authentication, if not already enabled
              if ! grep 'pam_tid.so' ${file} > /dev/null; then
                sed -i "" '2i\
              auth       sufficient     pam_tid.so # nix-darwin: ${option}
                ' ${file}
              fi
            '' else ''
              # Disable sudo Touch ID authentication, if added by nix-darwin
              if grep '${option}' ${file} > /dev/null; then
                sed -i "" '/${option}/d' ${file}
              fi
            ''}
          '';
        in

        {
          options = {
            security.pam.enableSudoTouchIdAuth = mkEnableOption ''
              Enable sudo authentication with Touch ID
              When enabled, this option adds the following line to /etc/pam.d/sudo:
                  auth       sufficient     pam_tid.so
              (Note that macOS resets this file when doing a system update. As such, sudo
              authentication with Touch ID won't work after a system update until the nix-darwin
              configuration is reapplied.)
            '';
          };

          config = {
            system.activationScripts.extraActivation.text = ''
              # PAM settings
              echo >&2 "setting up pam..."
              ${mkSudoTouchIdAuthScript cfg.enableSudoTouchIdAuth}
            '';
          };
        };
    };
 };
}
```

`home.nix`
```
{ config, pkgs, lib, ... }:

{
  home.stateVersion = "22.05";

  # https://github.com/malob/nixpkgs/blob/master/home/default.nix

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  home.packages = with pkgs; [
    # Some basics
    coreutils
    curl
    wget

    # Dev stuff
    # (agda.withPackages (p: [ p.standard-library ]))
    google-cloud-sdk
    haskellPackages.cabal-install
    haskellPackages.hoogle
    haskellPackages.hpack
    haskellPackages.implicit-hie
    haskellPackages.stack
    idris2
    jq
    nodePackages.typescript
    nodejs
    purescript

    # Useful nix related tools
    cachix # adding/managing alternative binary caches hosted by Cachix
    # comma # run software from without installing it
    niv # easy dependency management for nix projects
    nodePackages.node2nix

  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    m-cli # useful macOS CLI commands
  ];

  # Misc configuration files --------------------------------------------------------------------{{{

  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
    templates = {
      scm-init = "git";
      params = {
        author-name = "Your Name"; # config.programs.git.userName;
        author-email = "youremail@example.com"; # config.programs.git.userEmail;
        github-username = "yourusername";
      };
    };
    nix.enable = true;
  };

}
```

# build sd-image
```
https://nixos.wiki/wiki/NixOS_on_ARM#Installation
https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/installer/sd-card
https://github.com/lucernae/nixos-pi
https://nixos.wiki/wiki/NixOS_on_ARM/Banana_Pi

# armv7l

[nix-shell:/work/0_hackthebox/arm32v7/x]# echo "system = armv7l-linux" >> /etc/nix/nix.conf

{
  description = "Build image";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  outputs = { self, nixpkgs }: rec {
    nixosConfigurations.rpi2 = nixpkgs.lib.nixosSystem {
      system = "armv7l-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
        {
          nixpkgs.config.allowUnsupportedSystem = true;
          nixpkgs.crossSystem.system = "armv7l-linux";
          # ... extra configs as above
        }
      ];
    };
    images.rpi2 = nixosConfigurations.rpi2.config.system.build.sdImage;
  };
}
>> flake.nix
$ nix build .#images.rpi2

# aarch64
{ config, pkgs, lib, ... }:
{

  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
  ];
  
  # Do not compress the image as we want to use it straight away
  sdImage.compressImage = false;

  # The rest of user config goes here
}
>> configuration.sdImage.nix

$ nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./configuration.sdImage.nix \
  --argstr system aarch64-linux \
  --option sandbox false
```

# default configuration.nix
```
sandbox = false
filter-syscalls = false
substitute = true
substituters = file:///work/nix https://cache.nixos.org/
require-sigs = false
experimental-features = nix-command flakes
```

```
{ ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  services.openssh.enable = true;
  
  users.users.root.hashedPassword = "todo"; # mkpasswd -m sha-512 xxxx yyyy
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOXpeILiojsm+d/1o//+4AKreYIOxuhDoGuazeDlpVP"
  ];
  
  networking = {
    hostName = "nice-nixos";
    firewall.enable = false;
    enableIPv6 = false;
    useDHCP = false;
    interfaces = {
        # internet
        eth0 = {
            ipv4.addresses = [{address = "10.33.77.221"; prefixLength = 22;}];
            ipv4.routes = [{address = "0.0.0.0"; prefixLength = 0; via = "10.33.79.254";}];
        };
        # local
        eth1 = {
            ipv4.addresses = [{address = "10.32.93.83"; prefixLength = 22;}];
            ipv4.routes = [{address = "10.0.0.0"; prefixLength = 8; via = "10.32.95.254";}];
        };
    };
    nameservers = [ "10.35.10.35" "10.3.35.55" ];
  };

  # ifconfig ens3 10.33.77.221
  # ifconfig ens3 netmask 255.255.252.0
  # ip route add 0.0.0.0/0 via 10.33.79.254
  # ifconfig ens5 10.32.93.83
  # ifconfig ens5 netmask 255.255.252.0
  # ip route add 10.0.0.0/8 via 10.32.95.254
  
}
```