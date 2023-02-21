FROM nheuillet/exegol-builds:base-arm64 as build

ADD sources /root/sources

WORKDIR /root/sources/

RUN chmod +x start.sh

RUN ./start.sh package_misc

RUN chmod +x get_pipx_symlink.sh

RUN ./get_pipx_symlink.sh


FROM alpine:3.17.2

WORKDIR /tmp

COPY --from=build /opt/ tmp-opt
COPY --from=build /opt/packages tmp-deb
COPY --from=build /root/go/bin/ tmp-go
COPY --from=build /root/.zsh_history tmp-history
COPY --from=build /opt/.exegol_aliases tmp-aliases
COPY --from=build /.exegol/build_pipeline_tests/all_commands.txt tmp-commands
COPY --from=build /root/.local/pipx tmp-pipx
COPY --from=build /tmp/pipx-symlink tmp-pipx-symlink