# accepts as argument the no. of down checks
healthchecks_color() {
	if [[ $1 -eq 0 ]]
	then
		echo "#[$(get_tmux_option "@healthchecks_up_style" $(get_tmux_option "status-style" "fg=green,bg=black"))]"
	elif [[ $1 -gt 1 ]]
	then
		echo "#[$(get_tmux_option "@healthchecks_down_style" $(get_tmux_option "status-style" "fg=red,bg=black"))]"
	else
		echo "#[$(get_tmux_option "@healthchecks_unknown_style" $(get_tmux_option "status-style" "fg=yellow,bg=black"))]"
	fi
}
