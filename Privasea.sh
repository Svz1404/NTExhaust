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

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (e.g., use sudo)"
  exit
fi

# Update package list and install necessary dependencies
echo "Updating packages and installing dependencies..."
apt update && apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
echo "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker's official repository
echo "Adding Docker repository..."
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package list
echo "Updating package list..."
apt update

# Install Docker
echo "Installing Docker..."
apt install -y docker-ce

# Verify Docker installation
echo "Verifying Docker installation..."
docker_version=$(docker --version)
if [[ $docker_version == *"Docker version"* ]]; then
  echo "Docker installed successfully: $docker_version"
else
  echo "Docker installation failed. Exiting."
  exit 1
fi

# Start and enable Docker service
echo "Starting and enabling Docker service..."
systemctl start docker
systemctl enable docker

# Pull the Privasea Docker image
echo "Pulling Privasea Docker image..."
docker pull privasea/acceleration-node-beta:latest

# Create the program directory and navigate to it
echo "Creating configuration directory..."
mkdir -p /privasea/config && cd /privasea

# Generate a new keystore
echo "Generating a new keystore. Follow the prompts to set a password."
docker run -it -v "/privasea/config:/app/config" \
  privasea/acceleration-node-beta:latest ./node-calc new_keystore

echo "Note the node address and keystore filename from the output above."

# List the contents of the /privasea/config directory
echo "Listing contents of /privasea/config..."
cd /privasea/config && ls

# Prompt user for the keystore filename
echo "Please enter the name of the keystore file (e.g., UTC--2025-01-06T06-11-07.485797065Z--<rest_of_filename>):"
read -r keystore_filename

# Rename the keystore file
echo "Renaming the keystore file to wallet_keystore..."
mv "./$keystore_filename" ./wallet_keystore

# Verify the renaming
echo "Verifying the renamed keystore file..."
ls

# Prompt user for the keystore password
echo "Please enter the password you used for the keystore:"
read -s keystore_password

# Start the node
echo "Starting the Privasea node..."
cd /privasea/
docker run -d -v "/privasea/config:/app/config" \
  -e KEYSTORE_PASSWORD="$keystore_password" \
  privasea/acceleration-node-beta:latest

echo "Node setup is complete. Use the dashboard to link the node address and reward address."
