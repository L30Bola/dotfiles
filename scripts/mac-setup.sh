#!/usr/bin/env bash

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install pipx

pipx install --include-deps ansible
pipx install ansible-lint
pipx install ansible-navigator

pipx inject ansible passlib
pipx inject --include-apps ansible ansible-lint
pipx inject --include-apps ansible ansible-navigator
pipx inject --include-apps ansible-lint ansible
pipx inject --include-apps ansible-lint ansible-navigator