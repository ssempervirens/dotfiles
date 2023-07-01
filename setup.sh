# check if Homebrew is installed and install if not
if test ! $(which brew); then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install VSCode, iTerm2, pipenv if not exists
if test ! $(which code); then
    echo "Installing VSCode..."
    brew install --cask visual-studio-code
fi


if test ! $(which iterm); then
    echo "Installing iTerm2..."
    brew install --cask iterm2
fi

if test ! $(which pipenv); then
    echo "Installing pipenv..."
    brew install pipenv
fi

# install pip and jupyter notebooks if not exists
if test ! $(which pip); then
    echo "Installing pip..."
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
fi

if test ! $(which jupyter); then
    echo "Installing Jupyter..."
    python -m pip install jupyter
    python -m ipykernel install --user
fi

# install Rust if not exists
if test ! $(which rustc); then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# check if tree is installed and install if not
if test ! $(which tree); then
    echo "Installing tree..."
    brew install tree
fi

DOTFILES_DIRECTORY=~/dotfiles
VIMRC_FILE="$DOTFILES_DIRECTORY/vim/.vimrc"
ZSHRC_FILE="$DOTFILES_DIRECTORY/zsh/.zshrc"
STARSHIP_FILE="$DOTFILES_DIRECTORY/config/starship.toml"

# function to create symlink
create_symlink() {
    if [ -L $2 ]; then
        echo "Removing existing symlink $2"
        rm $2
    elif [ -e $2 ]; then
        echo "Existing file found at $2, renaming to $2.bak"
        mv $2 $2.bak
    fi

    echo "Creating new symlink $2"
    ln -s $1 $2
}

# create symlinks
create_symlink $VIMRC_FILE ~/.vimrc
create_symlink $ZSHRC_FILE ~/.zshrc
create_symlink $STARSHIP_FILE ~/.config/starship.toml

echo "Symlink creation complete"

# pyenv python
# set desired python version  
PYTHON_VERSION="3.8.10"

# check if pyenv is installed
command -v pyenv >/dev/null 2>&1 || { echo >&2 "Pyenv is not installed. Installing it now..."; curl https://pyenv.run | bash; }

# make sure .zshrc has necessary pyenv configuration
if ! grep -q 'pyenv init' ~/.zshrc; then
   echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
   echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
   echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init --path)"\nfi' >> ~/.zshrc
   echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
   source ~/.zshrc
fi

# check if the desired Python version is installed via pyenv
if ! pyenv versions --bare | grep -q $PYTHON_VERSION; then
    echo "Python $PYTHON_VERSION not found in pyenv versions. Installing now..."
    pyenv install $PYTHON_VERSION
fi

# set the desired Python version as the global version
pyenv global $PYTHON_VERSION

# custom terminal font
TARGET_FONT_DIR="/Library/Fonts"

# check if font source directory exists
if [ -d "$HOME/dotfiles/iterm2/JetBrainsMono" ]; then
    echo "Font source directory found. Proceeding with copying files..."
else
    echo "Font source directory not found. Please check the path and try again."
    exit 1
fi

# copy JetBrainsMono fonts to target directory
sudo cp -R "$HOME/dotfiles/iterm2/JetBrainsMono/*" "$TARGET_FONT_DIR"

# generate SSH key pair if not exists 
SSH_DIR="$HOME/.ssh"
SSH_KEY="$SSH_DIR/id_ed25519"

if [ ! -f "$SSH_KEY" ]; then
    echo "SSH key not found. Generating a new one..."
    ssh-keygen -t ed25519 -C "camille@sempervirens.io"
else
    echo "SSH key already exists."
fi