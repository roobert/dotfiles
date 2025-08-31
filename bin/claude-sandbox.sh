#!/bin/bash

# Function to build the container
build_container() {
  echo "Container 'claude-sandbox' not found. Building from devcontainer..."

  # Create temporary directory
  TEMP_DIR=$(mktemp -d)
  cd "$TEMP_DIR"

  # Clone the repository
  echo "Cloning claude-code repository..."
  git clone https://github.com/anthropics/claude-code.git
  cd claude-code/.devcontainer

  # Get current timezone
  CURRENT_TZ=$(date +%Z)
  echo "Setting timezone to: $CURRENT_TZ"

  # Build the container with current timezone
  echo "Building claude-sandbox container..."
  docker build -t claude-sandbox --build-arg TZ="$CURRENT_TZ" .

  # Clean up
  cd - >/dev/null
  rm -rf "$TEMP_DIR"

  echo "Container built successfully!"
}

# Create claude-sandbox config directory if it doesn't exist
mkdir -p "${HOME}/.claude-sandbox"

# Try to run the container
echo "Starting claude-sandbox container..."
if ! docker run -it \
  -v "$(pwd):/workspace/${PWD##*/}" \
  -v "${HOME}/.claude-sandbox:/home/node/.claude-sandbox" \
  -e CLAUDE_CONFIG_DIR="/home/node/.claude-sandbox" \
  --network="host" \
  -w "/workspace/${PWD##*/}" \
  claude-sandbox claude 2>/dev/null; then

  echo "Failed to run container. Checking if image exists..."
  if ! docker images claude-sandbox | grep -q claude-sandbox; then
    build_container
    # Try running again after build
    echo "Attempting to run container again..."
    docker run -it \
      -v "$(pwd):/workspace/${PWD##*/}" \
      -v "${HOME}/.claude-sandbox:/home/node/.claude-sandbox" \
      -e CLAUDE_CONFIG_DIR="/home/node/.claude-sandbox" \
      --network="host" \
      -w "/workspace/${PWD##*/}" \
      claude-sandbox claude
  else
    echo "Container image exists but failed to run. Please check Docker logs."
    exit 1
  fi
fi
