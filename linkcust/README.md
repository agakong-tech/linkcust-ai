# LinkCust Product Layer

This directory contains LinkCust-owned product capabilities that should remain separate from Twenty core whenever possible.

Planned boundaries:

- `modules/` — LinkCust business modules.
- `integrations/` — product-level external-system integrations.
- `agents/` — agent definitions and product-facing agent configuration.
- `skills/` — skill manifests, metadata, and registration; executable business capabilities may live behind service APIs.
- `workflows/` — LinkCust business workflow definitions and orchestration contracts.
- `shared/` — contracts and utilities shared by LinkCust-owned modules.

Create subdirectories as implementation begins rather than adding empty Git directories.
