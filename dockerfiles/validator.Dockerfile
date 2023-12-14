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

# Clone the specific branch of snarkOS from your fork
RUN git clone -b validator https://github.com/puzzlehq/snarkOS.git --depth 1 .

RUN git remote add aleo https://github.com/AleoHQ/snarkOS.git

RUN git fetch aleo 0af6a5597778d2f5cfb44432812afc81ed6207a2

RUN git checkout 0af6a5597778d2f5cfb44432812afc81ed6207a2

RUN cargo build --release

# Fetch the storage snapshot
RUN wget https://ledger.aleo.network/aleoledger-231201.tgz
# Uncompress the storage folder
RUN tar -xvzf aleoledger-231201.tgz

# Remove the old storage folder
RUN rm -rf ~/.aleo/storage/ledger-3
# Load in the new storage folder
RUN cp ledger-3/ ~/.aleo/storage/ledger-3 -R

# Set the start command; Railway should pass in the VALIDATOR_PRIVATE_KEY via environment variable
CMD ["sh", "-c", "echo The current value of VALIDATOR_PRIVATE_KEY is: $VALIDATOR_PRIVATE_KEY && cargo run --release -- start --nodisplay --client --private-key $VALIDATOR_PRIVATE_KEY"]
