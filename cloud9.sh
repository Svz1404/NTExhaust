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
# Perbarui paket dan instal dependensi dasar
echo "Memperbarui paket dan menginstal dependensi dasar..."
sudo apt-get update && sudo apt-get -y install curl git build-essential

# Instal Node.js
echo "Menginstal Node.js..."
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get -y install nodejs

# Clone repositori Cloud 9 dari GitHub
echo "Mengkloning repositori Cloud 9..."
git clone https://github.com/c9/core.git sdk

# Menjalankan skrip instalasi
echo "Menjalankan skrip instalasi Cloud 9..."
cd sdk
./scripts/install-sdk.sh

# Memulai sesi `screen` untuk menjaga server tetap berjalan
echo "Menyiapkan sesi screen untuk menjaga server tetap berjalan..."
screen -dmS c9-server bash -c "nodejs server.js -p 8080 -l 0.0.0.0 -a user:pass"

echo "Cloud 9 berhasil diinstal dan dijalankan!"
echo "Untuk memeriksa server, gunakan perintah: screen -r c9-server"

# Skrip tambahan untuk memastikan pembaruan saat restart
echo "Menambahkan perintah untuk pembaruan otomatis..."
cat <<EOT >> update-c9.sh
#!/bin/bash
cd sdk
git fetch origin
git reset origin/master --hard
sleep 100
EOT
chmod +x update-c9.sh

echo "Proses selesai. Jika Anda menutup terminal, gunakan 'screen -r c9-server' untuk kembali ke server."
