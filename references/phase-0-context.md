# Phase 0: Project Context

**Goal:** Establish the foundation before any design begins.

### 🔴 The 5 Mandatory Questions
Before writing a single line of the PRD, you MUST answer these:
1. **The "Why":** Why does this exist? What happens if we DON'T build it?
2. **The "Who":** Who is the specific user? (e.g., "Non-technical HR manager", not "everyone").
3. **The "Core":** What is the ONE feature that makes this project viable? (The MLP - Minimum Lovable Product).
4. **The "Lanscape":** Are we building on top of something (Extension), from scratch (Greenfield), or replacing something (Rewrite)?
5. **The "Success":** How do we measure if this works? (Binary criteria).

### 🛠️ Project Mode Presets
Choose a mode to apply default engineering standards:

| Mode | Focus | Validation Defaults |
| :--- | :--- | :--- |
| `web-app` | Scalability & UX | E2E (Playwright/Cypress), Unit, Build, Lint. |
| `mobile` | Performance & OS Native | Device tests, Platform-specific build checks. |
| `cli-tool` | Speed & Reliability | Integration tests, Smoke tests, Distribution check. |
| `data-pipeline` | Integrity & Latency | Data validation, Schema checks, Dry-runs. |
| `ml-service` | Accuracy & Evaluation | Eval metrics, Benchmarking, Drift detection. |

### Operational Guidelines

1. **Constraint Framework:** Document budget, timeline, team size, and regulatory requirements (e.g., GDPR, HIPAA).
2. **Asset Audit:** Identify existing repos, databases, APIs, or infrastructure that MUST be integrated.
3. **Zero-Tolerance:** Identify any feature that "sounds nice" but isn't part of the "Core". Mark it for deferred consideration.

**"I never look back! It distracts from the 'now'!"**
