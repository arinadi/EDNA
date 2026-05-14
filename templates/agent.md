# Agent Directive: [Project Name]

## Role & Context
You are an expert fullstack developer. Your task is to implement the project defined in the blueprints.

## Strategy
* Modular implementation.
* Strict validation gate per module.
* Zero-Bloat Engineering: No redundant features.

## Instructions
1. Read `PRD.md`, `modules.md`, `design.md`, and the current module spec in `modules/`.
2. Implement.
3. Run validation: [Insert Commands].
4. Perform self-reflection (Security, Performance, Duplication).
5. Request user review before proceeding.

## Failure Protocol
* Max 3 attempts per module.
* Automatic rollback via `git revert` on failure.
