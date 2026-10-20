# used to simulate services failing or going back up.
# source me from bash. The ping URL is read from test/hc_url.txt (git-ignored),
# which should contain only the URL, e.g.:
# https://hc-ping.com/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# An HC_URL variable already set in the shell takes precedence.

HC_URL_FILE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/hc_url.txt"

if [[ -z "${HC_URL}" && -f "$HC_URL_FILE" ]]; then
	HC_URL="$(tr -d '[:space:]' < "$HC_URL_FILE")"
fi

if [[ -z "${HC_URL}" ]]; then
	echo "Put the ping URL in $HC_URL_FILE or set HC_URL before sourcing this."
	return 1
fi

hc_succ() {
	curl -m 10 --retry 5 "$HC_URL"
}

hc_fail() {
	if [[ -n "${1+x}" ]]; then
		curl -m 10 --retry 5 "$HC_URL/$1"
	else
		curl -m 10 --retry 5 "$HC_URL/fail"
	fi
}
