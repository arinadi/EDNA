# MERPATI-CMS — Descriptive Design

**MERPATI** — *Media Editorial Ringkas, Praktis, Aman, Tetap Independen*

> Phase 2 deliverable per Agent EDNA methodology.

---

## Design Philosophy
WordPress familiarity is the primary goal. Journalists should feel at home within 5 minutes. The admin UI mirrors WordPress's classic layout (left sidebar navigation, top toolbar). Public pages are clean, fast, and optimized for reading.

---

## Color Palette & Typography

### Admin Theme: "WordPress Modern" (shadcn/ui + Tailwind CSS)
| Usage | Background/Foreground | Hex |
|---|---|---|
| Sidebar | bg: `#1D2327`, text: `#C3C4C7`, hover: `#2271B1` | WP Dark Sidebar |
| Content Area | bg: `#F0F0F1` | WP Gray Background |
| Cards / Panels | bg: `#FFFFFF` | White Cards |
| Primary Buttons | bg: `#2271B1`, hover: `#135E96` | WP Blue Action |
| Text | primary: `#1E1E1E`, muted: `#646970` | Text hierarchy |
| Status / Badges | success: `#00A32A`, warning: `#DBA617`, info: `#72AAEA`, error: `#D63638` | Status colors |

### Public Theme (Pure Tailwind CSS)
| Background/Text | Hex | Usage |
|---|---|---|
| Background / Body Text | bg: `#FFFFFF`, text: `#1A1A1A` | Main page |
| Headings | text: `#0F172A` | Clean high-contrast |
| Links / CTAs | text: `#2271B1` | Brand Blue |
| Meta Text (dates, author)| text: `#6B7280` | Subdued secondary info |

### Typography
- **Admin**: `system-ui, sans-serif` (13px body text).
- **Public**: `Inter, sans-serif` (18px body, headers up to 36px).
- **Editor**: `Georgia, serif` (16px base size for better reading focus).
- **Code snippet**: `JetBrains Mono`.

---

## Admin Layout Constraints
- **Desktop**: Full left sidebar (160px) + Main Content.
- **Tablet**: Collapsed sidebar (36px, icons only) + Main Content.
- **Mobile**: Sidebar hidden (hamburger menu toggle).

## Key Public Page Layouts

### Classic Editor Screen
- WP classic 70% / 30% split layout.
- **Left (70%)**: Title input, Permalink, Rich Text Formatting Toolbar (Bold, Italic, lists, headings, media insert, HTML toggle), Main Body, Word Count, Excerpt Box.
- **Right (30%)**: Publish Box (Status, Visibility, Auto/Published By, Save Draft, Publish Buttons), Categories Checklist, Tag Input Box (Autocomplete chips), Featured Image Box, SEO Preview Widget Box.

### Data Tables (Post, Page, Users)
- List table with actions on hover (Edit, Trash, View).
- Top bar with bulk actions dropdown and filters.

### Media Library
- Image grid layout with infinite scroll or pagination.
- Dedicated upload dropzone modal / top page area.

### Dashboard
- Widgetized cards (At a Glance counts, Quick Draft input).

### Setup & Login Screens
- Centered card layout with a fullscreen minimal background.
- Setup Form (Site Title, Description, Super User Email).
- Google Login button.

## Loading & Interaction States
- **Button Hover/Active**: Subtle inset/drop shadows.
- **Loading**: Inline spinners replace button text or Top-page NProgress bar.
- **Toasts**: Auto-dismissing bottom-right notifications for publish/save successes.
- **Empty States**: Friendly illustrations with clear CTAs (e.g., "Write your first post").
- **Editor Autosaving**: Debounced 30s transparent save with "Saving..." in the bottom status bar instead of blocking modals.
