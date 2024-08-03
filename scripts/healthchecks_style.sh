#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"
source "$CURRENT_DIR/options.sh" #TODO: is this necessary or are these function exported/exportable?

# accepts as argument any name as long as a corresponding style has been set in options, usually just "icon" or "text" but could be anything
healthchecks_style() {
	local down_count=$(get_data | jq -r 'try .down_count catch -1')
	if [[ "$down_count" -eq 0 ]]
	then
		get_tmux_option "@healthchecks_up_${1}_style" "$(get_tmux_option "status-style")"
	elif [[ "$down_count" -gt 1 ]]
	then
		get_tmux_option "@healthchecks_down_${1}_style" "$(get_tmux_option "status-style")"
	else
		get_tmux_option "@healthchecks_unknown_${1}_style" "$(get_tmux_option "status-style")"
	fi
}
healthchecks_style "$1"
