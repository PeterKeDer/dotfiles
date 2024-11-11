#!/usr/bin/bash

# In our WSL setup, the Wezterm GUI is installed in windows, so its config
# files must live in the windows home directory. This script syncs the wezterm
# config files between windows and WSL, replacing outdated files.

set -euxo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
REPO_DIR="${SCRIPT_DIR}/.."

CONFIG_DIR=".config/wezterm"
CONFIG_PATH="${REPO_DIR}/${CONFIG_DIR}"

# Find windows home dir
WINDOWS_HOME_RAW="$(wslvar USERPROFILE)"
WINDOWS_HOME="$(wslpath "$WINDOWS_HOME_RAW")"
WINDOWS_CONFIG_PATH="${WINDOWS_HOME}/${CONFIG_DIR}"

# Use the -u flag to only copy updated files
cp -u -r "${WINDOWS_CONFIG_PATH}/"* "${CONFIG_PATH}"
cp -u -r "${CONFIG_PATH}/"* "${WINDOWS_CONFIG_PATH}"

echo 'Successfully synced Wezterm settings!'

