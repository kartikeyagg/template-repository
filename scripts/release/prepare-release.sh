#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

SCRIPT_DIRECTORY=$(dirname "$0")
readonly SCRIPT_DIRECTORY

VERSION=$(cog bump --dry-run --auto)
readonly VERSION

bash "$SCRIPT_DIRECTORY/generate-CHANGELOG.sh" "$VERSION"

git add --all
git commit --message "chore(release): prepare for $VERSION"

git tag "$VERSION" --message "$VERSION" --edit
