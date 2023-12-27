#!/bin/bash
set -e

DATA_DIR="/root/.aleo/storage/ledger-3"

echo "Removing any existing ledger data..."
rm -rf $DATA_DIR/*

echo "Downloading the blockchain data snapshot..."
wget -O /tmp/aleoledger.tar.gz https://aleo-snapshots.f5nodes.com/storage_1054016.tar.gz

echo "Extracting the blockchain data..."
mkdir -p $DATA_DIR
tar -xzf /tmp/aleoledger.tar.gz -C $DATA_DIR
echo "ls on data dir"
ls $DATA_DIR
mv $DATA_DIR/ledger-3-1054016/* $DATA_DIR/
rm -rf $DATA_DIR/ledger-3-1054016

ls ~/.aleo/storage/ledger-3

echo "Cleaning up temporary files..."
rm -rf /tmp/aleoledger.tar.gz

echo "Starting snarkOS node..."
exec cargo run --release -- start --metrics --nodisplay --client
