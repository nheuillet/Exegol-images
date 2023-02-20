FROM nheuillet/exegol-builds:nightly-code-analysis-arm64 as code_analysis
FROM nheuillet/exegol-builds:nightly-ad-arm64 as ad

FROM nheuillet/exegol-builds:nightly-base-arm64

ARG TAG="local"
ARG VERSION="local"
ARG BUILD_DATE="n/a"

LABEL org.exegol.tag="${TAG}"
LABEL org.exegol.version="${VERSION}"
LABEL org.exegol.build_date="${BUILD_DATE}"
LABEL org.exegol.app="ExegolFull"
LABEL org.exegol.src_repository="https://github.com/ThePorgs/Exegol-images"

WORKDIR /tmp

COPY --from=code_analysis /tmp/tmp-pipx tmp-pipx
COPY --from=code_analysis /tmp/tmp-tools tmp-tools

COPY --from=code_analysis /tmp/tmp-history tmp-history
COPY --from=code_analysis /tmp/tmp-aliases tmp-aliases
COPY --from=code_analysis /tmp/tmp-commands tmp-commands


RUN cp -RT tmp-pipx /root/.local/pipx/
RUN cp -RT tmp-tools /opt/tools
RUN cp -RT tmp-history /root/.zsh_history
RUN cp -RT tmp-aliases /opt/.exegol_aliases
RUN cp -RT tmp-commands /.exegol/build_pipeline_tests/all_commands.txt

# RUN rm -rf /tmp/tmp-*

COPY --from=ad /tmp/tmp-pipx tmp-pipx
COPY --from=ad /tmp/tmp-tools tmp-tools
COPY --from=ad /tmp/tmp-deb tmp-deb
COPY --from=ad /tmp/tmp-go tmp-go

COPY --from=ad /tmp/tmp-history tmp-history
COPY --from=ad /tmp/tmp-aliases tmp-aliases
COPY --from=ad /tmp/tmp-commands tmp-commands

RUN cp -RT tmp-pipx /root/.local/pipx/
RUN cp -RT tmp-tools /opt/tools
RUN cp -RT tmp-deb /opt/packages
RUN cp -RT tmp-go /root/go/bin/
RUN cp -RT tmp-history /root/.zsh_history
RUN cp -RT tmp-aliases /opt/.exegol_aliases
RUN cp -RT tmp-commands /.exegol/build_pipeline_tests/all_commands.txt

RUN rm -rf /tmp/tmp-*

# Create pipx symbolic links

WORKDIR /root/sources/

ADD sources /root/sources/

RUN chmod +x start.sh

RUN ./start.sh package_ad_configure

RUN chmod +x pipx_symlink.sh

RUN ./pipx_symlink.sh

WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]
