Run the following command to get the requirements:

```bash
# the essentials
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update -y
apt install build-essential -y
sudo apt install neovim
# for clipboard support
sudo apt install xclip -y
# for greping
sudo apt install ripgrep -y
# for multiple terminals
sudo apt install tmux -y
# version control
sudo apt install git -y
# debuggers
sudo apt install lldb -y
# golang
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt install golang-go -y
# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# npm and nodejs
sudo apt install npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
# source the bashrc
```
For installing miniconda
```bash
# miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
```

Once everything is installed, run the following commands:
```bash
source ~/.bashrc
nvm install --lts
nvm use --lts
```

Opening neovim for the first time will install the plugins.
For debugging in python, install the following:
```bash
pip install debugpy
```
