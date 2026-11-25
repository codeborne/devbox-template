#!/bin/sh
# Rebuild and restart the devbox, then start Claude Code in it with Remote Control
# (from the host). Any arguments go to `claude remote-control`, for example
# `--name <session name>`.
#
# The interactive zsh is deliberate: ~/.zshrc holds the `claude` wrapper that adds
# --permission-mode bypassPermissions for remote-control sessions, so the rule
# lives in one place.
#
# Runs from its own directory (.devbox) so compose resolves docker-compose.yml and .env
# (COMPOSE_PROJECT_NAME) exactly as an in-directory invocation would.
set -e
cd "$(dirname "$0")"
./restart.sh
exec docker compose exec -u node app zsh -ic 'claude remote-control "$@"' zsh "$@"
