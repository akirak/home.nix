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

  code-new-roman = with self; stdenv.mkDerivation rec {
    name = "code-new-roman";

    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/CodeNewRoman.zip";
      # date = 2019-09-28T02:33:02+0900;
      sha256 = "18v86qw4skaz4g9fjs1cq218mmngwacd4jg3lnjgzdvbsjpjwc5l";
    };

    dontBuild = true;
    buildInputs = [ unzip ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      fontDir=$out/share/fonts/opentype
      mkdir -p $fontDir
      cp *.otf $fontDir
    '';
  };

  go-mono = with self; stdenv.mkDerivation rec {
    name = "go-mono";

    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Go-Mono.zip";
      # date = 2019-09-28T02:49:11+0900;
      sha256 = "18qga9z2hwsbaxi601vkfdh8fylg7j6q6nmi5zz3h28imd5kppmr";
    };

    dontBuild = true;
    buildInputs = [ unzip ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      fontDir=$out/share/fonts/truetype
      mkdir -p $fontDir
      cp *.ttf $fontDir
    '';
  };

  tinos = with self; stdenv.mkDerivation rec {
    name = "tinos";

    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Tinos.zip";
      # date = 2019-09-28T13:32:59+0900;
      sha256 = "09i4jki7qhfg76f63lvlxa3ddxgi5kx7y8xzk049z0z709k31qfg";
    };

    dontBuild = true;
    buildInputs = [ unzip ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      fontDir=$out/share/fonts/truetype
      mkdir -p $fontDir
      cp *.ttf $fontDir
    '';
  };

  hack-font = with self; stdenv.mkDerivation rec {
    name = "hack-font";

    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip";
      # date = 2019-09-28T13:33:37+0900;
      sha256 = "076l1q4kz8hmgf3hkizx21846gsfcm3ryyg6zimzl403zn1p856i";
    };

    dontBuild = true;
    buildInputs = [ unzip ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      fontDir=$out/share/fonts/truetype
      mkdir -p $fontDir
      cp *.ttf $fontDir
    '';
  };

}
