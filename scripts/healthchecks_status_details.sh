#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"
source "$CURRENT_DIR/options.sh"

healthchecks_status_details() {
	local data=$(get_data)
	local down_count=$(echo "$data" | jq -r 'try .down_count catch -1')
	if [[ "$down_count" -eq 0 ]]; then
		get_tmux_option "@healthchecks_up_details" "all UP"
	elif [[ "$down_count" -eq 1 ]]; then
		echo "$(echo "$data" | jq -r 'try .down_names.[0] catch "error"') down"
	elif [[ "$down_count" -eq 2 ]]; then
		echo "$(echo "$data" | jq -r 'try .down_names.[0] catch "error"') & $((down_count - 1)) other"
	elif [[ "$down_count" -gt 2 ]]; then
		echo "$(echo "$data" | jq -r 'try .down_names.[0] catch "error"') & $((down_count - 1)) others"
	else
		get_tmux_option "@healthchecks_unknown_details" "unknown"
	fi
}

healthchecks_status_details
