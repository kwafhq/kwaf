# KWAF Makefile
# Web Application Firewall for Kubernetes

# Variables
GO_VERSION := $(shell go version | cut -d ' ' -f 3)
MODULE_NAME := kwaf.io/kwaf
BINARY_DIR := bin
CMD_DIR := cmd

# Binary names and paths
KWAF_CP_BINARY := $(BINARY_DIR)/kwafcp
KWAF_DP_BINARY := $(BINARY_DIR)/kwafd
KWAF_CTL_BINARY := $(BINARY_DIR)/kwafctl

# Source paths
KWAF_CP_SRC := $(CMD_DIR)/kwaf-controlplane
KWAF_DP_SRC := $(CMD_DIR)/kwafd
KWAF_CTL_SRC := $(CMD_DIR)/kwaf-ctl

# Build flags
BUILD_FLAGS := -ldflags="-s -w"
BUILD_FLAGS += -ldflags="-X main.version=$(shell git describe --tags --always --dirty)"
BUILD_FLAGS += -ldflags="-X main.commit=$(shell git rev-parse --short HEAD)"
BUILD_FLAGS += -ldflags="-X main.date=$(shell date -u +%Y-%m-%dT%H:%M:%SZ)"

# Colors for output
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
RESET := \033[0m

.PHONY: help
help: ## Display this help message
	@echo "$(BLUE)KWAF - Kubernetes Web Application Firewall$(RESET)"
	@echo "$(BLUE)========================================$(RESET)"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "$(YELLOW)%-15s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: clean
clean: ## Clean build artifacts
	@echo "$(YELLOW)Cleaning build artifacts...$(RESET)"
	@rm -rf $(BINARY_DIR)
	@rm -f coverage.out
	@echo "$(GREEN)✓ Clean completed$(RESET)"

.PHONY: prepare
prepare: ## Create necessary directories
	@mkdir -p $(BINARY_DIR)

# Build targets
.PHONY: build
build: prepare build-cp build-dp build-ctl ## Build all binaries
	@echo "$(GREEN)✓ All binaries built successfully$(RESET)"
	@echo "$(BLUE)Binaries available in $(BINARY_DIR)/:$(RESET)"
	@ls -la $(BINARY_DIR)/

.PHONY: build-cp
build-cp: prepare ## Build control plane binary (kwafcp)
	@echo "$(YELLOW)Building control plane (kwafcp)...$(RESET)"
	@CGO_ENABLED=0 go build $(BUILD_FLAGS) -o $(KWAF_CP_BINARY) ./$(KWAF_CP_SRC)
	@echo "$(GREEN)✓ Control plane built: $(KWAF_CP_BINARY)$(RESET)"

.PHONY: build-dp
build-dp: prepare ## Build data plane binary (kwafd)
	@echo "$(YELLOW)Building data plane (kwafd)...$(RESET)"
	@CGO_ENABLED=0 go build $(BUILD_FLAGS) -o $(KWAF_DP_BINARY) ./$(KWAF_DP_SRC)
	@echo "$(GREEN)✓ Data plane built: $(KWAF_DP_BINARY)$(RESET)"

.PHONY: build-ctl
build-ctl: prepare ## Build CLI tool (kwafctl)
	@echo "$(YELLOW)Building CLI tool (kwafctl)...$(RESET)"
	@CGO_ENABLED=0 go build $(BUILD_FLAGS) -o $(KWAF_CTL_BINARY) ./$(KWAF_CTL_SRC)
	@echo "$(GREEN)✓ CLI tool built: $(KWAF_CTL_BINARY)$(RESET)"

# Test targets
.PHONY: test
test: ## Run all tests
	@echo "$(YELLOW)Running tests...$(RESET)"
	@go test -v -race -coverprofile=coverage.out ./...
	@echo "$(GREEN)✓ Tests completed$(RESET)"

.PHONY: test-coverage
test-coverage: test ## Run tests with coverage report
	@echo "$(YELLOW)Generating coverage report...$(RESET)"
	@go tool cover -html=coverage.out -o coverage.html
	@echo "$(GREEN)✓ Coverage report generated: coverage.html$(RESET)"

.PHONY: test-short
test-short: ## Run short tests only
	@echo "$(YELLOW)Running short tests...$(RESET)"
	@go test -short ./...
	@echo "$(GREEN)✓ Short tests completed$(RESET)"

# Lint and format targets
.PHONY: lint
lint: ## Run golangci-lint
	@echo "$(YELLOW)Running golangci-lint...$(RESET)"
	@if ! command -v golangci-lint &> /dev/null; then \
		echo "$(RED)golangci-lint is not installed. Installing...$(RESET)"; \
		go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest; \
	fi
	@golangci-lint run --config golangci.yml
	@echo "$(GREEN)✓ Linting completed$(RESET)"

.PHONY: format
format: ## Format code with gofmt and goimports
	@echo "$(YELLOW)Formatting code...$(RESET)"
	@go fmt ./...
	@if command -v goimports &> /dev/null; then \
		goimports -w .; \
	else \
		echo "$(YELLOW)goimports not found, installing...$(RESET)"; \
		go install golang.org/x/tools/cmd/goimports@latest; \
		$(shell go env GOPATH)/bin/goimports -w .; \
	fi
	@echo "$(GREEN)✓ Code formatting completed$(RESET)"

# Run targets
.PHONY: run-cp
run-cp: build-cp ## Run control plane
	@echo "$(YELLOW)Starting control plane...$(RESET)"
	@echo "$(BLUE)Press Ctrl+C to stop$(RESET)"
	@./$(KWAF_CP_BINARY)

.PHONY: run-dp
run-dp: build-dp ## Run data plane
	@echo "$(YELLOW)Starting data plane...$(RESET)"
	@echo "$(BLUE)Press Ctrl+C to stop$(RESET)"
	@./$(KWAF_DP_BINARY)

# Docker targets
.PHONY: docker-build
docker-build: docker-build-cp docker-build-dp docker-build-ctl ## Build all Docker images

.PHONY: docker-build-cp
docker-build-cp: ## Build control plane Docker image
	@echo "$(YELLOW)Building control plane Docker image...$(RESET)"
	@docker build -f deployments/docker/Dockerfile.controlplane -t kwaf/controlplane:latest .
	@echo "$(GREEN)✓ Control plane image built: kwaf/controlplane:latest$(RESET)"

.PHONY: docker-build-dp
docker-build-dp: ## Build data plane Docker image
	@echo "$(YELLOW)Building data plane Docker image...$(RESET)"
	@docker build -f deployments/docker/Dockerfile.dataplane -t kwaf/dataplane:latest .
	@echo "$(GREEN)✓ Data plane image built: kwaf/dataplane:latest$(RESET)"

.PHONY: docker-build-ctl
docker-build-ctl: ## Build CLI Docker image
	@echo "$(YELLOW)Building CLI Docker image...$(RESET)"
	@docker build -f deployments/docker/Dockerfile.cli -t kwaf/cli:latest .
	@echo "$(GREEN)✓ CLI image built: kwaf/cli:latest$(RESET)"

# Development targets
.PHONY: dev
dev: ## Setup development environment
	@echo "$(YELLOW)Setting up development environment...$(RESET)"
	@go mod download
	@go mod tidy
	@echo "$(GREEN)✓ Development environment ready$(RESET)"

.PHONY: deps
deps: ## Install development dependencies
	@echo "$(YELLOW)Installing development dependencies...$(RESET)"
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@go install golang.org/x/tools/cmd/goimports@latest
	@echo "$(GREEN)✓ Development dependencies installed$(RESET)"

# Utility targets
.PHONY: mod-tidy
mod-tidy: ## Tidy go modules
	@echo "$(YELLOW)Tidying go modules...$(RESET)"
	@go mod tidy
	@echo "$(GREEN)✓ Modules tidied$(RESET)"

.PHONY: mod-verify
mod-verify: ## Verify go modules
	@echo "$(YELLOW)Verifying go modules...$(RESET)"
	@go mod verify
	@echo "$(GREEN)✓ Modules verified$(RESET)"

.PHONY: version
version: ## Show version information
	@echo "$(BLUE)Go Version:$(RESET) $(GO_VERSION)"
	@echo "$(BLUE)Module:$(RESET) $(MODULE_NAME)"
	@echo "$(BLUE)Git Commit:$(RESET) $(shell git rev-parse --short HEAD)"
	@echo "$(BLUE)Git Tag:$(RESET) $(shell git describe --tags --always)"

# Default target
.DEFAULT_GOAL := help
