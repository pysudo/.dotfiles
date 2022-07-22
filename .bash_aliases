alias vi="nvim"
alias vim="nvim"


# Open current location with windows native explorer.
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
  alias open='explorer.exe'
fi
