# Use the official Rust image as a base
FROM rust:1.74-slim-buster

# Set the working directory
WORKDIR /usr/src/snarkOS_$(git rev-parse HEAD)

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
    wget \
    tar \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b validator https://github.com/puzzlehq/snarkOS.git --depth 1 .

RUN git remote add aleo https://github.com/AleoHQ/snarkOS.git

RUN git remote add joske https://github.com/joske/snarkOS.git

RUN git fetch joske fix/block_sync

RUN git checkout joske/fix/block_sync

# RUN git fetch aleo 0af6a5597778d2f5cfb44432812afc81ed6207a2

# RUN git checkout 0af6a5597778d2f5cfb44432812afc81ed6207a2

RUN cargo build --release

RUN wget https://aleo-snapshots.f5nodes.com/storage_975197.tar.gz

RUN tar -xvzf storage_975197.tar.gz && ls -lah

RUN rm -rf /home/ubuntu/.aleo/storage/ledger-3

RUN mkdir -p /extracted && tar -xvzf storage_975197.tar.gz -C /extracted && ls -lah /extracted/home/ubuntu/aleo-snapshots/storage/ledger-3

RUN mkdir -p /home/ubuntu/.aleo/storage && cp -R /extracted/home/ubuntu/aleo-snapshots/storage/ledger-3 /home/ubuntu/.aleo/storage/ledger-3


CMD ["sh", "-c", "cargo run --release -- start --nodisplay --client --verbosity 4"]
