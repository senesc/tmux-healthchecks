# accepts as argument the no. of down checks
healthchecks_icon() {
	if [[ $1 -eq 0 ]]
	then
		echo $(get_tmux_option "@healthchecks_up_icon" "󰗶")
	elif [[ $1 -gt 1 ]]
	then
		echo $(get_tmux_option "@healthchecks_down_icon" "")
	else
		echo $(get_tmux_option "@healthchecks_unknown_icon" "?")
	fi
}
