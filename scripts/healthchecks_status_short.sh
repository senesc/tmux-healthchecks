#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"
source "$CURRENT_DIR/options.sh"


healthchecks_status_short() {
	local status=$(get_data | hc_status)
	if [[ "$status" == up ]]; then
		get_tmux_option "@healthchecks_up_short" "UP"
	elif [[ "$status" == down ]]; then
		get_tmux_option "@healthchecks_down_short" "DOWN"
	else
		get_tmux_option "@healthchecks_unknown_short" "unknown"
	fi
}

healthchecks_status_short
