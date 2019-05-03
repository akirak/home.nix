self: super:
{
  zsh-pure-prompt = with self; stdenv.mkDerivation {
    name = "zsh-pure-prompt";

    src = pkgs.fetchFromGitHub {
      owner = "sindresorhus";
      repo = "pure";
      rev = "e7036c43487fedf608a988dde54dd1d4c0d96823";
      sha256 = "10mdk4dn2azzrhymx0ghl8v668ydy6mz5i797nmbl2ijx9hlqb3v";
      # date = 2019-03-21T18:29:27+02:00;
    };

    buildPhase = ''
mkdir -p $out
cat > $out/pure.plugin.zsh <<HERE
autoload -Uz promptinit
promptinit
prompt pure
# https://github.com/sindresorhus/pure/issues/188
prompt_pure_set_title() {}
HERE
'';

    installPhase = ''
cp -n *.* $out
ln -s $out/pure.zsh $out/prompt_pure_setup
ln -s $out/async.zsh $out/async
'';
  };

# spaceship prompt
# "${zPromptDir}/prompt_spaceship_setup".source
# = "${pkgs.fetchFromGitHub {
# owner = "denysdovhan";
# repo = "spaceship-prompt";
# rev = "d9f25e14e7bec4bef223fd8a9151d40b8aa868fa";
# sha256 = "0vl5dymd07mi42wgkh0c3q8vf76hls1759dirlh3ryrq6w9nrdbf";
# # date = 2019-03-11T19:03:37+02:00;
# }
# }/spaceship.zsh";

}
