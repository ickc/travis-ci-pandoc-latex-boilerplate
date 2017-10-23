#!/usr/bin/env bash

# install Xcode
xcode-select --install
sudo xcodebuild -license accept
# install pandoc
curl -Lo /tmp/pandoc-1.17.2-osx.pkg https://github.com/jgm/pandoc/releases/download/1.17.2/pandoc-1.17.2-osx.pkg
sudo installer -pkg "/tmp/pandoc-1.17.2-osx.pkg" -target /
rm /tmp/pandoc-1.17.2-osx.pkg
# install pandocfilters
sudo easy_install pandocfilters
