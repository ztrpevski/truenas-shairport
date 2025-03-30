FROM shairport-sync:latest

# Update and install dependencies
RUN apt-get update -y && apt-get install -y \
    build-essential git autoconf automake libtool \
    libpopt-dev libasound2-dev libavahi-client-dev \
    libmbedtls-dev libsoxr-dev libconfig-dev \
    libpulse-dev libmosquitto-dev libgstreamer1.0-dev \
    libglib2.0-dev libdbus-1-dev \
    alsa-utils alsa-plugins \
    ffmpeg libavcodec-dev libavformat-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && echo "Installed packages successfully"

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
