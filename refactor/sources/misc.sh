#!/bin/bash
# Author: The Exegol Project

source common.sh

# Package dedicated to offensive miscellaneous tools
function package_misc() {
    set_go_env
    install_go_tool "github.com/patrickhener/goshs@latest" goshs "goshs -v" history # Web uploader/downloader page
    install_searchsploit            # Exploitdb local search engine
    install_pipx_git_tool "git+https://github.com/ShutdownRepo/shellerator" shellerator "shellerator --help" history # Reverse shell generator
    install_pipx_git_tool "git+https://github.com/ShutdownRepo/uberfile" uberfile "uberfile --help" # file uploader/downloader commands generator
    install_pipx_git_tool "git+https://github.com/Orange-Cyberdefense/arsenal" arsenal "arsenal --version" # Cheatsheets tool
    install_trilium                 # notes taking tool
    install_ngrok                   # expose a local development server to the Internet
    install_pipx_tool whatportis "whatportis --version" history # Search default port number
}

function package_misc_configure() {
    install_apt_tool rlwrap "rlwrap --version" history # Reverse shell utility
    install_apt_tool exiftool "exiftool /usr/share/pixmaps/debian-logo.png" # Meta information reader/writer
    install_apt_tool imagemagick "convert -version" # Copy, modify, and distribute image
    install_apt_tool ascii "ascii -v" # The ascii table in the shell
    configure_searchsploit
    configure_trilium
    configure_whatportis
}

function install_searchsploit() {
    colorecho "Installing searchsploit"
    git -C /opt/tools/ clone https://gitlab.com/exploit-database/exploitdb
    add-test-command "searchsploit --help; searchsploit --help |& grep 'You can use any number of search terms'"
}

function configure_searchsploit() {
    colorecho "Configuring Searchsploit"
    ln -sf /opt/tools/exploitdb/searchsploit /opt/tools/bin/searchsploit
    cp -n /opt/tools/exploitdb/.searchsploit_rc ~/
    sed -i 's/\(.*[pP]aper.*\)/#\1/' ~/.searchsploit_rc
    sed -i 's/opt\/exploitdb/opt\/tools\/exploitdb/' ~/.searchsploit_rc
    searchsploit -u
}

function install_trilium() {
    colorecho "Installing Trilium (building from sources)"
    git -C /opt/tools/ clone -b stable https://github.com/zadam/trilium.git
    cd /opt/tools/trilium
    add-aliases trilium
    add-test-command "trilium-start;sleep 5;trilium-stop"
}

function configure_trilium() {
    colorecho "Configuring trilium"
    fapt libpng-dev nasm libx11-doc libxcb-doc libx11-dev libxkbfile-dev

    # the npm install needs to be executed in the zsh context where nvm is used to set the Node version to be used.
    zsh -c "source ~/.zshrc && cd /opt/tools/trilium && nvm install 16 && nvm use 16 && npm install && npm rebuild"
    mkdir -p /root/.local/share/trilium-data
    cp -v /root/sources/trilium/* /root/.local/share/trilium-data
}

function install_ngrok() {
    colorecho "Installing ngrok"
    if [[ $(uname -m) = 'x86_64' ]]
    then
        wget -O /tmp/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
    elif [[ $(uname -m) = 'aarch64' ]]
    then
        wget -O /tmp/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip
    elif [[ $(uname -m) = 'armv7l' ]]
    then
        wget -O /tmp/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
    else
        criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
    fi
    unzip -d /opt/tools/bin/ /tmp/ngrok.zip
    add-history ngrok
    add-test-command "ngrok version"
}

function configure_whatportis() {
    colorecho "Configuring whatportis"
    echo y | whatportis --update
}