FROM exegol_code_analysis as code_analysis
FROM exegol_ad as ad

FROM exegol_updated


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


RUN cp -RT tmp-pipx /root/.local/pipx/

RUN cp -RT tmp-tools /opt/tools

RUN rm -rf /tmp/tmp-*

COPY --from=ad /tmp/tmp-pipx tmp-pipx
COPY --from=ad /tmp/tmp-tools tmp-tools
COPY --from=ad /tmp/tmp-deb tmp-deb


RUN cp -RT tmp-pipx /root/.local/pipx/

RUN cp -RT tmp-tools /opt/tools

RUN cp -RT tmp-deb /var/cache/apt/archives

RUN rm -rf /tmp/tmp-*

ADD sources /root/sources/

WORKDIR /root/sources/

RUN chmod +x start.sh

RUN ./start.sh package_ad_configure


WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]
