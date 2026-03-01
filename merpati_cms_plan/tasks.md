# MERPATI-CMS — Implementation Plan & Task Checklist

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

---

## Phase 1: Init "Hello World"
**Goal:** Establish the foundation, ensure the application runs, builds, and lints without errors.

- [ ] **1.1 Project Setup**
  - **Task:** Initialize Next.js 15 App Router project, configure TypeScript, ESLint, Prettier, and standard directory structure (`app/`, `components/`, `lib/`).
  - **Priority:** P0 | **Dependencies:** None | **Effort:** S

- [ ] **1.2 Clean Up & Hello World**
  - **Task:** Remove default Next.js boilerplate, create basic layouts for public facing `/` and admin facing `/admin`.
  - **Priority:** P0 | **Dependencies:** 1.1 | **Effort:** S

- [ ] **1.3 CI/CD Verification**
  - **Task:** Run `pnpm lint` and `pnpm build` to verify a clean production build environment.
  - **Priority:** P0 | **Dependencies:** 1.2 | **Effort:** S

---

## Phase 2: Design & UI Components (Dummy Data)
**Goal:** Map all visual requirements from `design.md` into static React components using dummy data. No database logic.

### 2.1 CSS & Baseline Primitives
- [ ] **2.1.1 CSS Tokens**
  - **Task:** Implement 'WordPress Modern' CSS variables (`--admin-sidebar-bg`, etc.) and typography (Inter, System UI) as defined in `design.md`.
  - **Priority:** P0 | **Dependencies:** Phase 1 | **Effort:** S

- [ ] **2.1.2 Reusable UI Primitives**
  - **Task:** Build buttons (all states), inputs, skeleton loaders, and the Toast notification system (success/error/info sliders).
  - **Priority:** P0 | **Dependencies:** 2.1.1 | **Effort:** M

### 2.2 Auth & Admin Shell
- [ ] **2.2.1 Login Page UI**
  - **Task:** Build the centered Google Login card, including Loading, Denied (not invited), and Error states.
  - **Priority:** P0 | **Dependencies:** 2.1.2 | **Effort:** S

- [ ] **2.2.2 Admin Layout responsive shell**
  - **Task:** Build the Top Bar and left Sidebar (160px desktop, collapsed icons tablet, hamburger mobile).
  - **Priority:** P0 | **Dependencies:** 2.1.2 | **Effort:** M

- [ ] **2.2.3 Dashboard UI**
  - **Task:** Build the 2-column Dashboard grid with "At a Glance", "Quick Draft", and "Recent Posts" widget cards.
  - **Priority:** P1 | **Dependencies:** 2.2.2 | **Effort:** S

### 2.3 Post Management & Editor (The Core)
- [ ] **2.3.1 Post Table UI**
  - **Task:** Build the "All Posts" view. Includes bulk action selection, filter bar, and responsive layout (table on desktop, cards on mobile).
  - **Priority:** P0 | **Dependencies:** 2.2.2 | **Effort:** M

- [ ] **2.3.2 Classic Editor core**
  - **Task:** Build the main editor area: formatting toolbar buttons (Bold, HTML toggle, H2, etc.), title input, and main `contenteditable` zone.
  - **Priority:** P0 | **Dependencies:** 2.2.2 | **Effort:** L

- [ ] **2.3.3 Editor Sidebar Meta Boxes**
  - **Task:** Build the sidebar accordions: Publish Box (status/date), Category checkboxes, Tag chip selector, and Featured Image preview.
  - **Priority:** P0 | **Dependencies:** 2.3.2 | **Effort:** M

- [ ] **2.3.4 SEO & Preview Widgets**
  - **Task:** Build the SEO meta box inside the editor containing input fields and live preview components for Google SERP and WhatsApp/Telegram share cards.
  - **Priority:** P1 | **Dependencies:** 2.3.3 | **Effort:** M

### 2.4 Media & Taxonomy
- [ ] **2.4.1 Media Library Grid & Upload**
  - **Task:** Build the Media Library page: drag-and-drop upload zone, image grid, and click-to-open detail sidebar.
  - **Priority:** P1 | **Dependencies:** 2.2.2 | **Effort:** M

- [ ] **2.4.2 Category & Tag Split UI**
  - **Task:** Build the Category/Tag CRUD view featuring a split layout (Add form on left, table list on right).
  - **Priority:** P1 | **Dependencies:** 2.2.2 | **Effort:** S

### 2.5 Settings, Users & Themes
- [ ] **2.5.1 Users Page & Invite Modal**
  - **Task:** Build the user listing table (with active/inactive indicators) and the "Invite User" modal.
  - **Priority:** P1 | **Dependencies:** 2.2.2 | **Effort:** S

- [ ] **2.5.2 Settings Tabs UI**
  - **Task:** Build the Settings page with tabs for General (site title, logo), SEO Defaults, and Telegram config.
  - **Priority:** P2 | **Dependencies:** 2.2.2 | **Effort:** M

- [ ] **2.5.3 Themes Page UI**
  - **Task:** Build the theme selection grid showing theme preview images and active statuses.
  - **Priority:** P2 | **Dependencies:** 2.2.2 | **Effort:** S

### 2.6 Public Facing Pages
- [ ] **2.6.1 Public Theme Views**
  - **Task:** Build the default public layout including Homepage (Featured post + grid), Single Post layout (Author bio, Share icons), and Category/Tag Archive views using dummy data.
  - **Priority:** P1 | **Dependencies:** 2.1.1 | **Effort:** L

---

## Phase 3: Backend & Integration
**Goal:** Implement the database, authentication, the single RPC endpoint, and bind real data to Phase 2 UI.

### 3.1 Architecture & Database Setup
- [ ] **3.1.1 Drizzle & Neon Configuration**
  - **Task:** Install Drizzle ORM, configure `@neondatabase/serverless`, and define the full schema (Posts, Pages, Users, etc.) exactly as matched in `techstack.md`.
  - **Priority:** P0 | **Dependencies:** Phase 2 | **Effort:** M

- [ ] **3.1.2 WordPress-Style Initialization Seed**
  - **Task:** Implement the `init.sql` seed logic that bypasses migrations and generates tables, enums, "Uncategorized", and a welcome post on first run.
  - **Priority:** P0 | **Dependencies:** 3.1.1 | **Effort:** M

### 3.2 Authentication & Security
- [ ] **3.2.1 Auth.js Google Integration**
  - **Task:** Install Auth.js, configure Google OAuth provider, implement the `google_id` check, and super_user invitation validation rules. Protect `/(admin)` routes.
  - **Priority:** P0 | **Dependencies:** 3.1.1 | **Effort:** L

### 3.3 Single API Endpoint (RPC)
- [ ] **3.3.1 RPC Router setup**
  - **Task:** Create the `POST /api/rpc` core handler to receive `action` payloads and dispatch them securely.
  - **Priority:** P0 | **Dependencies:** 3.2.1 | **Effort:** S

- [ ] **3.3.2 Posts & Pages RPC Handlers**
  - **Task:** Implement `posts.list`, `posts.create`, `posts.update`, `posts.publish` (with status handling), and associated pages handlers.
  - **Priority:** P0 | **Dependencies:** 3.3.1 | **Effort:** L

- [ ] **3.3.3 Telegram Notification Pipeline**
  - **Task:** Implement lightweight `fetch()` Telegram push logic triggered uniquely by the `posts.publish` and `users.invite` actions (no webhooks/polling).
  - **Priority:** P1 | **Dependencies:** 3.3.2 | **Effort:** S

- [ ] **3.3.4 Taxonomy, Settings, & Users Handlers**
  - **Task:** Implement CRUD handlers for Categories, Tags, Settings, Users, and Theme selection.
  - **Priority:** P1 | **Dependencies:** 3.3.1 | **Effort:** M

- [ ] **3.3.5 Vercel Blob API Integration**
  - **Task:** Implement the separate `POST /api/media` handler for multipart uploads, plus RPC actions to list/delete blobs.
  - **Priority:** P1 | **Dependencies:** 3.1.1 | **Effort:** M

### 3.4 Data Binding & Public SEO Engines
- [ ] **3.4.1 Admin UI Real Data Binding**
  - **Task:** Swap out Phase 2 mock data getters with `fetch` calls hitting `/api/rpc`. Connect the Classic Editor autosave logic to the DB.
  - **Priority:** P0 | **Dependencies:** 3.3.2, 3.3.4 | **Effort:** L

- [ ] **3.4.2 Public Handlebars Theme Engine**
  - **Task:** Implement the backend `ThemeEngine.ts` to parse the active theme folder, perform child-theme fallback resolution, and render Handlebars data context.
  - **Priority:** P0 | **Dependencies:** 3.4.1 | **Effort:** L

- [ ] **3.4.3 SEO Meta, XML Feeds, & JSON-LD**
  - **Task:** Dynamically generate Open Graph/Twitter meta tags, `NewsArticle` JSON-LD schema, `/feed.xml`, `/sitemap.xml`, and Google `/news-sitemap.xml`.
  - **Priority:** P0 | **Dependencies:** 3.4.2 | **Effort:** M

### 3.5 Polish & Deployment
- [ ] **3.5.1 Final Integration Test**
  - **Task:** Perform the full end-to-end flow: Initialization → Login → Create Draft via UI → Upload Image → Set Tags → Publish → Receive Telegram → View JSON-LD.
  - **Priority:** P0 | **Dependencies:** 3.4.3 | **Effort:** M

- [ ] **3.5.2 CI/CD Verification**
  - **Task:** Run final `pnpm lint` and `pnpm build` ensuring no type errors across the entire codebase.
  - **Priority:** P0 | **Dependencies:** 3.5.1 | **Effort:** S
