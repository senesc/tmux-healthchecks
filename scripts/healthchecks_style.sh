#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"
source "$CURRENT_DIR/options.sh" #TODO: is this necessary or are these function exported/exportable?

# accepts as argument any name as long as a corresponding style has been set in options, usually just "icon" or "text" but could be anything
healthchecks_style() {
	local status=$(get_data | hc_status)
	get_tmux_option "@healthchecks_${status}_${1}_style" "$(get_tmux_option "status-style")"
}
healthchecks_style "$1"
