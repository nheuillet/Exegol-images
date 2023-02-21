#!/bin/bash
# Author: The Exegol Project

source common.sh

# Package dedicated to offline cracking/bruteforcing tools
function package_cracking() {
  install_hashcat                 # Password cracker
  install_john                    # Password cracker
  install_fcrackzip               # Zip cracker
  install_pdfcrack                # PDF cracker
  install_bruteforce-luks         # Find the password of a LUKS encrypted volume
  install_pipx_tool name-that-hash "nth --help" history # Name-That-Hash, the hash identifier tool
}

function package_cracking_configure() {
   configure_john
   configure_fcrackzip
   configure_pdfcrack
   configure_bruteforce-luks
}

function install_hashcat() {
    colorecho "Installing hashcat"
    add-test-command "wget -O /tmp/duck.png https://play-lh.googleusercontent.com/A6y8kFPu6iiFg7RSkGxyNspjOBmeaD3oAOip5dqQvXASnZp-Vg65jigJJLHr5mOEOryx && exiftool /tmp/duck.png && rm /tmp/duck.png"
    
    # Not works
    # mkdir /opt/tools/hashcat
    # wget -O /opt/tools/hashcat/hashcat.7z https://hashcat.net/files/hashcat-6.2.5.7z
    # cd /opt/tools/hashcat
    # 7z x hashcat.7z

    # FIXME : 29 deps
    # fapt hashcat
    # add-history hashcat
    add-test-command "hashcat --help"
}

function install_john() {
    colorecho "Installing john the ripper"
    git -C /opt/tools/ clone --depth 1 https://github.com/openwall/john
    add-aliases john-the-ripper
    add-history john-the-ripper
    add-test-command "john --help"
}

function configure_john() {
    cd /opt/tools/john/src
    ./configure && make
}

function install_fcrackzip() {
    colorecho "Installing fcrackzip"
    fapt-deps fcrackzip
    add-history fcrackzip
    add-test-command fcrackzip --help
}

function configure_fcrackzip() {
    colorecho "Configuring fcrackzip"
    dpkg -i /opt/packages/fcrackzip*
}

function install_pdfcrack() {
    colorecho "Installing pdfcrack"
    fapt-deps pdfcrack
    add-test-command "pdfcrack --version"
}

function configure_pdfcrack() {
    colorecho "Configuring pdfcrack"
    dpkg -i /opt/packages/pdfcrack*
}

function install_bruteforce-luks() {
  colorecho "Installing bruteforce-luks"
  fapt-deps bruteforce-luks
  add-test-command "bruteforce-luks -h |& grep 'Print progress info'"
}

function configure_bruteforce-luks() {
    colorecho "Configuring bruteforce-luks"
    dpkg -i /opt/packages/bruteforce-luks*
}