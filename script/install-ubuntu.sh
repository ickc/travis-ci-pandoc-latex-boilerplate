#!/usr/bin/env bash

# preparation
export DEBIAN_FRONTEND=noninteractive
# install pandoc
sudo apt-get update -qq
sudo apt-get -qq install pandoc
# install pandocfilters
sudo apt-get -qq install python-pip
pip install -U pip
sudo pip install -U pandocfilters
