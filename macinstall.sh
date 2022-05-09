#!/bin/zsh

echo "Install Neovim"
curl -L --silent https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz -o /tmp/nvim.tar.gz
mkdir -vp ~/.local/nvim
tar xf /tmp/nvim.tar.gz --strip-components 1 -C ~/.local/nvim
echo "Install Node"
curl -L --silent https://nodejs.org/dist/v18.1.0/node-v18.1.0-darwin-x64.tar.xz -o /tmp/node.tar.xz
mkdir -vp ~/.local/nodejs
tar xf /tmp/node.tar.xz --strip-components 1 -C ~/.local/nodejs
echo 'export PATH="$HOME/.local/nvim/bin:$HOME/.local/nodejs/bin:$PATH"' >> ~/.zshrc
echo 'alias vim=nvim' >> ~/.zshrc
source ~/.zshrc

echo "Install Neovim python bindings"
pip3 install --user pynvim

echo "Installing Neovim configuration and fonts"
mkdir -p ~/.local/src
cd ~/.local/src
git clone --depth 1 https://git.disroot.org/soratobuneko/neovim-conf.git
cd neovim-conf
SRC_DIR="$PWD"
git submodule init
git submodule update
cp -f fonts/Operator-Mono/Fonts/* fonts/operator-mono-lig/original/
pip3 install --user fonttools
cd fonts/operator-mono-lig
npm install
./build.sh
cp -v build/* ~/Library/Fonts
mkdir -p ~/.config
mv -f ~/.config/nvim ~/.config/nvim-`date "+%Y%m%d%H%M%S"`
ln -vs "$SRC_DIR/conf/nvim" ~/.config/

echo "Install Oh My Zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo
echo "Source your ~/.zshrc or open a new shell"
echo "You need to set your terminal font to 'Operator Mono Lig'"
