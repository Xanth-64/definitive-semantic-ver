#!/bin/bash
PR_NUMBER=$1
BASE_BRANCH=$2

# Check for any Commit with the word "BREAKING CHANGE" in the commit message
git fetch origin +refs/pull/${{ PR_NUMBER }}/merge
git log --pretty=format:"%s" origin/main..FETCH_HEAD | grep -i "BREAKING CHANGE" > breaking_changes.txt

# If there are breaking changes, and the base branch is not development, fail the build
if [ -s breaking_changes.txt ] and [ ${{ BASE_BRANCH }} != "development" ]; then
    echo "Breaking Changes Detected on a non-development branch. Please merge into development first."
    exit 1
else
    echo "No breaking changes. Proceeding with the build."
    exit 0
fi