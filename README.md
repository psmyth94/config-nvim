Run the following command to get the requirements:

## Quick Installation
Clone the repository and run the following command:
```bash
git clone git@github.com:psmyth94/config-nvim.git ~/.config/nvim
cd ~/.config/nvim
chmod +x install.sh
./install.sh
```

## Manual Installation
### with `sudo`:

```bash
# the essentials
sudo add-apt-repository ppa:neovim-ppa/unstable
# golang
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update -y
sudo apt install \
   build-essential \
   neovim \
   xclip \
   ripgrep \
   tmux \
   git \
   lldb \
   golang-go \
   luarocks \
   python3-pip \
   python3-venv \
   libmagickwand-dev \
   w3m \
   -y
# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# npm and nodejs
sudo apt install npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```

For installing miniconda

```bash
# miniconda
wget https://github.com/conda-forge/miniforge/releases/latest/Miniforge3-Linux-x86_64.sh
chmod +x Miniforge-pypy3-Linux-x86_64.sh
./Miniforge-pypy3-Linux-x86_64.sh
```

Once everything is installed, run the following commands:

```bash
source ~/.bashrc
nvm install --lts
nvm use --lts
```

### without `sudo`:

The following is for those who have a legacy system that does not have the latest glibc version or do not
have sudo access.

First, install miniconda:

```bash
# miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
```

Then, run the command and follow the instructions:

```bash
./Miniconda3-latest-Linux-x86_64.sh
```

Then, install neovim-releases (instead of nightly):

```bash
wget https://github.com/neovim/neovim-releases/releases/download/stable/nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz -C ~/
echo 'export PATH="$HOME/nvim-linux64/bin:$PATH"' >>~/.bashrc
source ~/.bashrc
```

Finally, install the following:

```bash
# Install the essentials with Conda
conda create -n neovim python=3.11
conda activate neovim
conda install -c conda-forge cxx-compiler make cmake ripgrep git lldb go rust nodejs luarocks
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```

Opening neovim for the first time will install the plugins.
For debugging in python, install the following:

```bash
pip install debugpy
```

### WSL Clipboard support
In order to enable clipboard support on wsl2, run the following command:
```bash
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe >/tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/
```
