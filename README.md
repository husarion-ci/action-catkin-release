# action-catkin-release
GitHub action to automate catkin version bumps and releases.

# Requirements

Since this action uses catkin to bump versions and prepare releases,
it will only work with catkin packages.

The action also requires the code to be checked out before it is run (e.g. via `actions/checkout`).

# Overview

The action uses `catkin_generate_changelog` to update package changelogs.
Only merge commits are included, so the recommended worklow is to update the main
branch via Pull Requests, and add short descriptions of changes in the PR commit
messages.

Afterwards, `catkin_prepare_release` is used to bump the version, then the code and
the tag are pushed back to the **same branch**.

The action can be used in tandem with `husarion-ci/action-get-version-bump`.
A `bump::` command can then be included in the PR body, and can be used to
instruct this action which version to bump in the release.

## Inputs

The action has the following inputs:

```
github_token:
    description: GitHub token to authenticate with
    required: true
git_user:
    description: username for the commit message
    required: true
git_email:
    description: e-mail address for the commit message
    required: true
bump:
    description: Which version to bump (major, minor or patch)
    required: true
    default: patch
```

## Outputs

The action currently has no outputs.

## Example

Below is an example of the action being used in a workflow.
The job is triggered when a PR is merged into the master branch,
and the action is used to automatically bump the 'patch' version.

```
name: Automatic Catkin Release
on:
  pull_request:
    branches: master
    types: [closed]

jobs:
  catkin-release:
    if: github.event.pull_request.merged == true
    name: Bump version
    runs-on: ubuntu-latest
    needs: get-bump
    steps:
      -
        name: Checkout
        uses: actions/checkout@v2
      -
        name: Catkin release
        id: catkin-release
        uses: husarion-ci/catkin_release@v0.1.0
        with:
          bump: patch
          github_token: ${{ secrets.GITHUB_TOKEN }}
          git_user: action-bot
          git_email: action-bot@action-bot.com
```