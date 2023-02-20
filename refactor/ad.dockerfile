FROM nheuillet/exegol-builds:nightly-base-arm64 as build

ADD sources /root/sources

WORKDIR /root/sources/

RUN chmod +x start.sh

RUN ./start.sh package_ad


FROM alpine:3.17.2

ARG TAG="local"
ARG VERSION="local"
ARG BUILD_DATE="n/a"

LABEL org.exegol.tag="${TAG}"
LABEL org.exegol.version="${VERSION}"
LABEL org.exegol.build_date="${BUILD_DATE}"
LABEL org.exegol.app="ExegolAD"
LABEL org.exegol.src_repository="https://github.com/ThePorgs/Exegol-images"

RUN echo "${TAG}-${VERSION}" > /opt/.exegol_version

WORKDIR /tmp

COPY --from=build /root/.local/pipx tmp-pipx
COPY --from=build /opt/tools tmp-tools
COPY --from=build /var/cache/apt/archives tmp-deb
COPY --from=build /root/go/bin/ tmp-go
