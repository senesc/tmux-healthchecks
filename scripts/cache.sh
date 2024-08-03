CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/options.sh"

# the following two accept the json response as first and only parameter
parse_down_count() {
	echo "$1" | jq -r 'try ([.checks.[].status | select(. == "down")] | length) catch -1'
}
parse_down_names() {
	echo "$1" | jq -rc 'try [.checks.[] | select(.status == "down") | .slug] catch "error"'
}

# wants cache file path and api key
update_cache() {
	local response="$(curl --silent --header "X-Api-Key: $2" "https://healthchecks.io/api/v3/checks/")"

	echo "{ \"timestamp\": $(date +%s), \"down_count\": $(parse_down_count "$response"), \"down_names\": $(parse_down_names "$response")}" > "$1"
}

# returns the content of the cache file (after fetching fresh data if necessary)
get_data() {
	local interval="$(get_tmux_option "@healthchecks_update_interval" "300")"
	local api_key="$(get_tmux_option "@healthchecks_api_key")"

	if [[ -z "$api_key" ]]; then
		return 1
	fi
	local cachefile="$(get_tmux_option "@healthchecks_cache_file" "/tmp/tmux-healthchecks-${api_key:0:6}")"
	if [[ -f "$cachefile" ]]; then
		local ts=$(jq -r 'try .timestamp catch 0' "$cachefile")
		if [[ $(date +%s) -gt $((ts + interval)) ]]; then
			update_cache "$cachefile" "$api_key"
		fi
	else
		update_cache "$cachefile" "$api_key"
	fi
	cat "$cachefile"
}
