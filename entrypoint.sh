#!/bin/bash
set -e

# Start HAProxy in background
echo "Starting HAProxy..."
/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg &

# Start Nginx in background with daemon mode disabled
echo "Starting Nginx..."
/usr/sbin/nginx -g "daemon off;" &

# Wait for all background processes to complete
# This keeps the container running
wait
