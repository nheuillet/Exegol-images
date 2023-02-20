#!/bin/bash

PIPX_DIR="/root/.local/bin"
OUTPUT_FILE="/tmp/pipx-symlink"

for symlink_path in $PIPX_DIR/*; do
    if [ -L "$symlink_path" ]; then
        binary_path=$(readlink "$symlink_path")
        echo "$binary_path" >> "$OUTPUT_FILE"
    fi
done