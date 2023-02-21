#!/bin/bash
# Author: The Exegol Project

source common.sh

# Package dedicated to offline cracking/bruteforcing tools
function package_cracking() {
    install_john                    # Password cracker
    install_pipx_tool name-that-hash "nth --help" history # Name-That-Hash, the hash identifier tool
}

function package_cracking_configure() {
    configure_apt_tools
    configure_john
}

function configure_apt_tools() {
    install_apt_tool hashcat "hashcat --help" history # Password cracker
    install_apt_tool fcrackzip "fcrackzip --help" history # Zip cracker
    install_apt_tool pdfcrack "pdfcrack --version" # PDF cracker
    install_apt_tool bruteforce-luks "bruteforce-luks -h |& grep 'Print progress info'" # Find the password of a LUKS encrypted volume
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