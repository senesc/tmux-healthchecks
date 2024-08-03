#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"

healthchecks_status_icon() {
	local down_count=$(get_data | jq -r 'try .down_count catch -1')
	if [[ "$down_count" -eq 0 ]];	then
		get_tmux_option "@healthchecks_up_icon" "󰗶"
	elif [[ "$down_count" -gt 0 ]]; then
		get_tmux_option "@healthchecks_down_icon" ""
	else
		get_tmux_option "@healthchecks_unknown_icon" "?"
	fi
}

healthchecks_status_icon
