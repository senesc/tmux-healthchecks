#!/usr/bin/env bash

if [[ -z "${HC_URL}" ]]; then
	echo "You should set the HC_URL variable before sourcing this."
	exit 1
fi

hc_succ() {
	curl -m 10 --retry 5 $HC_URL
}

hc_fail() {
	if [[ -n "${1+x}" ]]; then
		curl -m 10 --retry 5 "$HC_URL/$1"
	else
		curl -m 10 --retry 5 "$HC_URL/fail"
	fi
	
}



