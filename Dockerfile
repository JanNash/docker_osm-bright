# DOCKER-VERSION 17.03.0-ce
# VERSION 0.3.0

FROM debian:jessie-slim
MAINTAINER Jan Nash <jnash@jnash.de>

ARG CONTENT_DIR_PATH

ENV DEBIAN_FRONTEND noninteractive

RUN \
apt-get update && \
apt-get install -y --no-install-recommends \
	ca-certificates \
	node-carto \
	python \
	unzip \
	wget && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN mkdir -p ${CONTENT_DIR_PATH}

COPY ./scripts/load_and_process_osmbright /usr/local/bin
COPY ./content/configure.py ${CONTENT_DIR_PATH}

RUN chmod +x /usr/local/bin/load_and_process_osmbright ${CONTENT_DIR_PATH}/configure.py

ENTRYPOINT ["load_and_process_osmbright"]
