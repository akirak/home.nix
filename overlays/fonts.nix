# pkgname=otf-harenosora-mincho
# pkgver=1.00
# pkgrel=1
# pkgdesc="Japanese curvy and old style font."
# url="http://fontopo.com/?p=377"
# license=('custom')
# arch=('any')
# depends=('fontconfig' 'xorg-font-utils')
# install=$pkgname.install
# source=(hare.zip::https://github.com/qothr/cabinet/blob/master/hare.zip?raw=true)
# md5sums=('378062934c47a6ae4c79af28008730ef')

# package() {
#   cd ${srcdir}
#   install -dm755 "${pkgdir}"/usr/share/fonts/OTF
#   install -m644 Harenosora.otf "${pkgdir}"/usr/share/fonts/OTF/

#   install -d "${pkgdir}/usr/share/licenses/${pkgname}/"
#   install -Dm644 IPA_Font_License_Agreement_v1.0.txt "${pkgdir}/usr/share/licenses/${pkgname}/"
# }

self: super:
{
  harenosora-mincho-font = with self; stdenv.mkDerivation rec {
    name = "harenosora-mincho-font";

    src = pkgs.fetchFromGitHub {
      owner = "qothr";
      repo = "cabinet";
      rev = "f386afa8faa9052617eefffc88330afe10b7bad6";
      sha256 = "0ngfk7247xlgd6ijxags791xifvpfwyqhnwxcmqd1sv09xvb92wz";
      # date = 2016-10-21T07:10:44+09:00;
    };

    dontBuild = true;

    buildInputs = [unzip];

    installPhase = ''
      fontDir=$out/share/fonts/opentype
      unzip hare.zip
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
