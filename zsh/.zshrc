# pyenv
eval "$(pyenv init -)"

# starship 
eval "$(starship init zsh)"

# aliases
alias gc="git commit"
alias gs="git status"
alias ga="git add"
alias gl='git log --pretty=format:"%h%x09%an%x09%ad%x09%s"'
alias ll="ls -AlFGgh"
alias code='open -a "Visual Studio Code"' # open file or folder in VSCode

# znap (zsh plugin manager) install
[[ -r ~/plugins/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/plugins/znap
source ~/plugins/znap/znap.zsh  # Start Znap

# add zsh-autocomplete
znap source marlonrichert/zsh-autocomplete
