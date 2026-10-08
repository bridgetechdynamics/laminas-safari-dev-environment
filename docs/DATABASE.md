# Local database workflow

The local stack uses MariaDB 10.6.28 in a project-scoped Docker volume. The
application connects to the Compose service name `db`; it never connects to a
remote or production database.

## Payload

The current private payload is expected at:

```text
input/horsesns_safari-dev.sql.gz
```

It contains a MariaDB schema and data dump, including `CREATE DATABASE` and
`USE` statements. Do not distribute it to other developers until it has been
reviewed for real PHI, addresses, credentials, uploaded content, and other
sensitive information. The fact that the source is the DEV database does not
replace that review.

## Restore

Start the local database and import the payload with:

```bash
bash bin/restore-database.sh
```

The command imports into the local `db` container using the local root password
from `.env`. It does not contact any external database.

## Reset

To remove the local database and application writable volumes:

```bash
bash bin/reset-local.sh
```

The command shows the Compose project name and requires typing `RESET`. After
resetting, start the stack and explicitly restore the dump again if it is
approved for the current developer:

```bash
bash bin/start.sh
bash bin/restore-database.sh
```

Future YAML fixtures may be loaded after schema creation, but that mechanism is
not part of the proof-of-concept implementation yet.

