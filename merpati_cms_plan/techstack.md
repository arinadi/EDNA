# MERPATI-CMS — Technical Blueprint & Tech Stack

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

> Phase 3 deliverable per Agent EDNA methodology.

---

## 1. Stack Overview
- **Core Framework**: Next.js 15 (App Router, Serverless architecture).
- **Language**: TypeScript (strict mode).
- **Database**: Neon PostgreSQL Serverless (`@neondatabase/serverless`).
- **ORM**: Drizzle ORM (lightweight, edge-friendly).
- **Authentication**: Auth.js v5 (NextAuth) via Google OAuth.
- **Storage**: Vercel Blob (native integrated image hosting).
- **Theme/Templating**: Handlebars (for public pages rendering).
- **Styling**: Tailwind CSS + `shadcn/ui` (Admin only). Pure Tailwind (Public themes).
- **Notifications**: Telegram Bot API (HTTP fetch).

## 2. Serverless API Architecture (RPC Pattern)
To minimize Vercel Edge cold starts and DB connections, the CMS uses a **Single RPC API Endpoint** approach for data fetching.
- **`POST /api/rpc`**: The master API route receiving `{ action: "domain.function", payload: {...} }` and validating auth role before dispatching to controllers.
- (See `modules.md` for full list of actions/payloads.)
- **`POST /api/media`**: Dedicated Vercel Blob upload endpoint.
- **`/api/auth/[...nextauth]`**: Auth.js core handlers.

## 3. Database Schema (Drizzle ORM)
> Note: Full fields are defined here to serve as the single source of truth for the database layout. No DB-level migrations are used. The app runs a raw `init.sql` script on first boot to bypass CLI usage for laymen.

```typescript
import { pgTable, uuid, varchar, text, timestamp, boolean, integer, bigint, pgEnum } from 'drizzle-orm/pg-core';

export const postStatusEnum = pgEnum('post_status', ['draft', 'published', 'trash']);
export const pageStatusEnum = pgEnum('page_status', ['draft', 'published']);
export const userRoleEnum = pgEnum('user_role', ['super_user', 'user']);

export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  name: varchar('name', { length: 100 }).notNull(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  googleId: varchar('google_id', { length: 255 }).notNull().unique(),
  avatarUrl: varchar('avatar_url', { length: 500 }),
  bio: text('bio'),
  role: userRoleEnum('role').notNull().default('user'),
  isActive: boolean('is_active').notNull().default(true),
  invitedBy: uuid('invited_by'), 
  createdAt: timestamp('created_at').defaultNow().notNull(),
});

export const invitations = pgTable('invitations', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: varchar('email', { length: 255 }).notNull(),
  role: userRoleEnum('role').notNull().default('user'),
  invitedBy: uuid('invited_by').notNull(),
  acceptedAt: timestamp('accepted_at'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
});

export const posts = pgTable('posts', {
  id: uuid('id').defaultRandom().primaryKey(),
  title: varchar('title', { length: 255 }).notNull(),
  slug: varchar('slug', { length: 255 }).notNull().unique(),
  content: text('content'),
  excerpt: text('excerpt'),
  featuredImage: varchar('featured_image', { length: 500 }),
  status: postStatusEnum('status').notNull().default('draft'),
  authorId: uuid('author_id').notNull(),
  publishedBy: uuid('published_by'),
  publishedAt: timestamp('published_at'),
  seoTitle: varchar('seo_title', { length: 255 }),
  seoDescription: varchar('seo_description', { length: 500 }),
  canonicalUrl: varchar('canonical_url', { length: 500 }),
  isIndexable: boolean('is_indexable').notNull().default(true),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

// Categories & Tags
export const categories = pgTable('categories', {
  id: uuid('id').defaultRandom().primaryKey(),
  name: varchar('name', { length: 100 }).notNull(),
  slug: varchar('slug', { length: 100 }).notNull().unique(),
  description: text('description'),
  parentId: uuid('parent_id'),
});
export const tags = pgTable('tags', {
  id: uuid('id').defaultRandom().primaryKey(),
  name: varchar('name', { length: 100 }).notNull(),
  slug: varchar('slug', { length: 100 }).notNull().unique(),
});
export const postCategories = pgTable('post_categories', {
  postId: uuid('post_id').notNull(),
  categoryId: uuid('category_id').notNull(),
});
export const postTags = pgTable('post_tags', {
  postId: uuid('post_id').notNull(),
  tagId: uuid('tag_id').notNull(),
});

export const pages = pgTable('pages', {
  id: uuid('id').defaultRandom().primaryKey(),
  title: varchar('title', { length: 255 }).notNull(),
  slug: varchar('slug', { length: 255 }).notNull().unique(),
  content: text('content'),
  status: pageStatusEnum('status').notNull().default('draft'),
  authorId: uuid('author_id').notNull(),
  publishedBy: uuid('published_by'),
  parentId: uuid('parent_id'),
  sortOrder: integer('sort_order').notNull().default(0),
  seoTitle: varchar('seo_title', { length: 255 }),
  seoDescription: varchar('seo_description', { length: 500 }),
  canonicalUrl: varchar('canonical_url', { length: 500 }),
  isIndexable: boolean('is_indexable').notNull().default(true),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

export const media = pgTable('media', {
  id: uuid('id').defaultRandom().primaryKey(),
  filename: varchar('filename', { length: 255 }).notNull(),
  blobUrl: varchar('blob_url', { length: 500 }).notNull(),
  mimeType: varchar('mime_type', { length: 50 }).notNull(),
  sizeBytes: bigint('size_bytes', { mode: 'number' }).notNull(),
  altText: varchar('alt_text', { length: 255 }),
  uploadedBy: uuid('uploaded_by').notNull(),
  uploadedAt: timestamp('uploaded_at').defaultNow().notNull(),
});

export const settings = pgTable('settings', {
  key: varchar('key', { length: 100 }).primaryKey(),
  value: text('value').notNull(),
});
```

## 4. Security & Middleware
- **Auth.js Config**: Blocks logins explicitly absent from `invitations` table (unless `users` table is totally empty). Issues HTTP-Only JWT.
- **Middleware.ts**: Protects all `/(admin)/*` paths. Verifies `user` vs `super_user` permissions. Re-directs unauthenticated to `/login`.
- **Zod Validation**: Input payloads strictly parsed on RPC invocation.
- XSS prevention primarily via React escapes and DOMPurify for user rich text.

## 5. Deployment Constraints (Vercel Free Tier)
- **10s Function Timeout**: Rely strictly on indexed DB hits. Avoid long-running background loops.
- **50MB Max Serverless Size**: Minimal dependencies natively supported. Avoid massive bloated libs (e.g. Prisma).
- Application defaults completely to cache-first SSR/ISR for all public facing domains.
