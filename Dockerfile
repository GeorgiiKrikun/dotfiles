FROM ubuntu:22.04

COPY deps /opt/deps
RUN /opt/deps/bootstrap.sh
