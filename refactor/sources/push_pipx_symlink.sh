#!/bin/bash

BINARIES_FILE="/tmp/pipx-symlink"
BIN_DIR="/root/.local/bin"

while read -r binary_path; do
    binary_name=$(basename "$binary_path")
    ln -sfn "$binary_path" "$BIN_DIR/$binary_name"
    echo "Created symlink for $binary_name"
done < "$BINARIES_FILE"