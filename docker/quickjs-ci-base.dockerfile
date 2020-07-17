FROM ubuntu:20.04

ARG apt_mirror

SHELL ["/bin/bash", "-c"]

# Setup APT

RUN if [ "$apt_mirror" != "" ]; then sed -i "s/http:\/\/archive\.ubuntu\.com/${apt_mirror//\//\\\/}/g" /etc/apt/sources.list; fi

RUN apt-get update \
    && apt-get upgrade -y

# Basic commands

RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    software-properties-common \
    ssh-client \
    unzip \
    wget \
    xz-utils \
    && true

# Install tools for building quickjs

RUN apt-get install -y --no-install-recommends \
    clang \
    make \
    libc6-dev \
    && true

# Install latest git

RUN add-apt-repository ppa:git-core/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends git
