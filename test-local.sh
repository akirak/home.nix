NAME=akirak/home.nix:latest
docker build -t $NAME . && docker run $NAME make -f test.mk all
