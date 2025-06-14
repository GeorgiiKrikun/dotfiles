FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]

# Do the copy here first, because bootstrap takes a while and we want to avoid cache invalidation
COPY deps/bootstrap.sh /opt/deps/bootstrap.sh
RUN /opt/deps/bootstrap.sh

COPY deps/justfile /opt/deps/justfile
RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile install-zsh
RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile install-oh-my-zsh 
RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile change-shell-zsh
RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile setup-cargo-zsh
# RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile install-neovim
# RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile setup-nvim-path-zsh
# RUN ${HOME}/.cargo/bin/cargo install ripgrep 
# RUN ${HOME}/.cargo/bin/cargo install bottom 
# RUN ${HOME}/.cargo/bin/cargo install fd-find

