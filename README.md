# gravity-devnet-rpc-lb

A lightweight RPC Load Balancer for the Gravity Devnet. This project leverages HAProxy & Nginx to distribute RPC traffic across multiple blockchain nodes with sticky session support to ensure consistent client connections. Designed to run efficiently in Kubernetes, this solution helps optimize node performance and network reliability.

## Features

- Load balancing of RPC requests across multiple blockchain nodes
- Sticky sessions for consistent client connections
- Health checking and automatic failover
- Kubernetes-ready configuration
- WebSocket support
- Efficient request routing and connection management

## Architecture

The solution uses a two-tier architecture:

1. **Nginx (Front Tier)**

   - Handles incoming HTTP/HTTPS traffic
   - Provides initial request routing
   - Manages SSL/TLS termination
   - Forwards requests to HAProxy

2. **HAProxy (Back Tier)**
   - Manages load balancing across RPC nodes
   - Implements sticky sessions
   - Performs health checks
   - Handles WebSocket connections
   - Provides failover capabilities

## Prerequisites

- Docker
- Kubernetes cluster (for production deployment)
- Access to Gravity Devnet RPC nodes

## Quick Start

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/gravity-devnet-rpc-lb.git
   cd gravity-devnet-rpc-lb
   ```

2. **Build the Docker image:**

   ```bash
   docker build -t gravity-devnet-rpc-lb .
   ```

3. **Run the container:**
   ```bash
   docker run -d -p 8080:8080 gravity-devnet-rpc-lb
   ```

## Configuration

### HAProxy Configuration

The HAProxy configuration (`haproxy.cfg`) includes:

- TCP mode for WebSocket support
- Round-robin load balancing
- Sticky sessions based on client IP
- Health checks for RPC nodes
- Configurable timeouts and connection limits

### Nginx Configuration

The Nginx configuration (`nginx.conf`) provides:

- Reverse proxy setup
- Header forwarding
- Health check endpoint
- Connection pooling

## Health Checks

The service includes two health check endpoints:

- `/health/ready` - HAProxy internal health status
- `/health/alive` - Kubernetes readiness/liveness probe endpoint

## Security Considerations

- Health check endpoints are only accessible from localhost
- Proper header forwarding for client identification
- Connection limits and timeouts are configured for protection
- No direct external access to HAProxy management interface
