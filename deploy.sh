#!/bin/sh

initDir=$(pwd)
sudo apt-get update && sudo apt-get -y upgrade


# Download and install neovim.
echo -e "\n"
echo -e "\e[7mInstalling Neovim...\e[0m"
sudo apt-get install -y software-properties-common # add-apt-repository for configuring ppa
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get -y install neovim


# Plugin manager for vim and neovim.
echo -e "\n"
echo -e "\e[7mInstalling Plug (Plugin Manager) for vim/neovim...\e[0m"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


# Install nvm and Node
echo -e "\n"
echo -e "\e[7mInstalling nvm...\e[0m"
sudo apt-get install -y curl
nvmVersion=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/nvm-sh/nvm/releases/latest | awk -F "/" '{print $NF}')
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$nvmVersion/install.sh | bash
source $HOME/.bashrc
source $HOME/.profile
if [[ -d $HOME/.nvm && -f $HOME/.nvm/nvm.sh ]]
then
  source $HOME/.nvm/nvm.sh
fi
if command -v nvm
then
  echo -e "\n"
  echo -e "\e[7mInstalling node...\e[0m"
  nvm install --lts
  
  # Javascript debug adapter and configuration for nvim-dap
  echo -e "\n"
  echo -e "\e[7mInstalling and configuring Javascript debug adapter for nvim-dap...\e[0m"
  cd $HOME && mkdir -p ./dev/microsoft && cd ./dev/microsoft
  git clone https://github.com/microsoft/vscode-node-debug2.git
  cd vscode-node-debug2
  npm install
  NODE_OPTIONS=--no-experimental-fetch npm run build
else
  echo -e "\e[31mnvm could not be found. Skipping node installation.\e[0m"
  echo -e "\e[31mnode could not be installed. Skipping vscode-node-debug2 installation.\e[0m"
fi


# Symbolic link .vimrc configuration for vim and neovim.
echo -e "\n"
ln -s $initDir/.vimrc $HOME
echo -e "Created symlink \033[1;36m$initDir/.vimrc -> $HOME/.vimrc\e[0m"
mkdir -p $HOME/.config/nvim
ln -s $initDir/.vimrc $HOME/.config/nvim/init.vim
echo -e "Created symlink \033[1;36m$initDir/.vimrc -> $HOME/.config/nvim/init.vim\e[0m"


# Install extensions for vim and neovim using plugin manager.
echo -e "\n"
echo -e "\e[7mInstalling plugins for vim and neovim via plugin manager 'Plug'...\e[0m"
nvim +PlugInstall +qall
vim +PlugInstall +qall


# Symbolic link configuration files.
echo -e "\n"
ln -s $initDir/.bash_aliases $HOME # user defined bash aliases
echo -e "Created symlink \033[1;36m$initDir/.bash_aliases -> $HOME/.bash_aliases\e[0m"
ln -s $initDir/.tmux.conf $HOME # tmux configuration
echo -e "Created symlink \033[1;36m$initDir/.tmux -> $HOME/.tmux.conf\e[0m"

echo -e "\n"
echo -e "\e[34mRestart the terminal for changes to take effect.\e[0m"

