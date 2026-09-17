# LinkCust deployment

LinkCust uses Jenkins for CI/CD, Harbor for container artifacts, and Docker Compose on the target hosts.

## Environment mapping

- `develop` -> test host -> `*.tt.linkcust.com`
- `main` -> production host -> `*.t.linkcust.com`

Each host owns its own PostgreSQL, Redis, object storage and other infrastructure services. The application compose file does not start database or Redis containers.

## Server layout

Prepare the same directory on both servers:

```text
/opt/linkcust/
├── .env
└── deploy/
    ├── compose/
    │   └── docker-compose.yml
    └── scripts/
        ├── deploy.sh
        ├── health-check.sh
        └── rollback.sh
```

Copy `deploy/env/.env.example` to `/opt/linkcust/.env` and fill environment-specific values. Never commit the real `.env`.

## Jenkins credentials and variables

Credentials:

- `harbor-linkcust`: Harbor username/password
- `linkcust-test-ssh`: SSH credential for test server
- `linkcust-production-ssh`: SSH credential for production server

Global/job environment variables:

- `HARBOR_REGISTRY`, e.g. `harbor.example.com`
- `TEST_HOST`, e.g. `deploy@10.0.0.10`
- `PRODUCTION_HOST`, e.g. `deploy@10.0.0.20`

## Release flow

1. Merge/push to `develop`.
2. Jenkins builds `linkcust/linkcust-ai:develop-<sha>` and updates `:develop`.
3. Jenkins deploys the immutable SHA tag to test.
4. Open PR from `develop` to `main`.
5. After review and merge, Jenkins builds `main-<sha>` and updates `:latest`.
6. Jenkins deploys the immutable SHA tag to production.

Production and test deployments use the same compose definition and different `.env` values.
