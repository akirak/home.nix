self: super:
{
  easy-dhall-nix = import (self.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-dhall-nix";
    rev = "35bca5ba56b7b3f8684aa0afbb65608159beb5ce";
    # date = 2020-04-04T12:53:43+02:00;
    sha256 = "16l71qzzfkv4sbxl03r291nswsrkr3g13viqkma2s8r5vy9la3al";
  }) {};
}
