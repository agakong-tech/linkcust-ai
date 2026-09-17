# LinkCust Services

This directory is reserved for independently deployable LinkCust backend services that should not be coupled to the Twenty runtime.

Expected services may include:

- `agent-runtime/` — Python/Pydantic AI runtime when capabilities require an external agent execution layer.
- `wecom-gateway/` — WeCom messaging, identity mapping, and event ingress/egress.
- `rpa-gateway/` — controlled access to Playwright and other RPA capabilities.
- `data-service/` — normalized business-data and analytics APIs.

Services should expose stable APIs/events and enforce tenant, identity, permission, audit, and idempotency requirements at their boundaries.

Only create a service when an actual deployment boundary is needed. Do not duplicate capabilities already provided cleanly by Twenty.
