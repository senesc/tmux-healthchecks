#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"

healthchecks_status_icon() {
	local status=$(get_data | hc_status)
	if [[ "$status" == up ]]; then
		get_tmux_option "@healthchecks_up_icon" "󰗶"
	elif [[ "$status" == down ]]; then
		get_tmux_option "@healthchecks_down_icon" ""
	else
		get_tmux_option "@healthchecks_unknown_icon" "?"
	fi
}

healthchecks_status_icon
