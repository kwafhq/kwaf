# KWAF - Kubernetes Web Application Firewall

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Go Report Card](https://goreportcard.com/badge/kwaf.io/kwaf)](https://goreportcard.com/report/kwaf.io/kwaf)
[![Release](https://img.shields.io/github/release/kwaf-project/kwaf.svg)](https://github.com/kwaf-project/kwaf/releases)
[![Go Version](https://img.shields.io/badge/go-1.25+-00ADD8.svg)](https://golang.org/)

A modern, cloud-native Web Application Firewall (WAF) designed for Kubernetes environments. KWAF provides enterprise-grade security features with high performance, scalability, and ease of management.

## 🚀 Features

### Core Security Features
- **🛡️ Web Application Firewall**: Advanced request filtering and threat detection
- **🔒 API Security**: Comprehensive API protection with OpenAPI validation, JWT/OAuth support
- **🚨 DDoS Protection**: Multi-layered DDoS mitigation with adaptive algorithms
- **⚡ Rate Limiting**: Flexible rate limiting with multiple algorithms
- **🎯 Rule Engine**: Powerful rule-based security policy engine
- **🌍 Geo-blocking**: Geographic access control
- **🤖 Bot Detection**: Advanced bot detection and mitigation

### API Security
- **OpenAPI Validation**: Automatic API schema validation
- **JWT & OAuth**: Token-based authentication and authorization  
- **API Key Management**: Secure API key validation and management
- **GraphQL Security**: GraphQL-specific threat detection and validation
- **API Versioning**: Multi-version API support and management

### Management & Operations
- **🎛️ Web Admin Panel**: Modern React-based management interface
- **📊 Real-time Metrics**: Comprehensive monitoring and alerting
- **🔧 Multi-tenancy**: Enterprise-grade tenant isolation
- **📈 Observability**: Distributed tracing and structured logging
- **🎯 Exception Management**: Fine-grained exception handling

### Architecture
- **Control Plane**: Centralized policy management and configuration
- **Data Plane**: High-performance request processing engine
- **CLI Management**: Command-line tool for automation and DevOps
- **Cloud-native**: Kubernetes-first design with Helm charts

## 📋 Requirements

- **Go**: 1.25 or higher
- **Kubernetes**: 1.24 or higher (for production deployment)
- **PostgreSQL**: 12 or higher (for persistent storage)
- **Redis**: 6 or higher (for caching and rate limiting)

## 🚀 Quick Start

### Using Docker Compose (Development)

```bash
git clone https://github.com/kwaf-project/kwaf.git
cd kwaf

# Start all components
docker-compose up -d

# Access admin panel
open http://localhost:8080
```

### Using Pre-built Binaries

```bash
# Download latest release
curl -L https://github.com/kwaf-project/kwaf/releases/latest/download/kwaf-linux-amd64.tar.gz | tar xz

# Install components
sudo mv kwaf* /usr/local/bin/

# Start control plane
kwafcp --config config/controlplane.yaml

# Start data plane
kwafd --config config/dataplane.yaml
```

### Building from Source

```bash
git clone https://github.com/kwaf-project/kwaf.git
cd kwaf

# Build all components
make build

# Run tests
make test

# Build Docker images
make docker-build
```

## 🛠️ Components

### KWAF Control Plane (`kwafcp`)
Centralized management server responsible for:
- Policy configuration and distribution
- Rule management and compilation
- Multi-tenant administration
- Metrics collection and aggregation

### KWAF Data Plane (`kwafd`) 
High-performance proxy server that:
- Processes HTTP/HTTPS requests
- Applies security policies in real-time
- Enforces rate limits and access controls
- Provides DDoS protection

### KWAF CLI (`kwafctl`)
Command-line interface for:
- Configuration management
- Policy deployment
- Monitoring and troubleshooting
- Automation and CI/CD integration

### Admin Panel
Modern web interface featuring:
- Real-time dashboard and metrics
- Policy management interface
- User and tenant administration
- Security event visualization

## 📁 Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Admin Panel   │    │      kwafctl    │    │   External APIs │
│  (Web UI/API)   │    │   (CLI Tool)    │    │  (Monitoring)   │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          └──────────────────────┼──────────────────────┘
                                 │
                    ┌─────────────▼───────────┐
                    │     KWAF Control       │
                    │        Plane           │
                    │      (kwafcp)          │
                    └─────────────┬───────────┘
                                  │ gRPC
                      ┌───────────▼───────────┐
                      │                       │
            ┌─────────▼──────┐    ┌──────▼──────────┐
            │ KWAF Data     │    │ KWAF Data       │
            │ Plane (kwafd) │    │ Plane (kwafd)   │
            └─────────┬──────┘    └──────┬──────────┘
                      │                  │
            ┌─────────▼──────┐    ┌──────▼──────────┐
            │   Application  │    │   Application   │
            │    Services    │    │    Services     │
            └────────────────┘    └─────────────────┘
```

## 🔧 Configuration

### Basic Control Plane Configuration

```yaml
# config/controlplane.yaml
server:
  host: "0.0.0.0"
  port: 8090
  tls:
    enabled: true
    cert_file: "/path/to/cert.pem"
    key_file: "/path/to/key.pem"

database:
  host: "localhost"
  port: 5432
  database: "kwaf"
  username: "kwaf"
  password: "secure_password"

storage:
  type: "postgres"
  max_connections: 100
```

### Basic Data Plane Configuration

```yaml
# config/dataplane.yaml
server:
  host: "0.0.0.0"
  port: 8080
  admin_port: 8081

controlplane:
  address: "kwafcp:8090"
  tls:
    enabled: true
    ca_file: "/path/to/ca.pem"

upstream:
  default_backend: "http://app:3000"
  timeout: "30s"
  retries: 3
```

## 📚 Documentation

- [Installation Guide](docs/installation.md)
- [Configuration Reference](docs/configuration.md)
- [API Documentation](docs/api.md)
- [Rule Development](docs/rules.md)
- [Kubernetes Deployment](docs/kubernetes.md)
- [Performance Tuning](docs/performance.md)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Clone repository
git clone https://github.com/kwaf-project/kwaf.git
cd kwaf

# Install dependencies
make deps

# Run development environment
make dev

# Run tests
make test

# Run linting
make lint
```

## 🐛 Issues and Support

- 🐞 [Report Bugs](https://github.com/kwaf-project/kwaf/issues/new?template=bug_report.md)
- 💡 [Request Features](https://github.com/kwaf-project/kwaf/issues/new?template=feature_request.md)
- 💬 [Community Discussions](https://github.com/kwaf-project/kwaf/discussions)
- 📧 [Security Issues](mailto:security@kwaf.io)

## 📊 Benchmarks

KWAF is designed for high performance:

- **Throughput**: 100K+ requests/second per data plane instance
- **Latency**: <10ms additional latency in proxy mode
- **Memory**: <100MB base memory footprint
- **CPU**: Minimal CPU overhead with optimized rule engine

See our [Performance Documentation](docs/performance.md) for detailed benchmarks.

## 🎯 Roadmap

[//]: # (- [ ] **v1.1**: Enhanced GraphQL security features)

[//]: # (- [ ] **v1.2**: Machine learning-based anomaly detection)

[//]: # (- [ ] **v1.3**: Advanced API discovery and inventory)

[//]: # (- [ ] **v1.4**: Integration with service mesh &#40;Istio, Linkerd&#41;)

[//]: # (- [ ] **v2.0**: WebAssembly &#40;WASM&#41; plugin system)

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🌟 Acknowledgments

- The [OWASP ModSecurity Core Rule Set](https://owasp.org/www-project-modsecurity-core-rule-set/) project
- The [Envoy Proxy](https://www.envoyproxy.io/) community for architecture inspiration
- The [CNCF](https://www.cncf.io/) ecosystem for cloud-native best practices

---

**⭐ If you find KWAF useful, please give us a star on GitHub! It helps us understand the community interest and motivates continued development.**
