# Use the official Rust slim image as the base image
FROM rust:1.82.0-slim AS base

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -ms /bin/bash bob

# Switch to the bob user and set the working directory
USER bob
WORKDIR /home/bob

# Install the required Rust target for WebAssembly (WASM)
RUN rustup target add wasm32-unknown-unknown

# Install Stellar CLI with locked dependencies
RUN cargo install --locked stellar-cli --features opt

# Enable stellar completion to generate shell completion for bash
RUN echo "source <(stellar completion --shell bash)" >> ~/.bashrc


# Build for local network
FROM dalloglio/rust-with-stellar-cli:base AS setup-network

# Arguments for configuring the Stellar network
ARG STELLAR_NETWORK="local"
ARG STELLAR_RPC_URL="http://stellar:8000/rpc"
ARG STELLAR_NETWORK_PASSPHRASE="Standalone Network ; February 2017"

# Configure Stellar CLI for the given environment
RUN stellar network add \
    --global ${STELLAR_NETWORK} \
    --rpc-url ${STELLAR_RPC_URL} \
    --network-passphrase "${STELLAR_NETWORK_PASSPHRASE}"

# Set up a test identity for the bob user
RUN stellar keys generate --global bob --network ${STELLAR_NETWORK}

# Default command (this is an example; adjust as needed)
CMD [ "tail", "-f", "/dev/null" ]
