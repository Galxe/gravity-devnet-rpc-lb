# Use Debian slim as the base image for smaller size
FROM debian:bookworm-slim

# Install dependencies (HAProxy + Nginx) and clean up in a single layer
# to minimize image size
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        haproxy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy configuration files into the container
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Make entrypoint script executable
RUN chmod +x /entrypoint.sh

EXPOSE 8080

# Set the entrypoint script to handle service startup
ENTRYPOINT ["/entrypoint.sh"]