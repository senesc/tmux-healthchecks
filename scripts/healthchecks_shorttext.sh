# accepts as argument the number of down checks
healthchecks_shorttext() {
	if [[ $1 -eq 0 ]]
	then
		echo "$(get_tmux_option "@healthchecks_up_shorttext" "UP")"
	elif [[ $1 -gt 1 ]]
	then
		echo "$(get_tmux_option "@healthchecks_down_shorttext" "DOWN")"
	else
		echo "$(get_tmux_option "@healthchecks_unknown_shorttext" "unknown")"
	fi
}
