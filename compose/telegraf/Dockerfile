# Use the official Telegraf image
FROM telegraf:latest

# Install Docker CLI (Debian/Ubuntu based) and clean up APT cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends docker.io && \
    rm -rf /var/lib/apt/lists/*

# Create a symlink for Docker in the local bin for easier access
RUN ln -s /usr/bin/docker /usr/local/bin/docker

# Ensure the Docker group exists and add Telegraf user to it
RUN groupadd -g 999 docker || true && \
    usermod -aG docker telegraf

# Set the user to root to grant necessary permissions to Telegraf
USER root

# Specify the CMD to run Telegraf
CMD ["telegraf"]
