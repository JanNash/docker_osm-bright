# DOCKER-VERSION 17.06.0-ce
# VERSION 0.3.0

FROM debian:stretch-slim
MAINTAINER Jan Nash <jnash@jnash.de>

ENV DEBIAN_FRONTEND noninteractive

ARG CONTENT_DIR_PATH
ARG WAIT_FOR_VOLUME_PATH

RUN \
# Check for mandatory build-arguments
    MISSING_ARG_MSG="Build argument needs to be set and non-empty." \
&&  : "${CONTENT_DIR_PATH:?${MISSING_ARG_MSG}}" \
&&  : "${WAIT_FOR_VOLUME_PATH:?${MISSING_ARG_MSG}}" \

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
        "${WAIT_FOR_VOLUME_PATH}" \
        "${CONTENT_DIR_PATH}"

COPY ./content/osm-bright "${WAIT_FOR_VOLUME_PATH}"
COPY ./content/configure.py "${CONTENT_DIR_PATH}"
COPY ./scripts/load_and_process_osmbright /usr/local/bin

RUN chmod +x \
        "${WAIT_FOR_VOLUME_PATH}/osm-bright" \
        "${CONTENT_DIR_PATH}/configure.py" \
        /usr/local/bin/load_and_process_osmbright

CMD ["load_and_process_osmbright"]
