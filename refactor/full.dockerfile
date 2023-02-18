FROM ExegolCodeAnalysis as code_analysis

FROM ExegolBase


ARG TAG="local"
ARG VERSION="local"
ARG BUILD_DATE="n/a"

LABEL org.exegol.tag="${TAG}"
LABEL org.exegol.version="${VERSION}"
LABEL org.exegol.build_date="${BUILD_DATE}"
LABEL org.exegol.app="ExegolFull"
LABEL org.exegol.src_repository="https://github.com/ThePorgs/Exegol-images"

WORKDIR /tmp

COPY --from=code_analysis tmp-pipx tmp-pipx
COPY --from=code_analysis tmp-gem tmp-gem
COPY --from=code_analysis tmp-tool tmp-tool


RUN cp -RT temp-gem /root/.gem/

RUN cp -RT temp-pipx /root/.local/pipx/

RUN cp -RT temp-tools /opt/tools


ENTRYPOINT [ "/.exegol/entrypoint.sh" ]