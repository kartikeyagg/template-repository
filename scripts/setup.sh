#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

function info() {
	printf "\n%s\n" "${1}"
}

function __setup_shell_tools() {
	info "Setup shell tools"

	function __setup_formatter() {
		go install mvdan.cc/sh/v3/cmd/shfmt@latest
	}
	function __setup_linter() {
		cargo install shellharden
	}

	__setup_formatter
	__setup_linter
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
	function __setup_linter() {
		# Use `python -m pip` instead of `pip`.
		# https://snarky.ca/why-you-should-use-python-m-pip/
		python -m pip install --upgrade yamllint --user
	}

	__setup_formatter
	__setup_linter
}
function __setup_github_actions_linter() {
	info "Setup GitHub Actions linter"

	go install github.com/rhysd/actionlint/cmd/actionlint@latest
}
function __setup_git_hooks() {
	info "Setup git hooks manager"

	python -m pip install --upgrade pre-commit

	pre-commit install --overwrite \
		--hook-type pre-commit
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

	__setup_shell_tools
	__setup_json_tools
	__setup_yaml_tools
	__setup_github_actions_linter
	__setup_git_hooks
	__setup_natural_language

	info "Setup Complete"
}

setup
