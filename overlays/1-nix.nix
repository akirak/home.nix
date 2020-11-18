self: super: {

  nixGL =
    import (builtins.fetchGit {
      url = "https://github.com/guibou/nixGL.git";
      ref = "master";
      rev = "04a6b0833fbb46a0f7e83ab477599c5f3eb60564";
      # sha256 = "0z1zafkb02sxng91nsx0gclc7n7sv3d5f23gp80s3mc07p22m1k5";
    }) {};

}
