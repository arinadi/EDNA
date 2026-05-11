# Phase 4: Agent Prompt (Iterative Agentic Coding)

**Goal:** Create `agent_prompt.md` — the battle-ready execution prompt.

### Operational Guidelines

1. **Context Amnesia Prevention (CRITICAL):** Include rule: "Before starting a new module, review codebase from previous modules."
2. **Pacing:** Strict pause after every module for user approval.
3. **Mandatory Sections:**
   * **Tools & Capabilities**
   * **Context Links**
   * **Data Initialization Strategy**
   * **File & Folder Conventions**
   * **Validation Commands**
   * **Automated Acceptance Gate** (Security scan, binary criteria)
   * **Self-Reflection Step** (Security, duplication, performance)
   * **Failure Protocol** (Max 3 fix attempts → `git revert`)
   * **Evaluation Loop** (Every 3 modules)

### Structure
Use the [Agent Prompt Template](../templates/agent_prompt.md).
