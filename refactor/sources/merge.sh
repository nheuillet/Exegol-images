#!/bin/bash

cp -RT tmp-pipx /root/.local/pipx/ || true
cp -RT tmp-opt /opt/ || true
cp -RT tmp-deb /opt/packages || true
cp -RT tmp-go /root/go/bin/ || true
cat tmp-history >> /root/.zsh_history || true
cat tmp-aliases >> /opt/.exegol_aliases || true
cat tmp-commands >> /.exegol/build_pipeline_tests/all_commands.txt || true
cat tmp-pipx-symlink >> /tmp/pipx-symlink || true