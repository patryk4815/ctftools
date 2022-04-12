{ lib
, stdenv
, makeWrapper
, zsh
, zsh-powerlevel10k
, zsh-autosuggestions
, zsh-autocomplete
, zsh-syntax-highlighting
, zsh-you-should-use
, zsh-nix-shell
, oh-my-zsh
, nix-zsh-completions
, nix-index
}:
let
    zshNew = (zsh.overrideAttrs (oldAttrs: rec {
        configureFlags = [
            "--enable-multibyte"
            "--with-tcsetpgrp"
            "--enable-pcre"
            "--disable-etcdir"
            "--disable-site-fndir"
        ];
        #postInstall = "";
    })).override {
    };
in stdenv.mkDerivation rec {
  name = "zsh-wrapper";
  phases = [ "installPhase" ];

  # TODO: neovim ranger
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/etc/
    cat > $out/etc/.zshrc <<- EOF
source ${./zsh/.p10k.zsh}
source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh  # TODO: tput (ncurses)
source ${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

# TODO: vim
# TODO: zsh history

# podpowiadanie parametrow
fpath+=(${oh-my-zsh}/share/oh-my-zsh/plugins/docker)
fpath+=(${oh-my-zsh}/share/oh-my-zsh/plugins/golang)
fpath+=(${nix-zsh-completions}/share/zsh/site-functions)

# nix-index
source ${nix-index}/etc/profile.d/command-not-found.sh

export SHELL=zsh  # naprawa nix-shell

# history
HISTFILE="/work/nix/history"
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

EOF

    makeWrapper "${zshNew}/bin/zsh" "$out/bin/zsh" --set ZDOTDIR "$out/etc/"
  '';
}

