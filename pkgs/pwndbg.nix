{ lib
, stdenv
, python3
, fetchFromGitHub
, makeWrapper
, gdb
}:

let
  pythonPath = with python3.pkgs; makePythonPath [
    future
    isort
    psutil
    pycparser
    pyelftools
    python-ptrace
    ropgadget
    six
    unicorn
    pygments
    rpyc
    ropper
  ];

in stdenv.mkDerivation rec {
  pname = "pwndbg";
  version = "dev";
  format = "other";

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    rev = version;
    sha256 = "sha256-OZgtbo7cLW2QYfZvmp2mZW73ml6jPi+lcpz/NkTKnWM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/pwndbg
    cp -r *.py pwndbg $out/share/pwndbg
    chmod +x $out/share/pwndbg/gdbinit.py
    makeWrapper ${gdb}/bin/gdb $out/bin/pwndbg \
      --add-flags "-q -x $out/share/pwndbg/gdbinit.py" \
      --set NIX_PYTHONPATH ${pythonPath}
  '';

  meta = with lib; {
    description = "Exploit Development and Reverse Engineering with GDB Made Easy";
    homepage = "https://github.com/pwndbg/pwndbg";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mic92 ];
  };
}
