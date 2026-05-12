# How It Works: Agent EDNA
## *Technical Documentation: Software Context Engineering*

---

### Context Window Management
LLM performance depends on the quality and fidelity of the provided context. Agent EDNA addresses specific technical constraints:

*   **Context Window Limitations**
    LLMs have finite token limits. Accuracy decreases as the window reaches capacity, often leading to the **"Lost in the Middle"** effect where the model ignores critical instructions.
*   **Accuracy and Hallucination**
    In extended development cycles, models can lose track of initial architectural constraints. This leads to **hallucinations** where the AI generates code that conflicts with the established global state.
*   **Modular Isolation (Feature-First Strategy)**
    Unlike traditional layer-based approaches (Frontend vs. Backend), EDNA enforces **Feature-Driven Modularization**. Each module represents a complete, integrated feature (Design + Logic). 
    > **Rationale:** Layer-based development often leads to **"Dummy Debt,"** where UI components remain disconnected from backend logic. 
    >
    > **Fullstack Integration:** By delivering design and logic together, EDNA ensures components are functional from the start, preventing the **"silo effect"** where developers focus only on isolated layers.
*   **Dependency-Based Execution**
    Modules are executed in a strict sequence. A feature is only considered **"Done"** when the design, frontend, and backend integration are verified together.

---

### Client-Skill Integration Architecture
Agent EDNA operates as a standardized **AI Skill**, following a lifecycle of discovery, semantic matching, and execution within the host agent (Claude Code, Gemini CLI, etc.).

#### **Discovery & Indexing**
Upon startup, the host agent scans predefined directories. It parses the **YAML frontmatter** in `SKILL.md` to index:
*   **Skill Identity:** The internal name (`edna`).
*   **Activation Triggers:** Descriptive keywords used for semantic matching.
*   **Tool Manifest:** A declaration of allowed system tools (e.g., `read_file`, `write_file`, `run_shell_command`).

#### **Execution Lifecycle**
1.  **Semantic Triggering:** When user input matches the skill's description, the host agent loads the full instruction set from `SKILL.md` into the active context.
2.  **Context Isolation (Skill-Based):** To prevent token bloat, EDNA uses modular reference splitting:
    > **Reference Splitting:** By moving phase-specific instructions into the `references/` folder, the agent only loads core identity metadata at startup.
    >
    > **On-Demand Context:** Full phase details and templates are loaded only when relevant to the current task. This significantly reduces baseline token consumption.
3.  **Permission Handshake:** The host agent grants the skill access to specified tools, allowing it to manipulate the local filesystem and terminal.

---

### Comparative Analysis: Unmanaged Inference vs. Context Engineering
This section contrasts unmanaged LLM generation (one-shot prompting) with a managed context-engineering framework.

| Technical Aspect | One-Shot Prompting | Context-Managed Framework (EDNA) |
|:--- |:--- |:--- |
| **Input Analysis** | Direct code generation from ambiguous natural language instructions. | Structured extraction of implicit constraints prior to implementation. |
| **Logic Verification** | Relies on model probability for gap filling; prone to inconsistent logic. | Enforces **Binary Validation Criteria** within specs to ensure deterministic output. |
| **Context Management** | Combines multiple layers (UI/Auth/Logic) in a single turn, increasing context degradation. | Uses **Feature-Driven Modularization** to maintain a focused context window per task. |
| **Recovery Strategy** | Heuristic patching of errors, which propagates technical debt. | Implements a **3-Attempt Limit** followed by an automated **Git Rollback** to a verified state. |
| **State Persistence** | Transient; depends on immediate session history. | Persistent; uses `progress.json` and `decisions.md` (ADR) to maintain state across sessions. |

---

### Implementation Phases

#### **Phase 0 & 1: Requirement Discovery**
EDNA uses systematic discovery to extract requirements. The resulting `PRD.md` serves as the primary **technical specification**.

#### **Phase 2: Global Architecture**
*   **Storage-Agnostic Modeling:** Data entities are defined by relationships and field types. Implementation details are deferred to keep core logic decoupled.
*   **Risk Analysis:** Identification of critical dependencies and potential cascading failures across the module graph.

#### **Phase 3: Module Specification**
Modules are defined with a limited scope (typically under 20 files). Each specification includes **Binary Pass/Fail Criteria** for objective validation.

#### **Phase 4: Execution Loop**
EDNA generates an `agent_prompt.md` that directs implementation. It enforces dependency reviews and automated **validation gates** (linting, type-checking, and security scans).

---

### Operational Workflow

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant EDNA as Agent EDNA (Architect)
    participant Plan as Project Plan (Context)
    participant Coder as Coding Agent (Builder)

    User->>EDNA: Provide Idea
    
    Note over EDNA: Phase 0: Project Context
    EDNA->>EDNA: Assess Landscape & Select Mode
    
    Note over EDNA: Phase 1: Requirements & PRD
    EDNA->>User: Requirement Discovery
    User->>EDNA: Detailed Input
    EDNA->>Plan: Create PRD.md
    EDNA->>User: Request PRD Review
    User->>EDNA: Approve PRD
    
    Note over EDNA: Phase 2: Global Architecture
    EDNA->>Plan: Create modules.md (Data Model & Tech)
    EDNA->>User: Request Architecture Review
    User->>EDNA: Approve Architecture
    
    Note over EDNA: Phase 3: Granular Specs
    EDNA->>Plan: Populate reference/ & modules/ (Specs)
    
    EDNA->>User: Request Final Plan Review
    User->>EDNA: Approve & Start Build
    
    Note right of Plan: Phase 4: Execution Loop
    EDNA->>Coder: Pass Prompt + Context
    Coder->>Plan: Read Current Module Spec
    Coder->>Coder: Implement & Validate
    alt Success
        Coder->>Plan: Update logs & state (progress.json)
        Coder->>User: Request Module Review
    else Failure (Max 3 attempts)
        Coder->>Coder: Rollback (Git Revert)
        Coder->>User: Report Error State
    end
    
    User->>Coder: Approve Module
    Coder->>Plan: Proceed to Next Module
```

---

### 🛠️ Strategic Directives
*   **Precision in Requirements.**
*   **Isolation via Modularity.**
*   **Validation-Driven Finality.**
