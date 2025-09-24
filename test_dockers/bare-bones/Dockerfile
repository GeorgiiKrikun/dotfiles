FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a new user
ARG USERNAME=customuser
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID --create-home $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the new user
USER $USERNAME

# Set the working directory
WORKDIR /home/$USERNAME

# Default command



