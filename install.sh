#!/bin/bash

# Function to prompt the user with multiple options
prompt_user() {
    while true; do
        echo -e "\nDo you want to install $1?"
        echo "1) Install this package"
        echo "2) Install all remaining packages"
        echo "3) Skip this package"
        echo "4) Skip all remaining packages"
        read -p "Enter your choice [1-4]: " choice

        case $choice in
        1) return 0 ;; # Install this package
        2)
            INSTALL_ALL=true
            return 0
            ;;         # Install all packages
        3) return 1 ;; # Skip this package
        4)
            SKIP_ALL=true
            return 1
            ;; # Skip all remaining
        *) echo "Invalid option. Please enter 1-4." ;;
        esac
    done
}

# Add required repositories
echo "Adding essential repositories..."
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt update -y

# Install essential packages
echo "Installing essential packages..."
sudo apt install -y build-essential neovim xclip ripgrep tmux git lldb luarocks python3-pip python3-venv

# Install optional packages
SKIP_ALL=false
INSTALL_ALL=false

# Golang
if ! $SKIP_ALL; then
    if $INSTALL_ALL || prompt_user "Golang"; then
        echo "Installing Golang..."
        sudo apt install -y golang-go
    else
        echo "Skipping Golang installation."
    fi
fi

# R
if ! $SKIP_ALL; then
    if $INSTALL_ALL || prompt_user "R"; then
        echo "Installing R..."
        sudo apt install -y r-base
    else
        echo "Skipping R installation."
    fi
fi

# Rust
if ! $SKIP_ALL; then
    if $INSTALL_ALL || prompt_user "Rust"; then
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        echo "Skipping Rust installation."
    fi
fi

# Node.js and npm
echo "Installing npm and Node.js (NVM)..."
sudo apt install -y npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts

# WSL Clipboard support (if running on WSL2)
if grep -qi "(microsoft|wsl)" /proc/version; then
    echo "WSL detected. Installing win32yank for clipboard support..."
    curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
    unzip -p /tmp/win32yank.zip win32yank.exe >/tmp/win32yank.exe
    chmod +x /tmp/win32yank.exe
    sudo mv /tmp/win32yank.exe /usr/local/bin/
fi

# Miniconda
if ! $SKIP_ALL; then
    if $INSTALL_ALL || prompt_user "Miniconda"; then
        echo "Installing Miniconda..."
        wget https://repo.anaconda.com/miniconda/miniconda3-latest-linux-x86_64.sh -O /tmp/miniconda.sh
        bash /tmp/miniconda.sh -b -p $HOME/miniconda
        echo 'export PATH="$HOME/miniconda/bin:$PATH"' >>$HOME/.bashrc
        source $HOME/.bashrc
    else
        echo "Skipping Miniconda installation."
    fi
fi

echo "Installation process completed!"
