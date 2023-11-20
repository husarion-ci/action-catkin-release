#!/bin/sh

set -e

echo "Bump: $INPUT_BUMP"

cd $GITHUB_WORKSPACE

echo -e "machine github.com\nlogin ${INPUT_GITHUB_TOKEN}" > ~/.netrc
git config user.name "${INPUT_GIT_USER}"
git config user.email "${INPUT_GIT_EMAIL}"

# https://docs.ros.org/en/humble/How-To-Guides/Releasing/First-Time-Release.html
if [ "$INPUT_FIRST_RELEASE" == "true" ]; then 
    catkin_generate_changelog -a --only-merges -y
else
    catkin_generate_changelog --only-merges -y
fi

git add $(find . -name CHANGELOG.rst)
git commit -m "Update changelog"

catkin_prepare_release --no-push --version $INPUT_NEW_VERSION -y

cat $(find . -name "CHANGELOG.rst")
