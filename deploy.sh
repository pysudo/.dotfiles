#!/bin/sh

if [ $(uname -s) == "Darwin" ] # TODO: check if mac OS.
then
  pkgMgr="brew install"
else
  pkgMgr="sudo apt install -y"
fi

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

  if ! checkPath $path
  then
    executeCommandList "$@"
    return 0
  fi

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


if [ $(uname -s) == "Darwin" ]
then
  brew update && brew upgrade
  eval $pkgMgr "findutils"
  find() { # Alias 'find' to 'gfind' for this script.
    gfind $@
  }


else
  sudo apt update && sudo apt -y upgrade
fi
echo -e "\n"
echo -e "\x1B[7mPre-installing additional dependencies...\x1B[0m"
eval $pkgMgr "curl"
eval $pkgMgr "python3"
eval $pkgMgr "python3-pip"
python3 -m pip install --user --upgrade pynvim # Neovim
eval $pkgMgr "tmux"
eval $pkgMgr "ripgrep" # For nvim-telescope
eval $pkgMgr "luarocks"
if ! uname -a | grep -qEi "(Microsoft|WSL|Darwin)"
then
  sudo apt install i3 -y
  sudo apt install xclip -y
fi


# Download and install neovim.
echo -e "\n"
echo -e "\x1B[7mInstalling Neovim...\x1B[0m"
if [ $(uname -s) == "Linux" ]
then
  sudo apt install -y software-properties-common # add-apt-repository for configuring ppa
  if ! [ "$(ls /etc/apt/sources.list.d/neovim-ppa-ubuntu-unstable-*.list 2> /dev/null | wc -l)" -eq "1" ]; then
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update && sudo apt -y upgrade
  fi
fi

if ! [ -f /usr/bin/nvim ]
then
  eval $pkgMgr "neovim"
fi


# Install nvm and Node
echo -e "\n"
echo -e "\x1B[7mInstalling nvm...\x1B[0m"
nvmVersion=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/nvm-sh/nvm/releases/latest | awk -F "/" '{print $NF}')
nvmPath=$HOME/.nvm
modifyPath $nvmPath
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$nvmVersion/install.sh | bash

if [ $(uname -s) == "Darwin" ]; then
  source $HOME/.bash_profile
else
  source $HOME/.bashrc
fi
if [[ -d $HOME/.nvm && -f $HOME/.nvm/nvm.sh ]]
then
  source $HOME/.nvm/nvm.sh
fi

if command -v nvm
then
  echo -e "\n"
  echo -e "\x1B[7mInstalling node...\x1B[0m"
  nvm install --lts
  nvm use node # Switch to default node version.

  # Javascript debug adapter and configuration for nvim-dap
  echo -e "\n"
  echo -e "\x1B[7mInstalling and configuring Javascript/Typescript debug adapter...\x1B[0m"
  debuggerReleaseVersion=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/microsoft/vscode-js-debug/releases/latest | awk -F "/" '{print $NF}')
  debuggerTarFile="js-debug-dap-$debuggerReleaseVersion.tar.gz"
  debuggerFileName="js-debug"
  cd $HOME && mkdir -p ./dev/microsoft && cd ./dev/microsoft
  modifyPath "$PWD/$debuggerFileName" \
    "wget https://github.com/microsoft/vscode-js-debug/releases/download/$debuggerReleaseVersion/$debuggerTarFile" \
    "tar -xzf $debuggerTarFile" \
    "rm -rf $debuggerTarFile" \
    "luarocks install --local dkjson" # To parse package.json file.
else
  echo -e "\x1B[31mnvm could not be found. Skipping node installation.\x1B[0m"
  echo -e "\x1B[31mnode could not be installed. Skipping vscode-js-debug installation.\x1B[0m"
fi


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
  echo -e "Created symlink \x1B[1;36m$neovimHomePathSource/* -> $neovimHomePath\x1B[0m"
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
    echo -e "Created symlink \x1B[1;36m$neovimHomePathSource/* -> $neovimHomePath\x1B[0m"
  fi
fi
cd $initDir

<< TODO
  Instead for running post-update hooks for every 'VimEnter' event, execute it only once during deployment.
  Current workaround involves autocmds inside 'post-update-hook' files within the 'after' directory.
TODO
# Install extensions for neovim using plugin manager.
nvim  -c "autocmd User LazySync quitall" -c  'lua require("lazy").sync()'


if ! uname -a | grep -qEi "(Microsoft|WSL|Darwin)"
then
  # i3
  echo -e "\n"
  i3ParentDirPath=$HOME/.config
  i3DirPath=$HOME/.config/i3
  i3ConfigPathSource=$initDir/i3
  mkdir -p $i3ParentDirPath
  cd $i3ParentDirPath
  modifyPath $i3DirPath \
    "ln -s $i3ConfigPathSource ." \
    "echo -e Created symlink \x1B[1;36m$i3ConfigPathSource -> $i3DirPath\x1B[0m"

  cd $initDir
fi


# tmux configuration
echo -e "\n"
tmuxConfigPath=$HOME/.tmux.conf
modifyPath $tmuxConfigPath \
  "ln -s $initDir/tmux/tmux.conf $tmuxConfigPath" \
  "echo -e Created symlink \x1B[1;36m$initDir/tmux/tmux.conf -> $tmuxConfigPath\x1B[0m"

# Seperate custom bash configs.
echo -e "\n"
bashConfigPath=$HOME/.bashrc_local
modifyPath $bashConfigPath \
  "ln -s $initDir/bash/bashrc_local $bashConfigPath" \
  "echo -e Created symlink \x1B[1;36m$initDir/bash/bashrc_local -> $bashConfigPath\x1B[0m"

if [ $(uname -s) == "Darwin" ]
then
  configName=".bash_profile"
else
  configName=".bashrc"
fi
if [ -f "$HOME/$configName" ]; then
  echo -e "\n# Custom bash configuration." >> $HOME/$configName
  echo -e "if [ -f \"$HOME/.bashrc_local\" ]; then" >> $HOME/$configName
  echo -e "\x20\x20source $HOME/.bashrc_local" >> $HOME/$configName
  echo "fi" >> $HOME/$configName
fi
chmod u+x $HOME/.bashrc_local

# Debian specific display manager remains in the background for i3wm.
# https://github.com/sddm/sddm/issues/830
# TODO: Narrow down to a specific display manager instead of an entire debian distro.
if [[ -f "/etc/debian_version" && -n $DISPLAY ]]; then # $DISPLAY should not be a tty.
  echo -e "\nxsetroot -solid black " >> $HOME/.profile
fi


echo -e "\n"
echo -e "\x1B[34mRestart the terminal for changes to take effect.\x1B[0m"

