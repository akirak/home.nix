FROM nixos/nix
RUN nix-env -i coreutils
ENV HOME /root
RUN mkdir -p /root/home.nix
ADD . /root/home.nix
WORKDIR /root/home.nix
RUN sh bootstrap.sh
RUN nix-shell -p bash --run 'bash choose-profile.bash'
RUN test -e profile.nix
RUN unlink profile.nix
RUN ln -s profiles/linux-full.nix profile.nix
RUN cp identity.sample.nix identity.nix
RUN nix-shell -p gnumake --run 'make all'
RUN nix-shell -p bats --run 'bats tests/install-all.bats'
RUN nix-store --gc
