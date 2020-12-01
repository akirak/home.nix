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
      rev = "e0362a3048144fe671fe356ebae35e393cf66985";
      # date = 2020-12-02T00:50:14+09:00;
      sha256 = "1yrk2vqjxqy11bplmw477p4sw21imgq0n67qh7a8ispk75dwrgz0";
    }) { pkgs = super; };
  };
}
