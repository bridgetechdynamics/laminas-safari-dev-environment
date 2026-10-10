# Local maintenance mode

The development environment supports the application’s maintenance page
without using the DEV server’s hard-coded filesystem path.

## Enable

From the project root:

```bash
bash bin/maintenance-on.sh
```

The script creates this ignored marker:

```text
app/.maintenance
```

Refresh the application at <http://localhost:8080/>. Apache rewrites normal
requests to `/maintenance.php`, which returns HTTP 503 and serves the
application’s maintenance page.

## Disable

```bash
bash bin/maintenance-off.sh
```

Refresh the browser and the normal Laminas front controller will handle the
request again. No container rebuild or restart is required.

## Behavior

- `/maintenance.php` remains reachable so the maintenance response can render.
- `/maintenance.html` remains reachable for direct troubleshooting.
- `/newsletter/` remains reachable so the maintenance page can load its local
  assets.
- All other paths are sent to the maintenance response while the marker exists.
- The marker is local-only and ignored by Git.

This configuration is adapted from the DEV server rules in `htaccess.dev.out`.
The DEV server uses a different document root, so its absolute path must not be
copied into the local container configuration.

