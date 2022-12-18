#!/bin/bash

# Download and install neovim 8
curl -LJO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
dpkg --install nvim-linux64.deb
rm nvim-linux64.deb

# Prepare neovim config
mkdir -p ~/.config/nvim
cp init.lua ~/.config/nvim/

git submodule update --init

# Copy plugins into default plugin neovim location
PLUGINS_DIR=~/.local/share/nvim/site/pack
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
