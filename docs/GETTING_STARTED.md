# Getting started

This guide describes the verified editable-source workflow. Commands in this
document are run on the host unless explicitly marked as container commands.

## 1. Install prerequisites

Install and start Docker Desktop:

- macOS: Docker Desktop for Mac.
- Windows 11: Docker Desktop with the WSL 2 backend and WSL integration enabled
  for the Ubuntu distribution used for this project.

Git and a text editor are also required. Keep the project in the WSL home
directory rather than under a mounted Windows path when using WSL.

## 2. Prepare the project

From the project root, copy the safe configuration template:

```bash
cp .env.example .env
chmod 600 .env
```

Review `.env` before starting. Use development-only SMTP and CAPTCHA values.
Do not copy production credentials into it. Values containing spaces must be
quoted because `.env` is loaded by shell scripts.

The expected private payloads are:

```text
input/laminas-app.tar.gz
input/horsesns_safari-dev.sql.gz
```

They are ignored by Git and must not be uploaded to the repository.

The runtime configuration template is committed because it contains only
environment-variable lookups. Actual passwords and service keys remain in the
untracked `.env` file.

## 3. Start the application

```bash
bash bin/start.sh
```

The command extracts the source archive into ignored `app/`, builds the local
PHP/Apache image, starts MariaDB, installs Composer dependencies, and starts
the application. Open:

```text
http://localhost:8080/
```

The host port can be changed in `.env` with `APP_HTTP_PORT`.

## 4. Restore local development data

The database starts with an empty schema. Restore the private dump explicitly:

```bash
bash bin/restore-database.sh
```

Reloading or restarting the application does not restore the database. A
restore replaces the local database contents, including database-backed
sessions; it is therefore expected that a cart or login session may disappear
after a restore.

## 5. Edit application source

Edit files on the host under:

```text
app/
```

The directory is mounted into the container at `/var/www/html`. PHP and view
source edits should be visible after refreshing the browser. Composer
dependency changes may require restarting or rebuilding the application.

For container-side inspection:

```bash
bash bin/shell.sh
```

## 6. Stop and reset

Stop the stack while preserving local volumes:

```bash
bash bin/stop.sh
```

Delete this project’s database, cache, vendor, and generated-document volumes:

```bash
bash bin/reset-local.sh
```

The reset command displays its target and requires typing `RESET`. Afterward,
run `bin/start.sh` and explicitly restore the database if appropriate.
