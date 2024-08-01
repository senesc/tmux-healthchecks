#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/healthchecks_down_no.sh"
source "$CURRENT_DIR/scripts/healthchecks_icon.sh"
source "$CURRENT_DIR/scripts/healthchecks_color.sh"
source "$CURRENT_DIR/scripts/healthchecks_shorttext.sh"


main() {
	local response="$(curl --silent --header "X-Api-Key: $(get_tmux_option "@healthchecks_api_key")" https://healthchecks.io/api/v3/checks/)")

	local hc_down_no=$(healthchecks_down_no "$response")
	local hc_icon=$(healthchecks_icon $down_no)
	local hc_color=$(healthchecks_icon $down_no)
	local hc_shorttext=$(healthchecks_shorttext $down_no)
	local hc_detailstext=$(healthchecks_detailstext $down_no "$response")

	local sides=( "status-left" "status-right")
	for side in sides
	do
		local line="$(get_tmux_option $side)"
		line=${line//\#{healthchecks_status_icon}/$hc_icon}
		line=${line//\#{healthchecks_down_no}/$hc_down_no}
		line=${line//\#{healthchecks_status_color}/$hc_color}
		line=${line//\#{healthchecks_status_shorttext}/$hc_shorttext}
		set_tmux_option $side "$line"
	done
}

main
