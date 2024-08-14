#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/options.sh"

api_key="$(get_tmux_option "@healthchecks_api_key")"
if [[ -z "$api_key" ]]; then
	echo "Error: API key is not set."
	exit 1
fi
response="$(curl --silent --header "X-Api-Key: $api_key" "https://healthchecks.io/api/v3/checks/")"
echo -e "\e[1;4mHealthchecks status:\e[0m"
echo "$response" | jq -r '.checks.[] | if .status=="up" then " - [\u001b[32;1mUP\u001b[0m]" else " - [\u001b[1m\u001b[31mDOWN\u001b[0m]\u001b[1m\u001b[31m" end + "¦" + .name +"\u001b[0m¦\u001b[2m(" + .slug + ")\u001b[0m" ' | column -ts '¦'
