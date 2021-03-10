self: super:
let
  global = super.fetchFromGitHub {
    owner = "nix-community";
    repo = "NUR";
    rev = "2f0d93976702d07e984a836865af217d1bb496c8";
    sha256 = "1iicqs6jqn4s2nh5lqg3pzmz2k3nmlzmn19i4liksr7lc83frb55";
    # date = 2021-03-10T14:40:23+00:00;
  };
in
{
  nur = global // {
    akirak = import (super.fetchFromGitHub {
      owner = "akirak";
      repo = "nur-packages";
      rev = "33b61e4a8531b48f5e421c8a07f3e13ada619c27";
      # date = 2021-03-11T00:33:27+09:00;
      sha256 = "0fq60q93lqkxs2dlz4jdwln9nxvdrv6hlwhqdicbidvzwbd3rjbz";
    }) { pkgs = super; };
  };
}
