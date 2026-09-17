# Development and deployment model

## Branches

- `feature/*`: implementation work.
- `develop`: integration branch and source of the test deployment.
- `main`: reviewed production branch and source of the production deployment.

Normal flow:

```text
feature/* -> PR -> develop -> automatic test deployment
                         |
                         +-> PR/review -> main -> automatic production deployment
```

Direct pushes to `main` should be disabled with branch protection. A merged PR is the production approval event; Jenkins does not add a second manual approval.

## DNS

- test: `*.tt.linkcust.com`
- production: `*.t.linkcust.com`

The reverse proxy on each server terminates TLS and routes wildcard hosts to the LinkCust HTTP port on localhost.

## Artifact policy

Harbor is the source of truth for deployable artifacts. Jenkins publishes both a moving tag and an immutable branch/SHA tag:

- test: `develop`, `develop-<sha>`
- production: `latest`, `main-<sha>`

Target servers always deploy the immutable SHA tag supplied by Jenkins. Moving tags are for convenience only.

## Infrastructure isolation

Test and production use independent PostgreSQL, Redis, storage and secrets. Their addresses and credentials live only in `/opt/linkcust/.env` on the respective host or in an external secret manager.

No test application is permitted to connect to production infrastructure.

## Rollback

`deploy.sh` records the previously deployed immutable image tag before an update. If the post-deployment health check fails it invokes `rollback.sh` automatically. Database migrations that are not backward compatible require an explicit migration/rollback plan before merge to `main`.
