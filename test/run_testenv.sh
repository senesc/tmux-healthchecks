#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$CURRENT_DIR/.."
tmux -f "./testenv/tmux.conf" -L tmux-testenv new-session -A
