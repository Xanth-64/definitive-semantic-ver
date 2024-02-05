#!/bin/bash

# Check for any Commit with the word "BREAKING CHANGE" in the commit message
git fetch origin +refs/pull/${{ github.event.pull_request.number }}/merge
git log --pretty=format:"%s" origin/main..FETCH_HEAD | grep -i "BREAKING CHANGE" > breaking_changes.txt

# If there are breaking changes, and the base branch is not development, fail the build
if [ -s breaking_changes.txt ] and [ ${{ github.event.pull_request.base.ref }} != "development" ]; then
    echo "Breaking Changes Detected on a non-development branch. Please merge into development first."
    exit 1
else
    echo "No breaking changes. Proceeding with the build."
    exit 0
fi