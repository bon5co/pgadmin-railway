# pgAdmin 4 on Railway: thin wrapper over the official image.
# What it adds: a boot-time administrator from one generated password (the stock
# image refuses to start without PGADMIN_DEFAULT_EMAIL / PGADMIN_DEFAULT_PASSWORD
# and a deploy form would otherwise ask for both), the Railway-injected PORT
# (upstream listens on 80), settings for running behind Railway's HTTPS edge, no
# postfix, and a start as root so the upstream entrypoint can chown the
# root-owned volume at /var/lib/pgadmin and then drop to uid 5050 itself.
# upstream: pgadmin-org/pgadmin4
FROM dpage/pgadmin4:9.19.0@sha256:3591b3d02910dcd817dec6fcaa681c278ba6966945283dd0ea0042731c330c83

USER root

ENV PGADMIN_DEFAULT_EMAIL=admin@pgadmin.dev \
    PGADMIN_DISABLE_POSTFIX=1 \
    PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED=False \
    PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION=False \
    PGADMIN_CONFIG_UPGRADE_CHECK_ENABLED=False \
    PGADMIN_CONFIG_PROXY_X_HOST_COUNT=1

COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
