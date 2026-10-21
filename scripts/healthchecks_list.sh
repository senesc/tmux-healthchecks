#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"

# ANSI color code for the color name set in option $1 (default $2)
ansi_color() {
	case "$(get_tmux_option "$1" "$2")" in
		black) echo 30;; red) echo 31;; green) echo 32;; yellow) echo 33;;
		blue) echo 34;; magenta) echo 35;; cyan) echo 36;; white) echo 37;;
		*) echo 39;; # terminal default
	esac
}

unknown_color="$(ansi_color "@healthchecks_list_unknown_color" "yellow")"

if [[ -z "$(get_tmux_option "@healthchecks_api_key")" ]]; then
	echo -e "\e[1;${unknown_color}mError: API key is not set. See README.\e[0m"
	exit 1
fi

data="$(get_data)"
# only the placeholder for a missing cache has no timestamp
if ! printf '%s\n' "$data" | jq -e '.timestamp' >/dev/null; then
	echo "Still loading the checks, try again in a moment."
	exit 1
fi
if [[ "$(printf '%s\n' "$data" | down_count)" -lt 0 ]]; then
	echo -e "\e[1;${unknown_color}mError: couldn't fetch the checks. Check your network connection, API key and endpoint.\e[0m"
	exit 1
fi

age=$(( $(date +%s) - $(printf '%s\n' "$data" | jq -r '.timestamp') ))
echo -e "\e[1;4mHealthchecks status:\e[0m \e[2m(updated ${age}s ago)\e[0m"

# one row per check: status, name, slug, and how long it has been down / when it last pinged
printf '%s\n' "$data" | jq -r \
	--arg up "$(ansi_color "@healthchecks_list_up_color" "green")" \
	--arg grace "$(ansi_color "@healthchecks_list_grace_color" "yellow")" \
	--arg down "$(ansi_color "@healthchecks_list_down_color" "red")" \
	--arg paused "$(ansi_color "@healthchecks_list_paused_color" "default")" \
	--arg new "$(ansi_color "@healthchecks_list_new_color" "default")" \
	--arg unknown "$unknown_color" '
	def colors: {up: $up, grace: $grace, down: $down, paused: $paused, new: $new, unknown: $unknown};
	def seconds: sub("\\.[0-9]+"; "") | sub("\\+00:00$"; "Z") | fromdateiso8601;
	def duration: floor
		| if . < 60 then "\(.)s"
		elif . < 3600 then "\(. / 60 | floor)m"
		elif . < 86400 then "\(. / 3600 | floor)h \(. % 3600 / 60 | floor)m"
		else "\(. / 86400 | floor)d \(. % 86400 / 3600 | floor)h" end;
	def last_ping: if .last_ping then "last ping \(now - (.last_ping | seconds) | duration) ago" else "never pinged" end;

	.response.checks[]
	| (if colors[.status] then .status else "unknown" end) as $s
	| colors[$s] as $c
	| (if $s == "down" then (if .down_since then "down for \(now - (.down_since | seconds) | duration)" else last_ping end)
		elif $s == "up" or $s == "grace" then last_ping
		else "" end) as $info
	| " - [\u001b[1;\($c)m\($s | ascii_upcase)\u001b[0m]¦"
		+ (if $s == "down" then "\u001b[1;\($c)m" else "" end) + .name + "\u001b[0m¦"
		+ "\u001b[2m(" + .slug + ")\u001b[0m¦" + $info
	' | column -ts '¦'
