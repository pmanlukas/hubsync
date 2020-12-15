FROM ruby:2.6.6-slim

ARG ssh_prv_key
ARG ssh_pub_key
ARG source_ghes_domain
ARG target_ghes_domain

WORKDIR /app
ADD . /app/

RUN apt-get -q -y update \
    &&  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      openssh-client \
      git \
    && rm -rf /var/lib/apt/lists/*

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan ghe.io > /root/.ssh/known_hosts \
    ssh-keyscan github.stoelzle.me > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

RUN set -uex; \
    bundle install

# Enforce SSH
RUN echo "[url \"git@${source_ghes_domain}:\"]\n\tinsteadOf = https://${source_ghes_domain}/" >> /root/.gitconfig
RUN echo "[url \"git@${target_ghes_domain}:\"]\n\tinsteadOf = https://${target_ghes_domain}/" >> /root/.gitconfig

# Execute it
ENTRYPOINT ["/usr/local/bin/ruby", "/app/hubsync.rb"]
