{ lib
, fetchFromGitHub
, makeWrapper
, pkg-config
, lzma
, patchelf
, elfutils
, openssl
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "pwninit";
  version = "3.2.0";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    makeWrapper

    # package dependency
    lzma
    openssl
  ];

  # TODO: patch path for eu-unstrip ? -> https://github.com/io12/pwninit/blob/14d4b4f21b77c4b8a0bdb110ea5a578e715731af/src/unstrip_libc.rs#L32
  # TODO: patch path for patchelf in code? -> https://github.com/io12/pwninit/blob/master/src/patch_bin.rs#L53
  postFixup = ''
    wrapProgram $out/bin/pwninit \
      --set PATH ${lib.makeBinPath [
        elfutils
        patchelf
      ]}
  '';

  src = fetchFromGitHub {
    owner = "io12";
    repo = pname;
    rev = version;
    sha256 = "sha256-XKDYJH2SG3TkwL+FN6rXDap8la07icR0GPFiYcnOHeI=";
  };

  cargoSha256 = "sha256-2HCHiU309hbdwohUKVT3TEfGvOfxQWtEGj7FIS8OS7s=";

  meta = with lib; {
    description = "todo";
    homepage = "https://github.com/io12/pwninit";
    license = licenses.unlicense;
    maintainers = with maintainers; [ msm ];
  };
}