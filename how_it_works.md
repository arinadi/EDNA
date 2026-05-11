# How It Works: Agent EDNA
## *Technical Deep Dive into Software Context Engineering*

---

### 1. The Engineering Crisis: Token Entropy & Context Loss 🌪️
Standard LLM interactions suffer from **Token Entropy**. As project size increases, the relevance of provided context degrades.

*   **The Context Window Barrier:** LLMs have fixed limits. Even with large windows (e.g., 128k+), accuracy drops as the window fills—a phenomenon known as **"Lost in the Middle."**
*   **Context Amnesia:** In long-running projects, models lose track of early architectural constraints. This leads to **Hallucinations** where the AI proposes solutions that conflict with established patterns.
*   **The EDNA Solution:** We treat context as a first-class engineering object. By enforcing a modular, read-only plan structure, we keep the model focused on a narrow, high-fidelity subset of the project at any given time.

---

### 2. The Architectural Strategy: Phases 0-4 🏛️

#### **Phase 0 & 1: Precision Discovery**
Instead of guessing, EDNA uses **"Interrogative Prompting"** to extract latent requirements. The resulting `PRD.md` acts as the project’s "Source of Truth," preventing scope creep.

#### **Phase 2: Global Orchestration (The Master Blueprint)**
*   **Storage-Agnostic Modeling:** Data entities are defined by relationships and field types *before* selecting a database (SQL vs NoSQL). This prevents early-stage technical debt.
*   **Risk Chain Mapping:** We identify modules where failure causes cascading breaks (e.g., a change in Auth breaking Payments).

#### **Phase 3: Granular Specification**
Modules are limited to **~20 files** to ensure they fit within the high-accuracy "sweet spot" of the LLM’s context window. Each spec includes **Binary Pass/Fail Criteria**—removing the ambiguity of "done."

#### **Phase 4: Execution Loop (The Implementation Engine)**
EDNA generates an `agent_prompt.md` that governs the implementation agent. It enforces:
*   **Context Awareness:** Mandatory review of prior modules to ensure code reuse.
*   **Acceptance Gates:** Automated linting, type-checking, and security scans (blocking on HIGH severity findings).

---

### 3. The Agentic Lifecycle 🔄
*Collaboration flow between User, Architect (EDNA), and the Implementation Agent.*

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
    EDNA->>User: Precision Interrogation (Q&A)
    User->>EDNA: Detailed Requirements
    EDNA->>Plan: Create PRD.md
    EDNA->>User: Request PRD Review
    User->>EDNA: Approve PRD
    
    Note over EDNA: Phase 2: Global Architecture
    EDNA->>Plan: Create modules.md (Data Model & Tech)
    EDNA->>User: Request Architecture Review
    User->>EDNA: Approve Architecture
    
    Note over EDNA: Phase 3: Granular Specs
    EDNA->>Plan: Populate reference/ & modules/ (Specs)
    
    EDNA->>User: Request Final Blueprint Review
    User->>EDNA: Approve & Start Build
    
    Note right of Plan: Phase 4: Execution Loop
    EDNA->>Coder: Pass Prompt + Context
    Coder->>Plan: Read Current Module Spec
    Coder->>Coder: Implement & Test
    alt Success
        Coder->>Plan: Update logs & state (progress.json)
        Coder->>User: Request Module Review
    else Failure (Max 3 attempts)
        Coder->>Coder: Rollback (Git Revert)
        Coder->>User: Report Error & Context
    end
    
    User->>Coder: Approve Module
    Coder->>Plan: Proceed to Next Module
```

---

### 4. Technical Safeguards & State Management 🛡️

*   **Resilience (State Persistence):** `progress.json` tracks the `last_completed` module. If the session crashes, the agent resumes implementation from the exact point of failure without re-reading the entire history.
*   **Institutional Memory (ADRs):** Significant technical choices are logged in `decisions.md` using the **Architectural Decision Record** format. This provides the "Why" behind the "What," preventing future agents from reverting intentional designs.
*   **Context Management (Modularization):** By enforcing strict modularity, EDNA ensures that the coding agent only processes one small, self-contained module at a time. This keeps the active context well within the high-accuracy "sweet spot" of the LLM's memory, preventing the hallucinations that occur when a model is overwhelmed by a massive codebase.
*   **Failure Protocol:** A strict 3-attempt limit for bug fixes. If the agent cannot resolve a task, it must `git revert` to the last known-good state. **We never proceed with a broken build.**

---

### 5. Why It Works: The "No Capes" Principle ✂️
The core of EDNA's success is the **Elimination of Feature Bloat**. 
*   **Constraint-First Engineering:** By defining non-functional requirements (NFRs) like "Page load < 2s" upfront, we prevent the addition of heavy libraries or unnecessary abstractions.
*   **Binary Validation:** A task is only "Done" when the automated test suite and the binary criteria in the spec are both satisfied. No "maybe," no partial completions.

---

### 🛠️ Strategic Directives
*   **Precision is the Foundation.**
*   **Modularity is the Security.**
*   **Blueprint Immutability during Execution.**
