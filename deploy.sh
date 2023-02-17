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
if ! [ "$(ls /etc/apt/sources.list.d/neovim-ppa-ubuntu-unstable-*.list 2> /dev/null | wc -l)" -eq "1" ]
then
  sudo add-apt-repository -y ppa:neovim-ppa/unstable
  sudo apt-get update && sudo apt-get -y upgrade
fi
if ! [ -f /usr/bin/nvim ]
then
  sudo apt-get -y install neovim
fi


# Download and install GNU compiler tools.
echo -e "\n"
echo -e "\e[7mInstalling GNU compiler tools...\e[0m"
sudo apt-get install -y build-essential


# Download and install gdb.
echo -e "\n"
echo -e "\e[7mInstalling GDB debugger...\e[0m"
sudo apt-get install -y gdb


# Plugin manager for neovim.
echo -e "\n"
echo -e "\e[7mInstalling Packer (Plugin Manager) for neovim...\e[0m"
nvimPackerRepoPath=$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
modifyPath $nvimPackerRepoPath \
  "git clone --depth 1 https://github.com/wbthomason/packer.nvim $nvimPackerRepoPath"


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


<< TODO
  Instead for running post-update hooks for every 'VimEnter' event, execute it only once during deployment.
  Current workaround involves autocmds inside 'post-update-hook' files within the 'after' directory.
TODO
# Install extensions for neovim using plugin manager.
echo -e "\n"
echo -e "\e[7mInstalling plugins for neovim via plugin manager 'Packer'...\e[0m"
nvim -c "so $initDir/nvim/home/lua/main/packer.lua" -c "autocmd User PackerComplete quitall" -c "PackerSync"


# Symbolic link configuration and plugins for neovim.
echo -e "\n"
neovimHomePath=$HOME/.config/nvim
neovimHomePathSource=$initDir/nvim/home
mkdir -p $neovimHomePath
if [[ $(find -L "$neovimHomePath" "$neovimHomePathSource" -printf "%P\n" | sort | uniq -d | wc -w) -eq 0 ]]
then
  # Configuration does not exists.
  cd $neovimHomePath
  ln -s $neovimHomePathSource/* .
  echo -e "Created symlink \033[1;36m$neovimHomePathSource/* -> $neovimHomePath\e[0m"
else
  # Configuration exists or is not in sync.
  response=""
  if [[ $forceOverwrite = "f" ]]
  then
    response="Y"
  fi

  if [[ $(find -L "$neovimHomePath" "$neovimHomePathSource" -printf "%P\n" | sort | uniq -d | wc -w) -eq $(find "$neovimHomePathSource" -printf "%P\n" | wc -w) ]]
  then
    # Configuration exists.
    while ! [[ $response =~ ^(Y|n|N)$ ]]
    do
      echo -e "\n$neovimHomePath/* already exists. Do you wish to overwrite it? [Y/n]"
      read response
    done
  else
    # Configuration is not in sync.
    while ! [[ $response =~ ^(Y|n|N)$ ]]
    do
      echo -e "\n$neovimHomePath/* is not in sync with $neovimHomePathSource/*. Do you wish to recreate it (recommended)? [Y/n]"
      read response
    done
  fi
  if [[ $response = "Y" ]]
  then
    find -L "$neovimHomePathSource" -maxdepth 1 -not -path "$neovimHomePathSource" -printf $neovimHomePath/ -printf '%P\n' | xargs rm -rf
    cd $neovimHomePath
    ln -s $neovimHomePathSource/* .
    echo -e "Created symlink \033[1;36m$neovimHomePathSource/* -> $neovimHomePath\e[0m"
  fi
fi
cd $initDir


# Download and install ripgrep for grep search in nvim-telescope plugin.
echo -e "\n"
echo -e "\e[7mInstalling ripgrep...\e[0m"
sudo apt-get install -y ripgrep


# User-defined aliases.
echo -e "\n"
userDefinedAliasesPath=$HOME/.bash_aliases
modifyPath $userDefinedAliasesPath \
  "ln -s $initDir/bash/bash_aliases $userDefinedAliasesPath" \
  "echo -e Created symlink \033[1;36m$initDir/bash/bash_aliases -> $userDefinedAliasesPath\e[0m"


# tmux configuration
tmuxConfigPath=$HOME/.tmux.conf
modifyPath $tmuxConfigPath \
  "ln -s $initDir/tmux/tmux.conf $tmuxConfigPath" \
  "echo -e Created symlink \033[1;36m$initDir/tmux/tmux.conf -> $tmuxConfigPath\e[0m"


# Deployment configuration for full blown linux distribution.
if ! grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
  # i3
  echo -e "\n"
  i3ParentDirPath=$HOME/.config
  i3DirPath=$HOME/.config/i3
  i3ConfigPathSource=$initDir/i3
  mkdir -p $i3ParentDirPath
  cd $i3ParentDirPath
  modifyPath $i3DirPath \
    "ln -s $i3ConfigPathSource ." \
    "echo -e Created symlink \033[1;36m$i3ConfigPathSource -> $i3DirPath\e[0m"

  cd $initDir
fi


echo -e "\n"
echo -e "\e[34mRestart the terminal for changes to take effect.\e[0m"

