FROM ruby:2.6.6-slim

#ENV SRC_GHURL
#ENV SRC_GHTOKEN
#ENV SRC_GHORG
#ENV TRG_GHURL
#ENV TRG_GHTOKEN
#ENV TRG_GHORG
#ENV REPO_CACHE_PATH
#ENV REPO

WORKDIR /app
ADD . /app/
RUN apt-get -q -y update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    ssh \
    git

RUN set -uex; \
    bundle install

CMD ["sh","-c","./hubsync.rb","${SRC_GHURL}","${SRC_GHTOKEN}","${SRC_GHORG}","${TRG_GHURL}","${TRG_GHTOKEN}","${TRG_GHORG}","${REPO_CACHE_PATH}","${REPO}"]

# ADD those ENV to docker run with -e KEY=Value or use a local exported VAR
#
# ./hubsync.rb <source github enterprise url>           \
#              <source github enterprise token>         \
#              <source github enterprise organization>  \
#              <targert github enterprise url>          \
#              <targert github enterprise token>        \
#              <targert github enterprise organization> \
#              <repository-cache-path>                  \
#              [<repository-to-sync>]