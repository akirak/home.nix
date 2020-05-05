self: super: {
  gleam = super.stdenv.mkDerivation rec {
    name = "gleam";
    version = "0.7.1";
    src = builtins.fetchTarball
      "https://github.com/gleam-lang/gleam/releases/download/v${version}/gleam-v${version}-linux-amd64.tar.gz";
    buildInputs = [ super.coreutils ];
    propagateBuildInputs = [ self.erlang ];
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      cd $src
      pwd
      ls -al
      # cp $src $out/bin/gleam
      exit 1
    '';
  };
}
