# MERPATI-CMS — Implementation Instruction (for Agentic Coding)

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

> **ATTENTION AI AGENT:** You are to execute this instruction manual sequentially. Heavily reference `PRD.md`, `design.md`, and `techstack.md` for context on each step. You are free to determine the optimal file structures, code patterns, and specific implementations. **Focus on achieving the described goals and satisfying the logic constraints.** Do NOT skip validation commands. Run them in your terminal to ensure correctness before proceeding to the next phase.

---

## Phase 1: Init "Hello World"
**Goal:** Establish the foundation, ensure the application runs, builds, and lints without errors.

### Step 1.1: Project Setup
* **Goal:** Initialize a Next.js 15 App Router project using TypeScript and ESLint.
* **Logic/Constraint:** Use standard Next.js conventions. Tailor the setup according to the core stack described in `techstack.md`. Ensure dependencies are correctly installed.
* **Validation:** Clean initialization.

### Step 1.2: Environment & Backend Setup
* **Goal:** Create the basic wiring for the backend stack to prepare for development.
* **Logic/Constraint:** Set up a `.env.local` file placeholder for expected environment variables (Neon DB URL, Vercel Blob tokens, Auth.js secrets, Google Client IDs, Telegram tokens). Provide instructions on what the user needs to populate. Ensure the Next.js `next.config.ts` allows external images from Vercel Blob and Google avatars.

### Step 1.3: Clean Up & Hello World
* **Goal:** Remove default boilerplate and create basic "Hello World" entry points for both the public facing site and the secure admin dashboard area.
* **Logic/Constraint:** The public root should be cleanly separated from the admin root.
* **Validation:** Run the dev server. Ensure both public and admin routes successfully return the newly created content without errors.

### Step 1.4: CI/CD Verification
* **Goal:** Verify the foundation is production-ready.
* **Validation:** Run your package manager's lint and build commands. Fix any warnings or errors. Ensure it outputs an optimized production build successfully.

### Step 1.5: User Review Checkpoint
* **Action:** Pause execution. Notify the user that Phase 1 is complete. Ask the user to review the clean setup and "Hello World" pages. **Do not proceed to Phase 2 until explicit user approval is given.**

---

## Phase 2: Design & UI Components (Dummy Data)
**Goal:** Map all visual requirements from `design.md` into React components using dummy data. Build out the frontend structures without tying them to real databases yet.

### Step 2.1: CSS & Baseline Primitives
* **Goal:** Establish the foundational CSS variables and typography based on the 'WordPress Modern' theme described in `design.md`.
* **Logic/Constraint:** Build reusable UI primitive components (Buttons demonstrating all states, form Inputs, loaders) and a global Toast notification system. 

### Step 2.2: Auth & Admin Shell UI
* **Goal:** Scaffold the core layouts for the locked admin area and the login screen.
* **Logic/Constraint:** The Login view must visually represent Loading, Denied, and Error states according to `design.md`. The Admin layout must be a responsive shell (Sidebar, TopBar) handling desktop, tablet, and mobile views. The Dashboard should present a 2-column grid using static dummy data.

### Step 2.3: Post Management & Editor UI (The Core)
* **Goal:** Build the primary interfaces journalists will interact with.
* **Logic/Constraint:** Create a responsive table/card layout for listing posts with bulk action UI. Then, build the `ClassicEditor` feature: a formatting toolbar, a `contenteditable` zone, and highly specific sidebar meta boxes (Publish Box, Categories, Tag chips, Featured Image). Include the SEO & Preview Widgets (Google SERP, Social share cards) within the edit view.

### Step 2.4: Media & Taxonomy UI
* **Goal:** Build the views for managing files and categorizing content.
* **Logic/Constraint:** The Media Library requires a visual drag-and-drop upload zone, an image grid, and a detail sidebar for selected items. The Category and Tag views should visually mimic a CRUD split view (Add form left, table right).

### Step 2.5: Settings, Users & Themes UI
* **Goal:** Scaffold the remaining administrative screens.
* **Logic/Constraint:** Build the user management table including an "Invite User" modal. Build the Settings area separating concerns into tabs (General, SEO, Telegram). Build a visually descriptive grid for theme selection.

### Step 2.6: Public Facing Theme Scaffolding
* **Goal:** Build the default public layouts that site visitors will see.
* **Logic/Constraint:** Include a Homepage (Featured post + post grid), a Single Post reading layout, and Category/Tag Archive views. Use hardcoded dummy data for all variables.
* **Validation:** Run a production build to aggressively check for TypeScript errors in your dummy data interfaces.

### Step 2.7: User Review Checkpoint
* **Action:** Pause execution. Notify the user that Phase 2 is complete. Ask the user to review the visual components, layouts, and dummy-data interactions. **Do not proceed to Phase 3 until explicit user approval is given.**

---

## Phase 3: Backend & Integration
**Goal:** Implement the database, authentication, and specifically **a single RPC endpoint (1 serverless lambda function) to bypass Vercel Free Tier limits**, and bind real data to the Phase 2 UI.

### Step 3.1: Architecture & Database Setup
* **Goal:** Set up Drizzle ORM and connect to the Neon serverless database.
* **Logic/Constraint:** Translate the exact schema rules from `techstack.md` into code. Implement the raw SQL initialization script (`init.sql`) logic. *Crucially, bypass standard CLI database migrations.* The app must execute this raw SQL on runtime if it detects early tables are missing.

### Step 3.2: Authentication & Security
* **Goal:** Introduce Auth.js with the Google OAuth provider and lock down the admin area.
* **Logic/Constraint:** If the `users` table is empty upon someone logging in, they become the `super_user`. Any subsequent logins *must* be validated against an `invitations` list. Uninvited users must be hard injected into the "Denied" state.

### Step 3.3: API Implementation (Single Lambda RPC & Blob)
* **Goal:** Consolidate data operations into exactly ONE serverless route to avoid hitting the Vercel Free Tier strict limits on serverless functions.
* **Logic/Constraint:** Create a *single* RPC-style POST endpoint to handle actions like `posts.update` or `users.invite` instead of multiple REST routes. Ensure role-based gates are strictly applied based on `techstack.md`. Inside the `posts.publish` handler, trigger a lightweight `fetch()` push to Telegram (no webhooks). Implement a separate endpoint distinctly for Vercel Blob multipart uploads.

### Step 3.4: Data Binding & SEO Rendering
* **Goal:** Connect everything together.
* **Logic/Constraint:** Refactor all Phase 2 admin components to drop dummy data and instead communicate with the RPC API via `fetch`. Ensure the Classic Editor autosave pings the RPC efficiently. On the public side, implement the `ThemeEngine` parsing logic to hydrate Handlebars templates with live DB data. Dynamically construct Open Graph meta tags, JSON-LD schemas, and XML sitemaps using real data.

### Step 3.5: Polish & Deployment Verification
* **Goal:** Final check of all systems.
* **Validation:** Run linting and a production build. Test the flow end-to-end: system initializes > user logs in > creates draft > uploads image > publishes > Telegram notifies > JSON-LD renders correctly.

### Step 3.6: User Review Checkpoint
* **Action:** Pause execution. Notify the user that Phase 3 (and the final integration) is complete. Ask the user to review the fully functioning CMS. Your implementation task is now complete.
