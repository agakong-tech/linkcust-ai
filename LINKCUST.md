# LinkCust AI

LinkCust AI is the product layer built on top of the Twenty platform kernel.

## Product direction

LinkCust AI extends Twenty from an open CRM foundation into an AI-native enterprise platform for customer operations, intelligent agents, workflow automation, data access, and business-system integration.

## Architecture principles

1. **Keep Twenty as the platform kernel.** Reuse its workspace, identity, object model, UI, CRM, workflow, metadata, permissions, and application infrastructure wherever practical.
2. **Prefer extension over core modification.** LinkCust-specific capabilities should live outside Twenty core whenever possible.
3. **Isolate external runtimes.** Python agent runtime, RPA, WeCom, data services, and similar capabilities should communicate with the main platform through stable APIs/events instead of being embedded into Twenty internals.
4. **Keep upstream compatibility.** Minimize invasive edits under `packages/` so upstream Twenty changes remain reasonably mergeable.
5. **Treat agents as business operators, not chat-only features.** Agents may call workflows, business APIs, RPA, data services, and skills under auditable permission boundaries.

## Repository boundaries

- `packages/`: Twenty platform code and the minimum product-level modifications required by LinkCust.
- `linkcust/`: LinkCust-owned product modules, agent definitions, skills, workflows, integrations, and shared contracts.
- `services/`: independently deployable services such as agent runtime, WeCom gateway, RPA gateway, and data services.
- `docs/`: LinkCust architecture, ADRs, product decisions, and development documentation.

See `UPSTREAM.md` for rules governing synchronization with Twenty upstream.
