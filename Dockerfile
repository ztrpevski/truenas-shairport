FROM debian:bullseye

RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  autoconf \
  alsa-utils \
  libasound2-plugin-equal \
  automake \
  libtool \
  libdaemon-dev \
  libpopt-dev \
  libconfig-dev \
  libasound2-dev \
  libssl-dev \
  libsoxr-dev \
  libavahi-client-dev \
  avahi-daemon \
  dbus \
  curl \
  libsqlite3-dev \
  vim \
#  speaker-test \
  swh-plugins \
  && apt-get clean

RUN git clone https://github.com/mikebrady/shairport-sync.git /shairport-sync
WORKDIR /shairport-sync
RUN autoreconf -i \
 && ./configure --with-alsa --with-soxr --with-ssl=openssl --with-avahi  --sysconfdir=/etc \
 && make \
 && make install

COPY shairport-sync.conf /etc/shairport-sync.conf
COPY asound.conf /etc/asound.conf
RUN echo "source /etc/bash_completion" >> /root/.bashrc
SHELL ["/bin/bash", "-c"]

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
