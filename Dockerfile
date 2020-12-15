FROM ruby:2.6.6-slim

RUN apt-get -q -y update \
    &&  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      openssh-client \
      git \
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /app
ADD . /app/

RUN set -uex; \
    bundle install

ENTRYPOINT ["/usr/local/bin/ruby", "/app/hubsync.rb"]