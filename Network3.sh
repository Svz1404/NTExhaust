#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m'
#!/bin/bash
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

# Logger Function
log_message() {
    local level=$1
    local message=$2
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local border="----------------------------------------"

    echo -e "${CYAN}${border}${NC}"
    case $level in
        INFO) echo -e "${CYAN}[INFO] ${timestamp} - ${message}${NC}" ;;
        SUCCESS) echo -e "${GREEN}[SUCCESS] ${timestamp} - ${message}${NC}" ;;
        ERROR) echo -e "${RED}[ERROR] ${timestamp} - ${message}${NC}" ;;
        *) echo -e "${YELLOW}[UNKNOWN] ${timestamp} - ${message}${NC}" ;;
    esac
    echo -e "${CYAN}${border}${NC}\n"
}

# Check if a port is available
check_port() {
    local port=$1
    log_message "INFO" "Checking if port $port is available..."
    if ss -tuln | grep -q ":$port"; then
        log_message "ERROR" "Port $port is already in use. Please free it before proceeding."
        exit 1
    else
        log_message "SUCCESS" "Port $port is available."
    fi
}

# Get the server's IP address
get_server_ip() {
    ip route get 1 | awk '{print $7; exit}'
}

# Main Process
main() {
    log_message "INFO" "Starting system update and upgrade..."
    sudo apt update && sudo apt upgrade -y
    log_message "SUCCESS" "System updated successfully."

    log_message "INFO" "Installing required dependencies..."
    sudo apt install -y net-tools ufw wget
    log_message "SUCCESS" "Dependencies installed successfully."

    log_message "INFO" "Validating port 8080 availability..."
    check_port 8080

    log_message "INFO" "Configuring firewall to allow port 8080..."
    sudo ufw allow 8080
    sudo ufw reload
    log_message "SUCCESS" "Firewall configuration completed. Port 8080 is open."

    log_message "INFO" "Downloading node files..."
    cd $HOME
    wget -q https://network3.io/ubuntu-node-v2.1.1.tar.gz
    log_message "SUCCESS" "Node files downloaded successfully."

    log_message "INFO" "Extracting node files to 'Network3' folder..."
    mkdir -p $HOME/Network3
    tar -xzf ubuntu-node-v2.1.1.tar.gz -C $HOME/Network3 --strip-components=1
    log_message "SUCCESS" "Files extracted to 'Network3' folder."

    log_message "INFO" "Running node setup script..."
    cd $HOME/Network3
    sudo bash manager.sh up
    log_message "SUCCESS" "Node setup completed."

    log_message "INFO" "Saving node key..."
    sudo bash manager.sh key
    log_message "SUCCESS" "Key saved and bound successfully."

    local server_ip
    server_ip=$(get_server_ip)
    log_message "INFO" "Your server IP is: $server_ip"
    log_message "INFO" "Activate the node using this link:"
    echo -e "${GREEN}https://account.network3.ai/main?o=${server_ip}:8080${NC}"
}

# Run the script
main