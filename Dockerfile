FROM rust:1.74-slim-buster

WORKDIR /usr/src/snarkOS

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

# Preserve the following lines for future reference
# RUN git remote add aleo https://github.com/AleoHQ/snarkOS.git
# RUN git remote add joske https://github.com/joske/snarkOS.git
# RUN git fetch joske fix/block_sync
# RUN git checkout joske/fix/block_sync
# RUN git fetch aleo 0af6a5597778d2f5cfb44432812afc81ed6207a2
# RUN git checkout 0af6a5597778d2f5cfb44432812afc81ed6207a2

RUN ls ~/

RUN cargo build --release

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

ENTRYPOINT ["/startup.sh"]
