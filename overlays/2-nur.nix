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
      rev = "1fe065622c2eb3e504c0313ec99443e677e85568";
      # date = 2020-11-16T19:36:05+09:00;
      sha256 = "1lgmz54sws53z7pmnqf3jrc8g9nzcvbvnqszazrhijvy6886cwkr";
    }) { pkgs = super; };
  };
}
