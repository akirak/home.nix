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
      rev = "5dab4bfb44e7526b5deb017175b8ec184cde6cda";
      # date = 2020-12-02T01:14:34+09:00;
      sha256 = "1qhn0yaql7zknmrifp6pdn5bj54hn291j0shl92fjdcqrdvbqnbz";
    }) { pkgs = super; };
  };
}
