FROM exegol_code_analysis as code_analysis

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

WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]
