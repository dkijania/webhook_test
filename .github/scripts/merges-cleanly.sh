#!/bin/bash

BRANCH=$1
CURRENT=${GITHUB_HEAD_REF:-${GITHUB_REF#refs/heads/}}
echo 'Testing for conflicts between the current branch `'"${GITHUB_HEAD_REF}"'` and `'"${BRANCH}"'`...'

# Adapted from this stackoverflow answer: https://stackoverflow.com/a/10856937
# The git merge-tree command shows the content of a 3-way merge without
# touching the index, which we can then search for conflict markers.

# Fetch a fresh copy of the repo
git fetch origin
# Check mergeability

curl -s https://github.com/dkijania/webhook_test/branches/pre_mergeable/${BRANCH}...${CURRENT} | grep "Able to merge"

RET=$?

if [ $RET -eq 0 ]; then
  # Found a conflict
  echo "[ERROR] This pull request conflicts with $BRANCH, please open a new pull request against $BRANCH at this link:"
  echo "https://github.com/dkijania/webhook_test/compare/${BRANCH}...${CURRENT}"
  exit 1
else
  echo "No conflicts found against upstream branch ${BRANCH}"
  exit 0
fi