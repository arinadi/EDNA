# MERPATI-CMS — UI Components & API Roadmap (`modules.md`)

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

> Phase 2 deliverable per Agent EDNA methodology.
> This document acts as a bridge between the Descriptive Design (Phase 2) and the Technical Blueprint / Backend Integration (Phase 3). It maps out the core UI components, the exact JSON shapes they require, and the API contracts the backend must fulfill.

---

## 1. Authentication & Setup

### Setup / Initialization Page
- **Components:** `SetupForm`, `SetupSubmitButton` (with loading state).
- **Data Structure:**
  ```json
  {
    "site_title": "string",
    "description": "string",
    "super_user_email": "string"
  }
  ```
- **API Contract:** RPC `system.setup`
  - Input: Setup parameters.
  - Output: `{ "success": true }` or error.

### Login Page
- **Components:** `GoogleLoginButton`.
- **Data Structure:** User JWT (managed via Auth.js / Google OAuth).
- **API Contract:** Handled natively by Auth.js routes (`/api/auth/*`).

---

## 2. Dashboard

### Dashboard Overview
- **Components:** `StatCard`, `RecentPostsList`, `QuickDraftWidget`.
- **Data Structure:**
  ```json
  {
    "stats": {
      "post_count": 0,
      "page_count": 0,
      "media_count": 0,
      "user_count": 0
    },
    "recent_posts": [
      {
        "id": "uuid",
        "title": "string",
        "author": { "name": "string" },
        "status": "published | draft",
        "created_at": "date"
      }
    ]
  }
  ```
- **API Contract:** RPC `dashboard.getStats` (GET/POST approach depending on RPC router constraints).
- **Quick Draft API:** RPC `posts.create` (Draft status).

---

## 3. Post & Page Management

### Classic Editor
- **Components:** 
  - `EditorShell` (Title Input, Permalink Editor, Content Area)
  - `EditorToolbar` (Formatting buttons, Link/Media toggles)
  - `SidebarMetaBoxes` (Publish Box, Categories, Tags, Featured Image, SEO Preview Widget)
- **Data Structure (Post/Page Object):**
  ```json
  {
    "id": "uuid",
    "title": "string",
    "slug": "string",
    "content": "string (html)",
    "excerpt": "string",
    "featured_image": "url",
    "status": "draft | published | trash",
    "author": { "id": "uuid", "name": "string" },
    "published_by": { "id": "uuid", "name": "string" },
    "seo_title": "string",
    "seo_description": "string",
    "canonical_url": "string",
    "is_indexable": true,
    "categories": [ { "id": "uuid", "name": "string" } ],
    "tags": [ { "id": "uuid", "name": "string" } ],
    "published_at": "date",
    "updated_at": "date"
  }
  ```
- **API Contracts:**
  - `posts.create` / `pages.create`
  - `posts.update` / `pages.update` (incl. 30s autosave)
  - `posts.publish` / `pages.publish` (Triggers Telegram notification for posts)
  - `posts.get` / `pages.get` (Fetch single item for editing)

### All Posts / All Pages Data Tables
- **Components:** `DataTable`, `FilterBar`, `BulkActionBar`, `StatusBadge`, `PaginationBar`.
- **Data Structure:** Array of Post/Page Objects (summary fields).
  ```json
  {
    "items": [ /* Post Objects */ ],
    "total": 100,
    "page": 1,
    "limit": 20
  }
  ```
- **API Contracts:** 
  - `posts.list` / `pages.list` (with pagination, filtering, sorting).
  - `posts.bulkAction` / `pages.bulkAction` (Action: `trash`, `publish`).

---

## 4. Taxonomies (Categories & Tags)

### Taxonomy Manager
- **Components:** `TaxonomyForm` (Add/Edit), `TaxonomyTable`.
- **Data Structure:**
  ```json
  {
    "id": "uuid",
    "name": "string",
    "slug": "string",
    "description": "string",
    "total_posts": 0,
    "parent_id": "uuid | null" // (Categories only)
  }
  ```
- **API Contracts:**
  - `categories.list`, `categories.create`, `categories.update`, `categories.delete`
  - `tags.list`, `tags.create`, `tags.update`, `tags.delete`

---

## 5. Media Library

### Media Gallery & Upload
- **Components:** `UploadDropzone`, `MediaGrid`, `MediaDetailSidebar` or `MediaModal`.
- **Data Structure (Media Object):**
  ```json
  {
    "id": "uuid",
    "filename": "string",
    "blob_url": "url",
    "mime_type": "image/jpeg",
    "size_bytes": 102400,
    "alt_text": "string",
    "uploaded_by": "uuid",
    "uploaded_at": "date"
  }
  ```
- **API Contracts:**
  - Upload Endpoint: `/api/media` (POST request to Vercel Blob, returns Media Object).
  - RPC `media.list` (Pagination/Search).
  - RPC `media.updateAlt` (Update alt text).
  - RPC `media.delete` (Remove from DB and Vercel Blob).

---

## 6. User Management

### User & Invitation Manager (Super User Only)
- **Components:** `UserTable`, `InviteModal`, `RoleSelectorDropdown`.
- **Data Structure:**
  ```json
  // User Object
  {
    "id": "uuid",
    "name": "string",
    "email": "string",
    "role": "super_user | user",
    "is_active": true,
    "avatar_url": "url",
    "joined_at": "date"
  }
  
  // Invitation Object
  {
    "id": "uuid",
    "email": "string",
    "role": "super_user | user",
    "invited_by": "uuid",
    "created_at": "date"
  }
  ```
- **API Contracts:**
  - `users.list` (Includes both active users and pending invitations).
  - `users.invite` (Creates invitation record, email sent manually or implicitly handled).
  - `users.revokeInvite`
  - `users.updateRole`
  - `users.deactivate`

### Profile Manager
- **Components:** `ProfileForm` (Bio editor, read-only fields for email/name).
- **API Contracts:**
  - `users.me`
  - `users.updateMe` (Bio updates).

---

## 7. Settings & Themes

### Settings Manager (Super User Only)
- **Components:** `SettingsTabGroup` (General, SEO, Telegram), `SettingsForm`.
- **Data Structure:**
  ```json
  {
    "site_title": "string",
    "tagline": "string",
    "description": "string",
    "posts_per_page": 10,
    "logo_url": "url",
    "favicon_url": "url",
    "telegram_bot_token": "string",
    "telegram_chat_id": "string",
    "notify_on_publish": true,
    "notify_on_user_join": true
  }
  ```
- **API Contracts:**
  - `settings.get`
  - `settings.update`

### Theme Manager (Super User Only)
- **Components:** `ThemeGrid`, `ThemeCard` (Preview image, Name, Version, Active status).
- **Data Structure:**
  ```json
  {
    "id": "string (folder name)",
    "name": "string",
    "version": "string",
    "is_active": true,
    "parent": "string | null",
    "preview_url": "url"
  }
  ```
- **API Contracts:**
  - `themes.list`
  - `themes.activate`

---

## 8. Public Views & Theme Output

The public views are server-rendered (or statically generated with ISR). They do not call the RPC API via fetch clients. Instead, they directly hydrate the Handlebars templates via server logic.

### Server Components Context Payload
The data injected into the `ThemeEngine` for Handlebars rendering:

- **Homepage (`index.hbs`) / Archive Views:**
  Inject array of Post Objects, pagination info, and Site Settings.
- **Single Post (`single.hbs`):**
  Inject full Post Object, Author Bio string, Array of Related Posts, and Site Settings.
- **Single Page (`page.hbs`):**
  Inject full Page Object and Site Settings.

### Layout Global Context (`layout.hbs`)
All templates receive global contexts:
- `site_title`, `site_description`, `site_logo`
- Navigation menu structure
- Required SEO Metadata variables (for Open Graph, JSON-LD, Twitter Cards)

---

## Generic UI Utilities (Not Tied to DB)

- `ToastManager`: For UI feedback (Success, Error, Info, Warning).
- `ModalShell`: Reusable backdrop for Confirmations, Quick Edit, Media Library insertion.
- `SkeletonLoader`: For UI transitioning states before RPC requests complete.
