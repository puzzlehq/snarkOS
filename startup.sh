#!/bin/bash
set -e

DATA_DIR="/root/.aleo/storage/ledger-3"

cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf /tmp/aleoledger.tar.gz
}

trap cleanup EXIT

echo "Removing any existing ledger data..."
rm -rf $DATA_DIR/*

echo "Downloading the blockchain data snapshot..."
wget -O /tmp/aleoledger.tar.gz https://aleo-snapshots.f5nodes.com/storage_1054016.tar.gz

echo "Extracting the blockchain data..."
mkdir -p $DATA_DIR
tar -xzf /tmp/aleoledger.tar.gz -C $DATA_DIR

echo "Listing the data directory after extraction:"
ls $DATA_DIR

echo "Moving the extracted data to the data directory..."
EXTRACTED_DIR="$DATA_DIR/storage/storage_1054016"
if [ -d "$EXTRACTED_DIR" ]; then
    mv $EXTRACTED_DIR/* $DATA_DIR/
    echo "Removing the now-empty extracted directory..."
    rm -rf $EXTRACTED_DIR
else
    echo "Expected ledger directory not found in the extracted data."
    exit 1
fi

echo "Listing the final contents of ~/.aleo/storage/ledger-3:"
ls ~/.aleo/storage/ledger-3

echo "Starting snarkOS node..."
exec cargo run --release -- start --metrics --nodisplay --client
