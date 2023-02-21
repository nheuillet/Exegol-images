FROM nheuillet/exegol-builds:code-analysis-arm64 as code_analysis
FROM nheuillet/exegol-builds:ad-arm64 as ad
FROM nheuillet/exegol-builds:wordlists-arm64 as wordlists
FROM nheuillet/exegol-builds:misc-arm64 as misc
FROM nheuillet/exegol-builds:c2-arm64 as c2
FROM nheuillet/exegol-builds:cracking-arm64 as cracking

FROM nheuillet/exegol-builds:base-arm64

ARG TAG="local"
ARG VERSION="local"
ARG BUILD_DATE="n/a"

LABEL org.exegol.tag="${TAG}"
LABEL org.exegol.version="${VERSION}"
LABEL org.exegol.build_date="${BUILD_DATE}"
LABEL org.exegol.app="ExegolFull"
LABEL org.exegol.src_repository="https://github.com/ThePorgs/Exegol-images"

# Code Analysis

WORKDIR /tmp

ADD sources /root/sources/

ADD sources/merge.sh merge.sh

RUN chmod +x ./merge.sh

COPY --from=code_analysis /tmp/tmp-pipx tmp-pipx
COPY --from=code_analysis /tmp/tmp-opt tmp-opt
COPY --from=code_analysis /tmp/tmp-history tmp-history
COPY --from=code_analysis /tmp/tmp-aliases tmp-aliases
COPY --from=code_analysis /tmp/tmp-commands tmp-commands
COPY --from=code_analysis /tmp/tmp-pipx-symlink tmp-pipx-symlink

RUN ./merge.sh
RUN rm -rf /tmp/tmp-*

# Active Directory

COPY --from=ad /tmp/tmp-pipx tmp-pipx
COPY --from=ad /tmp/tmp-opt tmp-opt
COPY --from=ad /tmp/tmp-deb tmp-deb
COPY --from=ad /tmp/tmp-go tmp-go
COPY --from=ad /tmp/tmp-history tmp-history
COPY --from=ad /tmp/tmp-aliases tmp-aliases
COPY --from=ad /tmp/tmp-commands tmp-commands
COPY --from=ad /tmp/tmp-pipx-symlink tmp-pipx-symlink

RUN ./merge.sh
RUN rm -rf /tmp/tmp-*

# Wordlists

COPY --from=wordlists /tmp/tmp-opt tmp-opt
COPY --from=wordlists /tmp/tmp-history tmp-history
COPY --from=wordlists /tmp/tmp-commands tmp-commands

RUN ./merge.sh
RUN rm -rf /tmp/tmp-*

# Misc

COPY --from=misc /tmp/tmp-pipx tmp-pipx
COPY --from=misc /tmp/tmp-opt tmp-opt
COPY --from=misc /tmp/tmp-deb tmp-deb
COPY --from=misc /tmp/tmp-go tmp-go
COPY --from=misc /tmp/tmp-history tmp-history
COPY --from=misc /tmp/tmp-aliases tmp-aliases
COPY --from=misc /tmp/tmp-commands tmp-commands
COPY --from=misc /tmp/tmp-pipx-symlink tmp-pipx-symlink

RUN ./merge.sh
RUN rm -rf /tmp/tmp-*

# C2

COPY --from=c2 /tmp/tmp-pipx tmp-pipx
COPY --from=c2 /tmp/tmp-opt tmp-opt
COPY --from=c2 /tmp/tmp-history tmp-history
COPY --from=c2 /tmp/tmp-aliases tmp-aliases
COPY --from=c2 /tmp/tmp-commands tmp-commands
COPY --from=c2 /tmp/tmp-pipx-symlink tmp-pipx-symlink

RUN ./merge.sh
RUN rm -rf /tmp/tmp-*

# Cracking

COPY --from=cracking /tmp/tmp-pipx tmp-pipx
COPY --from=cracking /tmp/tmp-opt tmp-opt
COPY --from=cracking /tmp/tmp-deb tmp-deb
COPY --from=cracking /tmp/tmp-history tmp-history
COPY --from=cracking /tmp/tmp-aliases tmp-aliases
COPY --from=cracking /tmp/tmp-commands tmp-commands
COPY --from=cracking /tmp/tmp-pipx-symlink tmp-pipx-symlink

RUN ./merge.sh
RUN rm -rf /tmp/tmp-*

# Configure

WORKDIR /root/sources/

RUN chmod +x start.sh
RUN ./start.sh package_ad_configure
RUN ./start.sh package_c2_configure
RUN ./start.sh package_cracking_configure
RUN ./start.sh package_misc_configure
RUN ./start.sh package_wordlists_configure


# Pipx env setup

RUN chmod +x push_pipx_symlink.sh
RUN ./push_pipx_symlink.sh

# Cleanup

RUN rm -rf /tmp/tmp-*

WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]
