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
}
