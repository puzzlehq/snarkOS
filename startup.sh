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

echo "Debug: Checking contents of the tarball before extraction..."
tar -tzf /tmp/aleoledger.tar.gz || { echo "Debug: Failed to list tarball contents"; exit 1; }

echo "Debug: Creating $DATA_DIR if it doesn't exist..."
mkdir -p $DATA_DIR

echo "Debug: Extracting the blockchain data directly to $DATA_DIR..."
tar -xzf /tmp/aleoledger.tar.gz --strip-components=4 -C $DATA_DIR || { echo "Debug: Extraction failed"; exit 1; }

echo "Debug: Listing the final contents of $DATA_DIR:"
ls $DATA_DIR || { echo "Debug: Failed to list final contents"; exit 1; }

echo "Debug: Starting snarkOS node..."
exec cargo run --release -- start --metrics --nodisplay --client || { echo "Debug: Failed to start snarkOS node"; exit 1; }
