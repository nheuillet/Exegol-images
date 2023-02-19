#!/bin/bash

TOOLS_DIR="/root/.local/pipx/venvs"
BIN_DIR="/root/.local/bin"

for tool_path in $TOOLS_DIR/*; do
    if [ -d "$tool_path" ]; then
        tool_name=$(basename "$tool_path")
        binary_path="$tool_path/bin/$tool_name"
        if [ -x "$binary_path" ]; then
            ln -sfn "$binary_path" "$BIN_DIR/$tool_name"
            echo "Created symlink for $tool_name"
        fi
    fi
done
