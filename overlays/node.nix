self: super:
{
  mermaid-cli = self.pkgs.fetchFromGitHub {
    owner = "akirak";
    repo = "mermaid.cli";
    rev = "95de7e4e32ec45578714a0cbd985089f69be6f4a";
    # date = 2020-02-01T02:11:54+09:00;
    sha256 = "0vl3h50y44rhxgzdhzczgq7rlyfc9hy05h4bvkid6qb0vkk9h9cq";
  };

}
