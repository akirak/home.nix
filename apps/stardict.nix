{ profile, pkgs, lib, ... }:
with profile;
let
  sources = {
    bbi-combinatory = pkgs.fetchzip {
      url = "http://download.huzheng.org/bigdict/stardict-The_BBI_Combinatory_Dictionary_of_English-2.4.2.tar.bz2";
      sha256 = "000r6w2xpby6v2syir78wnhkn2537cwrg464fv2cx24lixdi20l6";
    };

    longman-common-errors = pkgs.fetchzip {
      url = "http://download.huzheng.org/bigdict/stardict-Longman_Dictionar_of_Common_Errors-2.4.2.tar.bz2";
      sha256 = "0lmxdj4i40n2ijfr84pjfjmyn1bjgw2sbvq6f1ypy68na9l91hyq";
      # date = 2021-04-10T13:01:36+0900;
    };

    oxford-collocations = pkgs.fetchzip {
      url = "http://download.huzheng.org/bigdict/stardict-Oxford_Collocations_Dictionary_2nd_Ed-2.4.2.tar.bz2";
      sha256 = "1zkfs0zxkcn21z2lhcabrs77v4ma9hpv7qm119hpyi1d8ajcw07q";
      # date = 2021-04-10T13:01:43+0900;
    };

    macmillan-thesaurus = pkgs.fetchzip {
      url = "http://download.huzheng.org/bigdict/stardict-Macmillan_English_Thesaurus-2.4.2.tar.bz2";
      sha256 = "1458vlh715xspim9h3qn1zz4r0lm00nfb4vfr38vf77pv3clsr91";
      # date = 2021-04-10T13:01:47+0900;
    };

    oxford-advanced-learners = pkgs.fetchzip {
      url = "http://download.huzheng.org/bigdict/stardict-Oxford_Advanced_Learner_s_Dictionary-2.4.2.tar.bz2";
      sha256 = "1dd5py3paw0dr8rn7nc5kr1k27l70lda6pgq1gd6lnhr6zacmssl";
      # date = 2021-04-10T13:02:08+0900;
    };

    wordnet = pkgs.fetchzip {
      url = "http://download.huzheng.org/bigdict/stardict-WordNet_3-2.4.2.tar.bz2";
      sha256 = "15zlgq2a4xyjyir197fbbps3rxac6klr9mdaip34jnx7lnvkjznl";
      # date = 2021-04-10T13:15:18+0900;
    };
  };

  dictFiles = pkgs.symlinkJoin {
    name = "my-stardict-dict-files";
    paths = with sources; [
      oxford-advanced-learners
      macmillan-thesaurus
      longman-common-errors
      wordnet
    ];
  };

  dicts = pkgs.linkFarm "my-stardict-dicts" [
    {
      name = "share/stardict/dict";
      path = dictFiles;
    }
  ];
in
{
  home.packages = with pkgs; [
    sdcv
    goldendict
    dicts
  ];
}
