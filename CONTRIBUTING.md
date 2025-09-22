# Contributing to KWAF

Thank you for your interest in contributing to KWAF! We welcome contributions from the community and are excited to work with you.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Contribution Guidelines](#contribution-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)
- [Community](#community)

## 📜 Code of Conduct

This project adheres to a code of conduct that we expect all contributors to follow. Please be respectful, inclusive, and constructive in all interactions.

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

- **Go 1.25+** installed
- **Git** installed and configured
- **Docker** and **Docker Compose** for development
- **Node.js 18+** and **npm** for admin panel development
- Basic understanding of Go, Kubernetes, and web security concepts

### Development Environment Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/kwaf.git
   cd kwaf
   ```

2. **Install Dependencies**
   ```bash
   make deps
   ```

3. **Start Development Environment**
   ```bash
   make dev
   ```

4. **Build All Components**
   ```bash
   make build
   ```

5. **Run Tests**
   ```bash
   make test
   ```

6. **Access Development Services**
   - Control Plane: `http://localhost:8090`
   - Data Plane: `http://localhost:8080`
   - Admin Panel: `http://localhost:3000`

### 🛠️ Development Commands

The project includes a comprehensive Makefile with all necessary development targets:

#### Build Commands
- `make build` - Build all three binaries (kwafcp, kwafd, kwafctl)
- `make build-cp` - Build control plane binary only
- `make build-dp` - Build data plane binary only  
- `make build-ctl` - Build CLI tool binary only

#### Test Commands
- `make test` - Run all tests with race detection and coverage
- `make test-short` - Run only short tests (fast)
- `make test-coverage` - Generate HTML coverage report

#### Code Quality
- `make lint` - Run golangci-lint with project configuration
- `make format` - Format code with gofmt and goimports

#### Run Commands
- `make run-cp` - Build and run control plane
- `make run-dp` - Build and run data plane

#### Docker Commands
- `make docker-build` - Build all Docker images
- `make docker-build-cp` - Build control plane image
- `make docker-build-dp` - Build data plane image
- `make docker-build-ctl` - Build CLI image

#### Development Helpers
- `make dev` - Setup development environment
- `make deps` - Install development dependencies
- `make clean` - Clean build artifacts
- `make help` - Show all available commands
- `make version` - Show version and build information
- `make mod-tidy` - Tidy Go modules
- `make mod-verify` - Verify Go modules

#### Quick Development Workflow
```bash
# Setup development environment
make deps dev

# Build all binaries
make build

# Run tests and linting
make test lint

# Run control plane in development
make run-cp

# In another terminal, run data plane
make run-dp
```

## 🔄 Development Workflow

### Branch Naming Convention

- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring
- `test/description` - Test improvements

### Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

**Examples:**
```
feat(api): add JWT validation middleware
fix(ddos): resolve race condition in rate limiter
docs(readme): update installation instructions
test(engine): add unit tests for rule compiler
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes
- `refactor` - Code refactoring
- `test` - Test additions or modifications
- `chore` - Build process or auxiliary tool changes

## 🎯 Contribution Guidelines

### Code Standards

- **Go Code**: Follow [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments)
- **Formatting**: Use `gofmt` and `goimports`
- **Linting**: Ensure code passes `golangci-lint`
- **Testing**: Maintain >80% test coverage for new code
- **Documentation**: Include docstrings for exported functions and types

### TypeScript/React Code (Admin Panel)

- Follow the existing code style
- Use TypeScript strict mode
- Write tests for new components
- Follow React best practices

### What to Contribute

**🎉 Great First Issues:**
- Documentation improvements
- Test coverage improvements
- Bug fixes
- Small feature enhancements

**🚀 Advanced Contributions:**
- New security rules or algorithms
- Performance optimizations
- New protocol support
- Integration improvements

### What We're Looking For

- **Security Features**: New WAF rules, attack detection algorithms
- **Performance**: Optimizations and benchmarks
- **Integrations**: Support for new platforms and tools
- **Documentation**: Guides, tutorials, API docs
- **Testing**: Unit tests, integration tests, load tests
- **Bug Fixes**: Issues from our GitHub issue tracker

## 📤 Pull Request Process

### Before Submitting

1. **Check Existing Issues**: Look for related issues or discussions
2. **Run Tests**: Ensure all tests pass
   ```bash
   make test
   make test-integration
   ```

3. **Run Linting**: Fix any linting issues
   ```bash
   make lint
   make format
   ```

4. **Update Documentation**: Update relevant docs if needed

### PR Requirements

1. **Descriptive Title**: Clear, concise description of changes
2. **Detailed Description**: Explain what, why, and how
3. **Issue Reference**: Link to related issues using `Fixes #123`
4. **Testing**: Include tests for new functionality
5. **Documentation**: Update docs for user-facing changes

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

### Review Process

1. **Automatic Checks**: CI/CD pipeline runs tests and linting
2. **Maintainer Review**: At least one maintainer reviews the code
3. **Community Input**: Community members may provide feedback
4. **Approval**: Changes approved by maintainers
5. **Merge**: PR merged into main branch

## 🐛 Reporting Issues

### Bug Reports

Use our [Bug Report Template](https://github.com/kwaf-project/kwaf/issues/new?template=bug_report.md):

- **Clear Title**: Descriptive summary of the issue
- **Steps to Reproduce**: Detailed reproduction steps
- **Expected vs Actual**: What should happen vs what actually happens
- **Environment**: OS, Go version, deployment method
- **Logs**: Relevant log excerpts
- **Additional Context**: Screenshots, configurations

### Feature Requests

Use our [Feature Request Template](https://github.com/kwaf-project/kwaf/issues/new?template=feature_request.md):

- **Use Case**: Why is this feature needed?
- **Proposed Solution**: How should it work?
- **Alternatives**: What alternatives have you considered?
- **Additional Context**: Any other relevant information

### Security Issues

**⚠️ Please do NOT create public GitHub issues for security vulnerabilities.**

Instead, email us at: **security@kwaf.io**

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested mitigation (if any)

## 🌍 Community

### Communication Channels

- **GitHub Discussions**: General questions and community discussions
- **GitHub Issues**: Bug reports and feature requests
- **Pull Requests**: Code contributions and reviews

### Getting Help

- **Documentation**: Check our [docs](docs/) first
- **GitHub Discussions**: Ask questions in our community forum
- **Examples**: Look at our [examples](examples/) directory

### Recognition

Contributors will be recognized in:
- **CONTRIBUTORS.md** file
- **Release notes** for significant contributions
- **GitHub contributors** section

---

## 🙏 Thank You

Every contribution, no matter how small, is valuable to the KWAF project. Whether you're fixing a typo, adding a feature, or improving documentation, you're helping make KWAF better for everyone.

**Happy Contributing! 🚀**
