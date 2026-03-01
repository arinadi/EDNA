# MERPATI-CMS — Implementation Instruction (for Agentic Coding)

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

> **ATTENTION AI AGENT:** You are to execute this instruction manual sequentially. Heavily reference `PRD.md`, `design.md`, and `techstack.md` for context on each step. Do NOT skip validation commands. Run them in your terminal to ensure correctness before proceeding to the next phase.

---

## Phase 1: Init "Hello World"
**Goal:** Establish the foundation, ensure the application runs, builds, and lints without errors.

### Step 1.1: Project Setup
* **Command Action:** Run `npx -y create-next-app@latest ./` in the project root to initialize a Next.js 15 App Router project. Configure it to use TypeScript, ESLint, Tailwind CSS (optional, if overriding vanilla), `src/` directory (No), App Router (Yes).
* **Command Action:** Create standard directory structure: `app/`, `components/`, `lib/` (if not auto-generated).
* **Context:** `techstack.md` (Stack Overview)
* **Validation:** Ensure `package.json` exists and dependencies are installed.

### Step 1.2: Clean Up & Hello World
* **Code Action:** Remove default Next.js boilerplate from `app/globals.css` and `app/page.tsx`.
* **Code Action:** Create a basic "Hello World" plain text/HTML page at `app/page.tsx` for the public face.
* **Code Action:** Create a basic "Admin Hello World" at `app/admin/page.tsx`.
* **Validation:** Run `npm run dev` in the background and use `curl` or browser preview to verify the root (`/`) returns the Hello World content.

### Step 1.3: CI/CD Verification
* **Command Action:** Run `npm run lint`. Fix any warnings or errors.
* **Command Action:** Run `npm run build`. Ensure it outputs an optimized production build successfully.

### Step 1.4: User Review Checkpoint
* **Action:** Pause execution. Notify the user that Phase 1 is complete. Ask the user to review the clean setup and "Hello World" pages. **Do not proceed to Phase 2 until explicit user approval is given.**

---

## Phase 2: Design & UI Components (Dummy Data)
**Goal:** Map all visual requirements from `design.md` into static React components using dummy data. Stop before writing real database logic.

### Step 2.1: CSS & Baseline Primitives
* **Code Action:** Inject the 'WordPress Modern' CSS variables (`--admin-sidebar-bg`, etc.) and typography (Inter, System UI) as defined in `design.md` into `app/globals.css`.
* **Code Action:** Build reusable UI primitives in `components/ui/` (Buttons for all states, Inputs, skeleton loaders).
* **Code Action:** Implement a Toast notification system (success/error/info sliders).

### Step 2.2: Auth & Admin Shell
* **Code Action:** Build the Login page UI (`app/(auth)/login/page.tsx`) featuring the centered Google Login card with Loading, Denied, and Error states. (No real auth logic yet, just UI).
* **Code Action:** Build the `Sidebar` and `TopBar` components. Create the responsive `app/(admin)/layout.tsx` wrapper handling desktop/tablet/mobile states based on `design.md`.
* **Code Action:** Build the `app/(admin)/dashboard/page.tsx` 2-column Dashboard grid using static dummy data.

### Step 2.3: Post Management & Editor (The Core)
* **Code Action:** Build the "All Posts" view in `app/(admin)/posts/page.tsx`. Include bulk action checkboxes, filters, and a responsive table/card layout.
* **Code Action:** Build the `ClassicEditor` component (`components/admin/ClassicEditor.tsx`) including formatting toolbar buttons and the main `contenteditable` zone.
* **Code Action:** Build the sidebar meta boxes for the editor: Publish Box, Category checkboxes, Tag chips, and Featured Image preview.
* **Code Action:** Build the SEO & Preview Widgets (Google SERP, WhatsApp/Telegram share cards) inside the editor.

### Step 2.4: Media & Taxonomy
* **Code Action:** Build the `app/(admin)/media/page.tsx` Media Library grid with a drag-and-drop upload zone and a detail sidebar overlay.
* **Code Action:** Build the `app/(admin)/categories/page.tsx` and `/tags` CRUD split views (Add form on left, table list on right).

### Step 2.5: Settings, Users & Themes
* **Code Action:** Build the `app/(admin)/users/page.tsx` table and "Invite User" modal.
* **Code Action:** Build the `app/(admin)/settings/page.tsx` tabs (General, SEO Defaults, Telegram config).
* **Code Action:** Build the `app/(admin)/themes/page.tsx` grid view showing theme placeholders.

### Step 2.6: Public Facing Pages & Validation
* **Code Action:** Build the default public layout including `Homepage` (Featured post + grid), `[slug]/page.tsx` (Single Post layout), and Category/Tag Archive views using hardcoded dummy data.
* **Validation:** Run `npm run build`. If errors occur, fix type definitions in your dummy data interfaces.

### Step 2.7: User Review Checkpoint
* **Action:** Pause execution. Notify the user that Phase 2 is complete. Ask the user to review the visual components, layouts, and dummy-data interactions. **Do not proceed to Phase 3 until explicit user approval is given.**

---

## Phase 3: Backend & Integration
**Goal:** Implement the database, authentication, single RPC endpoint, and bind real data to the Phase 2 UI.

### Step 3.1: Architecture & Database Setup
* **Command Action:** Install backend deps: `pnpm add drizzle-orm @neondatabase/serverless` and `pnpm add -D drizzle-kit`.
* **Code Action:** Define the full database schema in `lib/db/schema.ts` corresponding to `techstack.md`. Create connection helper in `lib/db/index.ts`.
* **Code Action:** Write `lib/db/init.sql.ts` containing the raw SQL seed logic (tables, enums, "Uncategorized", welcome post). Bypass CLI migrations for end-users.

### Step 3.2: Authentication & Security
* **Command Action:** Install Auth.js: `pnpm add next-auth@beta`.
* **Code Action:** Configure the Google OAuth provider. Implement the backend check: if `users` table is empty, first user is `super_user`. Else, validate against `invitations` table.
* **Code Action:** Setup `middleware.ts` to protect `/(admin)` routes.

### Step 3.3: Single API Endpoint (RPC) & Blob Upload
* **Code Action:** Create `app/api/rpc/route.ts` using the single generic POST action payload structure defined in `techstack.md`.
* **Code Action:** Implement handlers for: `posts.list`, `posts.create`, `posts.update`, `posts.publish`, `categories`, `tags`, `settings`, `users`.
* **Code Action:** Implement Telegram `fetch()` push inside the `posts.publish` handler (and `users.invite` handler). No webhook infrastructure allowed.
* **Code Action:** Create `app/api/media/route.ts` exclusively for handling multipart/form-data uploads to Vercel Blob.

### Step 3.4: Data Binding & Public SEO Engines
* **Code Action:** In all `app/(admin)/...` pages and components, swap the Phase 2 dummy data getters with dynamic `fetch('/api/rpc')` calls. Connect the Classic Editor autosave logic to the RPC endpoint.
* **Code Action:** Implement `lib/theme/ThemeEngine.ts` to parse the `themes/default/` folder and render Handlebars templates using real database records for public pages.
* **Code Action:** Generate dynamic SEO meta components: Open Graph, Twitter cards, `NewsArticle` JSON-LD. Generate XML files (`feed.xml`, `sitemap.xml`, `news-sitemap.xml`).

### Step 3.5: Polish & Deployment Verification
* **Command Action:** Run `npm run lint`.
* **Command Action:** Run `npm run build`.
* **Validation:** If successful, perform a complete e2e test script: Trigger Initialization -> Login -> Create Draft -> Upload Image -> Publish -> Verify DB state.

### Step 3.6: User Review Checkpoint
* **Action:** Pause execution. Notify the user that Phase 3 (and the final integration) is complete. Ask the user to review the fully functioning CMS. Your implementation task is now complete.
