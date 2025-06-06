#!/bin/bash

set -e

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
    "Linux")
        if [[ "$ARCH" == "x86_64" ]]; then
            ARTIFACT="escaperoom-linux-amd64"
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi
        ;;
    "Darwin")
        if [[ "$ARCH" == "arm64" ]]; then
            ARTIFACT="escaperoom-darwin-arm64"
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

DOWNLOAD_URL="https://github.com/datashift-eu/escaperoom/releases/latest/download/${ARTIFACT}"

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

LATEST_VERSION=$(curl -s https://api.github.com/repos/datashift-eu/escaperoom/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Downloading escaperoom ${LATEST_VERSION}..."
curl -sSL "$DOWNLOAD_URL" -o "$INSTALL_DIR/escaperoom"

chmod +x "$INSTALL_DIR/escaperoom"

echo "Installation complete! You can now run the escaperoom command."
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Note: You may need to add ~/.local/bin to your PATH."
fi
