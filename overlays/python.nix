self: super:
with self;
with self.python3Packages;
let
  beautifultable = buildPythonPackage rec {
    pname = "beautifultable";
    version = "0.8.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "05dqml5hl3skxchzpsa49lw5ga4szd7gh92kcy4glyzdpd8rakfl";
    };

    doCheck = false;
  };

  globber = buildPythonPackage rec {
    pname = "globber";
    version = "0.2.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0w7gaqpfc9j9l6hgm0cl7hrlf3lr0w7ifns035cksa1r16mhlwlr";
    };

    doCheck = false;
  };

  gitpython = buildPythonPackage rec {
    pname = "gitpython";
    version = "3.0.5";

    src = fetchPypi {
      inherit version;
      pname = "GitPython";
      sha256 = "0hjykykim1xvmy6359nm8vb3myd411pk2jrj4w5w9cywqgzrh8ww";
    };

    doCheck = false;

    propagatedBuildInputs = [
      gitdb2
    ];
  };

  # https://github.com/NixOS/nixpkgs/blob/69d58ee24506e2b3b5aff347ae3b0791110340ec/pkgs/applications/misc/gramps/default.nix
  git-hammer = buildPythonPackage rec {
    pname = "git-hammer";
    version = "0.1.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0sq98p2a40wn1r292qsj25y8ynnsswv4xljfw026hdv00lhcxd9c";
    };

    nativeBuildInputs = [pkgs.git];

    propagatedBuildInputs = [
      sqlalchemy
      sqlalchemy-utils
      matplotlib
      globber
      beautifultable
      python-dateutil
      gitpython
    ];

    shellHook = ''
makeWrapper $out/bin/githammer $out/lib/${python.libPrefix}/site-packages/githammer/__main__.py
'';

    doCheck = false;

    meta = with stdenv.lib; {
      homepage = "https://github.com/asharov/git-hammer";
      description = "Collect and display statistics of git repositories";
      license = licenses.apache;
    };
  };
in
{
  inherit git-hammer;
}
