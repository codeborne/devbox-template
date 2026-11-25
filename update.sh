#!/bin/sh
# Pull the latest devbox template into this directory (from the host or the devbox).
#
# The first install is `git subtree add`, see README.md. This script runs the matching
# `git subtree pull`. It merges only what changed in the template since the last pull,
# keeps the edits made here, and leaves git's usual conflict markers when both sides
# changed the same lines. Commit the result like any other merge.
#
# The subtree prefix comes from this script's own location, so it stays correct whether
# the repo root is one or more levels up.
#
# GITHUB_SSH replaces the part before the colon in the remote URL, for an SSH alias from
# ~/.ssh/config: `GITHUB_SSH=github-cb .devbox/update.sh`.
set -e
REPO="${GITHUB_SSH:-git@github.com}:codeborne/devbox-template.git"
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(git -C "$DIR" rev-parse --show-toplevel)"
cd "$ROOT"
exec git subtree pull --prefix="${DIR#"$ROOT"/}" "$REPO" main --squash -m "Update the devbox from the template"
