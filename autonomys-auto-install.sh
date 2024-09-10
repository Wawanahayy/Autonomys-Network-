#!/bin/bash

echo -e "\n\n############ Auto Install Autonomys Network Node and Farmer ############\n"

echo "Updating package list and upgrading installed packages..."
sudo apt update && sudo apt upgrade -y
if [ $? -ne 0 ]; then
  echo "Error updating and upgrading packages. Exiting..."
  exit 1
fi

echo "Installing required packages..."
sudo apt install curl wget tar build-essential jq unzip -y
if [ $? -ne 0 ]; then
  echo "Error installing packages. Exiting..."
  exit 1
fi

read -p "Enter your reward address: " REWARD_ADDRESS
read -p "Enter your node port (default 30333): " NODE_PORT
NODE_PORT=${NODE_PORT:-30333}
read -p "Enter your DNS port (default 30433): " DNS_PORT
DNS_PORT=${DNS_PORT:-30433}
read -p "Enter your farmer port (default 30533): " FARMER_PORT
FARMER_PORT=${FARMER_PORT:-30533}
read -p "Enter your plot size (default 100G): " PLOT_SIZE
PLOT_SIZE=${PLOT_SIZE:-100G}

if ! id -u subspace &>/dev/null; then
  sudo useradd -m -p ! -s /sbin/nologin -c "" subspace
  echo "User 'subspace' created."
else
  echo "User 'subspace' already exists."
fi

sudo su subspace -s /bin/bash << 'EOF'
mkdir -p ~/.local/bin ~/.local/share
wget -O ~/.local/bin/subspace-node https://github.com/autonomys/subspace/releases/download/gemini-3h-2024-sep-03/subspace-node-ubuntu-x86_64-skylake-gemini-3h-2024-sep-03
wget -O ~/.local/bin/subspace-farmer https://github.com/autonomys/subspace/releases/download/gemini-3h-2024-sep-03/subspace-farmer-ubuntu-x86_64-skylake-gemini-3h-2024-sep-03
chmod +x ~/.local/bin/subspace-node
chmod +x ~/.local/bin/subspace-farmer
exit
EOF

sudo tee /etc/systemd/system/subspace-node.service > /dev/null << EOF
[Unit]
Description=Subspace Node
Wants=network.target
After=network.target

[Service]
User=subspace
Group=subspace
ExecStart=/home/subspace/.local/bin/subspace-node \\
          run \\
          --name subspace \\
          --base-path /home/subspace/.local/share/subspace-node \\
          --chain gemini-3h \\
          --farmer \\
          --listen-on /ip4/0.0.0.0/tcp/$NODE_PORT \\
          --dsn-listen-on /ip4/0.0.0.0/tcp/$DNS_PORT
KillSignal=SIGINT
Restart=always
RestartSec=10
Nice=-5
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/subspace-farmer.service > /dev/null << EOF
[Unit]
Description=Subspace Farmer
Wants=network.target
After=network.target
Wants=subspace-node.service
After=subspace-node.service

[Service]
User=subspace
Group=subspace
ExecStart=/home/subspace/.local/bin/subspace-farmer \\
          farm \\
          --reward-address $REWARD_ADDRESS \\
          --listen-on /ip4/0.0.0.0/tcp/$FARMER_PORT \\
          path=/home/subspace/.local/share/subspace-farmer,size=$PLOT_SIZE
KillSignal=SIGINT
Restart=always
RestartSec=10
Nice=-5
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now subspace-node subspace-farmer

echo "subscribe my channel: https://t.me/AirdropJP_JawaPride"
