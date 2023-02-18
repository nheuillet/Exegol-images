#!/bin/bash
# Author: The Exegol Project

export RED='\033[1;31m'
export BLUE='\033[1;34m'
export GREEN='\033[1;32m'
export NOCOLOR='\033[0m'


### Support functions

function colorecho () {
  echo -e "${BLUE}[EXEGOL] $*${NOCOLOR}"
}

function criticalecho () {
  echo -e "${RED}[EXEGOL ERROR] $*${NOCOLOR}" 2>&1
  exit 1
}

function criticalecho-noexit () {
  echo -e "${RED}[EXEGOL ERROR] $*${NOCOLOR}" 2>&1
}

function add-aliases() {
  colorecho "Adding aliases for: $*"
  # Removing add empty lines and the last trailing newline if any, and adding a trailing newline.
  grep -vE "^\s*$" "/root/sources/zsh/aliases.d/$*" >> /opt/.exegol_aliases
}

function add-history() {
  colorecho "Adding history commands for: $*"
  # Removing add empty lines and the last trailing newline if any, and adding a trailing newline.
  grep -vE "^\s*$" "/root/sources/zsh/history.d/$*" >> ~/.zsh_history
}

function add-test-command() {
  colorecho "Adding build pipeline test command: $*"
  echo "$*" >> "/.exegol/build_pipeline_tests/all_commands.txt"
}

function fapt() {
  colorecho "Installing apt package(s): $*"
  apt-fast install -y --no-install-recommends "$@"
}

function fapt-noexit() {
  # This function tries the same thing as fapt but doesn't exit in case something's wrong.
  # Example: a package exists in amd64 but not arm64. I didn't find a way of knowing that beforehand.
  colorecho "Installing (no-exit) apt package(s): $*"
  apt-get install -y --no-install-recommends "$*" || echo -e "${RED}[EXEGOL ERROR] Package(s) $* probably doesn't exist for architecture $(uname -m), or no installation candidate was found, or some other error...${NOCOLOR}" 2>&1
}

function fapt-history() {
    fapt "$@"
    for i in "$@"; do
        add-history "$i"
    done
}

function fapt-aliases() {
    fapt "$@"
    for i in "$@"; do
        add-aliases "$i"
    done
}

function fapt-history-aliases() {
    fapt "$@"
    for i in "$@"; do
        add-history "$i"
        add-aliases "$i"
    done
}
