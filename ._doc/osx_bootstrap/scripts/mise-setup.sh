#!/usr/bin/env bash
# mise: runtime version manager
# uv: Python package/venv manager (uses whatever Python mise provides)

# Activate mise
eval "$(mise activate bash)"

# Install global runtimes
mise use --global python@3.14
mise use --global node@24
mise use --global go@latest

# Prevent bare pip install from polluting global Python
mise set --global PIP_REQUIRE_VIRTUALENV=true

echo "    mise runtimes installed."
echo "    uv installed via brew (uses mise-managed Python, handles venvs + packages)."
