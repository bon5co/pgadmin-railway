# pgadmin-railway

Wrapper image for running the official [pgAdmin 4](https://hub.docker.com/r/dpage/pgadmin4) image on
[Railway](https://railway.com). Published as `ghcr.io/bon5co/pgadmin-railway:9.19.0`.

It changes the following and leaves everything else, including every upstream `PGADMIN_*` variable, alone:

1. **Starts as root** so the upstream entrypoint can chown the root-owned Railway volume at `/var/lib/pgadmin` and then drop to the pgAdmin user (uid 5050).
2. **Refuses to start with an empty `PGADMIN_DEFAULT_PASSWORD`**, so a deploy never boots with no administrator password.
3. **Honours `$PORT`** by exporting it as `PGADMIN_LISTEN_PORT`.
4. **Bakes the settings that must not be template variables**: a valid administrator email (`admin@pgadmin.dev`), Postfix disabled, no master password prompt, the session no longer pinned to client IP and user agent (the Railway edge address rotates per request), the update check off.

## Variables

| Variable | Purpose |
|---|---|
| `PGADMIN_DEFAULT_PASSWORD` | Required. Password of the administrator `admin@pgadmin.dev`. |

Data (users, saved servers, settings) lives on the volume mounted at `/var/lib/pgadmin`.
