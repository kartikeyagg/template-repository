#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

function info() {
	printf "\n%s\n" "${1}"
}

function __setup_json_tools() {
	info "Setup JSON tools"

	function __setup_formatter() {
		cargo install dprint
	}

	__setup_formatter
}
function __setup_yaml_tools() {
	info "Setup YAML tools"

	function __setup_formatter() {
		cargo install dprint
	}

	__setup_formatter
}
function __setup_natural_language() {
	info "Setup natural language tools"

	function __setup_linter() {
		vale sync
	}

	__setup_linter
}

function setup() {
	info "Setup Start"

	__setup_json_tools
	__setup_yaml_tools
	__setup_natural_language

	info "Setup Complete"
}

setup
