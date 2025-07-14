#!/bin/bash

# List of screen session names
SESSION_NAMES=("nftables-frontend" "nftables-parser")

# Corresponding list of commands to run in each session
COMMANDS=("poetry run python3 /opt/nftables-gui/nftables-frontend/app.py" \
          "poetry run hug -f /opt/nftables-gui/nftables-parser/main.py")

# Working directory
WORKING_DIR="/opt/nftables-gui"

# Navigate to the working directory and set up environment
cd "$WORKING_DIR"
pip install --no-cache-dir poetry==2.1.3
poetry config virtualenvs.create false
poetry install --no-interaction -vvv --no-root

# Loop over sessions and start each one if not already running
for i in "${!SESSION_NAMES[@]}"; do
    SESSION_NAME="${SESSION_NAMES[$i]}"
    COMMAND="${COMMANDS[$i]}"

    if screen -list | grep -q "$SESSION_NAME"; then
        echo "Session '$SESSION_NAME' is already running."
    else
        screen -S "$SESSION_NAME" -dm bash -c "cd $WORKING_DIR && $COMMAND"
        echo "Session '$SESSION_NAME' started."
    fi
done
