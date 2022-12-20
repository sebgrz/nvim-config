#!/bin/bash

# Download and install neovim 8
curl -LJO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
dpkg --install nvim-linux64.deb
rm nvim-linux64.deb

# Prepare neovim config
mkdir -p ~/.config/nvim
cp init.lua ~/.config/nvim/

git submodule update --init --depth 1

# Copy plugins into default plugin neovim location
LOCAL_NVIM=~/.local/share/nvim
PLUGINS_DIR=$LOCAL_NVIM/site/pack
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

# Install lsp runtimes
mkdir -p $LOCAL_NVIM/lsp-runtime

# Golang lsp
cd tools/gopls && go build -v -o gopls .
mv gopls $LOCAL_NVIM/lsp-runtime/

# Typescript & javascript
cd ../../TypeScript && npm install && npm pack
npm install --global typescript-5.0.0.tgz

cd ../yarn && npm install --force && npm run build && npm pack
npm install --global yarn-1.22.19.tgz

cd ../typescript-language-server && npm install && npm pack
npm install --global typescript-language-server-2.2.0.tgz

