FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    build-base git autoconf automake libtool \
    popt-dev alsa-lib-dev avahi-dev \
    mbedtls-dev soxr-dev libconfig-dev \
    pulseaudio-dev mosquitto-dev gstreamer-dev \
    glib-dev dbus dbus-dev avahi \
    alsa-utils alsa-plugins \
    ffmpeg-dev alac-decoder \
    && rm -rf /var/cache/apk/*

# Clone Shairport Sync source
WORKDIR /usr/src
RUN git clone https://github.com/mikebrady/shairport-sync.git && \
    cd shairport-sync && \
    autoreconf -i -f && \
    ./configure \
        --with-alsa \
        --with-dummy \
        --with-pipe \
        --with-stdout \
        --with-avahi \
        --with-ssl=mbedtls \
        --with-soxr \
        --sysconfdir=/etc \
        --with-dbus-interface \
        --with-mpris-interface \
        --with-mqtt-client \
        --with-apple-alac \
        --with-convolution \
        --with-airplay-2 \
        --with-sysnice \
    && make -j$(nproc) && \
    make install && \
    ldconfig

# Clean up
RUN rm -rf /usr/src/shairport-sync

# Create config directory
RUN mkdir -p /etc/shairport-sync

# Ensure ALSA sound card is accessible
RUN mkdir -p /var/lib/alsa && touch /var/lib/alsa/asound.state

# Grant access to ALSA sound device
VOLUME ["/dev/snd"]

# Expose ports
EXPOSE 5000 6001 6002 6003

# Command to run Shairport Sync
CMD ["shairport-sync", "-v"]
