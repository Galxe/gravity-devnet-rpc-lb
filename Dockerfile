# Use Debian slim as the base image for smaller size
FROM debian:bookworm-slim

# Install dependencies and clean up in a single layer to minimize image size.
# libnginx-mod-http-js: njs module for JSON-RPC body inspection (debug/trace whitelist)
# gettext-base: provides envsubst for EXPLORER_TOKEN substitution at container start
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        libnginx-mod-http-js \
        gettext-base \
        haproxy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/nginx/njs

# Copy configuration files into the container.
# nginx.conf is stored as a template; entrypoint substitutes ${EXPLORER_TOKEN} at start.
COPY haproxy.cfg    /etc/haproxy/haproxy.cfg
COPY nginx.conf     /etc/nginx/nginx.conf.template
COPY rpc.js         /etc/nginx/njs/rpc.js
COPY entrypoint.sh  /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
