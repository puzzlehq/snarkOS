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

RUN cargo build --release

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

ENTRYPOINT ["/startup.sh"]
