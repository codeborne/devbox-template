# Devbox template

A firewalled devbox for Claude Code. The container starts as root, applies an outbound allow-list, and then
runs the workload as `node`.

## Use it in a new project

The files of this repo land in the project as the `.devbox` directory. The Dockerfile, the compose
file and the scripts assume that name.

1. In the project root, run:
   `git subtree add --prefix=.devbox git@github.com:codeborne/devbox-template.git main --squash`
   If you reach GitHub through an SSH alias from `~/.ssh/config`, put the alias in place of `git@github.com`.
2. Set `COMPOSE_PROJECT_NAME` in `.devbox/.env`.
3. Add the hosts of the project to `.devbox/allowed-domains.conf`.
4. If you want to connect to a server running inside the devbox, add the port to `.devbox/inbound-ports.conf`.
5. If the project needs a JDK other than 25, change `TEMURIN_VERSION` in the `Dockerfile`.
6. Run `.devbox/restart.sh` on the host.

`--squash` keeps the history of this repo out of the project. The project gets one commit with the
template files and one merge commit. The squash commit records the template commit it came from, so a
later `git subtree pull` merges only what changed since.

## Scripts

All scripts live in `.devbox` and run on the host.

- `.devbox/restart.sh` reads `GH_TOKEN` from 1Password, then rebuilds and
  starts the container. It needs the `op` CLI. Claude Code installs its plugin
  from GitHub with this token.
- `.devbox/shell.sh` opens a shell as `node`.
- `.devbox/firewall-restart.sh` applies the allow-list again without a
  rebuild.
- `.devbox/start-rc.sh` runs `restart.sh`, then starts Claude Code in the
  container with Remote Control. Arguments go to `claude remote-control`.

## Update a project

Run `.devbox/update.sh`. It pulls the template with `git subtree pull --squash`, which merges only
what changed since the last pull and keeps the project's own edits. If the project and the template
changed the same lines, git leaves conflict markers. Resolve them and commit.

With an SSH alias: `GITHUB_SSH=github-cb .devbox/update.sh`.

## Playwright

The build context is the repository root, so the image can read
`package-lock.json`. If the lock file pins Playwright, the image installs the
Chromium build of that version. If not, it installs the newest one.
`Dockerfile.dockerignore` limits the build context to the files the image needs.
