#!/bin/bash

set -e

echo "Bump: $INPUT_BUMP"

cd $GITHUB_WORKSPACE

echo -e "machine github.com\nlogin ${INPUT_GITHUB_TOKEN}" > ~/.netrc
git config user.name "${INPUT_GIT_USER}"
git config user.email "${INPUT_GIT_EMAIL}"

git fetch --tags --prune --unshallow

catkin_generate_changelog -y --only-merges

git add $(find . -name CHANGELOG.rst)
git commit -m "Update changelog"

catkin_prepare_release --no-push --version $INPUT_NEW_VERSION -y
