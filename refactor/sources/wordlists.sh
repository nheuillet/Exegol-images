#!/bin/bash
# Author: The Exegol Project

source common.sh

# Package dedicated to the installation of wordlists and tools like wl generators
function package_wordlists() {
  install_crunch                  # Wordlist generator
  install_seclists                # Awesome wordlists
  install_cewl                    # Wordlist generator FIXME
  install_cupp                    # User password profiler
  install_pass_station            # Default credentials database
  install_username-anarchy        # Generate possible usernames based on heuristics
  install_genusernames
}

function package_wordlists_configure() {
  configure_crunch
  configure_rockyou
  configure_seclists
  configure_cupp
  configure_genusernames
}

function install_crunch() {
  colorecho "Installing crunch"
  fapt-deps crunch
  add-test-command "crunch --help"
}

function configure_crunch() {
  colorecho "Configuring crunch"
  dpkg -i /opt/packages/crunch*
}

function install_seclists() {
  colorecho "Installing Seclists"
  git -C /opt clone --single-branch --branch master --depth 1 https://github.com/danielmiessler/SecLists.git seclists
  cd /opt/seclists
  rm -r LICENSE .git* CONTRIBUT* .bin
  add-test-command "[ -d '/opt/seclists/Discovery/' ]"
}

function configure_seclists() {
  colorecho "Configuring seclists"
  ln -v -s /opt/seclists /usr/share/seclists
}

function configure_rockyou() {
  colorecho "Configuring rockyou"
  mkdir /usr/share/wordlists
  tar -xvf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/wordlists/
  ln -s /usr/share/seclists/ /usr/share/wordlists/seclists
  add-test-command "[ -f '/usr/share/wordlists/rockyou.txt' ]"
}

function install_cewl() {
    colorecho "Installing cewl"
    # FIXME
    # if [[ $(uname -m) = 'x86_64' ]]
    # then
    #     fapt cewl
    # elif [[ $(uname -m) = 'aarch64' ]]
    # then
    #     git -C /opt/tools/ clone https://github.com/digininja/CeWL.git
    #     cd /opt/tools/CeWL || exit
    #     gem install bundler
    #     bundle install
    #     chmod u+x ./cewl.rb
    #     add-aliases cewl
    # else
    #     criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
    # fi
    # add-history cewl
    add-test-command "cewl --help"
}

function install_cupp() {
    colorecho "Installing cupp"
    fapt-deps cupp
    add-test-command "cupp --help"
}

function configure_cupp() {
    colorecho "Configuring cupp"
    dpkg -i /opt/packages/cupp*
}

function install_pass_station() {
    colorecho "Installing Pass Station"
    # FIX : gem venv
    #   gem install pass-station
    #   add-history pass-station
    add-test-command "pass-station --help"
}

function install_username-anarchy() {
    colorecho "Installing Username-Anarchy"
    git -C /opt/tools/ clone --depth=1 https://github.com/urbanadventurer/username-anarchy
    add-aliases username-anarchy
    add-test-command "username-anarchy --help"
}

function install_genusernames() {
    colorecho "Installing genusernames"
    mkdir -p /opt/tools/genusernames
    wget -O /opt/tools/genusernames/genusernames.function https://gitlab.com/-/snippets/2480505/raw/main/bash
    sed -i 's/genadname/genusernames/g' /opt/tools/genusernames/genusernames.function
    add-test-command "genusernames 'john doe'"
}

function configure_genusernames() {
    colorecho "Configuring genusernames"
    echo 'source /opt/tools/genusernames/genusernames.function' >> ~/.zshrc
}