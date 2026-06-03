#!/bin/bash
set -e

# EXPLORER_TOKEN must be set (injected via k8s Secret → envFrom secretRef).
# It gates debug_*/trace_* method access in nginx; an empty token would match
# any empty X-RPC-Auth header and effectively disable the whitelist.
if [ -z "${EXPLORER_TOKEN}" ]; then
    echo "ERROR: EXPLORER_TOKEN env var is not set — cannot start nginx safely" >&2
    exit 1
fi

# Substitute ${EXPLORER_TOKEN} into the nginx config template.
# Single-quoting the variable list ensures only this placeholder is replaced;
# all other nginx $variables (e.g. $remote_addr, $http_origin) are left intact.
envsubst '${EXPLORER_TOKEN}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Starting HAProxy..."
/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg &

echo "Starting Nginx..."
/usr/sbin/nginx -g "daemon off;" &

wait
