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

  myrepos = with self; stdenv.mkDerivation rec {
    name = "myrepos";
    version = "1.20180726";

    src = fetchTarball {
      url = "https://git.joeyh.name/index.cgi/myrepos.git/snapshot/myrepos-${version}.tar.gz";
      sha256 = "0jphw61plm8cgklja6hs639xhdvxgvjwbr6jpvjwpp7hc5gmhms5";
    };

    nativeBuildInputs = [pkgs.perl];

    installPhase = ''
mkdir -p $out/bin
install -t $out/bin mr
'';
  };

  bashcaster =
    let
      pkgs = self.pkgs;
      wrapped = with self; stdenv.mkDerivation rec {
        name = "bashcaster";
        version = "0.20190108";

        src = pkgs.fetchFromGitHub {
          owner = "alphapapa";
          repo = "bashcaster";
          rev = "5c27de9b7f40ddb724dbfc52543d85c4a1f6c1dc";
          sha256 = "0nap99qms5d1j0ny0ba5d49y4rvvyyxi959w5q7d704s507h10kn";
          # date = 2019-01-17T10:16:45-06:00;
        };

        installPhase = ''
mkdir -p $out/bin
install -t $out/bin bashcaster.sh
mv $out/bin/bashcaster.sh $out/bin/bashcaster
'';
      };
    in pkgs.symlinkJoin {
      name = "bashcaster";
      paths = with pkgs; [
        wrapped
        ffmpeg
        yad
        slop
        gifsicle
        xorg.xprop
        xorg.xwininfo
      ];
      buildInputs = with pkgs; [
        makeWrapper
      ];
      postBuild = ''
        wrapProgram $out/bin/bashcaster
      '';
    };

}
