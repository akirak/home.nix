self: super:
{

  # Deprecated. I won't use it since there is magit-list-repositories
  # on Emacs.
  gitbatch = with self; stdenv.mkDerivation rec {
    name = "gitbatch";
    version = "0.5.0";

    src = fetchurl {
      url = "https://github.com/isacikgoz/gitbatch/releases/download/v${version}/gitbatch_${version}_linux_amd64.tar.gz";
      sha256 = "0dw34m7qlz8i64jmng8ia9mdrr7ggq92ppcq5il3xk18n5qamgyq";
    };

    builder = builtins.toFile "builder.sh" ''
source $stdenv/setup

tar xvfz $src
mkdir -p $out/bin
install -t $out/bin gitbatch
'';
  };

  gif-progress = with self; stdenv.mkDerivation rec {
    name = "gif-progress";
    version = "latest";
    archive = "gif-progress-linux-amd64";

    src = fetchurl {
      url = "https://github.com/nwtgck/gif-progress/releases/download/release-fix-not-moving-progress-bar/gif-progress-linux-amd64.tar.gz";
      sha256 = "139zm9bbmnayn52myfjrshmg5wagzvghqxagv4g1b2dznjrxd4vn";
      # date = 2019-12-31T04:50:01+0900;
    };

    builder = builtins.toFile "builder.sh" ''
source $stdenv/setup

tar xvfz $src
mkdir -p $out/bin
install -t $out/bin $archive/gif-progress
'';
  };

}
