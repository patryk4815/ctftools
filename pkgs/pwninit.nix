{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pwninit";
  version = "3.2.0";

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
    maintainers = with maintainers; [ mic92 ];
  };
}