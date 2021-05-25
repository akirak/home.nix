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
      rev = "f62521564a0414a66847a92ddec5ca329ee275c6";
      # date = 2021-05-14T03:22:57+09:00;
      sha256 = "0s26w846mphgrdlwgy3bsd40wfdhlby7ghbvdcmkcdikpwj55djg";
    }) { system = builtins.currentSystem; };
  };
}
