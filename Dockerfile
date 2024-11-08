# Arguments for configuring the Stellar network
ARG STELLAR_NETWORK="local"
ARG STELLAR_RPC_URL="http://stellar:8000/rpc"
ARG STELLAR_NETWORK_PASSPHRASE="Standalone Network ; February 2017"

# Use the official Rust slim image as the base image
FROM rust:1.82.0-slim AS builder

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

# Configure Stellar CLI for the local environment
RUN stellar network add \
    --global ${STELLAR_NETWORK} \
    --rpc-url ${STELLAR_RPC_URL} \
    --network-passphrase "${STELLAR_NETWORK_PASSPHRASE}"

# Set up a test identity for the bob user
RUN stellar keys generate --global bob --network ${STELLAR_NETWORK}

# Display bob's public and private keys for confirmation
RUN echo "Identity that will be used to sign transactions:" && \
    echo "Public key: $(stellar keys address bob)" && \
    echo "Private key: $(stellar keys show bob)"

# Default command (this is an example; adjust as needed)
CMD [ "tail", "-f", "/dev/null" ]
