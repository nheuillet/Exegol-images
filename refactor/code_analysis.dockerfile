FROM ExegolBase as build

ADD sources /root/sources

WORKDIR /root/sources/

RUN chmod +x start.sh

RUN ./start.sh package_code_analysis


FROM alpine:3.17.2

ARG TAG="local"
ARG VERSION="local"
ARG BUILD_DATE="n/a"

LABEL org.exegol.tag="${TAG}"
LABEL org.exegol.version="${VERSION}"
LABEL org.exegol.build_date="${BUILD_DATE}"
LABEL org.exegol.app="ExegolCodeAnalysis"
LABEL org.exegol.src_repository="https://github.com/ThePorgs/Exegol-images"

RUN echo "${TAG}-${VERSION}" > /opt/.exegol_version

WORKDIR /root

COPY --from=build /root/.gem tmp-gem
COPY --from=build /root/.local/pipx tmp-pipx
COPY --from=build /opt/tools tmp-tools