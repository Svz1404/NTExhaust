#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e '\e[34m'
echo -e '$$\   $$\ $$$$$$$$\      $$$$$$$$\           $$\                                       $$\     '
echo -e '$$$\  $$ |\__$$  __|     $$  _____|          $$ |                                      $$ |    '
echo -e '$$$$\ $$ |   $$ |        $$ |      $$\   $$\ $$$$$$$\   $$$$$$\  $$\   $$\  $$$$$$$\ $$$$$$\   '
echo -e '$$ $$\$$ |   $$ |$$$$$$\ $$$$$\    \$$\ $$  |$$  __$$\  \____$$\ $$ |  $$ |$$  _____|\_$$  _|  '
echo -e '$$ \$$$$ |   $$ |\______|$$  __|    \$$$$  / $$ |  $$ | $$$$$$$ |$$ |  $$ |\$$$$$$\    $$ |    '
echo -e '$$ |\$$$ |   $$ |        $$ |       $$  $$<  $$ |  $$ |$$  __$$ |$$ |  $$ | \____$$\   $$ |$$\ '
echo -e '$$ | \$$ |   $$ |        $$$$$$$$\ $$  /\$$\ $$ |  $$ |\$$$$$$$ |\$$$$$$  |$$$$$$$  |  \$$$$  |'
echo -e '\__|  \__|   \__|        \________|\__/  \__|\__|  \__| \_______| \______/ \_______/    \____/ '
echo -e '\e[0m'
echo -e "Join our Telegram channel: https://t.me/NTExhaust"
sleep 5

set -e  # Exit immediately if a command exits with a non-zero status

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y curl wget build-essential pkg-config libssl-dev clang cmake

#Install unzip
apt install unzip

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Check Rust installation
rustc --version
cargo --version

# Check RAM and add swap if needed
RAM_SIZE=$(grep MemTotal /proc/meminfo | awk '{print $2}')
if [ "$RAM_SIZE" -lt 8000000 ]; then
    echo "RAM is less than 8GB, adding swap..."
    sudo fallocate -l 10G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    sudo sysctl vm.swappiness=100
    echo 'vm.swappiness=100' | sudo tee -a /etc/sysctl.conf
fi

# Install Rust targets
rustup target add wasm32-unknown-unknown
rustup show active-toolchain
rustup install nightly
rustup default nightly

# Fix Protoc error
PROTOC_VERSION=25.2
PROTOC_ZIP=protoc-$PROTOC_VERSION-linux-x86_64.zip
curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOC_VERSION/$PROTOC_ZIP
unzip $PROTOC_ZIP -d $HOME/.local
export PATH="$HOME/.local/bin:$PATH"
rm $PROTOC_ZIP

RUST_BACKTRACE=1

# Install Nexus CLI
curl https://cli.nexus.xyz/ | sh

# Reload shell
exec bash
