#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

function extract_commit_msg_from_file() {
	SCRIPT_DIRECTORY=$(dirname "$0")
	readonly SCRIPT_DIRECTORY

	MESSAGE="$(bash "$SCRIPT_DIRECTORY/extract-commit-msg.sh" "$1")"
	readonly MESSAGE

	if [[ -z $MESSAGE ]]; then
		exit 1
	fi

	echo "$MESSAGE"
}

extract_commit_msg_from_file "$1" | lychee --no-progress -
