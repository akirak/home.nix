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
    version = "30.0";

    src = pkgs.fetchFromGitHub {
      owner = "gusbemacbe";
      repo = "suru-plus";
      rev = "v${version}";
      sha256 = "18kc463q4kbzb3zkig0rycjqhxgsq8lrfwji7zkjbadflspcif32";
      # date = 2019-04-29T04:32:42-03:00;
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

  la-capitaine-icons = with self; stdenv.mkDerivation rec {
    name = "la-capitaine-icons";
    version = "0.6.1";

    src = pkgs.fetchFromGitHub {
      owner = "keeferrourke";
      repo = "la-capitaine-icon-theme";
      rev = "0299ebbdbbc4cb7dea8508059f38a895c98027f7";
      sha256 = "050w5jfj7dvix8jgb3zwvzh2aiy27i16x792cv13fpqqqgwkfpmf";
      # date = 2019-07-13T15:37:21+00:00;
    };

    phases = [ "buildPhase" ];

    buildInputs = [inkscape];

    buildPhase = ''
      cd ${src}/apps/scalable
      for basename in xorg; do
        for height in 32 48 64 96 128; do
          outdir=$out/share/icons/favorites/"$height"x"$height"/apps
          mkdir -p $outdir
          ${pkgs.inkscape}/bin/inkscape -z --export-background-opacity=0 \
            --export-height=$height \
            --export-png=$outdir/$basename.png \
            --file=$basename.svg
        done
      done
    '';

    nativeBuildInputs = [ gtk3 ];
  };

  alacritty-icons = with self; stdenv.mkDerivation rec {
    name = "alacritty-icons";
    version = "0.6.1";

    src = super.pkgs.alacritty.src;

    phases = [ "buildPhase" ];

    buildInputs = [inkscape];

    buildPhase = ''
      cd ${src}/extra/logo
      for basename in alacritty-term; do
        for height in 32 48 64 96 128; do
          outdir=$out/share/icons/favorites/"$height"x"$height"/apps
          mkdir -p $outdir
          ${pkgs.inkscape}/bin/inkscape -z --export-background-opacity=0 \
            --export-height=$height \
            --export-png=$outdir/$basename.png \
            --file=$basename.svg
        done
      done
    '';

    nativeBuildInputs = [ gtk3 ];
  };

}
