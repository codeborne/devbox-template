#!/bin/sh
# Re-apply the firewall inside the running devbox, without a full restart.
# Runs the bind-mounted init-firewall.sh (your live edits under .devbox/)
# as root, since node holds no privileges inside the container. Use after
# editing the allow-list; for a throwaway single host, adding the IP to the
# `allowed-domains` ipset is less disruptive than a full re-apply.
#
# Runs from its own directory (.devbox) so compose resolves docker-compose.yml and .env
# (COMPOSE_PROJECT_NAME) exactly as an in-directory invocation would.
set -e
cd "$(dirname "$0")"
exec docker compose exec -u 0 app bash /workspace/.devbox/init-firewall.sh
