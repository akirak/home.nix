self: super:
{
  honoka-mincho-font = with self; stdenv.mkDerivation rec {
    name = "honoka-mincho-font";

    src = pkgs.fetchzip {
      url = "http://font.gloomy.jp/dl-font-s5a4ik5w/honoka-min.zip";
      sha256 = "1wwrrz62zjnpnasq8d0fzi2kzfj6339xww0riqcg4h33fr97paav";
    };

    dontBuild = true;
    dontUnpack = true;

    installPhase = ''
      fontDir=$out/share/fonts/truetype
      mkdir -p $fontDir
      cp $src/*.ttf $fontDir
    '';
  };

  adobe-chinese = with self; stdenv.mkDerivation rec {
    name = "adobe-chinese";

    src = pkgs.fetchFromGitHub {
      owner = "mingchen";
      repo = "mac-osx-chinese-fonts";
      rev = "c221671103172e641b7590428eef1fc9e6efa51e";
      sha256 = "0r8z0ppdpsxvl1f31yyb533pf3nizcswsncq14xbykl942911zl7";
      # date = 2013-06-30T21:48:23+08:00;
    };

   dontBuild = true;

    installPhase = ''
      fontDir=$out/share/fonts/opentype
      mkdir -p $fontDir
      cp Adobe\ Simple\ Chinese\ Fonts/Adobe*.otf $fontDir
    '';
  };

}
