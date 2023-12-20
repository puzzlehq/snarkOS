#!/bin/bash
set -e

# Directory where the blockchain data will be stored
DATA_DIR="/.aleo/storage/ledger-3"

# Check if the ledger data exists and download it if not
if [ ! -d "$DATA_DIR" ]; then
    echo "Ledger directory not found. Downloading the blockchain data..."
    wget -O /tmp/aleoledger.tar.gz https://ledger.aleo.network/aleoledger-1002442.tar.gz
    echo "Extracting the blockchain data..."
    tar -xzf /tmp/aleoledger.tar.gz -C $(dirname "$DATA_DIR")
    echo "Moving the extracted data to the volume..."
    mv /storage/ledger-3-1002442 $DATA_DIR
    echo "Cleaning up temporary files..."
    rm -rf /tmp/aleoledger.tar.gz /storage
else
    echo "Ledger directory already exists. Skipping download."
fi

# Start snarkOS with the appropriate flags
echo "Starting snarkOS node..."
exec cargo run --release -- start --metrics --nodisplay --client --verbosity 4
