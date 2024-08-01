# accepts the curl response as argument
healthchecks_down_no() {
	echo $(echo $1 | jq -C 'try ([.checks.[].status | select(. == "down")] | length) catch -1')
}
