# MERPATI-CMS — Agent Prompt for Agentic Coding

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

> Phase 4 deliverable per Agent EDNA methodology.

---

## **Context Links (CRITICAL)**

Before you write any code, you must deeply understand the project by reading the following documents:
- **`PRD.md`**: Core features, user flows, and project goals (Vercel Free Tier constraint, invite-only auth).
- **`design.md`**: Visual layout definitions, admin theme (shadcn), and mock UI structures.
- **`modules.md`**: The UI components definition and their exact API payload boundaries.
- **`techstack.md`**: The DB schema definitions (Drizzle ORM), Next.js architecture, and single RPC endpoint strategy.

**Note**: Do not look for duplicated info. Each file contains specific aspects of the architecture (DRY Principle). Combine their contexts to build the app autonomously.

---

## **Phase 1: Init "Hello World"**

**Goal:** Scaffold the foundation repository with `Next.js App Router`, tailwind config, and CI/CD basics.

**Validation Commands:**
- `pnpm install`
- `pnpm run build`
- `pnpm run lint`

### **🛑 User Review Checkpoint**
Pause here. Awaiting review to begin Phase 2.

---

## **Phase 2: Design & UI**

**Goal:** Build the interactive UI components for Admin using mock data, strictly following `design.md` layout descriptions and `modules.md` component boundaries. Set up the `shadcn/ui` integration.

**Validation Commands:**
- `pnpm run build`
- `pnpm run lint`

### **🛑 User Review Checkpoint**
Pause here. Awaiting review to begin Phase 3.

---

## **Phase 3: Backend Integration**

**Goal:** Implement the Neon DB connection (`raw sql init` and Drizzle schema from `techstack.md`), the core `/api/rpc` serverless endpoint from `modules.md`, and Auth.js. Connect your UI components to these live endpoints. Hydrate public pages via Handlebars templates.

**Validation Commands:**
- `pnpm run build`
- `pnpm run lint`

### **🛑 User Review Checkpoint**
System ready for E2E testing. Awaiting next instructions.
