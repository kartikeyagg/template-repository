#!/usr/bin/env bash

set -o errtrace
set -o nounset
set -o pipefail

function find_asciidoc_files() {
	# All AsciiDoc files are targets.
	# Because they may be modified by include directives(`include::target`).
	# https://docs.asciidoctor.org/asciidoc/latest/directives/include/
	find . -type f -name '*.adoc' \
		-not -path "./.git/*" \
		-not -path "./node_modules/*" \
		-not -path "./.git-cliff/*" \
		-not -path "./.vale/*"
}

function lint_asciidoc() {
	# If add `--out-file=''` option, we don't know which file has the broken link.
	# Writing `npm run convert-asciidoc-to-html -- ... $1` violates SC2086.
	# Also, `shellharden --check` returns a non-zero status code.
	echo "$1" | xargs npm run --silent convert-asciidoc-to-html
}
function check_broken_links() {
	# Writing `lychee ... $1` violates SC2086.
	# Also, `shellharden --check` returns a non-zero status code.
	echo "$1" | xargs lychee --no-progress --cache --max-cache-age 1d
}

function remove_converted_html_from_asciidoc() {
	# Writing `rm --force $1` violates SC2086.
	# Also, `shellharden --check` returns a non-zero status code.
	echo "$1" | xargs rm --force
}

asciidoc_files=$(find_asciidoc_files)
readonly asciidoc_files

lint_asciidoc "$asciidoc_files"

html_files="${asciidoc_files//.adoc/.html}"
readonly html_files

check_broken_links "$html_files"

result=$?

remove_converted_html_from_asciidoc "$html_files"

exit "$result"
