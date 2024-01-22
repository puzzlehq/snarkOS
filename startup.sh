#!/bin/bash
set -e

DATA_DIR="$HOME/.aleo/storage/ledger-3"

cleanup() {
    echo "Debug: Cleaning up temporary files..."
    rm -rf $DATA_DIR/aleoledger.tar.gz
}

trap cleanup EXIT

echo "Debug: Removing any existing ledger data in $DATA_DIR..."
rm -rf $DATA_DIR/*

echo "Debug: Downloading the blockchain data snapshot..."
wget -O $DATA_DIR/aleoledger.tar.gz https://ledger.aleo.network/snapshot/aleoledger-1163525.tar.gz

# debugging purposes...
# echo "Debug: Checking contents of the tarball before extraction..."
# tar -tzf $DATA_DIR/aleoledger.tar.gz || { echo "Debug: Failed to list tarball contents"; exit 1; }

echo "Debug: Creating $DATA_DIR if it doesn't exist..."
mkdir -p $DATA_DIR

echo "Debug: Extracting the blockchain data directly to $DATA_DIR..."
tar -xzf $DATA_DIR/aleoledger.tar.gz -C $DATA_DIR

echo "Moving the extracted data to the data directory..."
EXTRACTED_DIR="$DATA_DIR/storage/ledger-3-1163525"
if [ -d "$EXTRACTED_DIR" ]; then
    mv $EXTRACTED_DIR/* $DATA_DIR/
    echo "Removing the now-empty extracted directory..."
    rm -rf $EXTRACTED_DIR
else
    echo "Expected ledger directory not found in the extracted data."
    exit 1
fi

echo "Debug: Listing the final contents of $DATA_DIR:"
ls $DATA_DIR || { echo "Debug: Failed to list final contents"; exit 1; }

echo "Debug: Starting snarkOS node..."

# old peers
# PEERS="211.171.42.238:4133","121.140.185.177:38259","36.189.234.237:60027","211.171.42.231:4133","128.199.66.135:4133","211.171.42.235:4133","159.135.194.92:4133","211.171.42.234:39891","211.171.42.233:4133","61.10.9.27:4133","47.242.151.228:4143","47.242.151.228:4133","180.151.225.92:64942","104.61.63.153:4133","121.140.185.177:40477","211.171.42.241:4133","118.36.228.252:4133","211.171.42.161:4133","36.189.234.195:4133","211.171.42.234:44875","121.140.185.177:4133","211.171.42.239:4133","45.14.135.4:4133","161.35.144.189:4133","47.243.96.237:4133","94.131.9.32:37007","211.171.42.240:4133","149.102.130.180:4133","211.171.42.164:4133","210.106.251.152:42837","211.171.42.163:4133","211.171.42.236:4133"
PEERS="35.227.159.141:4133","34.150.221.166:4133","35.224.50.150:4133","34.139.203.87:4133","159.65.172.226:4133","159.65.170.82:4133","65.108.104.9:4133","104.248.34.77:4133","159.89.6.215:4133","167.99.210.191:4133","24.199.105.251:4133","165.232.142.174:4133","147.192.99.28:4133","51.81.176.217:44133"

exec cargo run --release -- start --metrics --nodisplay --client --peers "$PEERS" || { echo "Debug: Failed to start snarkOS node"; exit 1; }


# running from f5 node snapshot

# set -e

# DATA_DIR="/root/.aleo/storage/ledger-3"

# cleanup() {
#     echo "Debug: Cleaning up temporary files..."
#     rm -rf /tmp/aleoledger.tar.gz
# }

# trap cleanup EXIT

# echo "Debug: Removing any existing ledger data in $DATA_DIR..."
# rm -rf $DATA_DIR/*

# echo "Debug: Downloading the blockchain data snapshot..."
# wget -O /tmp/aleoledger.tar.gz https://aleo-snapshots.f5nodes.com/storage_1163899.tar.gz || { echo "Debug: Failed to download"; exit 1; }

# # debugging purposes...
# # echo "Debug: Checking contents of the tarball before extraction..."
# # tar -tzf /tmp/aleoledger.tar.gz || { echo "Debug: Failed to list tarball contents"; exit 1; }

# echo "Debug: Creating $DATA_DIR if it doesn't exist..."
# mkdir -p $DATA_DIR

# echo "Debug: Extracting the blockchain data directly to $DATA_DIR..."
# tar -xzf /tmp/aleoledger.tar.gz --strip-components=5 -C $DATA_DIR || { echo "Debug: Extraction failed"; exit 1; }

# echo "Debug: Listing the final contents of $DATA_DIR:"
# ls $DATA_DIR || { echo "Debug: Failed to list final contents"; exit 1; }

# echo "Debug: Starting snarkOS node..."

# # old peers before friday, 1/12
# # PEERS="16.163.42.92:4133,147.192.99.28:14134,57.128.21.96:5000,121.140.185.177:38663,34.92.203.27:14134,51.81.176.217:14134,162.19.62.176:5000,117.2.6.45:5000,118.36.228.252:5000,121.140.185.177:5000,135.181.228.130:5000,47.242.151.228:4148,23.242.170.221:5000,114.254.79.86:37709,218.85.126.210:4133"
# PEERS="35.227.159.141:4133", "34.150.221.166:4133", "35.224.50.150:4133", "34.139.203.87:4133", "159.65.172.226:4133", "159.65.170.82:4133", "65.108.104.9:4133", "104.248.34.77:4133", "159.89.6.215:4133", "167.99.210.191:4133", "24.199.105.251:4133", "165.232.142.174:4133", "147.192.99.28:4133", "51.81.176.217:44133"

# exec cargo run --release -- start --metrics --nodisplay --client --peers "$PEERS" || { echo "Debug: Failed to start snarkOS node"; exit 1; }