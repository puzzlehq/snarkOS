FROM rust:1.70-slim-buster
RUN apt-get update -y && apt-get install git -y
RUN apt-get install -y pkg-config libssl-dev  # Install pkg-config and OpenSSL development libraries
RUN apt-get install -y llvm libclang-dev  # Install LLVM and libclang
RUN apt-get install -y build-essential  # Install build-essential for standard development headers
RUN apt-get install -y libc6-dev
RUN git clone https://github.com/AleoHQ/snarkOS.git --depth 1
WORKDIR snarkOS
RUN ["chmod", "+x", "build_ubuntu.sh"]
RUN ./build_ubuntu.sh
RUN snarkos account new > account.txt
RUN VALIDATOR_PRIVATE_KEY=$(awk '/Private Key/ {print $3}' account.txt) && echo $VALIDATOR_PRIVATE_KEY > private_key.txt
EXPOSE 5000/tcp
EXPOSE 3033/tcp
EXPOSE 4133/tcp
RUN ["chmod", "+x", "run-validator.sh"]
ENTRYPOINT ["./run-validator.sh"]
