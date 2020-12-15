FROM ruby:2.6.6-slim

WORKDIR /app

RUN apt-get -q -y update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    ssh \
    git \
    && rm -rf /var/lib/apt/lists/*

ADD Gemfile hubsync.rb /app/

RUN set -uex; \
    bundle install

CMD ["sh","-c","./hubsync.rb","${SRC_GHURL}","${SRC_GHTOKEN}","${SRC_GHORG}","${TRG_GHURL}","${TRG_GHTOKEN}","${TRG_GHORG}","${REPO_CACHE_PATH}","${REPO}"]

# ADD those ENV to env.list file and run with docker run ... --env-file env.txt
#
# ./hubsync.rb <source github enterprise url>           \
#              <source github enterprise token>         \
#              <source github enterprise organization>  \
#              <targert github enterprise url>          \
#              <targert github enterprise token>        \
#              <targert github enterprise organization> \
#              <repository-cache-path>                  \
#              [<repository-to-sync>]