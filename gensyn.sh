#!/bin/bash
# Colors
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
set -e

echo "🔄 Updating package list..."
sudo apt-get update

echo "📦 Installing basic dependencies..."
sudo apt-get install -y curl python3 python3-venv python3-pip screen git gnupg

echo "🌐 Fetching latest Node.js LTS setup script..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

echo "🧩 Installing Node.js and npm..."
sudo apt-get install -y nodejs

echo "🔑 Adding Yarn GPG key..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "🗂️ Adding Yarn APT repo..."
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

echo "🔄 Updating apt after adding Yarn repo..."
sudo apt update

echo "📦 Installing Yarn..."
sudo apt install -y yarn

echo "📁 Cloning RL-Swarm repo..."
git clone https://github.com/gensyn-ai/rl-swarm.git

cd rl-swarm

echo "📦 Installing project dependencies using Yarn..."
yarn install

echo "✅ Installation complete!"
