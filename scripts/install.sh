#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/Gitomation/gm.git"
APP_NAME="gm"
INSTALL_DIR="/usr/local/bin"
TMP_DIR="$(mktemp -d)"

echo "==> Cloning repository..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR"

cd "$TMP_DIR"

echo "==> Building release binary..."
cargo build --release

BIN_PATH="target/release/$APP_NAME"

if [ ! -f "$BIN_PATH" ]; then
    echo "Error: Build failed. Binary not found at $BIN_PATH"
    exit 1
fi

echo "==> Installing binary to $INSTALL_DIR..."
if [ "$EUID" -ne 0 ]; then
    sudo mv "$BIN_PATH" "$INSTALL_DIR/$APP_NAME"
else
    mv "$BIN_PATH" "$INSTALL_DIR/$APP_NAME"
fi
chmod +x "$INSTALL_DIR/$APP_NAME"

echo "==> Cleaning up temporary files..."
cd /
rm -rf "$TMP_DIR"

echo "Installation complete!"
echo "You can now run '$APP_NAME' from anywhere."
