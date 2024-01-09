FROM rust:1.74-slim-buster

WORKDIR /app

COPY . .

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

RUN cargo build --release

RUN chmod +x ./startup.sh

ENTRYPOINT ["./startup.sh"]
