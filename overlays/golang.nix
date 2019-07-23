self: super:
{

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

}
