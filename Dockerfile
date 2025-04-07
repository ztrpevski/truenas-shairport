# Use the official Shairport Sync image as the base
FROM mikebrady/shairport-sync:latest

# Set environment variables (uncomment if needed)
ENV S6_KEEP_ENV=1 \
    PULSE_SERVER=unix:/tmp/pulseaudio.socket \
    PULSE_COOKIE=/tmp/pulseaudio.cookie \
    XDG_RUNTIME_DIR=/tmp

# Create necessary directories (for PulseAudio/PipeWire)
RUN mkdir -p /tmp

# Install alsa-utils for alsamixer (using apk for Alpine Linux)
RUN apk add --no-cache alsa-utils alsaconf \

#RUN addgroup root audio
    

# Copy custom Shairport Sync configuration file (if you have one)
COPY ./shairport-sync.conf /etc/shairport-sync.conf

# Ensure ALSA sound card is accessible
#RUN mkdir -p /var/lib/alsa && touch /var/lib/alsa/asound.state

# Grant access to ALSA sound device
#VOLUME ["/dev/snd"]

# Expose ports
EXPOSE 5000 6001 6002 6003

# Command to run Shairport Sync
CMD ["shairport-sync", "-v", "--name=Attic"]
