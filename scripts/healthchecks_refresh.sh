#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"
source "$CURRENT_DIR/options.sh"

echo "doing a refresh" >> out.log
update_cache "$(get_tmux_option "@healthchecks_cache_file" "/tmp/tmux-healthchecks-${api_key:0:6}")" "$(get_tmux_option "@healthchecks_api_key")"
