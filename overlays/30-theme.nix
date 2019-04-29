self: super:
{
  emacs-alt-icon = with self; stdenv.mkDerivation rec {
    name = "emacs-alt-icon";

    src = pkgs.fetchFromGitHub {
      owner = "sjrmanning";
      repo = "emacs-icon";
      rev = "8d8eb9faec240e83c56e48ff470a4d462b79b891";
      sha256 = "1cqgmzb77vdxfq3dzqlgb5hnna9alqmdf4ij40i8g1sissqlb7mc";
      # date = 2014-09-11T21:24:11+08:00;
    };

    phases = [ "buildPhase" ];

    buildInputs = [imagemagick];

    buildPhase = ''
for height in 16 32 48 64 128; do
  dir=$out/share/icons/favorites/"$height"x"$height"/apps
  mkdir -p $dir
  convert $src/emacs-icon.png -resize "$height"x"$height" $dir/emacs.png
done
'';
  };

  suru-plus-terminal-icons = with self; stdenv.mkDerivation rec {
    name = "suru-plus-terminal-icons";
    version = "25.3";

    src = pkgs.fetchFromGitHub {
      owner = "gusbemacbe";
      repo = "suru-plus";
      rev = "v${version}";
      sha256 = "0xl7663zpbknzax9ad3l4d3j19184nymq71880f4y0d73901rqpi";
      # date = 2019-03-18T08:03:48-03:00;
    };

    phases = [ "buildPhase" ];

    buildInputs = [inkscape];

    buildPhase = ''
      cd ${src}/Suru++/apps
      for src in `find -H -regex '.+/[0-9]+/terminal\.svg' | sed 's/^\.\///'`; do
        height=`dirname $src`
        outdir=$out/share/icons/favorites/"$height"x"$height"/apps
        mkdir -p $outdir
        ${pkgs.inkscape}/bin/inkscape -z --export-background-opacity=0 \
        --export-height=$height \
        --export-png=$outdir/terminal.png \
        --file=$src
      done
    '';

    nativeBuildInputs = [ gtk3 ];
  };
}
