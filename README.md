# Stellar CLI Project with Rust and Docker

This project provides a configured environment for development with the Stellar network using Rust, Docker, and Docker Compose. The custom Docker image includes Stellar CLI, enables interaction with the Stellar network (both local and testnet), and is set up to work with [Stellar Quickstart](https://github.com/stellar/quickstart) in a local environment.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Project Structure](#project-structure)
- [Configuration Variables](#configuration-variables)
- [Using Docker Compose](#using-docker-compose)
- [GitHub Actions](#github-actions)
- [Contribution](#contribution)
- [License](#license)

## Overview

This project includes:

- **Rust**: Base environment for building and compiling Stellar CLI.
- **Stellar CLI**: Tool to interact with Stellar networks.
- **Docker and Docker Compose**: To manage the local development environment.
- **GitHub Actions**: To automate the Docker image build and push to Docker Hub.

## Prerequisites

- Docker and Docker Compose installed
- Docker Hub account (if pushing the image is required)

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/dalloglio/docker-rust-with-stellar-cli.git
cd docker-rust-with-stellar-cli
```

### 2. Configuring Sensitive Variables

If you plan to build and push the image to Docker Hub, make sure to add the credentials in GitHub Actions (in the **Secrets** section of your repository):

- `DOCKER_HUB_USERNAME`: Your Docker Hub username.
- `DOCKER_HUB_TOKEN`: Docker Hub access token.

## Project Structure

- **Dockerfile**: Defines the Docker image with Stellar CLI installation and network configurations.
- **.github/workflows/build-and-push.yml**: GitHub Actions workflow to automate the image build and push to Docker Hub.
- **docker-compose.yml**: Configuration for the local development environment with Stellar Quickstart and the custom image.

## Configuration Variables

The Dockerfile allows for network configuration for Stellar using build arguments:

- `STELLAR_NETWORK`: Sets the network (e.g., `local` or `testnet`).
- `STELLAR_RPC_URL`: The RPC URL for the Stellar network.
- `STELLAR_NETWORK_PASSPHRASE`: Network passphrase for Stellar.

These values can be adjusted directly in `docker-compose.yml` or when building the image.

## Using Docker Compose

To start the local development environment with Docker Compose, run:

```bash
docker compose up -d
```

This will:

- Start the `stellar` service using the official `stellar/quickstart` image.
- Start the `app` service using the `dalloglio/rust-with-stellar-cli:local` image, configured to communicate with the local network.

You can check if the containers are running with:

```bash
docker compose ps
```

To access the main development environment in the `app` container, where you'll perform most of your work, run:

```bash
docker compose exec app bash
```

This command opens a bash shell in the `app` service container, allowing you to run commands, execute scripts, and directly interact with the configured environment for development.

To set up a test identity for the bob user, run:

```bash
stellar keys generate --global bob --network local
```

This command will create a new wallet for the bob user and automatically fund the account with 10,000 XLM on the local network.

To view bob's public key, use:

```bash
stellar keys address bob
```

To view bob's secret key, use:

```bash
stellar keys show bob
```

## GitHub Actions

The GitHub Actions workflow (`.github/workflows/build-and-push.yml`) automates building and pushing the Docker image to Docker Hub.

### Workflow Overview

1. **build-base**: Builds and pushes the base image (`rust-with-stellar-cli:base`) to Docker Hub.
2. **build-networks**: Builds and pushes network-specific images (`local` and `testnet`), depending on the build-base step.

This workflow is triggered on a push to the `main` branch.

## Contribution

Contributions are welcome! Follow the steps below to contribute:

1. Fork the project.
2. Create a new branch (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

Let me know if there are any adjustments you'd like!
