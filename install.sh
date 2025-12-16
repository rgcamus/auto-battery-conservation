#!/bin/bash
# Install script for auto-battery-conservation

SCRIPT_NAME="auto-battery-conservation"
SERVICE_NAME="auto-battery-conservation.service"
TIMER_NAME="auto-battery-conservation.timer"

SRC_DIR=$(pwd)
BIN_DIR="/usr/local/bin"
SYSTEMD_DIR="/etc/systemd/system"

# Ensure root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exec sudo "$0" "$@"
fi

echo "Installing $SCRIPT_NAME..."

# Install executable
if [[ -f "$SRC_DIR/$SCRIPT_NAME" ]]; then
    cp "$SRC_DIR/$SCRIPT_NAME" "$BIN_DIR/"
    chmod +x "$BIN_DIR/$SCRIPT_NAME"
    echo "Installed $BIN_DIR/$SCRIPT_NAME"
else
    echo "Error: $SCRIPT_NAME not found in current directory."
    exit 1
fi

# Install systemd units
if [[ -f "$SRC_DIR/$SERVICE_NAME" && -f "$SRC_DIR/$TIMER_NAME" ]]; then
    cp "$SRC_DIR/$SERVICE_NAME" "$SYSTEMD_DIR/"
    cp "$SRC_DIR/$TIMER_NAME" "$SYSTEMD_DIR/"
    echo "Installed systemd units to $SYSTEMD_DIR"
else
    echo "Error: Systemd unit files not found."
    exit 1
fi

# Enable timer
echo "Reloading systemd daemon..."
systemctl daemon-reload

echo "Enabling and starting $TIMER_NAME..."
systemctl enable --now "$TIMER_NAME"

echo "Installation complete!"
echo "You can check the status with: systemctl status $TIMER_NAME"
echo "Or run manually: $SCRIPT_NAME --help"
