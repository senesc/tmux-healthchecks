CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/options.sh"

# the cache holds {"timestamp": <unix time>, "response": <full API response>}.
# down checks also get a "down_since" field (see add_down_since).
# "response" is null when the data couldn't be fetched, which is shown as "unknown"
HC_UNKNOWN_ENTRY='{"response": null}'

HC_JQ_ID='def id: .unique_key // .uuid // (.ping_url | strings | split("/") | last);'
hc_get() {
	curl --silent --fail --max-time 10 --header "X-Api-Key: $1" "$2"
}

make_cache_entry() {
	printf '%s\n' "$1" | jq -ec --argjson ts "$(date +%s)" \
		'select(.checks | type == "array") | {timestamp: $ts, response: .}' 2>/dev/null
}

add_down_since() {
	local entry="$1" api_key="$2" endpoint="$3" cachefile="$4"
	local ids id dir since="{}"
	ids="$(printf '%s\n' "$entry" | jq -r "$HC_JQ_ID"' .response.checks[] | select(.status == "down") | id // empty')"
	if [[ -z "$ids" ]] || ! dir="$(mktemp -d "${cachefile}.flips.XXXXXX")"; then
		printf '%s\n' "$entry"
		return
	fi

	for id in $ids; do
		hc_get "$api_key" "$endpoint/api/v3/checks/$id/flips/" > "$dir/$id" &
	done
	wait

	# the check went down at its latest flip to "down" (up == 0)
	for id in $ids; do
		since="$(jq -ec --arg id "$id" --argjson since "$since" \
			'$since + {($id): ([.flips[]? | select(.up == 0) | .timestamp] | max)}' "$dir/$id" 2>/dev/null \
			|| printf '%s' "$since")"
		rm -f "$dir/$id"
	done
	rmdir "$dir"

	printf '%s\n' "$entry" | jq -c --argjson since "$since" "$HC_JQ_ID"'
		.response.checks |= map(if $since[id] then . + {down_since: $since[id]} else . end)'
}

hc_status() {
	jq -r 'try (if [.response.checks[] | select(.status == "down")] | length > 0 then "down" else "up" end) catch "unknown"'
}
# number of down checks, -1 if unknown
down_count() {
	jq -r 'try ([.response.checks[] | select(.status == "down")] | length) catch -1'
}
update_cache() {
	local api_key=$(get_tmux_option "@healthchecks_api_key")
	local cachefile=$(get_tmux_option "@healthchecks_cache_file")
	local endpoint=$(get_tmux_option "@healthchecks_endpoint" "https://healthchecks.io")
	local lock="${cachefile}.lock"

	# mkdir fails if the directory exists, so exactly one process gets the lock.
	# a lock older than a minute was left by a crashed refresh (the requests give up after 10s each,
	# and the flips requests run in parallel): remove it and retry once
	if ! mkdir "$lock" 2>/dev/null; then
		if [[ -n "$(find "$lock" -maxdepth 0 -mmin +1 2>/dev/null)" ]]; then
			rmdir "$lock" 2>/dev/null
			mkdir "$lock" 2>/dev/null || return 0
		else
			return 0
		fi
	fi
	trap 'rmdir "$lock" 2>/dev/null' EXIT
	# on any failure, cache an "unknown" entry, so the next attempt waits for the update interval as usual
	local response entry
	if [[ -n "$api_key" ]] && response="$(hc_get "$api_key" "$endpoint/api/v3/checks/")" && entry="$(make_cache_entry "$response")"; then
		entry="$(add_down_since "$entry" "$api_key" "$endpoint" "$cachefile")"
	else
		entry="$(printf '%s\n' "$HC_UNKNOWN_ENTRY" | jq -c --argjson ts "$(date +%s)" '. + {timestamp: $ts}')"
	fi

	# the rename is atomic, so readers never see a half-written file
	local tmpfile
	if tmpfile="$(mktemp "${cachefile}.XXXXXX")"; then
		printf '%s\n' "$entry" > "$tmpfile"
		mv -f "$tmpfile" "$cachefile" || rm -f "$tmpfile"
	fi

	rmdir "$lock" 2>/dev/null
	trap - EXIT
}

# returns the content of the cache file (after fetching fresh data if necessary)
get_data() {
	local interval="$(get_tmux_option "@healthchecks_update_interval" "300")"
	local cachefile=$(get_tmux_option "@healthchecks_cache_file")

	if [[ -f "$cachefile" ]]; then
		local ts failed
		read -r ts failed < <(jq -r '"\(.timestamp // 0) \(.response == null)"' "$cachefile" 2>/dev/null)
		if [[ "$failed" == true ]]; then
			local retry="$(get_tmux_option "@healthchecks_retry_interval" "30")"
			(( retry < interval )) && interval="$retry"
		fi
		if [[ $(date +%s) -gt $((ts + interval)) ]]; then
			update_cache
		fi
	else
		update_cache
	fi
	cat "$cachefile" 2>/dev/null || printf '%s\n' "$HC_UNKNOWN_ENTRY"
}
