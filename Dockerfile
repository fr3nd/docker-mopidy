FROM debian:buster-slim

ENV MOPIDY_VERSION 3.0.2-1
ENV MOPIDY_LOCAL_VERSION 3.1.1-1
ENV MOPIDY_MPD 3.0.0-1
ENV MOPIDY_SOMAFM 2.0.0-1
ENV MOPIDY_SCROBBLER 2.0.0-1
ENV MOPIDY_SOUNDCLOUD 3.0.0-1
ENV MOPIDY_TUNEIN 1.0.0-1
ENV MOPIDY_GMUSIC 4.0.0
ENV MOPIDY_MOBILE 1.9.1
ENV MOPIDY_MUSICBOX_WEBCLIENT 3.0.1
ENV MOPIDY_PARTY 1.0.0
ENV MOPIDY_SPOTIFY 4.0.1
ENV IRIS_VERSION 3.50.0

WORKDIR /src
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      git \
      gnupg2 \
      wget \
      && \
    wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add - && \
    wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      dumb-init \
      libspotify-dev \
      libspotify12 \
      mopidy-local=${MOPIDY_LOCAL_VERSION} \
      mopidy-mpd=${MOPIDY_MPD} \
      mopidy-scrobbler=${MOPIDY_SCROBBLER} \
      mopidy-somafm=${MOPIDY_SOMAFM} \
      mopidy-soundcloud=${MOPIDY_SOUNDCLOUD} \
      mopidy-tunein=${MOPIDY_TUNEIN} \
      mopidy=${MOPIDY_VERSION} \
      python3-pip \
    && \
    pip3 install \
      Mopidy-GMusic==${MOPIDY_GMUSIC} \
      git+git://github.com/jaedb/Iris.git@${IRIS_VERSION}#egg=Mopidy-Iris \
      Mopidy-Mobile==${MOPIDY_MOBILE} \
      Mopidy-MusicBox-Webclient==3.0.1 \
      Mopidy-Party==${MOPIDY_PARTY} \
      Mopidy_Spotify==${MOPIDY_SPOTIFY} \
    && \
    apt-get purge --auto-remove -y \
      git \
      gcc \
      wget \
    && \
    apt-get clean all && \
    rm -rf /usr/share/doc/* && \
    rm -rf /usr/share/info/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/* && \
    rm -rf /var/lib/apt/lists/*

COPY mopidy.conf /etc/mopidy/mopidy.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/lib/mopidy
ENV HOME=/var/lib/mopidy
RUN usermod -G audio,sudo mopidy && \
    chown mopidy:audio -R $HOME /entrypoint.sh && \
    chmod go+rwx -R $HOME /entrypoint.sh
USER mopidy:audio

VOLUME ["/var/lib/mopidy/local", "/var/lib/mopidy/local-images"]

EXPOSE 6600 6680 1704 1705 5555/udp

#ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint.sh"]
CMD ["/usr/bin/mopidy", "--config", "/etc/mopidy/mopidy.conf"]
