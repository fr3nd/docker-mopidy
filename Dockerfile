FROM python:2.7-slim

ENV MOPIDY_VERSION 2.3.1

RUN apt-get update && apt-get install -y \
      build-essential \
      gir1.2-gst-plugins-base-1.0 \
      gir1.2-gstreamer-1.0 \
      gstreamer1.0-plugins-good \
      gstreamer1.0-plugins-ugly \
      gstreamer1.0-tools \
      python-dev \
      python-gst-1.0 \
      python-pip \
      wget \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*

RUN pip install mopidy==${MOPIDY_VERSION}

RUN wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list
RUN wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/stretch.list
RUN apt-get update && apt-get install -y \
      libspotify12 \
      libspotify-dev \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
