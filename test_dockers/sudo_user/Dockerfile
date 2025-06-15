FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]

ENV TEST_UID=1003
ENV TEST_GID=1050
RUN useradd -m --uid ${TEST_UID} -s /bin/bash devuser
RUN groupadd --gid ${TEST_GID} devgroup
RUN usermod -aG sudo devuser
RUN usermod -aG devgroup devuser
RUN apt update && apt install -y git build-essential curl sudo
RUN echo "devuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER devuser


