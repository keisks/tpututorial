#!/usr/bin/env bash

curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
sudo apt-get install build-essential git libreadline-dev zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev
pyenv install 3.6.4
echo "wsc" > .python-version
pyenv  virtualenv 3.6.4 wsc
pip install -r requirements.txt
