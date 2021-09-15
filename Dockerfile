FROM rikorose/gcc-cmake:latest

# Install deps
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    ruby \
    clang-11 \
    ninja-build \
    pkg-config \
    openssh-client \
    apt

# Make sure clang is the default compiler
RUN DEBIAN_FRONTEND=noninteractive update-alternatives --install /usr/bin/cc cc /usr/bin/clang-11 100 && \
    DEBIAN_FRONTEND=noninteractive update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-11 100

WORKDIR /workspace

ADD . ./

ENV BV_SKIP_GIT_PULL_IN_INIT=TRUE BV_USE_LOG_FILES=FALSE

RUN bash shell/ci_build.sh
