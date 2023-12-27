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

echo "Checking contents of the tarball before extraction:"
tar -tzf /tmp/aleoledger.tar.gz

echo "Extracting the blockchain data..."
mkdir -p $DATA_DIR
tar -xzf /tmp/aleoledger.tar.gz -C $DATA_DIR || { echo "Extraction failed"; exit 1; }

echo "Listing the data directory after extraction:"
ls $DATA_DIR

# Update the path based on your logs. This assumes the data is in $DATA_DIR/home/
EXTRACTED_DIR="$DATA_DIR/home"
echo "Checking what is inside the extracted folder:"
ls $EXTRACTED_DIR

for dir in $EXTRACTED_DIR/*; do
    if [ -d "$dir" ]; then
        echo "Listing contents of $dir:"
        ls "$dir"
    fi
done

echo "Moving the extracted data to the data directory..."
if [ -d "$EXTRACTED_DIR" ]; then
    mv $EXTRACTED_DIR/* $DATA_DIR/
    echo "Removing the now-empty extracted directory..."
    rm -rf $EXTRACTED_DIR
else
    echo "Expected ledger directory not found in the extracted data."
    exit 1
fi

echo "Listing the final contents of $DATA_DIR:"
ls $DATA_DIR

echo "Starting snarkOS node..."
exec cargo run --release -- start --metrics --nodisplay --client
