FROM sudo_user_test_image:latest
SHELL ["/bin/bash", "-c"]

# Do the copy here first, because bootstrap takes a while and we want to avoid cache invalidation
COPY deps/bootstrap.sh /opt/deps/bootstrap.sh
RUN /opt/deps/bootstrap.sh

COPY deps/justfile /opt/deps/justfile
RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile install-zsh
RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile install-oh-my-zsh 
RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile change-shell-zsh
RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile setup-cargo-zsh

COPY configs/zsh /opt/configs/zsh
RUN ${HOME}/.cargo/bin/just -f /opt/configs/zsh/justfile setup

RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile install-neovim
RUN ${HOME}/.cargo/bin/just -f /opt/deps/justfile setup-nvim-path-zsh

COPY configs/nvim /opt/configs/nvim
RUN ${HOME}/.cargo/bin/just -f /opt/configs/nvim/justfile setup


# RUN ${HOME}/.cargo/bin/cargo install ripgrep 
# RUN ${HOME}/.cargo/bin/cargo install bottom 
# RUN ${HOME}/.cargo/bin/cargo install fd-find

