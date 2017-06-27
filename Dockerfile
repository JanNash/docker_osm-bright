# DOCKER-VERSION 17.03.0-ce
# VERSION 0.3.0

FROM debian:jessie-slim
MAINTAINER Jan Nash <jnash@jnash.de>

ENV DEBIAN_FRONTEND noninteractive

ARG CONTENT_DIR_PATH
ARG WAIT_FOR_VOLUME_PATH

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

COPY ./content/shapefiles "${WAIT_FOR_VOLUME_PATH}"
COPY ./content/configure.py ${CONTENT_DIR_PATH}
COPY ./scripts/load_and_process_osmbright /usr/local/bin

RUN chmod +x \
	"${WAIT_FOR_VOLUME_PATH}"/shapefiles \
	${CONTENT_DIR_PATH}/configure.py \
	/usr/local/bin/load_and_process_osmbright

CMD ["load_and_process_osmbright"]
