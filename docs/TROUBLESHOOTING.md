# Troubleshooting

## Check service status and logs

Run on the host:

```bash
docker compose ps
bash bin/logs.sh app
bash bin/logs.sh db
```

The application shell is:

```bash
bash bin/shell.sh
```

## Port already allocated

Change the host port in `.env`:

```dotenv
APP_HTTP_PORT=8081
```

Then restart the stack and use `http://localhost:8081/`.

## Cache or generated files are not writable

The entrypoint assigns the cache and document volumes to Apache’s `www-data`
user. Rebuild and restart after changing the runtime image:

```bash
bash bin/stop.sh
bash bin/start.sh
```

Do not solve this by making the entire source tree world-writable.

## Source changes are not visible

Confirm the edited file is under host `app/`, not inside the container’s
temporary filesystem. Confirm the source mount with:

```bash
docker compose exec app pwd
docker compose exec app ls -la /var/www/html
```

Clear Laminas configuration cache when changing configuration:

```bash
docker compose exec app php bin/clear-config-cache.php
```

## Database connection or missing-table errors

Confirm both services are running:

```bash
docker compose ps
```

The application database hostname is `db`, not `localhost`. If the database
has been reset or was newly created, restore the local dump explicitly:

```bash
bash bin/restore-database.sh
```

## Login or cart state disappeared

A database restore or reset replaces the `tblSessions` data used by the
application. Losing an existing login or cart after either operation is
expected; log in again and recreate the cart.

## Docker Desktop or architecture issues

On macOS Apple Silicon, Docker Desktop should run the ARM64-compatible image
build. On Windows 11, use WSL 2 integration. If Docker cannot start the image,
check Docker Desktop’s resource allocation and run:

```bash
docker version
docker compose version
```

