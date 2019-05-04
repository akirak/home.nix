self: super:
{
  my-scripts = with self; stdenv.mkDerivation {
    name = "my-scripts";

    src = ../scripts;

    installPhase = ''
      mkdir -p $out/bin
      find . -maxdepth 1 \( -type f -o -type l \) -executable \
        -exec cp -pL {} $out/bin \;
'';
  };

  git-sync= with self; stdenv.mkDerivation {
    name = "git-sync";

    src = pkgs.fetchFromGitHub {
      owner = "simonthum";
      repo = "git-sync";
      rev = "dd3715598ab98a2e9453a17e52fa079ce5038cf5";
      sha256 = "0j4xk2vg3n5x9wbassjgiyv79729ii5zgix3hrfigbvnwqm203bi";
      # date = 2019-04-26T21:41:14+02:00;
    };

    installPhase = ''
mkdir -p $out/bin
install -t $out/bin git-sync
'';
  };

}
