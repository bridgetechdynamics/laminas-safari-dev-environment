# Laminas Safari Developer Environment Design

## Status

Proof-of-concept design baseline. The project is initially driven by a supplied
application archive and may later switch to a GitHub source checkout without
changing the local runtime contract.

## Goals

- Run the Laminas application locally on macOS and Windows 11 with Docker
  Desktop.
- Make application source editable on the host.
- Keep every developer's application, database, and writable data isolated.
- Provide explicit, safe lifecycle commands for startup, logs, shell access,
  database restore, and destructive reset.
- Support comparison against a pinned, approved ECR image.
- Keep production credentials, payloads, and deployment infrastructure outside
  this project.

## Initial decisions

| Concern | Decision |
| --- | --- |
| Source delivery | Supplied `input/laminas-app.tar.gz` for the POC; future private/public GitHub checkout supported |
| Database | Local MariaDB 10.6.28; current dump is held pending sensitive-data review |
| Email | Real development SMTP, configured only through local secrets |
| CAPTCHA | Real test keys, configured only through local secrets |
| Mercury/payment | Mocked locally; real test-card transactions belong to QA/Integration |
| Application workflow | Editable source by default; optional pinned ECR image profile |
| Default URL | `http://localhost:8080/` |
| Host port | Configurable with `APP_HTTP_PORT`; `8080` by default |
| Reset | Explicit confirmation-required command scoped to this Compose project |
| Future fixtures | Leave an extension point; do not implement YAML injection in the POC |

## Proposed layout

```text
laminas-safari-dev-environment/
├── app/                  # extracted or checked-out source; ignored by Git
├── input/                # private archive and database payloads; ignored
├── runtime/              # local generated configuration; ignored
├── compose.yaml          # editable-source default stack
├── compose.image.yaml    # planned optional pinned-image override/profile
├── Dockerfile.dev        # development runtime with PHP/Apache dependencies
├── .env.example          # safe variable names and local defaults
├── .gitignore
├── bin/
│   ├── start.sh
│   ├── stop.sh
│   ├── logs.sh
│   ├── shell.sh
│   ├── extract-source.sh
│   ├── restore-database.sh
│   └── reset-local.sh
├── docs/
│   ├── GETTING_STARTED.md
│   ├── DATABASE.md
│   ├── SERVICES.md
│   └── TROUBLESHOOTING.md
├── DESIGN.md
└── DEVELOPER_ENVIRONMENT_PROJECT_HANDOFF.md
```

## Runtime architecture

The default Compose stack contains:

1. `db`: MariaDB 10.6.28 with a project-scoped named volume and health check.
2. `app`: a PHP 8.1/Apache development image with the application source
   mounted from `app/`.

The application container receives database and service settings through
environment variables. A generated local Laminas override will map the
application database connection to `db`, avoiding the archive’s default
`localhost` setting. Configuration cache clearing runs after configuration
changes and during startup when required.

The source mount must not obscure runtime dependencies or writable directories.
Composer dependencies, cache, generated documents, and other required writable
paths will therefore be assessed from the extracted source and assigned either
named volumes or ignored host paths.

## Source workflow

For the POC:

1. Validate that `input/laminas-app.tar.gz` exists.
2. Extract it into ignored `app/`.
3. Build the development runtime image.
4. Install dependencies into a controlled `vendor` location.
5. Mount editable application files into Apache’s `/var/www/html` document tree.

The future repository workflow should populate the same `app/` contract, so the
Compose and lifecycle commands remain unchanged.

## Database lifecycle

The database dump remains private and is not considered approved for developer
distribution until a data review confirms that it contains no real PHI,
addresses, credentials, or other sensitive information. The restore command
will require the payload explicitly and will never contact a remote database.

The reset command will:

1. Display the exact Compose project and local volume it will affect.
2. Require an explicit confirmation flag or confirmation response.
3. Stop the local stack.
4. Remove only this project’s database and generated writable data.
5. Recreate MariaDB.
6. Restore the approved local dump only when explicitly requested.

Future YAML fixtures can be added after schema creation without changing this
reset contract.

## External services

Local configuration will distinguish service modes clearly:

- SMTP uses development credentials and should support a safe recipient policy.
- CAPTCHA uses test credentials.
- Mercury uses a local mock adapter or mock endpoint.
- Real Mercury test-card flows are documented as QA/Integration-only.

No production endpoints or production credentials will be valid defaults.

## Image comparison workflow

The editable-source Compose stack is the default. An optional image override
will require an explicit immutable ECR image reference, preferably a full
deployment commit SHA. It will not use `latest`.

This workflow is planned but not part of the currently verified POC. The local
editable-source workflow should remain stable while it is added.

The two modes share the MariaDB and environment contract where possible, but
the image mode will not mount editable source and will be documented as a
packaged-image comparison workflow rather than a coding workflow.

## Verification targets

The first implementation should verify:

- Compose configuration resolves without production values.
- MariaDB becomes healthy and remains private to the Compose network.
- The application connects to MariaDB using `db` as its hostname.
- The homepage loads at `http://localhost:8080/`.
- A harmless source edit is visible without rebuilding the image.
- Logs and an application shell are accessible.
- Reset removes only local project data and can recreate the stack.
- No input payload, `.env`, runtime secret, or generated data is tracked.

## Current verification status

The local POC has been verified on Docker Desktop for:

- application startup and homepage access;
- editable host source changes appearing without an image rebuild;
- login and database-backed behavior;
- database restore;
- application and database logs;
- application shell access; and
- destructive reset followed by clean recreation.
