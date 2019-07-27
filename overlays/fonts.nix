self: super:
{
  hannari-mincho-font = with self; stdenv.mkDerivation rec {
    name = "hannari-mincho-font";

    src = fetchurl {
      url = "https://github.com/qothr/cabinet/blob/master/hannari.zip?raw=true";
      sha256 = "f9f7cb9c2711e04b8ad492af5d3ae11b948f1de7bec7896470b1728602010a4e";
    };

    dontBuild = true;
    buildInputs = [ unzip ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      fontDir=$out/share/fonts/truetype
      mkdir -p $fontDir
      cp *.otf $fontDir
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
