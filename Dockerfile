# syntax=docker/dockerfile:1
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
    && rm -rf /var/lib/apt/lists/*

# Make sure clang is the default compiler
RUN DEBIAN_FRONTEND=noninteractive update-alternatives --install /usr/bin/cc cc /usr/bin/clang-11 100 && \
    DEBIAN_FRONTEND=noninteractive update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-11 100

WORKDIR /workspace

COPY . ./

ENV BV_SKIP_GIT_PULL_IN_INIT=TRUE

RUN bash shell/ci_build.sh

COPY shell/on_docker_startup.sh /usr/bin/
RUN chmod +x /usr/bin/on_docker_startup.sh
ENTRYPOINT ["on_docker_startup.sh"]

RUN groupadd -r workspace_user && useradd --no-log-init -r -g workspace_user workspace_user
USER workspace_user

# CMD ["executable","param1","param2"]