# https://docs.ros.org/en/humble/How-To-Guides/Releasing/First-Time-Release.html
#!/bin/sh

set -e

echo "Bump: $INPUT_BUMP"

cd $GITHUB_WORKSPACE

echo -e "machine github.com\nlogin ${INPUT_GITHUB_TOKEN}" > ~/.netrc
git config user.name "${INPUT_GIT_USER}"
git config user.email "${INPUT_GIT_EMAIL}"

if [ "$INPUT_FIRST_RELEASE" == "true" ]; then 
    catkin_generate_changelog --only-merges --print-root -y
else
    catkin_generate_changelog -a --only-merges --print-root -y
fi

catkin_prepare_release --no-push --version $INPUT_NEW_VERSION -y
