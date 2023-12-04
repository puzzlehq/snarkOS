FROM rust:1.70-slim-buster
RUN apt-get update -y && apt-get install git -y
RUN apt-get install -y pkg-config libssl-dev  # Install pkg-config and OpenSSL development libraries
RUN apt-get install -y llvm libclang-dev  # Install LLVM and libclang
RUN apt-get install -y build-essential  # Install build-essential for standard development headers
RUN apt-get install -y libc6-dev
RUN ls
RUN git clone \
  https://github.com/AleoHQ/snarkOS.git \
  --depth 1
WORKDIR snarkOS
RUN ["chmod", "+x", "build_ubuntu.sh"]
RUN ./build_ubuntu.sh
EXPOSE 5000/tcp
EXPOSE 3033/tcp
EXPOSE 4133/tcp
ENTRYPOINT ["./run-validator.sh"]