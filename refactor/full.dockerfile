FROM nheuillet/exegol-builds:nightly-code-analysis-arm64 as code_analysis
# FROM exegol_ad as ad

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

# Create pipx symbolic links

WORKDIR /root/sources/

ADD sources /root/sources/

RUN chmod +x pipx_symlink.sh

RUN pipx_symlink.sh

# RUN rm -rf /tmp/tmp-*

# COPY --from=ad /tmp/tmp-pipx tmp-pipx
# COPY --from=ad /tmp/tmp-tools tmp-tools
# COPY --from=ad /tmp/tmp-deb tmp-deb

# Need to merge ~/.zsh_history /opt/.exegol_aliases and test commands (/.exegol/build_pipeline_tests/all_commands.txt)


# RUN cp -RT tmp-pipx /root/.local/pipx/

# RUN cp -RT tmp-tools /opt/tools

# RUN cp -RT tmp-deb /var/cache/apt/archives

RUN rm -rf /tmp/tmp-*

# ADD sources /root/sources/

# WORKDIR /root/sources/

# RUN chmod +x start.sh

# RUN ./start.sh package_ad_configure


WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]
