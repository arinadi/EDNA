# MERPATI-CMS — UI Components & API Roadmap (`modules.md`)

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

> Phase 2 deliverable per Agent EDNA methodology. API Contracts to bridge UI to Backend Core `/api/rpc`.

---

## 1. Setup & Auth Components
- **SetupForm**: Requests `site_title`, `description`, `super_user_email` → **API**: RPC `system.setup`.
- **GoogleLoginButton**: Auth.js flow.

## 2. Dashboard Widgets
- **StatCard & RecentPostsList**: Takes `post_count`, `page_count`, `users`, and recent `[Posts]` → **API**: RPC `dashboard.getStats`.
- **QuickDraftWidget**: Takes `title`, `content` → **API**: RPC `posts.create` (Draft).

## 3. Post & Page Management
- **ClassicEditor**: `EditorShell`, `Toolbar`, `PublishBox`, `TaxonomyChecklist`, `SEOPanel`.
  - Content Payload shape: `{ id, title, slug, content, excerpt, status, featured_image, seo_title, seo_description, categories[], tags[] }`.
  - **API Contract**: RPC `posts.create`, `posts.update` (incl. 30s autosave), `posts.publish`.
- **DataTables**: `DataTable`, `FilterBar`, `BulkActionBar`, `StatusBadge`, `PaginationBar`.
  - **API Contract**: RPC `posts.list`, `pages.list` (paginated), `posts.bulkAction` (Trash/Publish).

## 4. Taxonomy Manager
- **TaxonomyForm & Table**: Adds/Edits `{ name, slug, description, parent_id? }`.
  - **API Contract**: RPC `categories.*`, `tags.*` (list, create, update, delete).

## 5. Media Library
- **UploadDropzone & MediaGrid**: Visual components. Media Payload `{ id, filename, blob_url, alt_text }`.
  - **API Contract**: `/api/media` (POST for raw Blob upload), RPC `media.list`, `media.delete`, `media.updateAlt`.

## 6. User Management
- **UserTable & InviteModal**: Role toggler (`super_user` or `user`).
  - **API Contract**: RPC `users.list` (mixed users & pending invites), `users.invite`, `users.updateRole`, `users.deactivate`.
- **ProfileForm**: Update own bio. → **API**: RPC `users.me`, `users.updateMe`.

## 7. Settings & Themes
- **SettingsTabGroup**: General, SEO, Telegram configurations. Payload `{ site_title, telegram_bot_token, etc }`.
  - **API Contract**: RPC `settings.get`, `settings.update`.
- **ThemeGrid**: Theme activation.
  - **API Contract**: RPC `themes.list`, `themes.activate`.

## 8. Theme Engine Server Context (Public UI)
- The Public UI completely bypasses RPC client calls.
- Handlebars views (`index.hbs`, `single.hbs`) are hydrated directly on the server by the ThemeEngine passing Server Components payloads (Post Objects, Settings Metadata, etc.) prior to edge string serialization.

## 9. Generic Utility Components
- `ToastManager`, `ModalShell`, `SkeletonLoader` (for data-fetching states).
