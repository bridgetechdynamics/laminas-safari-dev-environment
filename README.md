# Laminas Safari Developer Environment

Local Docker Desktop environment for editable Laminas Safari development.

This is currently a proof of concept. The application source is supplied as a
private archive while the project is prepared for a future GitHub repository
workflow.

## Quick start

Prerequisites: Docker Desktop must be installed and running. On Windows 11,
use Docker Desktop with the WSL 2 backend and run these commands from the WSL
terminal.

From the project root:

```bash
cp .env.example .env
chmod 600 .env
bash bin/start.sh
```

Open <http://localhost:8080/>.

The first start extracts `input/laminas-app.tar.gz` into the ignored `app/`
directory and builds the local development image. Place the database dump at
`input/horsesns_safari-dev.sql.gz`, then restore it explicitly:

```bash
bash bin/restore-database.sh
```

The dump is currently considered private and not approved for distribution
until it has completed a sensitive-data review.

For the complete onboarding procedure, see [Getting started](docs/GETTING_STARTED.md).

## Common commands

```bash
bash bin/start.sh
bash bin/stop.sh
bash bin/logs.sh app
bash bin/logs.sh db
bash bin/shell.sh
bash bin/reset-local.sh
```

`reset-local.sh` deletes only this project’s Compose volumes and requires an
explicit `RESET` confirmation. Use `bash bin/reset-local.sh --yes` only when
the deletion is intentional.

The editable workflow mounts `app/` into the application container. Source
edits should be visible without rebuilding the image; dependency changes may
require restarting the stack or rebuilding it.

Host files are edited under `app/`. The container path for the same source is
`/var/www/html`; use `bash bin/shell.sh` only for inspection or container-side
commands.

## Safety boundaries

- Never put `.env`, database dumps, private keys, or service credentials in Git.
- Local Mercury/payment behavior is mocked.
- Real Mercury test-card transactions belong to QA/Integration environments.
- Use development SMTP and CAPTCHA credentials only.
- MariaDB is available only inside the local Compose network.

See [DESIGN.md](DESIGN.md) and [docs/DATABASE.md](docs/DATABASE.md) for the
current contract and database handling rules. External service behavior is
documented in [docs/SERVICES.md](docs/SERVICES.md), and common failures are
covered in [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md). Current POC
test status is tracked in [docs/POC_VALIDATION.md](docs/POC_VALIDATION.md).

Repository ownership and the future GitHub migration are documented in
[docs/REPOSITORY_BOUNDARIES.md](docs/REPOSITORY_BOUNDARIES.md) and
[docs/SOURCE_REPOSITORY_READINESS.md](docs/SOURCE_REPOSITORY_READINESS.md).
