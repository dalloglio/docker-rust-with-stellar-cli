# Use the official Rust slim image as the base image
FROM rust:slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user named dev
RUN useradd -ms /bin/bash dev

# Switch to the dev user
USER dev

# Set the working directory
WORKDIR /home/dev

# Install the target
RUN rustup target add wasm32-unknown-unknown

# Install the Stellar CLI
RUN cargo install --locked stellar-cli --features opt

# Enable stellar completion to generate shell completion for bash
RUN echo "source <(stellar completion --shell bash)" >> ~/.bashrc

# Configure the Stellar CLI for Testnet
RUN stellar network add \
    --global testnet \
    --rpc-url https://soroban-testnet.stellar.org:443 \
    --network-passphrase "Test SDF Network ; September 2015"

# Configure an Identity
RUN stellar keys generate --global dev --network testnet

# See the public key of dev
RUN echo "Identity that will be used to sign the transactions: $(stellar keys address dev)"
