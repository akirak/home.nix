self: super:
let
  global = super.fetchFromGitHub {
    owner = "nix-community";
    repo = "NUR";
    rev = "2b4c62062d656f58baf46d19462d526638e4dda9";
    sha256 = "00c5m5dj5li0y0f8mzdsaykcnpkppj6sgmbjkliszg6wi0dqidpj";
    # date = 2020-12-01T08:36:42+00:00;
  };
in
{
  nur = global // {
    akirak = import (super.fetchFromGitHub {
      owner = "akirak";
      repo = "nur-packages";
      rev = "c19d9b88a00447ce014a60bbf9a7b6007e36317f";
      # date = 2020-12-10T05:01:11+09:00;
      sha256 = "1qac2zck0bjckmcflgni5jv20ydv08f33v28wni6gbcgmdhjqh1x";
    }) { pkgs = super; };
  };
}
