#!/usr/bin/env bash

# install MacTeX
wget http://mirror.ctan.org/systems/mac/mactex/BasicTeX.pkg -O "/tmp/BasicTeX.pkg"
sudo installer -pkg "/tmp/BasicTeX.pkg" -target /
rm /tmp/BasicTeX.pkg
# TexLive manager
sudo tlmgr update --self
sudo tlmgr install inconsolata upquote courier courier-scaled helvetic latexmk physics cancel siunitx placeins
