#!/usr/bin/env bash

set -o errtrace
set -o nounset
set -o pipefail

COMMIT_EDITMSG_FILE="$1"
readonly COMMIT_EDITMSG_FILE
# Set extension to md, to format with dprint.
TEMP_FILE="COMMIT_EDITMSG.md"
readonly TEMP_FILE

function extract_commit_msg_to_temp_file() {
	SCRIPT_DIRECTORY=$(dirname "$0")
	readonly SCRIPT_DIRECTORY

	MESSAGE="$(bash "$SCRIPT_DIRECTORY/extract-commit-msg.sh" "$COMMIT_EDITMSG_FILE")"
	readonly MESSAGE

	if [[ -z $MESSAGE ]]; then
		exit 1
	fi

	echo "$MESSAGE" >"$TEMP_FILE"
}

PATTERN="^\(=\|-\)\+"
ADDITIONAL_WORD="MD003/heading-style/header-style"
readonly PATTERN
readonly ADDITIONAL_WORD

# Avoid MD003
# https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md003---heading-style
# Because MD003 in dprit can't be disabled.
# MD003 in markdownlinter is disabled.
function replace_lines_with_only_symbols_to_avoid_MD003() {
	sed --in-place "s#${PATTERN}\$#\0${ADDITIONAL_WORD}#g" "$TEMP_FILE"
}
function restore_lines_with_only_symbols() {
	sed --in-place "s#\(${PATTERN}\)${ADDITIONAL_WORD}#\1#g" "$TEMP_FILE"
}

function clean_up_files() {
	restore_lines_with_only_symbols

	mv "$TEMP_FILE" "$COMMIT_EDITMSG_FILE"
}

function format() {
	function run_dprint() {
		dprint fmt "$TEMP_FILE"
	}

	run_dprint
}

extract_commit_msg_to_temp_file

replace_lines_with_only_symbols_to_avoid_MD003

format

result="$?"

clean_up_files

exit "$result"
