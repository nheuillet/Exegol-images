#!/bin/bash
# Author: The Exegol Project

source common.sh

# Package dedicated to internal Active Directory tools
function package_ad() {
  bundle config path vendor/bundle

  set_go_env
  install_responder               # LLMNR, NBT-NS and MDNS poisoner
  install_pipx_tool ldapdomaindump "ldapdomaindump --help" history
  install_crackmapexec            # Network scanner
  install_pipx_tool sprayhound "sprayhound --help" history # Password spraying tool
  install_pipx_git_tool "git+https://github.com/ShutdownRepo/smartbrute" "smartbrute" "smartbrute --help" history # Password spraying tool
  install_bloodhound-py           # AD cartographer
  install_neo4j                   # Bloodhound dependency
  install_bloodhound
  install_cyperoth                # Bloodhound dependency
#  # install_mitm6_sources         # Install mitm6 from sources
  install_pipx_tool mitm6 "mitm6 --help" history # DNS server misconfiguration exploiter
  install_pipx_git_tool "git+https://github.com/aas-n/aclpwn.py" "aclpwn" "aclpwn -h" # ACL exploiter
  install_impacket                # Network protocols scripts
  install_pykek                   # AD vulnerability exploiter
  install_pipx_tool lsassy "lsassy --version" history # Credentials extracter
  install_privexchange            # Exchange exploiter
  install_ruler                   # Exchange exploiter
  install_darkarmour              # Windows AV evasion
  install_amber                   # AV evasion
  install_powershell              # Windows Powershell for Linux
  install_krbrelayx               # Kerberos unconstrained delegation abuse toolkit
  install_evilwinrm               # WinRM shell
#   install_pypykatz                # Mimikatz implementation in pure Python
#   install_enyx                    # Hosts discovery
#   install_enum4linux-ng           # Hosts enumeration
#   install_zerologon               # Exploit for zerologon cve-2020-1472
#   install_libmspack               # Library for some loosely related Microsoft compression format
#   install_windapsearch-go         # Active Directory Domain enumeration through LDAP queries
#   install_oaburl                  # Send request to the MS Exchange Autodiscover service
#   install_lnkup
#   install_samdump2                # Dumps Windows 2k/NT/XP/Vista password hashes
#   install_smbclient               # Small dynamic library that allows iOS apps to access SMB/CIFS file servers
#   install_polenum
#   install_smbmap                  # Allows users to enumerate samba share drives across an entire domain
#   install_pth-tools               # Pass the hash attack
#   install_smtp-user-enum          # SMTP user enumeration via VRFY, EXPN and RCPT
#   install_onesixtyone             # SNMP scanning
#   install_nbtscan                 # NetBIOS scanning tool
#   install_rpcbind                 # RPC scanning
#   install_gpp-decrypt             # Decrypt a given GPP encrypted string
#   install_ntlmv1-multi            # NTLMv1 multi tools: modifies NTLMv1/NTLMv1-ESS/MSCHAPv2
#   install_hashonymize             # Anonymize NTDS, ASREProast, Kerberoast hashes for remote cracking
#   install_gosecretsdump           # secretsdump in Go for heavy files
#   install_adidnsdump              # enumerate DNS records in Domain or Forest DNS zones
#   install_pygpoabuse
#   install_bloodhound-import       # Python script to import BH data to a neo4j db
#   install_bloodhound-quickwin     # Python script to find quickwins from BH data in a neo4j db
#   install_ldapsearch-ad           # Python script to find quickwins from basic ldap enum
#   install_petitpotam              # Python script to coerce auth through MS-EFSR abuse
#   install_dfscoerce               # Python script to coerce auth through NetrDfsRemoveStdRoot and NetrDfsAddStdRoot abuse
#   install_coercer                 # Python script to coerce auth through multiple methods
#   install_pkinittools             # Python scripts to use kerberos PKINIT to obtain TGT
#   install_pywhisker               # Python script to manipulate msDS-KeyCredentialLink
#   #install_manspider              # Snaffler-like in Python # FIXME : https://github.com/blacklanternsecurity/MANSPIDER/issues/18
#   install_targetedKerberoast
#   install_pcredz
#   install_pywsus
#   install_donpapi
#   install_webclientservicescanner
#   install_certipy
#   install_shadowcoerce
#   install_gmsadumper
#   install_pylaps
#   install_finduncommonshares
#   install_ldaprelayscan
#   install_goldencopy
#   install_crackhound
#   install_kerbrute                # Tool to enumerate and bruteforce AD accounts through kerberos pre-authentication
#   install_ldeep
#   install_rusthound
#   install_certsync
#   install_KeePwn
#   install_pre2k
#   install_msprobe
#   install_masky
#   install_roastinthemiddle
#   install_PassTheCert
}

function package_ad_configure() {
  configure_responder
  configure_bloodhound
  configure_neo4j
  configure_impacket
  configure_darkarmour
  configure_krbrelayx
}

function install_responder() {
  colorecho "Installing Responder"
  git -C /opt/tools/ clone --depth=1 https://github.com/lgandx/Responder
  fapt gcc-mingw-w64-x86-64 python3-netifaces
  add-aliases responder
  add-history responder
  add-test-command "responder --version"
}

function configure_responder() {
  sed -i 's/ Random/ 1122334455667788/g' /opt/tools/Responder/Responder.conf
  sed -i 's/files\/AccessDenied.html/\/opt\/tools\/Responder\/files\/AccessDenied.html/g' /opt/tools/Responder/Responder.conf
  sed -i 's/files\/BindShell.exe/\/opt\/tools\/Responder\/files\/BindShell.exe/g' /opt/tools/Responder/Responder.conf
  sed -i 's/certs\/responder.crt/\/opt\/tools\/Responder\/certs\/responder.crt/g' /opt/tools/Responder/Responder.conf
  sed -i 's/certs\/responder.key/\/opt\/tools\/Responder\/certs\/responder.key/g' /opt/tools/Responder/Responder.conf
  x86_64-w64-mingw32-gcc /opt/tools/Responder/tools/MultiRelay/bin/Runas.c -o /opt/tools/Responder/tools/MultiRelay/bin/Runas.exe -municode -lwtsapi32 -luserenv
  x86_64-w64-mingw32-gcc /opt/tools/Responder/tools/MultiRelay/bin/Syssvc.c -o /opt/tools/Responder/tools/MultiRelay/bin/Syssvc.exe -municode
  cd /opt/tools/Responder || false
  /opt/tools/Responder/certs/gen-self-signed-cert.sh
}

function install_crackmapexec() {
  colorecho "Installing CrackMapExec"
  python3 -m pipx install crackmapexec
  add-aliases crackmapexec
  add-history crackmapexec
  add-test-command "crackmapexec --help"
}

function configure_crackmapexec() {
  ~/.local/bin/crackmapexec || true
  mkdir -p ~/.cme
  [ -f ~/.cme/cme.conf ] && mv ~/.cme/cme.conf ~/.cme/cme.conf.bak
  cp -v /root/sources/crackmapexec/cme.conf ~/.cme/cme.conf
  # below is for having the ability to check the source code when working with modules and so on
  # git -C /opt/tools/ clone https://github.com/byt3bl33d3r/CrackMapExec
  cp -v /root/sources/grc/conf.cme /usr/share/grc/conf.cme
}

function install_bloodhound-py() {
  colorecho "Installing and Python ingestor for BloodHound"
  git -C /opt/tools/ clone --depth=1 https://github.com/fox-it/BloodHound.py
  add-aliases bloodhound-py
  add-history bloodhound-py
  add-test-command "bloodhound.py --help"
}

function install_bloodhound() {
  colorecho "Installing BloodHound from sources"
  git -C /opt/tools/ clone --depth=1 https://github.com/BloodHoundAD/BloodHound/
  mv /opt/tools/BloodHound /opt/tools/BloodHound4
}

function configure_bloodhound() {
  zsh -c "source ~/.zshrc && cd /opt/tools/BloodHound4 && nvm install 16.13.0 && nvm use 16.13.0 && npm install -g electron-packager && npm install && npm run build:linux"
  if [[ $(uname -m) = 'x86_64' ]]
  then
    ln -s /opt/tools/BloodHound4/BloodHound-linux-x64/BloodHound /opt/tools/BloodHound4/BloodHound
  elif [[ $(uname -m) = 'aarch64' ]]
  then
    ln -s /opt/tools/BloodHound4/BloodHound-linux-arm64/BloodHound /opt/tools/BloodHound4/BloodHound
  elif [[ $(uname -m) = 'armv7l' ]]
  then
    ln -s /opt/tools/BloodHound4/BloodHound-linux-armv7l/BloodHound /opt/tools/BloodHound4/BloodHound
  else
    criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
  fi
  mkdir -p ~/.config/bloodhound
  cp -v /root/sources/bloodhound/config.json ~/.config/bloodhound/config.json
  cp -v /root/sources/bloodhound/customqueries.json ~/.config/bloodhound/customqueries.json
  add-aliases bloodhound
  # TODO add-test-command
}

function install_neo4j() {
  colorecho "Installing neo4j"
  wget -O - https://debian.neo4j.com/neotechnology.gpg.key | apt-key add -
  echo 'deb https://debian.neo4j.com stable latest' | tee /etc/apt/sources.list.d/neo4j.list
  apt-get update
  fapt --download-only neo4j
}

function configure_neo4j() {
  dpkg -i /var/cache/apt/archives/cypher-shell*
  dpkg -i /var/cache/apt/archives/daemon*
  dpkg -i /var/cache/apt/archives/neo4j*


  # TODO: when temporary fix is not needed anymore --> neo4j-admin dbms set-initial-password exegol4thewin
  neo4j-admin set-initial-password exegol4thewin
  
  mkdir -p /usr/share/neo4j/logs/
  touch /usr/share/neo4j/logs/neo4j.log
  cp /usr/bin/neo4j /opt/tools/bin/
  add-history neo4j
  add-test-command "neo4j version"
}

function install_cyperoth() {
  colorecho "Installing cypheroth"
  git -C /opt/tools/ clone --depth=1 https://github.com/seajaysec/cypheroth/
  add-aliases cypheroth
  add-history cypheroth
  add-test-command "cypheroth --help; cypheroth -u neo4j -p exegol4thewin | grep 'Quitting Cypheroth'"
}

function install_impacket() {
  colorecho "Installing Impacket scripts"
  # apt-get -y install libffi-dev # Base Image ?
  
  # git -C /opt/tools/ clone https://github.com/ThePorgs/impacket

  # # See https://github.com/ThePorgs/impacket/blob/master/ChangeLog.md

  # python3 -m pipx install /opt/tools/impacket/
  # python3 -m pipx inject impacket chardet

  python3 -m pipx install git+https://github.com/ThePorgs/impacket
  python3 -m pipx inject impacket chardet

  add-aliases impacket
  add-history impacket
  add-test-command "ntlmrelayx.py --help"
  add-test-command "secretsdump.py --help"
  add-test-command "Get-GPPPassword.py --help"
  add-test-command "getST.py --help && getST.py --help | grep 'u2u'"
  add-test-command "ticketer.py --help && ticketer.py --help | grep impersonate"
  add-test-command "ticketer.py --help && ticketer.py --help | grep hours"
  add-test-command "ticketer.py --help && ticketer.py --help | grep extra-pac"
  add-test-command "dacledit.py --help"
  add-test-command "describeTicket.py --help"
}

function configure_impacket() {
  cp -v /root/sources/grc/conf.ntlmrelayx /usr/share/grc/conf.ntlmrelayx
  cp -v /root/sources/grc/conf.secretsdump /usr/share/grc/conf.secretsdump
  cp -v /root/sources/grc/conf.getgpppassword /usr/share/grc/conf.getgpppassword
  cp -v /root/sources/grc/conf.rbcd /usr/share/grc/conf.rbcd
  cp -v /root/sources/grc/conf.describeTicket /usr/share/grc/conf.describeTicket
}

function install_pykek() {
  colorecho "Installing Python Kernel Exploit Kit (pykek) for MS14-068"
  git -C /opt/tools/ clone --depth=1 https://github.com/preempt/pykek
  add-aliases pykek
  add-test-command "ms14-068.py |& grep '<clearPassword>'"
}

function install_privexchange() {
  colorecho "Installing privexchange"
  git -C /opt/tools/ clone --depth=1 https://github.com/dirkjanm/PrivExchange
  add-aliases privexchange
  add-history privexchange
  add-test-command "python3 /opt/tools/PrivExchange/privexchange.py --help"
}

function install_ruler() {
  colorecho "Downloading ruler and form templates"

  go install github.com/sensepost/ruler@latest

  # git -C /opt/tools clone https://github.com/sensepost/ruler/
  # cd /opt/tools/ruler
  # if [[ $(uname -m) = 'x86_64' ]]
  # then
  #   GOOS=linux GOARCH=amd64 go build -o ruler
  # elif [[ $(uname -m) = 'aarch64' ]]
  # then
  #   GOOS=linux GOARCH=arm64 go build -o ruler
  # else
  #   criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
  # fi
  # ln -s /opt/tools/ruler/ruler /opt/tools/bin/ruler
  add-history ruler
  add-test-command "ruler --version"
}

function install_darkarmour() {
  colorecho "Installing darkarmour"
  git -C /opt/tools/ clone --depth=1 https://github.com/bats3c/darkarmour
  fapt --download-only mingw-w64-tools mingw-w64-common g++-mingw-w64 gcc-mingw-w64 upx-ucl osslsigncode # DEPS
  add-aliases darkarmour
  add-history darkarmour
  add-test-command "darkarmour --help"
}

function configure_darkarmour() {
  dpkg -i /var/cache/apt/archives/mingw-w64-tools*
  dpkg -i /var/cache/apt/archives/mingw-w64-common*
  dpkg -i /var/cache/apt/archives/g++-mingw-w64*
  dpkg -i /var/cache/apt/archives/gcc-mingw-w64*
  dpkg -i /var/cache/apt/archives/upx-ucl*
  dpkg -i /var/cache/apt/archives/osslsigncode*
}

function install_amber() {
  colorecho "Installing amber"
  # Installing keystone requirement
  git -C /opt/tools/ clone --depth=1 https://github.com/EgeBalci/keystone
  cd /opt/tools/keystone/ || false
  mkdir build
  cd build || false
  ../make-lib.sh
  cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DLLVM_TARGETS_TO_BUILD="AArch64;X86" -G "Unix Makefiles" ..
  make -j8
  make install && ldconfig
  # Installing amber
  go install -v github.com/EgeBalci/amber@latest
  add-history amber
  add-test-command "amber --help"
}

function install_powershell() {
  colorecho "Installing powershell"
  if [[ $(uname -m) = 'x86_64' ]]
  then
    curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.2/powershell-7.3.0-linux-x64.tar.gz
  elif [[ $(uname -m) = 'aarch64' ]]
  then
    curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.2/powershell-7.3.0-linux-arm64.tar.gz
  elif [[ $(uname -m) = 'armv7l' ]]
  then
    curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.2/powershell-7.3.0-linux-arm32.tar.gz
  else
    criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
  fi
  mkdir -v -p /opt/tools/powershell/7
  tar xvfz /tmp/powershell.tar.gz -C /opt/tools/powershell/7
  chmod -v +x /opt/tools/powershell/7/pwsh
  ln -v -s /opt/tools/powershell/7/pwsh /opt/tools/bin/pwsh
  ln -v -s /opt/tools/bin/pwsh /opt/tools/bin/powershell
  rm -v /tmp/powershell.tar.gz
  add-test-command "powershell -Version"
}

#TODO: turn into venv
function install_krbrelayx() {
  # Need pyenv
  colorecho "Installing krbrelayx"
  python3 -m pip install dnspython ldap3
  #python -m pip install dnstool==1.15.0
  git -C /opt/tools/ clone --depth=1 https://github.com/dirkjanm/krbrelayx

  add-aliases krbrelayx
  add-history krbrelayx
  add-test-command "krbrelayx.py --help"
  add-test-command "addspn.py --help"
  add-test-command "addspn.py --help"
  add-test-command "printerbug.py --help"
}

function configure_krbrelayx() {
  cp -v /root/sources/grc/conf.krbrelayx /usr/share/grc/conf.krbrelayx
}

function install_evilwinrm() {
  colorecho "Installing evil-winrm"
  git -C /opt/tools/ clone --depth=1 https://github.com/Hackplayers/evil-winrm
  cd /opt/tools/evil-winrm || false
  bundle install

  add-history evil-winrm
  add-test-command "evil-winrm --help"
}