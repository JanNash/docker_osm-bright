# DOCKER-VERSION 17.06.0-ce
# VERSION 0.3.0

FROM debian:stretch-slim
MAINTAINER Jan Nash <jnash@jnash.de>

ENV DEBIAN_FRONTEND noninteractive

ARG CONTENT_DIR_PATH
ARG STATUS_VOLUME_PATH

RUN \
# Check for mandatory build-arguments
    MISSING_ARG_MSG="Build argument needs to be set and non-empty." \
&&  : "${CONTENT_DIR_PATH:?${MISSING_ARG_MSG}}" \
&&  : "${STATUS_VOLUME_PATH:?${MISSING_ARG_MSG}}" \

# Package installations
&&  apt-get update \
&&  apt-get install -y --no-install-recommends \
        ca-certificates \
        node-carto \
        python \
        wget \

# Cleanup
&&  apt-get clean \
&&  rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/* \

# Create directories
&&  mkdir -p \
        "${STATUS_VOLUME_PATH}" \
        "${CONTENT_DIR_PATH}"

COPY ./content/wait_for_osmbright "${STATUS_VOLUME_PATH}"
COPY ./content/configure.py "${CONTENT_DIR_PATH}"
COPY ./scripts/load_and_process_osmbright /usr/local/bin

RUN chmod +x \
        "${STATUS_VOLUME_PATH}/wait_for_osmbright" \
        "${CONTENT_DIR_PATH}/configure.py" \
        /usr/local/bin/load_and_process_osmbright

# FIXME: Atm, the command has to be specified in the compose-file,
# so it doesn't get wiped by the overridden entrypoint in the compose-file.
# For further information, see: https://github.com/docker/compose/issues/3140
# CMD ["load_and_process_osmbright"]
