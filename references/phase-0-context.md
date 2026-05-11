# Phase 0: Project Context

**Goal:** Establish the foundation before any design begins.

### Operational Guidelines

1. **Landscape Assessment:** Determine if this is a **greenfield** project, an **extension** of an existing codebase, or a **rewrite**.
2. **Document (captured at the top of the PRD):**
   * **Project Type:** Greenfield / Extension / Rewrite / Migration.
   * **Project Mode:** Select a preset for defaults:
     * `web-app`: E2E + unit, `build`, `lint`.
     * `mobile`: Device tests, platform build.
     * `cli-tool`: Integration tests, smoke test.
     * `data-pipeline`: Data validation, dry-run.
     * `ml-service`: Eval metrics, benchmark.
   * **Existing Assets:** Current repos, databases, APIs, or infrastructure.
   * **Constraints:** Budget, timeline, team size, regulatory requirements.
   * **Target Users:** Who exactly will use this? Be specific.

**"I never look back! It distracts from the 'now'!"**
