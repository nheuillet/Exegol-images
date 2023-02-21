#!/bin/bash
# Author: The Exegol Project

source common.sh

# Package dedicated to offensive miscellaneous tools
function package_misc() {
    set_go_env
    install_go_tool "github.com/patrickhener/goshs@latest" goshs "goshs -v" history # Web uploader/downloader page
    install_searchsploit            # Exploitdb local search engine
    install_rlwrap                  # Reverse shell utility
    install_pipx_git_tool "git+https://github.com/ShutdownRepo/shellerator" shellerator "shellerator --help" history # Reverse shell generator
    install_pipx_git_tool "git+https://github.com/ShutdownRepo/uberfile" uberfile "uberfile --help" # file uploader/downloader commands generator
    install_pipx_git_tool "https://github.com/Orange-Cyberdefense/arsenal" arsenal "arsenal --version" # Cheatsheets tool
    install_trilium                 # notes taking tool
    install_exiftool                # Meta information reader/writer
    install_imagemagick             # Copy, modify, and distribute image
    install_ngrok                   # expose a local development server to the Internet
    install_pipx_tool whatportis "whatportis --version" history # Search default port number
    install_ascii                   # The ascii table in the shell
}

function package_misc_configure() {
    configure_searchsploit
    configure_rlwrap
    configure_trilium
    configure_exiftool
    configure_whatportis
    configure_ascii
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

function install_rlwrap() {
    colorecho "Installing rlwrap"
    fapt-deps rlwrap
    add-history rlwrap
    add-test-command "rlwrap --version"
}

function configure_rlwrap() {
    colorecho "Configuring rlwrap"
    dpkg -i /opt/packages/rlwrap*
}

function install_trilium() {
    colorecho "Installing Trilium (building from sources)"
    # fapt libpng-dev nasm libx11-doc libxcb-doc libx11-dev libxkbfile-dev
    # git -C /opt/tools/ clone -b stable https://github.com/zadam/trilium.git
    # cd /opt/tools/trilium || exit
    # # the npm install needs to be executed in the zsh context where nvm is used to set the Node version to be used.
    # zsh -c "source ~/.zshrc && cd /opt/tools/trilium && nvm install 16 && nvm use 16 && npm install && npm rebuild"
    # mkdir -p /root/.local/share/trilium-data
    # cp -v /root/sources/trilium/* /root/.local/share/trilium-data
    # add-aliases trilium
    # # Start the trilium, sleep for 3 sec, attempt to stop it
    # # Stop command will fail if trilium isn't running
    add-test-command "trilium-start;sleep 5;trilium-stop"

    # Deps too large :/
}

function configure_trilium() {
    colorecho "Configuring trilium"
    # dpkg -i /opt/packages/libpng-dev*
}

function install_exiftool() {
    colorecho "Installing exiftool"
    fapt exiftool
    cp $(which exiftool) /opt/tools/bin/
    add-test-command "wget -O /tmp/duck.png https://play-lh.googleusercontent.com/A6y8kFPu6iiFg7RSkGxyNspjOBmeaD3oAOip5dqQvXASnZp-Vg65jigJJLHr5mOEOryx && exiftool /tmp/duck.png && rm /tmp/duck.png"
}

function install_imagemagick() {
    colorecho "Installing imagemagick"
    # fapt imagemagick
    add-test-command "convert -version"
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

function install_ascii() {
    colorecho "Installing ascii"
    fapt-deps ascii
    add-test-command "ascii -v"
}

function configure_ascii() {
    colorecho "Configuring ascii"
    dpkg -i /opt/packages/ascii*
}