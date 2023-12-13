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

# Set the start command; Railway should pass in the VALIDATOR_PRIVATE_KEY via environment variable
CMD ["sh", "-c", "echo The current value of VALIDATOR_PRIVATE_KEY is: $VALIDATOR_PRIVATE_KEY && cargo run --release -- start --nodisplay --validator --private-key $VALIDATOR_PRIVATE_KEY --validators 15.188.23.173:5000, 104.61.63.153:5000, 141.94.195.144:5000, 135.181.228.130:5000, 136.243.6.40:5000, 35.230.64.227:5000, 185.8.106.92:5000, 212.126.35.133:5000, 173.208.52.137:5000, 162.19.62.176:5000, 160.202.128.199:5000, 34.162.206.75:5000, 34.150.226.123:5000, 15.235.41.104:5000, 136.38.55.33:5000, 16.63.62.210:5000, 37.27.57.162:5000, 57.128.21.47:5000, 37.208.111.110:5000, 157.90.215.172:5000, 57.128.73.212:5000, 5.199.172.71:5000, 185.119.116.244:5000, 37.187.71.86:5000, 202.94.169.43:5000, 23.29.115.242:5000, 93.123.72.201:5000, 165.154.225.64:5000, 35.202.251.152:5000, 167.235.163.202:5000, 34.85.217.171:5000, 95.217.231.107:5000, 15.235.53.79:5000, 34.105.69.153:5000, 202.8.8.143:5000, 195.201.8.101:5000, 195.189.96.107:5000, 35.246.173.244:5000"]
