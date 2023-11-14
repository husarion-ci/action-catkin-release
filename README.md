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

Afterwards, `catkin_prepare_release` is used to bump the version in the package.xml and create a new tag. This action doesn't push the tag. 

The resault is two new commits.

The action should be used in tandem with actions:
- actions-ecosystem/action-get-latest-tag
- actions-ecosystem/action-bump-semver
- actions-ecosystem/action-push-tag

See: https://github.com/actions-ecosystem/action-bump-semver

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
new_version:
    description: New version that will be published
    required: true
```

## Example

TODO:
