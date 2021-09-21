# syntax=docker/dockerfile:1
FROM benvining/dev_machine:latest AS base

FROM base AS workspace

WORKDIR /workspace

COPY . ./

RUN BV_SKIP_GIT_PULL_IN_INIT=TRUE && \
	bash shell/ci_build.sh

COPY shell/on_docker_startup.sh /usr/bin/
RUN chmod +x /usr/bin/on_docker_startup.sh
ENTRYPOINT ["on_docker_startup.sh"]

RUN groupadd -r workspace_user && useradd --no-log-init -r -g workspace_user workspace_user
USER workspace_user

# CMD ["executable","param1","param2"]