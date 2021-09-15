FROM ubuntu:latest AS base

FROM base AS juce_dev_machine

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    clang-11 \
    cmake \
    ninja-build \
    pkg-config \
    openssh-client \
    ruby

# Make sure clang is the default compiler:
RUN DEBIAN_FRONTEND=noninteractive update-alternatives --install /usr/bin/cc cc /usr/bin/clang-11 100
RUN DEBIAN_FRONTEND=noninteractive update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-11 100

ADD . /dev_workspace

WORKDIR /dev_workspace

ENV BV_IGNORE_GIT_IN_INIT=TRUE

RUN bash shell/ci_build.sh