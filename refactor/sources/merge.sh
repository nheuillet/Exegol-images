#!/bin/bash

cp -RT tmp-pipx /root/.local/pipx/ || true
cp -RT tmp-opt /opt/ || true
cp -RT tmp-deb /opt/packages || true
cp -RT tmp-go /root/go/bin/ || true
cp -RT tmp-history /root/.zsh_history || true
cp -RT tmp-aliases /opt/.exegol_aliases || true
cp -RT tmp-commands /.exegol/build_pipeline_tests/all_commands.txt || true
cp -RT tmp-pipx-symlink /tmp/pipx-symlink || true