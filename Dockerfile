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
