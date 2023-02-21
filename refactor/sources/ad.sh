#!/bin/bash
# Author: The Exegol Project

source common.sh

# Package dedicated to internal Active Directory tools
function package_ad() {

  set_go_env
  install_responder               # LLMNR, NBT-NS and MDNS poisoner
  install_pipx_tool ldapdomaindump "ldapdomaindump --help" history
  install_crackmapexec            # Network scanner
  install_pipx_tool sprayhound "sprayhound --help" history # Password spraying tool
  install_pipx_git_tool "git+https://github.com/ShutdownRepo/smartbrute" "smartbrute" "smartbrute --help" history # Password spraying tool
  install_bloodhound-py           # AD cartographer  
  install_bloodhound
  install_cypheroth                # Bloodhound dependency
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
  install_pypykatz                # Mimikatz implementation in pure Python
  install_enyx                    # Hosts discovery
  install_enum4linux-ng           # Hosts enumeration
  install_zerologon               # Exploit for zerologon cve-2020-1472
  install_libmspack               # Library for some loosely related Microsoft compression format
  install_windapsearch-go         # Active Directory Domain enumeration through LDAP queries
  install_oaburl                  # Send request to the MS Exchange Autodiscover service
  install_lnkup
  install_polenum
  install_smbmap                  # Allows users to enumerate samba share drives across an entire domain
  install_pth-tools               # Pass the hash attack
  install_smtp-user-enum          # SMTP user enumeration via VRFY, EXPN and RCPT
  install_gpp-decrypt             # Decrypt a given GPP encrypted string
  install_ntlmv1-multi            # NTLMv1 multi tools: modifies NTLMv1/NTLMv1-ESS/MSCHAPv2
  install_hashonymize             # Anonymize NTDS, ASREProast, Kerberoast hashes for remote cracking
  install_gosecretsdump           # secretsdump in Go for heavy files
  install_pipx_git_tool "git+https://github.com/dirkjanm/adidnsdump" adidnsdump "adidnsdump --help" history # enumerate DNS records in Domain or Forest DNS zones
  install_pygpoabuse
  install_pipx_tool bloodhound-import "bloodhound-import --help" history

  install_bloodhound-quickwin     # Python script to find quickwins from BH data in a neo4j db
  install_ldapsearch-ad           # Python script to find quickwins from basic ldap enum
  install_petitpotam              # Python script to coerce auth through MS-EFSR abuse
  install_dfscoerce               # Python script to coerce auth through NetrDfsRemoveStdRoot and NetrDfsAddStdRoot abuse
  install_pipx_tool coercer "coercer --help" history # Python script to coerce auth through multiple methods
  install_pkinittools             # Python scripts to use kerberos PKINIT to obtain TGT
  install_pywhisker               # Python script to manipulate msDS-KeyCredentialLink
  # install_pipx_git_tool "git+https://github.com/blacklanternsecurity/MANSPIDER" manspider "manspider --help" history # # Snaffler-like in Python # FIXME : https://github.com/blacklanternsecurity/MANSPIDER/issues/18
  install_targetedKerberoast
  install_pcredz
  install_pywsus
  install_donpapi
  install_pipx_git_tool "git+https://github.com/Hackndo/WebclientServiceScanner" webclientservicescanner "webclientservicescanner --help" history
  install_pipx_tool certipy "certipy --version" history
  install_shadowcoerce
  install_gmsadumper
  install_pylaps
  install_finduncommonshares
  install_ldaprelayscan
  install_pipx_tool goldencopy "goldencopy --help" history
  install_crackhound
  install_kerbrute                # Tool to enumerate and bruteforce AD accounts through kerberos pre-authentication
  install_pipx_tool ldeep "ldeep --help" history
#   install_rusthound
  install_pipx_tool certsync "certsync --help"
  install_pipx_git_tool "git+https://github.com/Orange-Cyberdefense/KeePwn" keewpn "keepwn --help"
  install_pipx_git_tool "git+https://github.com/garrettfoster13/pre2k" pre2k "pre2k --help"
  install_pipx_tool msprobe "msprobe --help"
  install_pipx_tool masky "masky --help"
  install_pipx_git_tool "git+https://github.com/Tw1sm/RITM" roastinthemiddle "roastinthemiddle --help"
}

function package_ad_configure() {
    install_apt_tool samdump2 "samdump2 -h; samdump2 -h |& grep 'enable debugging'" # Dumps Windows 2k/NT/XP/Vista password hashes
    install_apt_tool smbclient "smbclient --help" history # Small dynamic library that allows iOS apps to access SMB/CIFS file servers
    install_apt_tool onesixtyone "onesixtyone 127.0.0.1 public" history # SNMP scanning
    install_apt_tool nbtscan "nbtscan 127.0.0.1" history # NetBIOS scanning tool  
    configure_responder
    configure_bloodhound
    configure_neo4j
    configure_impacket
    configure_krbrelayx
    configure_pth-tools
    configure_powershell
    configure_cypheroth
    configure_darkarmour
    configure_pcreds
}

function install_responder() {
  colorecho "Installing Responder"
  git -C /opt/tools/ clone --depth=1 https://github.com/lgandx/Responder
  add-aliases responder
  add-history responder
  add-test-command "responder --version"
}

function configure_responder() {
  colorecho "Configure responder"
  fapt python3-netifaces
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
  colorecho "Configure crackmapexec"
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
  python3 -m pipx install git+https://github.com/fox-it/BloodHound.py
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
  colorecho "Configure bloodhound"
  zsh -c "source ~/.zshrc && cd /opt/tools/BloodHound4 && nvm install 16.13.0 && nvm use 16.13.0 && npm install -g electron-packager && npm install && npm run build:linux"
  ln -s /opt/tools/BloodHound4/BloodHound-linux/BloodHound /opt/tools/BloodHound4/BloodHound
  mkdir -p ~/.config/bloodhound
  cp -v /root/sources/bloodhound/config.json ~/.config/bloodhound/config.json
  cp -v /root/sources/bloodhound/customqueries.json ~/.config/bloodhound/customqueries.json
  add-aliases bloodhound
  # TODO add-test-command
}

function configure_neo4j() {
  colorecho "Configure neo4j"
  wget -O - https://debian.neo4j.com/neotechnology.gpg.key | apt-key add -
  echo 'deb https://debian.neo4j.com stable latest' | tee /etc/apt/sources.list.d/neo4j.list
  apt-get update
  fapt neo4j

  # TODO: when temporary fix is not needed anymore --> neo4j-admin dbms set-initial-password exegol4thewin
  neo4j-admin dbms set-initial-password exegol4thewin
  
  mkdir -p /usr/share/neo4j/logs/
  touch /usr/share/neo4j/logs/neo4j.log
  cp /usr/bin/neo4j /opt/tools/bin/
  add-history neo4j
  add-test-command "neo4j version"
}

function install_cypheroth() {
  colorecho "Installing cypheroth"
  git -C /opt/tools/ clone --depth=1 https://github.com/seajaysec/cypheroth/
  add-aliases cypheroth
  add-history cypheroth
  add-test-command "cypheroth --help; cypheroth -u neo4j -p exegol4thewin | grep 'Quitting Cypheroth'"
}

function configure_cypheroth() {
  fapt cypher-shell daemon
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
  colorecho "Configure impacket"
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
  cd /opt/tools/PrivExchange
  python3 -m venv ./venv
  ./venv/bin/python3 -m pip install impacket
  add-aliases privexchange
  add-history privexchange
  add-test-command "privexchange.py --help"
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
    add-aliases darkarmour
    add-history darkarmour
    add-test-command "darkarmour --help"
}

function configure_darkarmour() {
    fapt upx-ucl osslsigncode
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
    curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.2/powershell-7.3.2-linux-x64.tar.gz
  elif [[ $(uname -m) = 'aarch64' ]]
  then
    curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.2/powershell-7.3.2-linux-arm64.tar.gz
  elif [[ $(uname -m) = 'armv7l' ]]
  then
    curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.2/powershell-7.3.2-linux-arm32.tar.gz
  else
    criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
  fi
  mkdir -v -p /opt/tools/powershell/7
  tar xvfz /tmp/powershell.tar.gz -C /opt/tools/powershell/7
  chmod -v +x /opt/tools/powershell/7/pwsh
  rm -v /tmp/powershell.tar.gz
  add-test-command "powershell -Version"
}

function configure_powershell() {
  colorecho "Configure powershell"
  ln -v -s /opt/tools/powershell/7/pwsh /opt/tools/bin/pwsh
  ln -v -s /opt/tools/bin/pwsh /opt/tools/bin/powershell
}

function install_krbrelayx() {
  colorecho "Installing krbrelayx"
  git -C /opt/tools/ clone --depth=1 https://github.com/dirkjanm/krbrelayx
  cd /opt/tools/krbrelayx
  python3 -m venv ./venv
  ./venv/bin/python3 -m pip install dnspython ldap3 impacket dsinternals
  add-aliases krbrelayx
  add-history krbrelayx
  add-test-command "krbrelayx.py --help"
  add-test-command "addspn.py --help"
  add-test-command "addspn.py --help"
  add-test-command "printerbug.py --help"
}

function configure_krbrelayx() {
  colorecho "Configure krbrelayx"
  cp -v /root/sources/grc/conf.krbrelayx /usr/share/grc/conf.krbrelayx
}

function install_evilwinrm() {
  colorecho "Installing evil-winrm"
  git -C /opt/tools/ clone --depth=1 https://github.com/Hackplayers/evil-winrm
  cd /opt/tools/evil-winrm
  bundle install
  add-aliases evil-winrm
  add-history evil-winrm
  add-test-command "evil-winrm --help"
}

function install_pypykatz() {
  colorecho "Installing pypykatz"
  python3 -m pipx install pypykatz
  python3 -m pipx inject pypykatz minikerberos==0.3.5
  add-history pypykatz
  add-test-command "pypykatz version"
}

function install_enyx() {
  colorecho "Installing enyx"
  git -C /opt/tools/ clone --depth=1 https://github.com/trickster0/Enyx
  add-aliases enyx
  add-history enyx
  add-test-command "enyx"
}

function install_enum4linux-ng() {
  colorecho "Installing enum4linux-ng"
  python3 -m pipx install git+https://github.com/cddmp/enum4linux-ng
  add-history enum4linux-ng
  add-test-command "enum4linux-ng --help"
}

function install_zerologon() {
  colorecho "Pulling CVE-2020-1472 exploit and scan scripts"
  mkdir /opt/tools/zerologon
  python3 -m venv /opt/tools/zerologon/venv
  /opt/tools/zerologon/venv/bin/python3 -m pip install impacket
  git -C /opt/tools/zerologon clone --depth=1 https://github.com/SecuraBV/CVE-2020-1472 zerologon-scan
  git -C /opt/tools/zerologon clone --depth=1 https://github.com/dirkjanm/CVE-2020-1472 zerologon-exploit
  add-aliases zerologon
  add-history zerologon
  add-test-command "zerologon-scan; zerologon-scan | grep Usage"
}

function install_libmspack() {
  colorecho "Installing libmspack"
  git -C /opt/tools/ clone --depth=1 https://github.com/kyz/libmspack.git
  cd /opt/tools/libmspack/libmspack || false
  ./rebuild.sh
  ./configure
  make
  add-aliases libmspack
  add-test-command "oabextract"
}

function install_windapsearch-go() {
  colorecho "Installing Go windapsearch"
  git -C /opt/tools/ clone https://github.com/magefile/mage
  cd /opt/tools/mage
  go run bootstrap.go

  git -C /opt/tools/ clone --depth=1 https://github.com/ropnop/go-windapsearch
  cd /opt/tools/go-windapsearch
  /root/go/bin/mage build
  add-aliases windapsearch
  add-history windapsearch
  add-test-command "windapsearch --version"
}

function install_oaburl() {
  colorecho "Downloading oaburl.py"
  mkdir /opt/tools/OABUrl
  wget -O /opt/tools/OABUrl/oaburl.py "https://gist.githubusercontent.com/snovvcrash/4e76aaf2a8750922f546eed81aa51438/raw/96ec2f68a905eed4d519d9734e62edba96fd15ff/oaburl.py"
  cd /opt/tools/OABUrl/
  python3 -m venv ./venv
  ./venv/bin/python3 -m pip install requests
  add-aliases oaburl
  add-history oaburl
  add-test-command "oaburl.py --help"
}

# TODO: check that the venv does work
function install_lnkup() {
  colorecho "Installing LNKUp"
  git -C /opt/tools/ clone https://github.com/Plazmaz/LNKUp
  cd /opt/tools/LNKUp
  virtualenv --python=/usr/bin/python2.7 ./venv
  ./venv/bin/python2 -m pip install -r requirements.txt
  add-aliases lnkup
  add-history lnkup
  add-test-command "lnk-generate.py --help"
}

function install_polenum() {
  colorecho "Installing polenum"
  git -C /opt/tools/ clone --depth=1 https://github.com/Wh1t3Fox/polenum
  cd /opt/tools/polenum
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install impacket
  add-aliases polenum
  add-history polenum
  add-test-command "polenum.py --help"
}

# TODO: check venv (alias)
function install_smbmap(){
  colorecho "Installing smbmap"
  git -C /opt/tools/ clone --depth=1 https://github.com/ShawnDEvans/smbmap
  cd /opt/tools/smbmap || false

  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r requirements.txt
  # This doesn't seem to be the case anymore?
  # # installing requirements manually to skip impacket overwrite
  # # wish we could install smbmap in virtual environment :'(
  # python3 -m pip install pyasn1 pycrypto configparser termcolor impacket
  add-aliases smbmap
  add-history smbmap
  add-test-command "smbmap --help"
}

function install_pth-tools(){
  colorecho "Installing pth-tools"
  git -C /opt/tools clone --depth=1 https://github.com/byt3bl33d3r/pth-toolkit
  cd /opt/tools/pth-toolkit || true
  if [[ $(uname -m) = 'x86_64' ]]
  then
    wget -O /opt/packages/libreadline6_6.3-8+b3.deb http://ftp.debian.org/debian/pool/main/r/readline6/libreadline6_6.3-8+b3_amd64.deb
    wget -O /opt/packages/multiarch-support_2.19-18+deb8u10.deb http://ftp.debian.org/debian/pool/main/g/glibc/multiarch-support_2.19-18+deb8u10_amd64.deb
  elif [[ $(uname -m) = 'aarch64' ]]
  then
    criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
    # FIXME
    #16 428.9  libreadline6:armhf : Depends: libc6:armhf (>= 2.15) but it is not installable
    #16 428.9                       Depends: libtinfo5:armhf but it is not installable
    #16 428.9  multiarch-support:armhf : Depends: libc6:armhf (>= 2.13-5) but it is not installable
    wget -O /opt/packages/libreadline6_6.3-8+b3.deb http://ftp.debian.org/debian/pool/main/r/readline6/libreadline6_6.3-8+b3_armhf.deb
    wget -O /opt/packages/multiarch-support_2.19-18+deb8u10.deb http://ftp.debian.org/debian/pool/main/g/glibc/multiarch-support_2.19-18+deb8u10_armhf.deb
  elif [[ $(uname -m) = 'armv7l' ]]
  then
    criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
    # FIXME ?
    wget -O /opt/packages/libreadline6_6.3-8+b3.deb http://ftp.debian.org/debian/pool/main/r/readline6/libreadline6_6.3-8+b3_armel.deb
    wget -O /opt/packages/multiarch-support_2.19-18+deb8u10.deb http://ftp.debian.org/debian/pool/main/g/glibc/multiarch-support_2.19-18+deb8u10_armel.deb
  else
    criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
  fi
  add-aliases pth-tools
  add-history pth-tools
  # TODO add-test-command
}

function configure_pth-tools(){
  colorecho "Configure pth-tools"
  # FIXME
  #  dpkg -i /opt/packages/libreadline6_6.3-8+b3.deb
  # dpkg -i /opt/packages/multiarch-support_2.19-18+deb8u10.deb
}

function install_smtp-user-enum(){
  colorecho "Installing smtp-user-enum"
  python3 -m pipx install smtp-user-enum
  add-history smtp-user-enum
  add-test-command "smtp-user-enum --help"
}

function install_gpp-decrypt(){
  colorecho "Installing gpp-decrypt"
  git -C /opt/tools/ clone --depth=1 https://github.com/t0thkr1s/gpp-decrypt
  cd /opt/tools/gpp-decrypt || false
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install pycrypto colorama
  add-aliases gpp-decrypt
  add-test-command "gpp-decrypt.py -f /opt/tools/gpp-decrypt/groups.xml"
}

function install_ntlmv1-multi() {
  colorecho "Installing ntlmv1 multi tool"
  git -C /opt/tools clone --depth=1 https://github.com/evilmog/ntlmv1-multi
  add-aliases ntlmv1-multi
  add-history ntlmv1-multi
  add-test-command "ntlmv1-multi --ntlmv1 a::a:a:a:a"
}

function install_hashonymize() {
  colorecho "Installing hashonymizer"
  python3 -m pipx install git+https://github.com/ShutdownRepo/hashonymize
  add-test-command "hashonymize --help"

  install_pipx_git_tool "git+https://github.com/ShutdownRepo/hashonymize" hashonymize "hashonymize --help"
}

function install_gosecretsdump() {
  colorecho "Installing gosecretsdump"
  go install -v github.com/C-Sto/gosecretsdump@latest
  add-history gosecretsdump
  add-test-command "gosecretsdump -version"
}

function install_pygpoabuse() {
  colorecho "Installing pyGPOabuse"
  git -C /opt/tools/ clone --depth=1 https://github.com/Hackndo/pyGPOAbuse
  cd /opt/tools/pyGPOAbuse
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r requirements.txt

  add-aliases pygpoabuse
  add-test-command "pygpoabuse --help"
}

function install_bloodhound-quickwin() {
  colorecho "Installing bloodhound-quickwin"
  git -C /opt/tools/ clone --depth=1 https://github.com/kaluche/bloodhound-quickwin
  cd /opt/tools/bloodhound-quickwin
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install py2neo pandas prettytable

  add-aliases bloodhound-quickwin
  add-history bloodhound-quickwin
  add-test-command "bloodhound-quickwin --help"
}

function install_ldapsearch-ad() {
  colorecho "Installing ldapsearch-ad"
  git -C /opt/tools/ clone --depth=1 https://github.com/yaap7/ldapsearch-ad
  cd /opt/tools/ldapsearch-ad/
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r requirements.txt
  add-aliases ldapsearch-ad
  add-history ldapsearch-ad
  add-test-command "ldapsearch-ad --version"
}

function install_petitpotam() {
  colorecho "Installing PetitPotam"
  git -C /opt/tools/ clone --depth=1 https://github.com/ly4k/PetitPotam
  mv /opt/tools/PetitPotam /opt/tools/PetitPotam_alt
  git -C /opt/tools/ clone --depth=1 https://github.com/topotam/PetitPotam
  add-aliases petitpotam
  add-history petitpotam
  add-test-command "petitpotam.py --help"
}

function install_dfscoerce() {
  colorecho "Installing DfsCoerce"
  git -C /opt/tools/ clone --depth=1 https://github.com/Wh04m1001/DFSCoerce.git
  add-aliases dfscoerce
  add-history dfscoerce
  add-test-command "dfscoerce.py --help"
}

function install_pkinittools() {
  colorecho "Installing PKINITtools"
  git -C /opt/tools/ clone --depth=1 https://github.com/dirkjanm/PKINITtools
  add-aliases pkinittools
  add-history pkinittools
  add-test-command "gettgtpkinit.py --help"
}

function install_pywhisker() {
  colorecho "Installing pyWhisker"
  git -C /opt/tools/ clone --depth=1 https://github.com/ShutdownRepo/pywhisker
  cd /opt/tools/pywhisker
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r requirements.txt
  add-aliases pywhisker
  add-history pywhisker
  add-test-command "pywhisker.py --help"
}

function install_targetedKerberoast() {
  colorecho "Installing targetedKerberoast"
  git -C /opt/tools/ clone https://github.com/ShutdownRepo/targetedKerberoast
  cd /opt/tools/targetedKerberoast
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r requirements.txt
  add-aliases targetedkerberoast
  add-history targetedkerberoast
  add-test-command "targetedKerberoast.py --help"
}

function install_pcredz() {
  colorecho "Installing PCredz"
  # git -C /opt/tools/ clone --depth=1 https://github.com/lgandx/PCredz
  # cd /opt/tools/PCredz
  # python3 -m venv ./venv/
  # ./venv/bin/python3 -m pip install Cython python-libpcap

  # add-aliases pcredz
  add-test-command "PCredz --help"
}

function configure_pcreds() {
  colorecho "Configuring pcreds"
  # fapt libpcap-dev
}

function install_pywsus() {
  colorecho "Installing pywsus"
  git -C /opt/tools/ clone --depth=1 https://github.com/GoSecure/pywsus
  cd /opt/tools/pywsus
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r ./requirements.txt
  add-aliases pywsus
  add-history pywsus
  add-test-command "pywsus.py --help"
}

function install_donpapi() {
  colorecho "Installing DonPAPI"
  git -C /opt/tools/ clone --depth=1 https://github.com/login-securite/DonPAPI.git
  cd /opt/tools/DonPAPI
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r ./requirements.txt
  add-aliases donpapi
  add-history donpapi
  add-test-command "DonPAPI.py --help"
}

function install_shadowcoerce() {
  colorecho "Installing ShadowCoerce PoC"
  git -C /opt/tools/ clone --depth=1 https://github.com/ShutdownRepo/ShadowCoerce
  add-aliases shadowcoerce
  add-history shadowcoerce
  add-test-command "shadowcoerce.py --help"
}

function install_gmsadumper() {
  colorecho "Installing gMSADumper"
  git -C /opt/tools/ clone --depth=1 https://github.com/micahvandeusen/gMSADumper
  add-aliases gmsadumper
  add-history gmsadumper
  add-test-command "gMSADumper.py --help"
}

function install_pylaps() {
  colorecho "Installing pyLAPS"
  git -C /opt/tools/ clone --depth=1 https://github.com/p0dalirius/pyLAPS
  add-aliases pylaps
  add-history pylaps
  add-test-command "pyLAPS.py --help"
}

function install_finduncommonshares() {
  colorecho "Installing FindUncommonShares"
  git -C /opt/tools/ clone --depth=1 https://github.com/p0dalirius/FindUncommonShares
  cd /opt/tools/FindUncommonShares/
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r requirements.txt
  add-aliases finduncommonshares
  add-history finduncommonshares
  add-test-command "FindUncommonShares.py --help"
}


function install_ldaprelayscan() {
  colorecho "Installing LdapRelayScan"
  git -C /opt/tools/ clone --depth=1 https://github.com/zyn3rgy/LdapRelayScan
  cd /opt/tools/LdapRelayScan
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r requirements.txt
  add-aliases ldaprelayscan
  add-history ldaprelayscan
  add-test-command "LdapRelayScan.py --help"
}

function install_crackhound() {
  colorecho "Installing CrackHound"
  git -C /opt/tools/ clone --depth=1 https://github.com/trustedsec/CrackHound
  cd /opt/tools/CrackHound
  prs="6"
  for pr in $prs; do git fetch origin pull/$pr/head:pull/$pr && git merge --strategy-option theirs --no-edit pull/$pr; done
  python3 -m venv ./venv/
  ./venv/bin/python3 -m pip install -r requirements.txt
  add-aliases crackhound
  add-history crackhound
  add-test-command "crackhound.py --help"
}


function install_kerbrute() {
  colorecho "Installing Kerbrute"
  # install_go_tool kerbrute "kerbrute --help" history
  go install github.com/ropnop/kerbrute@latest
  add-history kerbrute
  add-test-command "kerbrute --help"
  # FIXME ARM platforms install ?
}

function install_rusthound() {
  colorecho "Installing RustHound"
  # fapt gcc libclang-dev clang libclang-dev libgssapi-krb5-2 libkrb5-dev libsasl2-modules-gssapi-mit musl-tools gcc-mingw-w64-x86-64
  # git -C /opt/tools/ clone https://github.com/OPENCYBER-FR/RustHound
  # cd /opt/tools/RustHound
  # # Sourcing rustup shell setup, so that rust binaries are found when installing cme
  # source "$HOME/.cargo/env"
  # cargo build --release
  # ln -s /opt/tools/RustHound/target/release/rusthound /opt/tools/bin/rusthound
  # add-history rusthound
  add-test-command "rusthound --help"
}

function install_PassTheCert() {
  colorecho "Installing PassTheCert"
  git -C /opt/tools/ clone --depth=1 https://github.com/AlmondOffSec/PassTheCert
  add-aliases PassTheCert
  add-test-command "passthecert.py --help"
}