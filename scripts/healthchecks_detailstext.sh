healthchecks_detailstext() {
	if [[ $1 -eq 0 ]]
	then
		echo $(get_tmux_option "@healthchecks_up_detailstext" "all UP.")
	elif [[ $1 -eq 1 ]]
	then
		echo "$(echo $2 | jq -r 'try (.checks.[] | select(.status == "down") | .slug) catch "error"') down"
	elif [[ $1 -gt 1 ]]
	then
		echo "$(echo $2 | jq -r 'try ([.checks.[] | select(.status == "down")].[0] | .slug) catch "error"') \& $(expr $1 - 1) other down"
	else
		echo "unknown"
	fi
}
