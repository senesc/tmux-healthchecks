#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"
source "$CURRENT_DIR/options.sh"

# accepts as argument the number of down checks
healthchecks_status_short() {
	local down_count=$(get_data | jq -r 'try .down_count catch -1')
	if [[ "$down_count" -eq 0 ]];	then
		get_tmux_option "@healthchecks_up_short" "UP"
	elif [[ "$down_count" -gt 0 ]]; then
		get_tmux_option "@healthchecks_down_short" "DOWN"
	else
		get_tmux_option "@healthchecks_unknown_short" "unknown"
	fi
}

healthchecks_status_short
