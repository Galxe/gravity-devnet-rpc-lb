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

   - Handles incoming traffic on port 8080
   - Automatic WebSocket protocol detection and routing
   - Manages CORS and HTTP headers
   - Routes traffic to appropriate HAProxy ports (8545/8546)

2. **HAProxy (Back Tier)**
   - Listens on ports 8545 (RPC) and 8546 (WebSocket)
   - Port-based backend selection
   - Maintains sticky sessions for 30 minutes
   - Load balances across 4 backend nodes
   - Performs TCP-level health checks every 3 seconds

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

- Dual-port TCP mode (8545/8546) for RPC and WebSocket support
- Port-based traffic routing between RPC and WebSocket backends
- Round-robin load balancing with sticky sessions
- Sticky sessions based on client IP (30-minute persistence)
- Health checks every 3 seconds with 2-attempt failure/rise thresholds
- Configurable timeouts (connect: 5s, client: 50s, server: 50s)
- Internal health monitoring endpoint on localhost:8547

### Nginx Configuration

The Nginx configuration (`nginx.conf`) provides:

- Single entry point on port 8080
- Automatic WebSocket protocol upgrade handling
- CORS headers management with preflight request support
- Smart traffic routing:
  - WebSocket connections → HAProxy port 8546
  - RPC traffic → HAProxy port 8545
- Dual health check endpoints:
  - `/health/alive` for basic liveness checks
  - `/health/ready` for HAProxy status verification

## Health Checks

The service includes two health check endpoints:

- `/health/ready` - HAProxy internal health status
- `/health/alive` - Kubernetes readiness/liveness probe endpoint

## Security Considerations

- Health check endpoints are only accessible from localhost
- Proper header forwarding for client identification
- Connection limits and timeouts are configured for protection
- No direct external access to HAProxy management interface
