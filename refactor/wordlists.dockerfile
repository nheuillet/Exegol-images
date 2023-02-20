FROM nheuillet/exegol-builds:base-arm64 as build

ADD sources /root/sources

WORKDIR /root/sources/

RUN chmod +x start.sh

RUN ./start.sh package_wordlists


FROM alpine:3.17.2

WORKDIR /tmp

COPY --from=build /opt/tools tmp-tools
COPY --from=build /root/.zsh_history tmp-history
COPY --from=build /.exegol/build_pipeline_tests/all_commands.txt tmp-commands