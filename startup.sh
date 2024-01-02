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
wget -O /tmp/aleoledger.tar.gz https://aleo-snapshots.f5nodes.com/storage_1095822.tar.gz || { echo "Debug: Failed to download"; exit 1; }

echo "Debug: Checking contents of the tarball before extraction..."
tar -tzf /tmp/aleoledger.tar.gz || { echo "Debug: Failed to list tarball contents"; exit 1; }

echo "Debug: Creating $DATA_DIR if it doesn't exist..."
mkdir -p $DATA_DIR

echo "Debug: Extracting the blockchain data directly to $DATA_DIR..."
tar -xzf /tmp/aleoledger.tar.gz --strip-components=5 -C $DATA_DIR || { echo "Debug: Extraction failed"; exit 1; }

echo "Debug: Listing the final contents of $DATA_DIR:"
ls $DATA_DIR || { echo "Debug: Failed to list final contents"; exit 1; }

echo "Debug: Starting snarkOS node..."

PEERS="121.140.185.177:5000,57.128.21.96:5000,171.243.124.191:5000,14.245.137.63:5000,34.118.201.213:5000,117.2.6.45:5000,5.199.172.71:5000,113.161.31.227:5000,113.161.31.179:5000,14.224.130.232:5000,135.181.228.130:5000,44.224.120.105:5000,165.154.225.64:5000"

exec cargo run --release -- start --metrics --nodisplay --client --peers "$PEERS" || { echo "Debug: Failed to start snarkOS node"; exit 1; }
