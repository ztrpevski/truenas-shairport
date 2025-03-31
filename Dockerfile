# Use the official Shairport Sync image as the base
FROM mikebrady/shairport-sync:latest

# Set environment variables (uncomment if needed)
# ENV S6_KEEP_ENV=1 \
#     PULSE_SERVER=unix:/tmp/pulseaudio.socket \
#     PULSE_COOKIE=/tmp/pulseaudio.cookie \
#     XDG_RUNTIME_DIR=/tmp

# Create necessary directories (for PulseAudio/PipeWire)
RUN mkdir -p /tmp

# Copy custom Shairport Sync configuration file (if you have one)
# COPY ./shairport-sync.conf /etc/shairport-sync.conf

# Grant access to ALSA sound devices
VOLUME ["/dev/snd"]

# Expose necessary ports (if needed for remote control)
# EXPOSE 5000 6001

# Command to run Shairport Sync (modify output backend as needed)
CMD ["shairport-sync -v --name=MyShairport --output=alsa"]
