DOTFILES_DIRECTORY=~/dotfiles
VIMRC_FILE="$DOTFILES_DIRECTORY/vim/.vimrc"
ZSHRC_FILE="$DOTFILES_DIRECTORY/zsh/.zshrc"
STARSHIP_FILE="$DOTFILES_DIRECTORY/config/starship.toml"

# Function to create symlink
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

# Create symlinks
create_symlink $VIMRC_FILE ~/.vimrc
create_symlink $ZSHRC_FILE ~/.zshrc
create_symlink $STARSHIP_FILE ~/.config/starship.toml

echo "Symlink creation complete"
