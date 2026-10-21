#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"
source "$CURRENT_DIR/options.sh"

healthchecks_status_details() {
	local data=$(get_data)
	case "$(printf '%s\n' "$data" | hc_status)" in
		up)
			get_tmux_option "@healthchecks_up_details" "all UP"
			;;
		down)
			local slug="$(printf '%s\n' "$data" | first_down_slug)"
			local others=$(( $(printf '%s\n' "$data" | down_count) - 1 ))
			if (( others == 0 )); then
				echo "$slug down"
			elif (( others == 1 )); then
				echo "$slug & 1 other"
			else
				echo "$slug & $others others"
			fi
			;;
		*)
			get_tmux_option "@healthchecks_unknown_details" "unknown"
			;;
	esac
}

healthchecks_status_details
