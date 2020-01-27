FROM ubuntu:18.04

ENV DEBIAN_FRONTEND         noninteractive

ARG NODE_VERSION=10

MAINTAINER Roman Lakhtadyr <roman.lakhtadyr@gmail.com>

# Install container dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        curl \
        apt-transport-https \
        ca-certificates \
        && \
    (curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash) && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        nodejs \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
