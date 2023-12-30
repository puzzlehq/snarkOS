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
wget -O /tmp/aleoledger.tar.gz https://aleo-snapshots.f5nodes.com/storage_1076809.tar.gz || { echo "Debug: Failed to download"; exit 1; }

echo "Debug: Checking contents of the tarball before extraction..."
tar -tzf /tmp/aleoledger.tar.gz || { echo "Debug: Failed to list tarball contents"; exit 1; }

echo "Debug: Creating $DATA_DIR if it doesn't exist..."
mkdir -p $DATA_DIR

echo "Debug: Extracting the blockchain data directly to $DATA_DIR..."
tar -xzf /tmp/aleoledger.tar.gz --strip-components=5 -C $DATA_DIR || { echo "Debug: Extraction failed"; exit 1; }

echo "Debug: Listing the final contents of $DATA_DIR:"
ls $DATA_DIR || { echo "Debug: Failed to list final contents"; exit 1; }

echo "Debug: Starting snarkOS node..."

PEERS="5.199.172.71:5000,203.160.91.77:4133,171.243.124.191:5000,51.81.176.217:44133,135.181.135.38:5000,16.163.42.92:4133,14.165.27.214:5000,121.140.185.177:5000,35.227.159.141:4133,34.134.14.127:5000,135.181.228.130:5000,118.36.228.252:5000,14.245.130.160:5000,162.19.62.176:5000,104.61.63.153:5000,211.171.42.230:4133,116.8.132.151:4133,68.183.160.13:4133,74.208.98.125:4133,113.161.31.179:5000"

exec cargo run --release -- start --metrics --nodisplay --client --peers "$PEERS" || { echo "Debug: Failed to start snarkOS node"; exit 1; }
