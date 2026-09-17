# Upstream Twenty Synchronization

LinkCust AI is forked from Twenty. This document defines how we keep the fork maintainable while developing LinkCust-specific capabilities.

## Core rule

Prefer LinkCust extension points over modifying Twenty core.

A change under `packages/` should be made only when at least one of the following is true:

- the capability cannot reasonably be implemented in `linkcust/` or an external service;
- a product-wide UI or platform behavior must change;
- an extension point required by LinkCust does not yet exist;
- maintaining an adapter would be more complex or fragile than a small, well-contained core change.

When a core change is necessary, keep it narrow and document why it exists.

## Upstream remote

Recommended local Git configuration:

```bash
git remote add upstream https://github.com/twentyhq/twenty.git
git fetch upstream
```

`origin` should point to the LinkCust repository. `upstream` should point to Twenty.

## Sync strategy

1. Fetch upstream regularly rather than allowing a large divergence to accumulate.
2. Review upstream release notes and migrations before merging.
3. Merge or rebase upstream changes in a dedicated maintenance change when practical.
4. Resolve conflicts in favor of preserving upstream behavior unless a documented LinkCust product requirement intentionally differs.
5. Run relevant Twenty and LinkCust tests after synchronization.
6. Record significant intentional divergences as ADRs under `docs/adr/`.

## Avoid

- renaming Twenty packages solely for branding;
- moving large portions of the original monorepo;
- global search-and-replace of internal `twenty-*` identifiers;
- duplicating infrastructure already provided by Twenty;
- mixing WeCom/RPA/agent-runtime implementation details deeply into Twenty core.

Branding presented to end users may be LinkCust while internal upstream-compatible package names remain unchanged.
