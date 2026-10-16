#!/usr/bin/env bash

set -euo pipefail

if ! command -v brew > /dev/null 2>&1; then
  homebrew_installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
  NONINTERACTIVE=1 /bin/bash -c "$homebrew_installer"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

brew install pipx python@3.13
ansible_python="$(brew --prefix python@3.13)/bin/python3.13"

# Each CLI owns its entry point and dependencies. Expose Ansible's CLI through its core dependency.
pipx install --force --upgrade --python "$ansible_python" --include-deps ansible
pipx inject ansible passlib
pipx install --force --upgrade --python "$ansible_python" ansible-lint
# Supply the collections to lint without exposing another set of Ansible commands.
pipx inject --force ansible-lint ansible
pipx install --force --upgrade --python "$ansible_python" ansible-navigator
