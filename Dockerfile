FROM akirak/nixmacs-bootstrap

ENV NIX_PATH=/root/.nix-defexpr/channels
RUN nix-channel --update

RUN mkdir /root/nix
ADD . /root/nix
WORKDIR /root/nix
ENV HOME_MANAGER_CONFIG=/root/nix/home.nix
RUN nix-shell '<home-manager>' -A install
RUN home-manager switch
