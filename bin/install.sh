#!/bin/bash

# install latest unstable nix
nix=$(curl -s https://api.github.com/repos/numtide/nix-unstable-installer/releases/latest | jq -r '.assets[0] | .browser_download_url')
sh <(curl -L $nix)

# configure shit