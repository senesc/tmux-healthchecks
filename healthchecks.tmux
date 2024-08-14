#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/options.sh"

hc_interpolation_strings=(
	"\#{healthchecks_down_count}"
	"\#{healthchecks_status_icon}"
	"\#{healthchecks_status_short}"
	"\#{healthchecks_status_details}"
	"\#{healthchecks_icon_style}"
	"\#{healthchecks_text_style}"
)

hc_commands=(
	"#($CURRENT_DIR/scripts/healthchecks_down_count.sh)"
	"#($CURRENT_DIR/scripts/healthchecks_status_icon.sh)"
	"#($CURRENT_DIR/scripts/healthchecks_status_short.sh)"
	"#($CURRENT_DIR/scripts/healthchecks_status_details.sh)"
	"#($CURRENT_DIR/scripts/healthchecks_style.sh icon)"
	"#($CURRENT_DIR/scripts/healthchecks_style.sh text)"
)


do_interpolation() {
	local all_interpolated="$1"
	for ((i=0; i<${#hc_commands[@]}; i++)); do
		all_interpolated=${all_interpolated//${hc_interpolation_strings[$i]}/${hc_commands[$i]}}
	done
	echo "$all_interpolated"
}

interpolate_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
	interpolate_tmux_option "status-right"
	interpolate_tmux_option "status-left"
	tmux bind-key -N "Force refresh Healthchecks status" "$(get_tmux_option "@healthchecks_refresh_key" "M-h")" "run-shell $CURRENT_DIR/scripts/healthchecks_refresh.sh"
	tmux bind-key -N "Show Healthchecks status" "$(get_tmux_option "@healthchecks_list_key" "H")" "run-shell $CURRENT_DIR/scripts/healthchecks_list.sh"
}
main
