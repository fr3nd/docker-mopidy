FROM debian:buster-slim

ENV MOPIDY_VERSION 2.3.1-1

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      gnupg2 \
      wget \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*

RUN wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      mopidy=${MOPIDY_VERSION} \
      mopidy-local-sqlite \
      mopidy-scrobbler \
      mopidy-somafm \
      mopidy-soundcloud \
      mopidy-tunein \
      mopidy-spotify \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*

COPY mopidy.conf /etc/mopidy/mopidy.conf
COPY logging.conf /etc/mopidy/logging.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /var/lib/mopidy
ENV HOME=/var/lib/mopidy

CMD /entrypoint.sh
