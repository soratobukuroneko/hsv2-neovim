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
mkdir -p ~/.config
mv -f ~/.config/nvim ~/.config/nvim-`date "+%Y%m%d%H%M%S"`
ln -vs "$SRC_DIR/conf/nvim" ~/.config/
cd ~/.local/src
git clone --depth 1 https://github.com/40huo/Patched-Fonts.git
cp Patched-Fonts/operator-mono-nerd-font/* ~/Library/Fonts/

echo "Installing dependencies"
git clone --depth 1 https://github.com/Homebrew/brew ~/.local/homebrew
eval "`~/.local/homebrew/bin/brew shellenv`"
brew update --force --quiet
chmod -R go-w "$(brew --prefix)/share/zsh"
echo 'eval "`~/.local/homebrew/bin/brew shellenv`"' >> ~/.zshrc
brew install fd bat glow lua-language-server

#echo "Installing lua-language-server"
#mkdir ~/.local/lua-language-server
#curl -L --silent https://github.com/sumneko/lua-language-server/releases/download/3.2.2/lua-language-server-3.2.2-darwin-x64.tar.gz -o /tmp/lua-language-server.tar.gz
#tar xf /tmp/lua-language-server.tar.gz -C ~/.local/lua-language-server
#echo 'export PATH="$HOME/.local/lua-language-server/bin:$PATH"' >> ~/.zshrc

echo "Install Oh My Zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo
echo "Source your ~/.zshrc or open a new shell"
echo "You need to set your terminal font to 'Operator Mono Lig'"
