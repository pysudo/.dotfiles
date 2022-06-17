alias vi="nvim"
alias vim="nvim"

# Check if system is running via WSL
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
  alias winopen='cmd.exe /C start .'
fi
