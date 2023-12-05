# FROM rust:1.70-slim-buster
# RUN apt-get update -y && apt-get install git -y
# RUN git clone -b validator https://github.com/puzzlehq/snarkos.git --depth 1
# WORKDIR snarkos
# RUN ["chmod", "+x", "build_ubuntu.sh"]
# RUN ./build_ubuntu.sh
# EXPOSE 5000/tcp
# EXPOSE 3033/tcp
# EXPOSE 4133/tcp
# CMD ["sh", "-c", "snarkos start --nodisplay --validator --private-key ${VALIDATOR_PRIVATE_KEY}"]
# Use the official Rust image as a base
FROM rust:1.74-slim-buster

# Set the working directory
WORKDIR /usr/src/snarkOS

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    libssl-dev \
    llvm \
    pkg-config \
    curl \
    make \
    gcc \
    tmux \
    xz-utils \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone the specific branch of snarkOS from the repository
RUN git clone -b validator https://github.com/puzzlehq/snarkOS.git --depth 1 .

# Build snarkOS
RUN cargo build --release

# Expose ports (note that these are only for documentation; actual port mapping is done at runtime)
# EXPOSE 3033 4133

# Set the start command; Railway should pass in the VALIDATOR_PRIVATE_KEY via environment variable
CMD ["sh", "-c", "echo The current value of VALIDATOR_PRIVATE_KEY is: $VALIDATOR_PRIVATE_KEY && cargo run --release -- start --nodisplay --validator --private-key $VALIDATOR_PRIVATE_KEY"]

# CMD ["sh", "-c", "cargo run --release -- start --nodisplay --validator --private-key ${VALIDATOR_PRIVATE_KEY}"]
