#!/bin/sh


getopts ":f" forceOverwrite
initDir=$(pwd)


# Ignore or execute forceOverwriteal commands, if it doesn't exists.
executeCommandList() {
  if [[ $# -eq 0 ]]
  then
    return 0
  fi
  
  local command
  for command in "$@" ; do
      $command
  done
}


# Check if specified path exists in the file system.
checkPath() { 
  local path=$1
  
  if [[ $(find $path -maxdepth 0 2> /dev/null | wc -w) -eq 0 ]]
  then
    false
  else
    true
  fi
}


# User prompt for overwriting a specified path.
queryOverwrite() {
  if [[ $forceOverwrite = "f" ]]
  then
    return 0
  fi
  
  local path=$1
  
  local response
  while ! [[ $response =~ ^(Y|n|N)$ ]]
  do
    echo -e "\n$path already exists. Do you wish to overwrite it? [Y/n]"
    read response
  done

  if [[ $response =~ ^(n|N)$ ]]
  then
   return 1
  fi
  
  return 0
}


<<"modify-path"
  Prompt the user for deleting an exisiting path and its replacement of space
  seperated strings as commands should be specified.
  Usage: modifyPath <ABSOULTE_PATH> [COMMANDS...]
modify-path
modifyPath() {
  getopts ":f" forceModify
  if [[ $forceModify = "f" ]]
  then
    shift
  fi
  
  local path=$1
  shift
  
  if ! checkPath $path; then executeCommandList "$@"; return 0; fi
  
  queryOverwrite $path
  local response=$?
  
  if [[ ($forceModify = "f" || response -eq 0) && -d $path ]]
  then
    rm -rf $path
    executeCommandList "$@"
    return 0
  elif [[ $forceModify = "f" || response -eq 0 ]]
  then
    rm $path
    executeCommandList "$@"
    return 0
  fi
  
  return 1
}


sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get install -y curl


# Download and install neovim.
echo -e "\n"
echo -e "\e[7mInstalling Neovim...\e[0m"
sudo apt-get install -y software-properties-common # add-apt-repository for configuring ppa
if ! [[ -f /etc/apt/sources.list.d/neovim-ppa-ubuntu-stable-bionic.list ]]
then
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt-get update
fi
if ! [ -f /usr/bin/nvim ]
then
  sudo apt-get -y install neovim
fi


# Plugin manager for vim and neovim.
echo -e "\n"
echo -e "\e[7mInstalling Plug (Plugin Manager) for vim/neovim...\e[0m"
vimPlugPath=$HOME/.vim/autoload/plug.vim
modifyPath $vimPlugPath \
  "curl -fLo $vimPlugPath --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

neovimPlugPath="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim
modifyPath $neovimPlugPath \
  "curl -fLo $neovimPlugPath --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"


# Install nvm and Node
echo -e "\n"
echo -e "\e[7mInstalling nvm...\e[0m"
nvmVersion=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/nvm-sh/nvm/releases/latest | awk -F "/" '{print $NF}')
nvmPath=$HOME/.nvm
modifyPath $nvmPath
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
  nvm use node # Switch to default node version.
  
  # Javascript debug adapter and configuration for nvim-dap
  echo -e "\n"
  echo -e "\e[7mInstalling and configuring Javascript debug adapter for nvim-dap...\e[0m"
  cd $HOME && mkdir -p ./dev/microsoft && cd ./dev/microsoft
  modifyPath "$PWD/vscode-node-debug2" \
    "git clone https://github.com/microsoft/vscode-node-debug2.git" \
    "cd vscode-node-debug2" \
    "npm install"
  if [[ $? -eq 0 ]] # Build only if path is modified or newly created.
  then
    NODE_OPTIONS=--no-experimental-fetch npm run build
  fi
else
  echo -e "\e[31mnvm could not be found. Skipping node installation.\e[0m"
  echo -e "\e[31mnode could not be installed. Skipping vscode-node-debug2 installation.\e[0m"
fi


# Symbolic link .vimrc configuration for vim and neovim.
echo -e "\n"
vimConfigPath=$HOME/.vimrc
modifyPath $vimConfigPath \
  "ln -s $initDir/.vimrc $vimConfigPath" \
  "echo -e Created symlink \033[1;36m$initDir/.vimrc -> $HOME/.vimrc\e[0m" \
  "echo -e \e[33mcoc startup warning has been disabled. Ensure Vim or Neovim is using the right version for coc.nvim\e[0m"
mkdir -p $HOME/.config/nvim

echo -e "\n"
neovimConfigPath=$HOME/.config/nvim/init.vim
modifyPath $neovimConfigPath \
  "ln -s $initDir/.vimrc $neovimConfigPath" \
  "echo -e Created symlink \033[1;36m$initDir/.vimrc -> $HOME/.config/nvim/init.vim\e[0m"


# Install extensions for vim and neovim using plugin manager.
echo -e "\n"
echo -e "\e[7mInstalling plugins for vim and neovim via plugin manager 'Plug'...\e[0m"
nvim +PlugInstall +qall
vim +PlugInstall +qall



# Symbolic link configuration files.
echo -e "\n"
userDefinedAliasesPath=$HOME/.bash_aliases
modifyPath $userDefinedAliasesPath \
  "ln -s $initDir/.bash_aliases $userDefinedAliasesPath" \
  "echo -e Created symlink \033[1;36m$initDir/.bash_aliases -> $HOME/.bash_aliases\e[0m"
  
# tmux configuration
tmuxConfigPath=$HOME/.tmux.conf
modifyPath $tmuxConfigPath \
  "ln -s $initDir/.tmux.conf $tmuxConfigPath" \
  "echo -e Created symlink \033[1;36m$initDir/.tmux -> $HOME/.tmux.conf\e[0m"

echo -e "\n"
echo -e "\e[34mRestart the terminal for changes to take effect.\e[0m"

