#!/bin/bash
# Author: The Exegol Project

export GEM_HOME=/root/.gem

# Package dedicated to SAST and DAST tools
function package_code_analysis() {
  install_vulny-code-static-analysis
  install_brakeman		            # Checks Ruby on Rails applications for security vulnerabilities
  install_semgrep                 # Static analysis engine for finding bugs and vulnerabilities
}

function install_vulny-code-static-analysis() {
  colorecho "Installing Vulny Code Static Analysis"
  git -C /opt/tools/ clone --depth=1 https://github.com/swisskyrepo/Vulny-Code-Static-Analysis
  add-aliases vulny-code-static-analysis
  add-test-command "vulny-code-static-analysis --help"
}

function install_brakeman() {
  colorecho "Installing Brakeman"
  git -C /opt/tools clone --depth=1 https://github.com/presidentbeef/brakeman
  cd /opt/tools/brakeman
  bundle install
  # /opt/tools/brakeman/bin/brakeman
  add-history brakeman 
  add-test-command "brakeman --help"
}

function install_semgrep() {
  colorecho "Installing semgrep"
  python3 -m pipx install semgrep
  add-history semgrep
  add-test-command "semgrep --help"
}