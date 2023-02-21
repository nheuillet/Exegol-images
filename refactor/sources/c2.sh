#!/bin/bash
# Author: The Exegol Project

source common.sh

# Package dedicated to command & control frameworks
function package_c2() {
    # install_empire                # Exploit framework FIXME
    # install_starkiller            # GUI for Empire, commenting while Empire install is not fixed
    install_metasploit              # Offensive framework
    install_routersploit            # Exploitation Framework for Embedded Devices
    install_pipx_tool pwncat "pwncat-cs --version" # netcat and rlwrap on steroids to handle revshells, automates a few things too
}

function package_c2_configure() {
    configure_metasploit
}

function install_metasploit() {
    colorecho "Installing Metasploit"
    mkdir /opt/tools/metasploit
    cd /opt/tools/metasploit
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall
    add-test-command "msfconsole --version"
}

function configure_metasploit() {
    cd /opt/tools/metasploit
    ./msfinstall
}

function install_routersploit() {
    colorecho "Installing RouterSploit"
    python3 -m pipx install routersploit
    python3 -m pipx inject routersploit colorama
    add-aliases routersploit
    add-test-command "rsf --help"
}