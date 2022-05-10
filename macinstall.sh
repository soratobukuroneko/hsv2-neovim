#!/bin/zsh

INSTALL_DIR="$HOME/.local/nvim-brew"

git clone --depth 1 https://github.com/Homebrew/brew "$INSTALL_DIR"
eval "`$INSTALL_DIR/bin/brew shellenv`"
brew update --force --quiet
chmod -R go-w "`brew --prefix`/share/zsh"
brew install fd bat glow lua-language-server neovim sqlite node ripgrep
mkdir -p /tmp/font_install
cd /tmp/font_install
curl -L "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/VictorMono.zip" -o victormono.zip
unzip victormono.zip
rm *Windows*
mv *.ttf ~/Library/Fonts/
rm -rf "$INSTALL_DIR/Library"
rm -f "$INSTALL_DIR/bin/brew"
echo "`$INSTALL_DIR/bin/brew shellenv | grep --color=no PATH`" >> ~/.zshrc
echo "alias vim=nvim" >> ~/.zshrc

echo "Install Neovim python bindings"
pip3 install --user pynvim

echo "Installing Neovim configuration"
mkdir -p ~/.local/src
cd ~/.local/src
git clone --depth 1 https://git.disroot.org/soratobuneko/neovim-conf.git
cd neovim-conf
SRC_DIR="$PWD"
mkdir -p ~/.config
mv -f ~/.config/nvim ~/.config/nvim-`date "+%Y%m%d%H%M%S"`
ln -vs "$SRC_DIR/conf/nvim" ~/.config/

echo "Install Oh My Zsh"
sh -c "`curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh`"

echo
echo "Source your ~/.zshrc or open a new shell"
echo "You need to set your terminal font to 'Victor Mono Nerd Font'"
