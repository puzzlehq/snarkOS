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
wget -O /tmp/aleoledger.tar.gz https://aleo-snapshots.f5nodes.com/storage_1055773.tar.gz || { echo "Debug: Failed to download"; exit 1; }

# echo "Debug: Checking contents of the tarball before extraction..."
# tar -tzf /tmp/aleoledger.tar.gz || { echo "Debug: Failed to list tarball contents"; exit 1; }

echo "Debug: Creating $DATA_DIR if it doesn't exist..."
mkdir -p $DATA_DIR

echo "Debug: Extracting the blockchain data directly to $DATA_DIR..."
tar -xzf /tmp/aleoledger.tar.gz --strip-components=5 -C $DATA_DIR || { echo "Debug: Extraction failed"; exit 1; }

echo "Debug: Listing the final contents of $DATA_DIR:"
ls $DATA_DIR || { echo "Debug: Failed to list final contents"; exit 1; }

echo "Debug: Starting snarkOS node..."

PEERS="162.219.87.220:5000,51.81.176.217:44133,121.140.185.177:5000,16.63.62.210:5000,159.135.194.92:4133,162.219.87.217:4133,117.2.202.91:5000,203.160.91.77:4133,113.161.31.179:5000,173.208.52.137:5000,34.118.201.213:5000,14.176.174.201:5000,23.109.158.196:5000,202.94.169.43:5000,202.8.8.143:5000,104.61.63.153:5000"
exec cargo run --release -- start --metrics --nodisplay --client --peers "$PEERS" || { echo "Debug: Failed to start snarkOS node"; exit 1; }
