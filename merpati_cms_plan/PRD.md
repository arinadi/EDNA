# MERPATI-CMS — Product Requirements Document

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

> *"Kebebasan pers dimulai dari kemandirian infrastrukturnya."*

---

## Phase 0: Project Context

| Field | Value |
|---|---|
| **Project Type** | Greenfield |
| **Constraints** | Vercel Free Tier, Neon DB free tier, Vercel Blob free tier |
| **Target Users** | Indonesian journalists familiar with WordPress |
| **Business Goal** | Free CMS for journalists. |

---

## The Story (The Pain)

Indonesian journalists need a familiar writing platform like WordPress. But WordPress hosting is expensive. **MERPATI-CMS** solves this with a serverless architecture that runs for free on Vercel Free Tier, giving the WordPress feel without the server cost.

---

## Core Features (NO CAPES!)

1. **📝 Classic Editor**: WP-style editor (Bold, Italic, lists, headings, media insert). HTML toggle, autosave.
2. **📋 Post Management**: Draft, Published, Trash. Quick actions, bulk actions, search, filter, pagination.
3. **🏷️ Categories & Tags**: Hierarchical categories, flat tags.
4. **📄 Pages**: Static pages with the same editor, hierarchical.
5. **📷 Media Library**: Upload to Vercel Blob. Grid view, image metadata, copy URL. 
6. **🎨 Theme System**: File-based themes with child-theme fallback inheritance.
7. **👤 User Management (Invite-Only)**: Google OAuth only. First login = Super User. Super User invites others. Roles: `super_user`, `user`. All can publish.
8. **⚙️ Settings**: Site title, logo, pagination limit, active theme.
9. **🔧 Dashboard**: Quick draft, recent posts, counts.
10. **🔔 Telegram Notifications**: Push notifications to a configured channel on user join and post publish.
11. **🔗 Share & SEO Engine**: Open Graph, Twitter Cards, `NewsArticle` JSON-LD, Sitemap (`/sitemap.xml`, `/news-sitemap.xml`), RSS Feed.

---

## Role Permissions

| Permission | Super User | User |
|---|---|---|
| Write, edit & publish own posts | ✅ | ✅ |
| Manage media (own) | ✅ | ✅ |
| Edit/Delete all posts & pages | ✅ | ❌ |
| Manage taxonomies, themes, settings | ✅ | ❌ |
| Invite users & manage roles | ✅ | ❌ |

---

## Initialization Flow
*Self-initializes on the first run (no CLI DB migrations).*
1. If DB is empty, run `init.sql` to create tables and enums.
2. Seed default categories, tags, settings, welcome post, and page.
3. First user to login via Google becomes Super User.

---

## Non-Functional Requirements
- **Performance**: Admin < 500ms response (SPA-like), Public < 200ms (ISR cached).
- **Security**: Google OAuth 2.0 (JWT), DOMPurify sanitization.
- **Scalability**: Serverless auto-scaling on Vercel Edge.

## Success Criteria
- Full admin CRUD operational.
- Google OAuth invite-only login.
- File-based child themes work.
- Valid RSS, Google News JSON-LD, and Open Graph previews.
- $0/month on Vercel Free Tier.
- WordPress-familiar UI.
