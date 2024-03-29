#!/usr/bin/env bash

set -euo pipefail

version=2.10.3

if [[ $# -eq 1 ]]; then
  version="$1"
elif [[ $# -ne 0 ]]; then
  script=$(basename "$0")
  echo "usage: $script [version (default $version)]" >&2
  exit 2
fi

# shellcheck disable=SC2046
nix=$(readlink -f $(which nix))
# shellcheck disable=SC2046,SC2086
nix_pkg=$(dirname $(dirname $nix))
install_cmd="
  $nix profile remove $nix_pkg &&
    $nix profile install --verbose nix/${version}
"

if [[ $(uname) == Darwin ]]; then
  sudo -i sh -c "
    $install_cmd &&
      launchctl remove org.nixos.nix-daemon &&
      launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
  "
else
  if [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    echo Multi-user upgrade
    sudo -i sh -c "
      $install_cmd nixpkgs#cacert &&
        systemctl daemon-reload &&
        systemctl restart nix-daemon
    "
  else
    echo Single-user upgrade
    $install_cmd 'nixpkgs#cacert'
  fi
fi
