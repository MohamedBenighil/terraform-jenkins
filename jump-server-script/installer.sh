#!/bin/bash

# Définir le nom d'hôte à partir de la variable
hostnamectl set-hostname ${hostname}

echo "127.0.0.1 ${hostname}" >> /etc/hosts
# echo "Hello benighil"
# curl -LsSf https://astral.sh/uv/install.sh | sh
# echo "Hello benighil"
# echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/ubuntu/.bashrc
# echo "Hello benighil"
# export PATH="$HOME/.local/bin:$PATH"
# uv tool install pyinfra



