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

RUN wget https://ledger.aleo.network/aleoledger-840269.tar.gz

RUN tar -xvzf aleoledger-840269.tar.gz

RUN rm -rf ~/.aleo/storage/ledger-3

RUN mkdir -p ~/.aleo/storage && cp -R storage/ledger-3/ ~/.aleo/storage/ledger-3

CMD ["sh", "-c", "cargo run --release -- start --nodisplay --client --verbosity 4"]