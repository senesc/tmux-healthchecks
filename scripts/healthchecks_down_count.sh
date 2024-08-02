CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache.sh"

healthchecks_down_count() {
	get_data | jq -r 'try .down_count catch -1'
}

healthchecks_down_count
