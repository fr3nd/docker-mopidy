FROM debian:buster-slim

ENV MOPIDY_VERSION 3.0.1-2
ENV MOPIDY_LOCAL_VERSION 3.1.1-1
ENV IRIS_VERSION 3.44.0

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
      mopidy-mpd=3.0.0-1 \
      mopidy-scrobbler=2.0.0-1 \
      mopidy-somafm=2.0.0~rc1-1 \
      mopidy-soundcloud=3.0.0-1 \
      mopidy-tunein=1.0.0-1 \
      mopidy=${MOPIDY_VERSION} \
      python3-pip \
    && \
    pip3 install \
      Mopidy-GMusic==4.0.0 \
      git+git://github.com/jaedb/Iris.git@${IRIS_VERSION}#egg=Mopidy-Iris \
      Mopidy-Mobile==1.9.1 \
      Mopidy-MusicBox-Webclient==3.0.1 \
      Mopidy-Party==1.0.0 \
      Mopidy_Spotify==4.0.1 \
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
