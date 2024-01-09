#!/bin/bash
set -e

DATA_DIR="/root/.aleo/storage/ledger-3"

cleanup() {
    echo "Debug: Cleaning up temporary files..."
    rm -rf /tmp/aleoledger.tar.gz
}

trap cleanup EXIT

echo "Debug: Removing any existing ledger data in $DATA_DIR..."
rm -rf $DATA_DIR/*

echo "Debug: Downloading the blockchain data snapshot..."
wget -O /tmp/aleoledger.tar.gz https://ledger.aleo.network/aleoledger-1141222.tar.gz

# wget -O /tmp/aleoledger.tar.gz https://aleo-snapshots.f5nodes.com/storage_1127757.tar.gz || { echo "Debug: Failed to download"; exit 1; }

# echo "Debug: Checking contents of the tarball before extraction..."
# tar -tzf /tmp/aleoledger.tar.gz || { echo "Debug: Failed to list tarball contents"; exit 1; }

echo "Debug: Creating $DATA_DIR if it doesn't exist..."
mkdir -p $DATA_DIR

echo "Debug: Extracting the blockchain data directly to $DATA_DIR..."
# tar -xzf /tmp/aleoledger.tar.gz --strip-components=5 -C $DATA_DIR || { echo "Debug: Extraction failed"; exit 1; }
tar -xzf /tmp/aleoledger.tar.gz -C $DATA_DIR
mv $DATA_DIR/ledger-3-1141222/* $DATA_DIR/
rm -rf $DATA_DIR/ledger-3-1141222

echo "Debug: Listing the final contents of $DATA_DIR:"
ls $DATA_DIR || { echo "Debug: Failed to list final contents"; exit 1; }

echo "Debug: Starting snarkOS node..."

PEERS="94.131.9.32:37007","211.171.42.161:4133","211.171.42.234:39891","121.140.185.177:4133","128.199.66.135:4133","211.171.42.231:4133","125.131.208.72:4133","104.61.63.153:4133","161.35.144.189:4133","45.14.135.4:4133","47.242.151.228:4143","210.106.251.152:42837","36.157.219.50:44297","211.171.42.239:4133","211.171.42.163:4133","47.242.151.228:4133","118.36.228.252:4133","211.171.42.236:4133","211.171.42.241:4133","149.102.130.180:4133","61.10.9.27:4133","36.189.234.237:60027","180.151.225.92:64942","211.171.42.237:4133","211.171.42.164:4133","36.189.234.195:4133","211.171.42.233:4133","211.171.42.234:4133","47.243.96.237:4133","211.171.42.240:4133","46.38.242.141:4133","211.171.42.235:4133","159.135.194.92:4133","211.171.42.234:44875","211.171.42.238:4133"

exec cargo run --release -- start --metrics --nodisplay --client --peers "$PEERS" || { echo "Debug: Failed to start snarkOS node"; exit 1; }
