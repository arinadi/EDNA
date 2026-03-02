# MERPATI-CMS — Agent Prompt for Agentic Coding

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

> Phase 4 deliverable per Agent EDNA methodology.

---

## **Context Links (CRITICAL)**

Before you write any code, you must deeply understand the project by reading the following documents:
- **`PRD.md`**: Core features, user flows, and project constraints (Vercel Free Tier, invite-only auth, etc.).
- **`design.md`**: All visual requirements, UI layouts, color palettes, and mock data needs.
- **`modules.md`**: The definitive component roadmap detailing data structures and UI-Backend API contracts.
- **`techstack.md`**: The chosen technologies, single serverless API endpoint (RPC-style) architecture, Next.js App Router structure, and the raw SQL database initialization strategy instead of CLI migrations.

You are an autonomous AI Coding Agent. Do not ask for exact file paths or step-by-step code snippets. You must derive the technical implementation (the "how") yourself from the provided constraints and blueprints (the "what" and "why").

---

## **Phase 1: Init "Hello World"**

**Goal:** Initialize the codebase repository and CI/CD foundation. Set up the development environment locally to prove a running app can be built.

**Detailed Objectives & Logic Constraints:**
1. **Initialize Project:** Scaffold a Next.js 15 App Router project using pnpm, TypeScript, and ESLint. Read `techstack.md` to determine the exact dependencies (e.g., Drizzle ORM, @neondatabase/serverless, Auth.js). Keep dependencies minimal as required for Vercel Free Tier (9 production packages).
2. **Project Structure:** Create the base folders (`app/(auth)`, `app/(admin)`, `app/(public)`, `components`, `lib`, `themes`, etc.) as outlined in `techstack.md`.
3. **Hello World:** Render a simple "Hello World" screen on the `/` route to confirm the Next.js setup is functional.
4. **Setup/Initialization UI:** Create an initial setup screen (which will later map to the `system.setup` RPC) that accepts basic site configurations (Site Title, Tagline) and first super user details. This is necessary because we are bypassing CLI migrations in favor of runtime database initialization as specified in `techstack.md`. 
5. **Linting & Formatting:** Ensure code meets the configured ESLint and Prettier rules.

**Validation Commands:**
The agent must successfully run the following commands and ensure a clean exit before considering this phase complete:
- `pnpm install`
- `pnpm run build`
- `pnpm run lint`

### **🛑 User Review Checkpoint**
Pause execution here. Notify the user: "Phase 1 complete. Scaffolded Next.js project and confirmed build constraints. Awaiting review and approval to begin Phase 2." Do not proceed until the user explicitly approves.

---

## **Phase 2: Design & UI**

**Goal:** Build the interactive UI components using dummy data. **You must derive all visual, mock data requirements, and component structures by deeply reading `design.md`, `modules.md`, and `PRD.md`.** No backend logic or database connections yet.

**Detailed Objectives & Logic Constraints:**
1. **Derive Requirements First:** Deeply read `design.md`, `modules.md`, and `PRD.md` to extract expected layouts, responsive behavior, and the precise mock data structure needed to populate all components defined in the roadmap.
2. **Design System & Styling:** Initialize Tailwind CSS. Use `shadcn/ui` components for the admin interface (`app/(admin)`). Use pure Tailwind CSS utility classes for the public interface (`app/(public)`) to keep it lightweight. Configure `tailwind.config` and global variables based on `design.md`.
3. **Admin SPA UI & Core Features:** Build the app shell (Sidebar/TopBar) and view components using only dummy data:
   - **Post Management / Editor:** Contenteditable UI with a custom toolbar.
   - **Data Tables:** Resizable/filterable tables for Posts, Media, Categories, Tags, and Users.
   - **Settings & Theme Managers:** Site configuration forms and theme selection UI.
   - **Modal & Toasts:** Reusable feedback blocks.
4. **Public Theme Engine UI:** Build the base layout for public pages exactly as specified in `design.md` and `PRD.md`.
5. **Interactivity:** Ensure hover states, responsive breakpoints, and micro-animations are perfectly aligned with design specs.

**Validation Commands:**
- `pnpm run build`
- `pnpm run lint`

### **🛑 User Review Checkpoint**
Pause execution here. Notify the user: "Phase 2 complete. All UI components and layouts are built with dummy data. Please review the look and feel in the browser. Awaiting approval to begin Phase 3." Do not proceed until the user explicitly approves.

---

## **Phase 3: Backend Integration**

**Goal:** Implement the serverless API, DB, and Auth. **You must derive the architecture strictly from `techstack.md` and `PRD.md`, and you must connect the backend to the UI components built in Phase 2, using `modules.md` as the definitive roadmap.**

**Detailed Objectives & Logic Constraints:**
1. **Derive Architecture First:** Deeply review `techstack.md`, `modules.md`, and `PRD.md` to map out the database schema, RPC-based endpoint behavior from the required API contracts, and authentication flow before coding.
2. **Database Setup (Raw SQL):** Setup Neon DB connection via `@neondatabase/serverless` and implement the raw SQL auto-initialization scripts.
3. **Single Serverless Endpoint (RPC):** Implement the core `/api/rpc` route. Route all feature logic through this single endpoint to adhere strictly to Vercel free-tier capacity.
4. **Authentication:** Implement Auth.js with Google OAuth. Enforce invite-only access. The first user becomes `super_user`. Secure the RPC endpoint with role-based middleware.
5. **Connect Backend to Phase 2 UI:** Replace the dummy data from Phase 2 with real database integrations. Connect your generic Data Tables, Editor, and Settings UIs directly to the RPC endpoint. Ensure loading/error states function seamlessly within the UI built earlier.
6. **Themes & Public Output:** Integrate the Handlebars UI base from Phase 2. Make the public routes (`app/(public)`) fetch data from DB and hydrate the templates. Create RSS and Sitemap routes.
7. **Telegram Integration:** Add a `fetch` call to the Telegram Bot API to push Publish and Join events.

**Validation Commands:**
- `pnpm run build`
- `pnpm run lint`

### **🛑 User Review Checkpoint**
Pause execution here. Notify the user: "Phase 3 complete. Backend, DB, Auth, and Theme Engine are wired up, and Phase 2 UI elements are now connected to real data. System is ready for E2E testing. Awaiting next instructions." Do not proceed further.
