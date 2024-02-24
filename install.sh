#!/bin/bash

MODE=$1

# Download and install neovim 0.10.0
install_nvim() {
	local VERSION="v0.10.0"
	local REPO="https://github.com/neovim/neovim"
	local DIR="neovim"
	echo "neovim $VERSION - installation"
	echo "install dependencies"
	apt install ninja-build gettext cmake unzip curl file -y
	rm -rf $DIR
	git clone --depth 1 --branch $VERSION $REPO $DIRG
	echo "start building"
	(cd $DIR && make CMAKE_BUILD_TYPE=RelWithDebInfo)
	echo "start packaging and installation"
	(cd $DIR/build && cpack -G DEB && dpkg -i nvim-linux64.deb)
	rm -rf $DIR
	echo "END installation"
}

prepare_config_plugins_and_lsp() {
	# Prepare neovim config
	mkdir -p ~/.config/nvim
	cp init.lua ~/.config/nvim/

	git submodule update --init --depth 1

	# Copy plugins into default plugin neovim location
	local LOCAL_NVIM=~/.local/share/nvim
	local PLUGINS_DIR=$LOCAL_NVIM/site/pack

	rm -rf $PLUGINS_DIR
	mkdir -p $PLUGINS_DIR/cmp-nvim-lsp/opt/cmp-nvim-lsp
	mkdir -p $PLUGINS_DIR/cmp-vsnip/opt/cmp-vsnip
	mkdir -p $PLUGINS_DIR/nvim-cmp/opt/nvim-cmp
	mkdir -p $PLUGINS_DIR/nvim-lspconfig/opt/nvim-lspconfig
	mkdir -p $PLUGINS_DIR/nvim-plenary/opt/nvim-plenary
	mkdir -p $PLUGINS_DIR/nvim-telescope/opt/nvim-telescope
	mkdir -p $PLUGINS_DIR/nvim-tree/opt/nvim-tree
	mkdir -p $PLUGINS_DIR/tokyonight/opt/tokyonight
	mkdir -p $PLUGINS_DIR/vim-polyglot/opt/vim-polyglot
	mkdir -p $PLUGINS_DIR/vim-vsnip/opt/vim-vsnip

	cp -r cmp-nvim-lsp/* $PLUGINS_DIR/cmp-nvim-lsp/opt/cmp-nvim-lsp/
	cp -r cmp-vsnip/* $PLUGINS_DIR/cmp-vsnip/opt/cmp-vsnip/
	cp -r nvim-cmp/* $PLUGINS_DIR/nvim-cmp/opt/nvim-cmp/
	cp -r nvim-lspconfig/* $PLUGINS_DIR/nvim-lspconfig/opt/nvim-lspconfig/
	cp -r plenary.nvim/* $PLUGINS_DIR/nvim-plenary/opt/nvim-plenary/
	cp -r telescope.nvim/* $PLUGINS_DIR/nvim-telescope/opt/nvim-telescope/
	cp -r nvim-tree.lua/* $PLUGINS_DIR/nvim-tree/opt/nvim-tree/
	cp -r tokyonight.nvim/* $PLUGINS_DIR/tokyonight/opt/tokyonight/
	cp -r vim-polyglot/* $PLUGINS_DIR/vim-polyglot/opt/vim-polyglot/
	cp -r vim-vsnip/* $PLUGINS_DIR/vim-vsnip/opt/vim-vsnip/

	# Setup yarn
	corepack enable
	corepack prepare yarn@3.5.0 --activate

	# Install lsp runtimes
	rm -rf $LOCAL_NVIM/lsp-runtime
	mkdir -p $LOCAL_NVIM/lsp-runtime

	# Typescript & javascript
	echo "Install typescript and javascript LSP"
	export TS_DIR=TypeScript
	(cd $TS_DIR && npm install && npm pack)
	npm install --global ./$TS_DIR/typescript-5.0.4.tgz

	export TS_LSP_DIR=typescript-language-server
	(cd $TS_LSP_DIR && yarn && yarn build && yarn pack)
	npm install --global ./$TS_LSP_DIR/package.tgz

	# Golang lsp
	echo "Install golang LSP"
	(cd tools/gopls && go build -v -o gopls .)
	mv tools/gopls/gopls $LOCAL_NVIM/lsp-runtime/

	# Rust
	echo "Install rust LSP"
	export RUST_DIR=rust-analyzer
	(cd $RUST_DIR && cargo build --release)
	mv $RUST_DIR/target/release/rust-analyzer $LOCAL_NVIM/lsp-runtime/

	# CSS
	echo "Install css LSP"
	curl -L https://github.com/sebgrz/language-servers/releases/latest/download/css-language-server-0.0.21.tgz --output css-language-server.tgz
	npm install --global css-language-server.tgz
	rm css-language-server
}

install_dependencies() {
	# NODE
	curl -fsSL https://deb.nodesource.com/setup_21.x | bash - &&\
	apt install -y nodejs
	
	# GOLANG
	curl -L -O https://go.dev/dl/go1.22.3.linux-amd64.tar.gz
	rm -rf $HOME/.local/go && tar -C $HOME/.local/ -xzf go1.22.3.linux-amd64.tar.gz
	echo 'export PATH=$PATH:$HOME/.local/go/bin' >> $HOME/.profile
	 
	# RUST
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

case $MODE in
	"neovim"*)
		install_nvim
		;;
	"config"*)
		prepare_config_plugins_and_lsp
		;;
	"dep"*) # DEPENDENCIES
		install_dependencies
		;;
esac
exit 1

