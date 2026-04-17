# tsunamiunleashed.com — Build Specification v1.1
# All pre-build decisions resolved. No open questions remain.

**Audience:** Claude Code (and any human collaborator).
**Companion document:** `tsunamiunleashed-com-architecture.md` (strategic rationale; this file is the executable plan).
**Source of truth for content:** the existing `ministry-kb` repo (canon) + canonical 8GC v2026-04-08 + the Life with God field guide HTML.
**Status:** Phase 1 is buildable from this spec alone. Phases 2 and 3 are specified enough to plan and partially build.

---

## 0. How to use this spec

Work top-to-bottom by phase. Do not skip ahead. Each phase ends with **Acceptance tests** that must all pass before moving on. When in doubt about a structural decision, this spec is the authority; when in doubt about content (what a card actually says, what an 8GC entry actually teaches), the `ministry-kb` repo is the authority. Never invent doctrinal content. If a section instructs you to "import from canon" and the canon file is unclear, **stop and ask Edward** rather than paraphrase.

Every code block labeled `# CMD` is a shell command to run. Every block labeled `# FILE: path/to/file` is the literal contents of a file to create. Every block labeled `# SNIPPET` is illustrative — adapt as needed but preserve the structure.

---

## 1. Pre-build decisions (all resolved)

These were open questions. They are now answered and locked. Do not re-litigate them.

| # | Decision | Answer |
|---|---|---|
| 1 | GitHub org vs personal | **Create new GitHub org: `github.com/tsunami-unleashed`**. Edward is org admin. Brian, Russ, Duran get collaborator access. Repo: `github.com/tsunami-unleashed/tsunamiunleashed.com`. |
| 2 | Color palette / typography | **Derive from Edward's existing SVG logo/wordmark** once provided. Ship neutral greens/blues as placeholders in Phase 1; swap in brand colors before Phase 1 acceptance sign-off. |
| 3 | Logo / wordmark | **Edward will provide an existing SVG file.** Drop it at `assets/media/images/logo.svg`. Until received, use a text-only wordmark in `baseof.html`. |
| 4 | Trademark | **Not yet filed. NOTICE.md stays neutral** — no legal language about name protection. Revisit when Edward initiates filing. |
| 5 | DNS control | **Edward controls `tsunamiunleashed.com` DNS** and will add CNAME and TXT records as needed at each deploy step. Flag which records are needed and when. |
| 6 | Short-URL domain for QR codes | **Register a short domain** (check availability: `tu.link`, `tu.page`, `tu.to`, `tsun.ai` — pick the cleanest available). All QR codes on bookmark cards point to `<shortdomain>/1` through `/9`. These redirect to `tsunamiunleashed.com/cards/card-{a..i}/`. |
| 7 | archive.org account | **Does not yet exist. Create one** at https://archive.org/account/signup before Phase 2 audio uploads begin. Use a ministry-owned email (not personal). Store credentials in the shared password manager. Add the account name to `data/media.toml` metadata once created. |
| 8 | PeerTube / video | **Deferred entirely to Phase 3.** No video infrastructure in Phase 1 or 2. The `{{< media >}}` shortcode stubs `type = "video"` but it is unused until Phase 3. |
| 9 | Hindi translation review | **A trusted Hindi-speaking field leader reviews and approves all PRs to `content/hi/`.** Edward designates this person before Phase 2 begins. Their GitHub username becomes a required reviewer on the `content/hi/` CODEOWNERS entry. |
| 10 | First release tag | **`v2026.05.0`** — calendar versioning (`vYYYY.MM.PATCH`). Tag is applied when Phase 1 acceptance tests all pass. |
| 11 | PeerTube subdomain | **N/A — deferred to Phase 3.** Placeholder: `video.tsunamiunleashed.com` on the Hetzner VPS, but no DNS record or install until Phase 3. |

### Pre-build checklist (complete before writing a line of code)

- [ ] Create GitHub org `tsunami-unleashed`; Edward is owner
- [ ] Add Duran as org member with `maintain` role on the repo
- [ ] Receive SVG logo file from Edward; place at `assets/media/images/logo.svg`
- [ ] Register short domain; configure redirect rules `/1`–`/9` to `/cards/card-{a..i}/`
- [ ] Confirm Edward's DNS access to `tsunamiunleashed.com` (log in to registrar, verify)
- [ ] Set GitHub Actions secrets: `MINISIGN_SECRET_KEY`, `CF_API_TOKEN`, `CF_ACCOUNT_ID`
- [ ] Generate minisign keypair (see §6.9); store secret key in 1Password; commit public key
- [ ] Create Cloudflare Pages project named `tsunamiunleashed` connected to the GitHub repo
- [ ] Enable GitHub Pages on the repo (`main` branch → `/` root)

---

## 2. Mission, audience, constraints

### 2.1 What we are building

A static, CC0, multilingual ministry resource site at `tsunamiunleashed.com` that serves three audiences (field workers in South Asia on cheap Android phones, Western coaches/trainers, global seekers/believers) and is engineered to be **unkillable** — replicable in five minutes by any volunteer with a laptop, mirrorable across seven independent hosts, and downloadable as offline bundles that work without internet.

### 2.2 Hard constraints (non-negotiable)

These rules apply to every file, every page, every commit, every deploy. Violating any of these is a build failure.

1. **Müller philosophy.** No donation buttons. No "support us" language. No solicitation of any kind. Provision is reported after the fact, never asked for in advance. The word "donate" must not appear in the site UI in any language.
2. **CC0 1.0 license.** All content. The full legal code is in `LICENSE`. Every Markdown file has `license: CC0-1.0` in front matter. Every page footer states it.
3. **"Christ Community" not "church."** If the word "church" appears in any user-facing text outside of direct Bible quotation or a historical proper noun, that is a bug.
4. **8GC wording is locked.** Use the v2026-04-08 wording exactly as it appears in canon. Do not paraphrase, soften, reorder, or expand.
5. **M2L precedes M4L, always.** In any page that touches both, M2L (Ministry TO the Lord) must appear first, structurally and visually.
6. **NIV scripture, full text.** Where a verse is quoted, use NIV and quote it in full — not a summary, not a paraphrase. Include the citation.
7. **Dirt-drawable simplicity for Tier 1 and Tier 2.** If a piece of content cannot be drawn in dirt with a stick, it does not belong in Tier 1 or Tier 2.
8. **No photographs of identifiable believers in the field.** Illustration, diagrams, SVG only.
9. **Factual accuracy.** Never embellish, never infer doctrinal claims, never invent quotes or stories. If the canon does not contain something, do not create it; flag and ask.
10. **Mobile-first, low-bandwidth aware.** Every page must be usable on a 360px-wide screen on 3G. The primary audience phone is a ₹5,000 Android.

### 2.3 The three audiences

- **Field worker** (South Asia, cheap Android, often offline). Default audience. Lands on the home screen, sees 9 card tiles and 8 command tiles, taps one, gets dirt-drawable content. Installs PWA. Receives single-file HTML bundles via WhatsApp.
- **Coach / trainer** (Western, high-bandwidth, deploying materials to others). Same site, deeper paths via "Deeper" nav and Tier 3/4 badges. Downloads PDFs, A4 print-ready cards, facilitator notes.
- **Seeker / global believer** (anywhere, any device). Lands on home screen, follows "Start Here" card, reads Three Verses. No friction, no signup, no paywall.

---

## 3. Glossary

| Term | Meaning |
|---|---|
| 8GC | The 8 General Commands (v2026-04-08, locked wording) |
| M2L | Ministry **TO** the Lord — seeking God for who He is. Always precedes M4L. |
| M4L | Ministry **FOR** the Lord — work done in His name. Comes after M2L. |
| Three Verses | John 3:16 (See) / John 1:12–13 (Shift) / Matthew 22:37–40 (Sift). |
| Two-Pillar | Pillar 1 = Three Verses (message). Pillar 2 = Luke 9:57–10:42 (strategic charter). |
| Six Encounter Questions | See Him → Love Him → Live for Him. Governs ongoing gatherings. |
| Relational Question Set | Prodigal Son (Lk 15:11–32) flow for pre-gathering contexts. |
| Christ Community | The standard term. Never "church." |
| Jesus Community | Used specifically inside the Life with God field guide context. |
| Tier 1–4 | Ministry Canon Map depth ladder. Tier 1 = core, Tier 4 = background. |
| Card | One of the 9 bookmark cards A–I in the Life with God field guide. |
| Canon | The locked, authoritative source content in `ministry-kb`. |
| Müller | No solicitation; provision reported after the fact. |

---

## 4. Tech stack

| Concern | Choice | Version | Notes |
|---|---|---|---|
| Static site generator | Hugo Extended | ≥0.140 | Single Go binary; no Node/Ruby/Python for basic build |
| Theme | Hugo Relearn | latest | Vendored into `themes/relearn/`; not a submodule |
| Search | Pagefind | ≥1.3 | WASM, multilingual, runs in browser |
| Single-file bundler | monolith (Rust CLI) | latest | CC0 licensed |
| PDF generator | pagedjs-cli + Chromium headless | latest | MIT licensed |
| Signing | minisign | latest | Ed25519 |
| Service worker | Workbox CLI | 7.x | Run once at CI time |
| Image processing | Hugo built-in | — | WebP + JPEG fallback, 320/640/1280w |
| Fonts | Noto Sans + Noto Sans Devanagari, subsetted WOFF2 | — | `font-display: swap` |
| Phase 1 hosts | GitHub Pages + Cloudflare Pages | — | — |
| Phase 2 hosts adds | Netlify, Codeberg Pages, GitLab Pages, Wayback | — | — |
| Phase 3 host adds | IPFS (Pinata + DNSLink), Tor onion, self-hosted Caddy | — | — |
| Audio host | archive.org | — | Primary. CC0 native. Account to be created. |
| Video host | PeerTube on Hetzner VPS | latest stable | **Phase 3 only.** archive.org secondary. YouTube mirror only. |
| Languages v1 | English (`en`) | — | — |
| Languages v2 | Hindi (`hi`) | — | Phase 2 |
| Short-URL domain | TBD — register before Phase 2 QR cards | — | `/1`–`/9` redirect to card pages |
| Release versioning | Calendar: `vYYYY.MM.PATCH` | — | First: `v2026.05.0` |

**Anti-stack (never introduce):** React, Vue, Tailwind, Node-based Hugo rendering, Docker for development, Ruby, MkDocs, Quartz, any analytics, any tracking pixels, any CMS, any database, any server-side rendering.

---

## 5. Repository structure

```
tsunamiunleashed.com/              # github.com/tsunami-unleashed/tsunamiunleashed.com
├── README.md
├── LICENSE                        # CC0 1.0 full legal code
├── NOTICE.md
├── MIRRORS.md
├── SECURITY.md                    # minisign public key + verify instructions
├── CONTRIBUTING.md
├── CANON.md                       # Pointer to ministry-kb
├── CODEOWNERS                     # content/hi/ → Hindi field leader's GitHub username
├── hugo.toml
├── workbox-config.js
├── config/
│   └── _default/
│       ├── languages.toml
│       ├── menus.en.toml
│       ├── menus.hi.toml
│       └── params.toml
├── content/
│   ├── en/
│   │   ├── _index.md
│   │   ├── start-here/
│   │   ├── cards/                 # card-a through card-i
│   │   ├── commands/              # command-1 through command-8
│   │   ├── verses/                # three-verses, two-pillar, six-encounter-questions,
│   │   │                          #   relational-question-set
│   │   ├── deeper/
│   │   ├── stories/
│   │   └── pack/                  # aggregated Tier 1+2 for monolith bundle
│   │       └── _index.md
│   └── hi/                        # Phase 2 — mirror of en/ tree
├── data/
│   ├── canon.toml                 # 8GC, Three Verses, Six Encounter Questions
│   ├── tiers.toml
│   └── media.toml                 # Phase 2 — external audio/video manifest
├── i18n/
│   ├── en.toml
│   └── hi.toml                    # Phase 2
├── layouts/
│   ├── _default/
│   │   ├── baseof.html
│   │   ├── single.html
│   │   ├── list.html
│   │   └── card.html
│   ├── partials/
│   │   ├── tier-badge.html
│   │   ├── footer-license.html
│   │   ├── lang-switcher.html
│   │   ├── pwa-install.html
│   │   └── version-widget.html    # Phase 3
│   └── shortcodes/
│       ├── verse.html
│       ├── card-link.html
│       ├── command.html
│       └── media.html             # Phase 2
├── assets/
│   ├── css/
│   │   ├── custom.css
│   │   └── print.css
│   ├── js/
│   │   ├── pwa-register.js
│   │   └── version-check.js       # Phase 3
│   ├── media/
│   │   └── images/
│   │       └── logo.svg           # Edward's SVG — place here when received
│   └── fonts/
│       ├── noto-sans-subset.woff2
│       └── noto-sans-devanagari-subset.woff2
├── static/
│   ├── manifest.webmanifest
│   ├── sw.js                      # Workbox-generated
│   ├── icons/
│   │   ├── icon-192.png
│   │   └── icon-512.png
│   ├── .well-known/
│   │   ├── cc0.txt
│   │   ├── minisign.pub
│   │   └── security.txt
│   └── mirrors.json
├── themes/
│   └── relearn/                   # Vendored — not a submodule
├── scripts/
│   ├── build.sh
│   ├── manifest.sh
│   ├── sign.sh
│   ├── bundle-html.sh
│   ├── bundle-pdf.sh
│   ├── bundle-zim.sh              # Phase 2
│   ├── bundle-sd.sh               # Phase 2
│   ├── fetch-media.sh             # Phase 2
│   └── verify.sh
└── .github/
    └── workflows/
        ├── ci.yml
        └── deploy.yml
```

---

## 6. Phase 0: Bootstrap

Goal: empty repo, Hugo runs, first commit pushed.

### 6.1 Create the repo

```bash
# CMD
# 1. Create the org at github.com — "tsunami-unleashed" — via GitHub UI.
# 2. Create the repo "tsunamiunleashed.com" under that org, public, no template.
# 3. Clone locally:
git clone git@github.com:tsunami-unleashed/tsunamiunleashed.com.git
cd tsunamiunleashed.com
hugo version   # must show ≥0.140 extended
```

### 6.2 Create `hugo.toml`

```toml
# FILE: hugo.toml
baseURL = "https://tsunamiunleashed.com/"
title = "Tsunami Unleashed"
theme = "relearn"
defaultContentLanguage = "en"
defaultContentLanguageInSubdir = false
enableGitInfo = true
enableRobotsTXT = true
enableEmoji = true
hasCJKLanguage = false

[outputs]
home = ["HTML", "RSS", "JSON"]

[markup.goldmark.renderer]
unsafe = true

[markup.tableOfContents]
startLevel = 2
endLevel = 4
ordered = false
```

### 6.3 Vendor the Hugo Relearn theme

```bash
# CMD
git clone --depth 1 https://github.com/McShelby/hugo-theme-relearn.git themes/relearn
rm -rf themes/relearn/.git
git add themes/relearn
```

### 6.4 `config/_default/languages.toml`

```toml
# FILE: config/_default/languages.toml
[en]
languageCode = "en"
languageName = "English"
weight = 1
contentDir = "content/en"

[hi]
languageCode = "hi"
languageName = "हिन्दी"
weight = 2
contentDir = "content/hi"
disabled = true    # flip to false in Phase 2
```

### 6.5 `CODEOWNERS`

```
# FILE: CODEOWNERS
# Hindi content requires review from the designated Hindi field leader.
# Edward: replace @hindi-reviewer-github with the actual GitHub username
# before Phase 2 begins.
/content/hi/  @tsunami-unleashed/edward @hindi-reviewer-github
```

### 6.6 `LICENSE`

Paste the **full** CC0 1.0 Universal legal code from https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt. Do not abbreviate.

### 6.7 First commit

```bash
# CMD
cat > .gitignore << 'EOF'
node_modules/
public/
resources/
.hugo_build.lock
*.minisig.tmp
/tsunami.key
EOF

cat > .editorconfig << 'EOF'
root = true
[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
EOF

git add -A
git commit -m "chore: Phase 0 bootstrap"
git push -u origin main
```

### 6.8 Acceptance: Phase 0

- `hugo server` runs without errors at `http://localhost:1313`.
- `git log --oneline` shows one commit on `main` in the `tsunami-unleashed` org.
- `LICENSE` is the full CC0 legal text, unabridged.
- `CODEOWNERS` is in place with a placeholder for the Hindi reviewer username.

---

## 7. Phase 1: The spine

Goal: English-only site live on GitHub Pages and Cloudflare Pages, all 9 cards, all 8 commands, Three Verses, Two-Pillar, Six Encounter Questions, Relational Question Set, signed manifest, installable PWA, single-file HTML + PDF bundles produced in CI, README that lets a stranger fork-and-rehost in 5 minutes.

First release tag on passing acceptance: **`v2026.05.0`**.

### 7.1 Front-matter schema

Every Markdown file in `content/en/` uses this schema:

```yaml
# SNIPPET — front matter template
---
title: "Card A — Ministry to the Lord"
slug: "card-a"
weight: 1
tier: 1
audiences: ["field", "coach", "seeker"]
license: "CC0-1.0"
canonRef: "ministry-kb/life-with-god/card-a.md"
translationKey: "card-a"
lastSourceUpdate: "2026-04-15"
summary: "Ministry to the Lord — seeking God for who He is."
---
```

`translationKey` must match exactly across language pairs. `canonRef` anchors to `ministry-kb`; it is required and must not be blank.

### 7.2 The 9 bookmark cards (`content/en/cards/`)

Pull content verbatim from the canonical Life with God field guide HTML. One file per card.

| File | Slug | Title | Tier |
|---|---|---|---|
| `card-a.md` | `card-a` | Ministry to the Lord (M2L) | 1 |
| `card-b.md` | `card-b` | Three Key Verses (See / Shift / Sift) | 1 |
| `card-c.md` | `card-c` | The 8 General Commands | 1 |
| `card-d.md` | `card-d` | Telling Your Story | 2 |
| `card-e.md` | `card-e` | Spiritual Conversations | 2 |
| `card-f.md` | `card-f` | The Prodigal Son | 2 |
| `card-g.md` | `card-g` | Gathering (Six Encounter Questions) | 2 |
| `card-h.md` | `card-h` | Stories for the 8 General Commands | 2 |
| `card-i.md` | `card-i` | Key Words | 1 |

Each card uses the `card` layout. Design constraint: **one screen on a 360px-wide mobile**. If content overflows one screen, reduce — do not scroll.

### 7.3 The 8 General Commands (`content/en/commands/`)

Use the **locked v2026-04-08 wording** exactly. No paraphrasing.

```
1. Love God                              Mt 22:37; Lk 10:25–28; Lk 10:38–42
2. Love Neighbors, Enemies, Believers    Mt 22:39; Lk 6:27–35; Jn 13:34–35
3. Believe / Repent / Receive Spirit     Jn 3:16; Mk 1:14–15; Jn 20:19–22
4. Baptize                               Mt 28:19; Ac 8:26–40
5. Lord's Supper                         Lk 22:14–20; Lk 24:13–35
6. Pray in Name of Jesus                 Lk 11:1–13; Jn 14:13–14
7. Give Generously                       Mk 12:41–44
8. Make Disciples                        Mt 28:16–20; Lk 10:1–9; 2Ti 2:2
```

Each command page: title → Scripture (full NIV via `verse` shortcode) → worked example (from canon) → story (from canon, Card H source). Tier 1.

Also create `data/canon.toml` as structured data:

```toml
# FILE: data/canon.toml

[[commands]]
number = 1
title = "Love God"
refs = ["Matthew 22:37", "Luke 10:25–28", "Luke 10:38–42"]

[[commands]]
number = 2
title = "Love Neighbors, Enemies, and Believers"
refs = ["Matthew 22:39", "Luke 6:27–35", "John 13:34–35"]

[[commands]]
number = 3
title = "Believe, Repent, Receive the Holy Spirit"
refs = ["John 3:16", "Mark 1:14–15", "John 20:19–22"]

[[commands]]
number = 4
title = "Baptize"
refs = ["Matthew 28:19", "Acts 8:26–40"]

[[commands]]
number = 5
title = "Lord's Supper"
refs = ["Luke 22:14–20", "Luke 24:13–35"]

[[commands]]
number = 6
title = "Pray in the Name of Jesus"
refs = ["Luke 11:1–13", "John 14:13–14"]

[[commands]]
number = 7
title = "Give Generously"
refs = ["Mark 12:41–44"]

[[commands]]
number = 8
title = "Make Disciples"
refs = ["Matthew 28:16–20", "Luke 10:1–9", "2 Timothy 2:2"]

[[three_verses]]
label = "See"
ref = "John 3:16"
theme = "God so loved the world"

[[three_verses]]
label = "Shift"
ref = "John 1:12–13"
theme = "Becoming children of God"

[[three_verses]]
label = "Sift"
ref = "Matthew 22:37–40"
theme = "Love God, love others"
```

### 7.4 Three Verses, Two-Pillar, and encounter content (`content/en/verses/`)

| File | Slug | Tier |
|---|---|---|
| `_index.md` | — | — |
| `three-verses.md` | `three-verses` | 1 |
| `two-pillar.md` | `two-pillar` | 2 |
| `six-encounter-questions.md` | `six-encounter-questions` | 2 |
| `relational-question-set.md` | `relational-question-set` | 2 |

Pull all content from canon verbatim.

### 7.5 Tier badge system

```toml
# FILE: data/tiers.toml
[[tier]]
n = 1
glyph = "★"
label = "Core"
class = "tier-1"
desc = "Dirt-drawable. Memorize this."

[[tier]]
n = 2
glyph = "★★"
label = "Practice"
class = "tier-2"
desc = "How to use the core in real life."

[[tier]]
n = 3
glyph = "★★★"
label = "Deeper"
class = "tier-3"
desc = "For coaches and trainers."

[[tier]]
n = 4
glyph = "★★★★"
label = "Background"
class = "tier-4"
desc = "Scholarly context."
```

```html
<!-- FILE: layouts/partials/tier-badge.html -->
{{ $tier := .Params.tier | default 1 }}
{{ $data := index site.Data.tiers.tier (sub $tier 1) }}
<span class="tier-badge {{ $data.class }}" title="{{ $data.desc }}">
  <span class="tier-glyph">{{ $data.glyph }}</span>
  <span class="tier-label">{{ $data.label }}</span>
</span>
```

Render this partial at the top of every page.

### 7.6 Home page (`content/en/_index.md`)

Single screen. Order:

1. Three Verses — three panels with full NIV verse text (use `verse` shortcode).
2. 9 card tiles (A–I) — title + one-line summary, horizontal strip.
3. 8 command tiles — numbered, horizontal strip.
4. "Start Here →" button linking to `/start-here/`.
5. Footer.

No marketing copy. No mission statement. The content is the content.

### 7.7 The `verse` shortcode

```html
<!-- FILE: layouts/shortcodes/verse.html -->
{{- $ref := .Get "ref" -}}
{{- $text := .Inner -}}
<blockquote class="verse" lang="{{ $.Page.Lang }}">
  <p>{{ $text | safeHTML }}</p>
  <cite>— {{ $ref }} (NIV)</cite>
</blockquote>
```

Usage:
```markdown
{{< verse ref="John 3:16" >}}
For God so loved the world that he gave his one and only Son, that whoever
believes in him shall not perish but have eternal life.
{{< /verse >}}
```

This is the **only** approved way to render Scripture on the site.

### 7.8 Logo handling

When Edward provides `logo.svg`, place it at `assets/media/images/logo.svg`. Reference it in `baseof.html` via:

```html
<!-- SNIPPET — logo in baseof.html -->
{{- $logo := resources.GetMatch "media/images/logo.svg" -}}
{{- if $logo -}}
  <img src="{{ $logo.RelPermalink }}" alt="Tsunami Unleashed" class="site-logo">
{{- else -}}
  <span class="site-wordmark">Tsunami Unleashed</span>
{{- end -}}
```

Phase 1 ships with the text-only wordmark fallback until the SVG is received.

### 7.9 PWA setup

```json
// FILE: static/manifest.webmanifest
{
  "name": "Tsunami Unleashed",
  "short_name": "Tsunami",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#0a4d68",
  "icons": [
    { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

Generate 192px and 512px PNG icons from `logo.svg` (or a placeholder wave mark if SVG not yet received). Place in `static/icons/`.

```javascript
// FILE: assets/js/pwa-register.js
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(console.error);
  });
}
```

```javascript
// FILE: workbox-config.js
module.exports = {
  globDirectory: 'public/',
  globPatterns: ['**/*.{html,css,js,woff2,svg,png,webp,json}'],
  globIgnores: ['**/bundles/**', '**/media/**'],
  swDest: 'public/sw.js',
  maximumFileSizeToCacheInBytes: 5_000_000,
  runtimeCaching: [
    {
      urlPattern: ({ request }) => request.destination === 'image',
      handler: 'CacheFirst',
      options: {
        cacheName: 'images',
        expiration: { maxEntries: 100, maxAgeSeconds: 30 * 24 * 60 * 60 }
      }
    }
  ]
};
```

Target: total precached app shell **under 10 MB**.

### 7.10 minisign keypair and manifest pipeline

Generate keypair **once on a trusted local machine, never in CI**:

```bash
# CMD — run once locally
minisign -G -p static/.well-known/minisign.pub -s ~/.minisign/tsunami.key
# Store ~/.minisign/tsunami.key in 1Password. Never commit it.
# Commit static/.well-known/minisign.pub.
```

Add to `SECURITY.md`: the public key fingerprint, instructions for verifying, and note that the DNS TXT record on `tsunamiunleashed.com` also publishes the key (Edward to add: `tsunami-pubkey=<key>` TXT record).

Add to GitHub Actions secrets:
- `MINISIGN_SECRET_KEY` — contents of `~/.minisign/tsunami.key` (base64-encoded or raw)

```bash
# FILE: scripts/manifest.sh
#!/usr/bin/env bash
set -euo pipefail
cd public
VERSION=$(git -C .. describe --tags --always 2>/dev/null || echo "untagged")
COMMIT=$(git -C .. rev-parse HEAD 2>/dev/null || echo "unknown")
BUILT_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)
{
  echo "{"
  echo "  \"version\": \"$VERSION\","
  echo "  \"commit\": \"$COMMIT\","
  echo "  \"built_at\": \"$BUILT_AT\","
  echo "  \"files\": ["
  find . -type f \
    ! -name 'MANIFEST.json' \
    ! -name 'MANIFEST.json.minisig' \
    -print0 \
    | sort -z \
    | xargs -0 -I{} sh -c \
      'printf "    {\"path\": \"%s\", \"sha256\": \"%s\"}\n" \
       "${1#./}" "$(sha256sum "$1" | cut -d" " -f1)"' _ {} \
    | paste -sd ',\n' -
  echo "  ]"
  echo "}"
} > MANIFEST.json
```

```bash
# FILE: scripts/sign.sh
#!/usr/bin/env bash
set -euo pipefail
printf '%s' "$MINISIGN_SECRET_KEY" > /tmp/tsunami-sign.key
chmod 600 /tmp/tsunami-sign.key
minisign -Sm public/MANIFEST.json -s /tmp/tsunami-sign.key
shred -u /tmp/tsunami-sign.key
```

```bash
# FILE: scripts/verify.sh
#!/usr/bin/env bash
set -euo pipefail
PUB=$(cat static/.well-known/minisign.pub)
minisign -Vm public/MANIFEST.json -P "$PUB"
echo "Signature valid."
```

### 7.11 Single-file HTML bundle

```bash
# FILE: scripts/bundle-html.sh
#!/usr/bin/env bash
set -euo pipefail
DATE=$(date -u +%Y-%m)
mkdir -p public/bundles
monolith http://localhost:8080/pack/ \
  --no-audio --no-video \
  --output "public/bundles/TsunamiUnleashed_Complete_EN_v${DATE}.html"
SIZE=$(stat -c%s "public/bundles/TsunamiUnleashed_Complete_EN_v${DATE}.html")
if [ "$SIZE" -gt 50000000 ]; then
  echo "ERROR: bundle exceeds 50MB ($SIZE bytes). Investigate." >&2; exit 1
fi
echo "Bundle size: $((SIZE / 1024))KB"
```

The `/pack/` page (`content/en/pack/_index.md`) aggregates all Tier 1 and Tier 2 content into a single scroll — it is the monolith input and the WhatsApp payload.

### 7.12 PDF bundles

```bash
# FILE: scripts/bundle-pdf.sh
#!/usr/bin/env bash
set -euo pipefail
DATE=$(date -u +%Y-%m)
mkdir -p public/bundles
pagedjs-cli http://localhost:8080/print/field-guide/ \
  --output "public/bundles/LifeWithGod_FieldGuide_EN_v${DATE}_A5.pdf"
pagedjs-cli http://localhost:8080/print/cards/ \
  --output "public/bundles/BookmarkCards_EN_v${DATE}_A4.pdf"
pagedjs-cli http://localhost:8080/print/commands/ \
  --output "public/bundles/8GC_EN_v${DATE}_A4.pdf"
```

Create `content/en/print/` pages with `@page` CSS rules in `assets/css/print.css`.

### 7.13 GitHub Actions: CI and deploy

```yaml
# FILE: .github/workflows/ci.yml
name: ci
on:
  pull_request:
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: peaceiris/actions-hugo@v3
        with: { hugo-version: '0.140.0', extended: true }
      - run: hugo --minify
      - name: Check for 'church' in rendered output
        run: |
          if grep -rI --include="*.html" -w "church" public/ | grep -v "<!--" ; then
            echo "ERROR: word 'church' found in rendered output." >&2; exit 1
          fi
      - name: Check for donation language
        run: |
          if grep -rI --include="*.html" -iE "(donate|support us|give to|help fund)" public/; then
            echo "ERROR: solicitation language found." >&2; exit 1
          fi
      - name: Check all Markdown files have license front matter
        run: |
          while IFS= read -r -d '' f; do
            if ! grep -q "license: CC0-1.0" "$f"; then
              echo "ERROR: $f missing 'license: CC0-1.0' in front matter." >&2; exit 1
            fi
          done < <(find content/ -name "*.md" -print0)
```

```yaml
# FILE: .github/workflows/deploy.yml
name: deploy
on:
  push:
    branches: [main]
    tags: ['v*']
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - uses: peaceiris/actions-hugo@v3
        with: { hugo-version: '0.140.0', extended: true }
      - name: Install tools
        run: |
          cargo install monolith --locked
          npm install -g pagedjs-cli workbox-cli
          curl -sSfL \
            https://github.com/jedisct1/minisign/releases/latest/download/minisign-linux-x86_64.tar.gz \
            | tar xz && sudo mv minisign /usr/local/bin/
      - name: Build site
        run: hugo --minify
      - name: Run local server for bundle scripts
        run: (cd public && python3 -m http.server 8080 &) && sleep 3
      - name: Generate bundles
        run: |
          bash scripts/bundle-html.sh
          bash scripts/bundle-pdf.sh
      - name: Generate service worker
        run: workbox generateSW workbox-config.js
      - name: Generate and sign manifest
        env:
          MINISIGN_SECRET_KEY: ${{ secrets.MINISIGN_SECRET_KEY }}
        run: |
          bash scripts/manifest.sh
          bash scripts/sign.sh
      - uses: actions/upload-artifact@v4
        with: { name: site, path: public/ }

  deploy-github-pages:
    needs: build
    runs-on: ubuntu-latest
    permissions: { pages: write, id-token: write }
    steps:
      - uses: actions/download-artifact@v4
        with: { name: site, path: public/ }
      - uses: actions/upload-pages-artifact@v3
        with: { path: public/ }
      - uses: actions/deploy-pages@v4

  deploy-cloudflare-pages:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with: { name: site, path: public/ }
      - uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CF_API_TOKEN }}
          accountId: ${{ secrets.CF_ACCOUNT_ID }}
          projectName: tsunamiunleashed
          directory: public

  archive:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Wayback save
        run: |
          curl -sS "https://web.archive.org/save/https://tsunamiunleashed.com/" || true
```

### 7.14 DNS records Edward needs to add

When Phase 1 deploys, add these records at `tsunamiunleashed.com` DNS:

| Type | Name | Value |
|---|---|---|
| CNAME | `@` or `www` | `tsunami-unleashed.github.io` |
| TXT | `@` | `tsunami-pubkey=<minisign public key>` |
| TXT | `@` | `v=spf1 ...` (existing, do not overwrite) |

Cloudflare Pages uses its own domain by default (`tsunamiunleashed.pages.dev`); add a custom domain in the CF Pages dashboard pointing `mirror1.tsunamiunleashed.com` → CF Pages.

### 7.15 Key static files

```markdown
<!-- FILE: README.md -->
# Tsunami Unleashed — Resources

Public-domain (CC0) discipleship multiplication resources.
Copy, modify, redistribute, translate, re-host — no permission needed.

## Mirror this site in 5 minutes

```bash
git clone https://github.com/tsunami-unleashed/tsunamiunleashed.com.git
cd tsunamiunleashed.com
hugo --minify
# Serve public/ on any web host.
```

## Verify what you got

```bash
minisign -Vm public/MANIFEST.json -P $(cat static/.well-known/minisign.pub)
```

## Contribute

PRs welcome. See CONTRIBUTING.md. Translations especially welcome.

## License

CC0 1.0 Universal. Public domain. No rights reserved.
```

```markdown
<!-- FILE: NOTICE.md -->
# A note from those who put this together

This material is offered freely. We do not ask for support of any kind.

CC0. Take it. Use it. Translate it. Re-host it. Multiply it.
```

```markdown
<!-- FILE: MIRRORS.md -->
# Known mirrors

| URL | Operator | Last verified |
|---|---|---|
| https://tsunamiunleashed.com | canonical | — |
| https://tsunamiunleashed.pages.dev | Cloudflare mirror | — |

Submit a PR to add your mirror.
```

```
# FILE: static/.well-known/cc0.txt
license: CC0-1.0
dedication: https://creativecommons.org/publicdomain/zero/1.0/
content-source: https://github.com/tsunami-unleashed/tsunamiunleashed.com
verify: https://tsunamiunleashed.com/.well-known/minisign.pub
```

```html
<!-- FILE: layouts/partials/footer-license.html -->
<footer class="site-footer">
  <p>
    🅮 Public domain (CC0).
    <a href="https://github.com/tsunami-unleashed/tsunamiunleashed.com">Clone this site →</a> ·
    <a href="/mirrors/">Mirror list</a> ·
    <a href="/.well-known/minisign.pub">Verify ↗</a>
  </p>
</footer>
```

### 7.16 Tag and release

When all Phase 1 acceptance tests pass:

```bash
# CMD
git tag -a v2026.05.0 -m "Phase 1: English spine, PWA, signed manifest, two-host deploy"
git push origin v2026.05.0
```

The deploy workflow triggers on the tag. GitHub Release is created manually with the bundle artifacts attached.

### 7.17 Acceptance: Phase 1

All must pass. No exceptions.

1. **Fork-and-rehost test.** Clone → `hugo --minify` → serve `public/` locally in under 10 minutes on a machine that has never seen this repo.
2. **Mobile test.** On a 360px-wide screen (real Android or Chrome DevTools 3G sim), every page is readable, tap targets ≥44px, first paint under 2 seconds.
3. **PWA test.** Android Chrome → Add to Home Screen → airplane mode → reopen → all Tier 1 content available offline.
4. **Bundle tests.** Single-file HTML bundle opens in Chrome and Firefox offline, under 50 MB. Three PDFs print correctly.
5. **Signature test.** `bash scripts/verify.sh` passes.
6. **License test.** Every `.md` file has `license: CC0-1.0`. Every page footer shows CC0 line. `LICENSE` is full legal text.
7. **No-solicitation test.** CI grep for "donate", "support us", "give to", "help fund" returns zero hits.
8. **No-church test.** CI grep for standalone word "church" in rendered HTML returns zero hits outside Bible quotations.
9. **Tier badge test.** Every page renders a visible Tier badge.
10. **Two-host live test.** GitHub Pages and Cloudflare Pages both serve the site with valid TLS.
11. **Tag test.** `git tag` shows `v2026.05.0`. GitHub Release exists with PDF and HTML bundle artifacts attached.

---

## 8. Phase 2: Hindi, audio, ZIM, additional mirrors

Goal: Hindi live (reviewed by designated field leader), Pagefind search, audio via archive.org, ZIM bundles submitted to Kiwix, four additional mirror hosts active, SD-card image producible, QR codes on physical bookmark cards.

### 8.1 Pre-Phase-2 checklist

- [ ] Designate Hindi field leader; add GitHub username to `CODEOWNERS`
- [ ] Create archive.org account with ministry email; add credentials to 1Password
- [ ] Register short-URL domain; configure `/1`–`/9` redirects
- [ ] Print first run of bookmark cards with QR codes; test QR codes on Android

### 8.2 Enable Hindi

Flip `disabled = true` → `disabled = false` in `config/_default/languages.toml` for `[hi]`.

Mirror `content/en/` to `content/hi/`. Preserve all `translationKey:` values exactly. Source: existing English/Hindi canon pairs. Resolve before launch: चेला vs शिष्य, M2L rendering, §3 translation error, कलिसिया vs "Christ Community", omitted preamble, भगवान् vs परमेश्वर.

All PRs to `content/hi/` require the Hindi field leader's GitHub approval (enforced by `CODEOWNERS`).

### 8.3 i18n strings

```toml
# FILE: i18n/en.toml
[home_start_here]
other = "Start Here"
[nav_cards]
other = "Cards"
[nav_commands]
other = "Commands"
[nav_verses]
other = "Verses"
[nav_deeper]
other = "Deeper"
[nav_stories]
other = "Stories"
[footer_license]
other = "Public domain (CC0)."
[footer_clone]
other = "Clone this site"
[footer_verify]
other = "Verify"
[tier_core]
other = "Core"
[tier_practice]
other = "Practice"
[tier_deeper]
other = "Deeper"
[tier_background]
other = "Background"
```

Create `i18n/hi.toml` with Hindi equivalents of every key.

### 8.4 Pagefind search

```bash
# CMD — added to scripts/build.sh after hugo --minify
npx -y pagefind --site public --output-path public/pagefind
```

Add to `baseof.html`:

```html
<!-- SNIPPET -->
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js"></script>
<div id="search"></div>
<script>
  window.addEventListener('DOMContentLoaded', () => {
    new PagefindUI({ element: "#search", showImages: false });
  });
</script>
```

### 8.5 Devanagari typography

```bash
# CMD — run once to subset the font
pyftsubset NotoSansDevanagari-Regular.ttf \
  --unicodes="U+0900-097F,U+0020-007E" \
  --layout-features='*' \
  --flavor=woff2 \
  --output-file=assets/fonts/noto-sans-devanagari-subset.woff2
```

```css
/* SNIPPET — assets/css/custom.css */
@font-face {
  font-family: 'Noto Sans Devanagari';
  src: url('/fonts/noto-sans-devanagari-subset.woff2') format('woff2');
  font-display: swap;
  unicode-range: U+0900-097F;
}
:lang(hi) {
  font-family: 'Noto Sans Devanagari', system-ui, sans-serif;
  line-height: 1.7;
}
```

**Mandatory:** test on a real ₹5,000 Android before declaring Phase 2 complete.

### 8.6 Translation staleness flag

```html
<!-- FILE: layouts/partials/staleness-warning.html -->
{{- $self := . -}}
{{- range .Translations -}}
  {{- if and (eq .Lang "en") (gt .Params.lastSourceUpdate $self.Params.lastSourceUpdate) -}}
    <div class="staleness-warning">
      ⚠ This translation is based on English v{{ $self.Params.lastSourceUpdate }}.
      English was updated v{{ .Params.lastSourceUpdate }}.
      <a href="{{ .RelPermalink }}">View current English ↗</a>
    </div>
  {{- end -}}
{{- end -}}
```

Include in `single.html` immediately after the Tier badge.

### 8.7 Media manifest and shortcode

```toml
# FILE: data/media.toml
# Populated as audio is uploaded to archive.org.
# id must be globally unique and stable.
# Example entry (replace with real values):

[[items]]
id = "story-prodigal-en-v2026-05"
type = "audio"
title_en = "The Prodigal Son (English narration)"
title_hi = "उड़ाऊ बेटा"
duration_seconds = 487
size_bytes = 4_410_000
license = "CC0-1.0"
languages = ["en"]
sha256 = "REPLACE_WITH_REAL_SHA256"
transcript = "content/en/stories/prodigal-transcript.md"

  [[items.sources]]
  url = "https://archive.org/download/tsunami-prodigal-en/prodigal-en.mp3"
  role = "canonical"

  [[items.sources]]
  url = "/media/audio/prodigal-en.mp3"
  role = "local-bundle"
```

```html
<!-- FILE: layouts/shortcodes/media.html -->
{{- $id := .Get "id" -}}
{{- $items := where site.Data.media.items "id" $id -}}
{{- with index $items 0 -}}
  {{- $canonical := index (where .sources "role" "canonical") 0 -}}
  {{- $src := $canonical.url -}}
  {{- $lang := $.Page.Lang -}}
  {{- $title := index . (printf "title_%s" $lang) | default .title_en -}}
  {{- $sizeMB := div .size_bytes 1048576 -}}
  <figure class="media media-{{ .type }}">
    {{ if eq .type "audio" }}
      <audio controls preload="none" src="{{ $src }}"></audio>
    {{ end }}
    {{/* Video type stubbed here; implemented in Phase 3 */}}
    <figcaption>
      <strong class="media-title">{{ $title }}</strong>
      <span class="media-meta">{{ $sizeMB }} MB</span>
      <a class="media-download" href="{{ $src }}" download>
        Download {{ if eq .type "audio" }}MP3{{ else }}MP4{{ end }}
        ({{ $sizeMB }} MB)
      </a>
      {{ with .transcript }}
        <a class="media-transcript" href="/{{ . }}">Transcript ↗</a>
      {{ end }}
    </figcaption>
  </figure>
{{- end -}}
```

### 8.8 archive.org upload workflow

For each audio file:

```bash
# CMD
pip install internetarchive
ia configure   # enter ministry archive.org credentials once
ia upload tsunami-prodigal-en prodigal-en.mp3 \
  --metadata="title:The Prodigal Son (English narration)" \
  --metadata="creator:Tsunami Unleashed" \
  --metadata="licenseurl:https://creativecommons.org/publicdomain/zero/1.0/" \
  --metadata="mediatype:audio" \
  --metadata="collection:opensource_audio"
# Compute hash and add to data/media.toml:
sha256sum prodigal-en.mp3
```

Submit selected audio to GRN 5fish (manual; separate process — not automated in CI).

### 8.9 ZIM bundles

```bash
# FILE: scripts/bundle-zim.sh
#!/usr/bin/env bash
set -euo pipefail
DATE=$(date -u +%Y-%m)
mkdir -p public/bundles

for LANG in en hi; do
  zimwriterfs \
    --welcome=index.html \
    --illustration=icons/icon-512.png \
    --language=$LANG \
    --title="Tsunami Unleashed" \
    --description="Discipleship resources (text only)" \
    --creator="Tsunami Unleashed" \
    --publisher="Tsunami Unleashed" \
    --name="tsunami_${LANG}_mini_${DATE}" \
    public/$LANG \
    "public/bundles/tsunami_${LANG}_mini_${DATE}.zim"
done
# Core and full ZIM flavors (with audio/video) to be added
# once media is staged into the build tree.
```

Submit ZIMs to library.kiwix.org (manual, one-time per release).

### 8.10 Additional deploy targets

Add these jobs to `.github/workflows/deploy.yml` (each downloads the same `site` artifact):

- `deploy-netlify` — `nwtgck/actions-netlify@v3` with `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID` secrets.
- `deploy-codeberg` — push `public/` to a Codeberg repo's `pages` branch via SSH deploy key.
- `deploy-gitlab` — push `public/` to a GitLab Pages branch via SSH deploy key.
- `archive` already pings Wayback (exists from Phase 1).

DNS records Edward adds for Phase 2:

| Type | Name | Value |
|---|---|---|
| CNAME | `mirror1` | Netlify domain |
| CNAME | `mirror2` | Codeberg pages domain |
| CNAME | `mirror3` | GitLab pages domain |

### 8.11 SD-card bundle

```bash
# FILE: scripts/bundle-sd.sh
#!/usr/bin/env bash
set -euo pipefail
SD=public/bundles/sd-image
mkdir -p "$SD"/{content/en,content/hi,bundles,kiwix,apk,media/audio}

cp -r public/en  "$SD/content/"
cp -r public/hi  "$SD/content/" 2>/dev/null || true
cp public/bundles/*.html public/bundles/*.pdf "$SD/bundles/" 2>/dev/null || true
cp public/bundles/*.zim "$SD/kiwix/" 2>/dev/null || true
# Fetch Kiwix APK once and cache in scripts/cache/
cp scripts/cache/kiwix-reader.apk "$SD/apk/" 2>/dev/null || true

cat > "$SD/START-HERE.html" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>Tsunami Unleashed — Start Here</title></head>
<body>
  <h1>Tsunami Unleashed</h1>
  <p>Choose your format:</p>
  <ul>
    <li><a href="content/en/index.html">Browse site (English)</a></li>
    <li><a href="content/hi/index.html">Browse site (Hindi)</a></li>
    <li><a href="bundles/">Download bundles (PDF, HTML)</a></li>
    <li><a href="kiwix/">Kiwix offline files (.zim)</a></li>
  </ul>
  <p>Public domain (CC0). Copy freely.</p>
</body>
</html>
HTMLEOF

find "$SD" -type f | sort | xargs sha256sum > "$SD/SHA256SUMS.txt"
```

### 8.12 QR codes for bookmark cards

```bash
# CMD — generate QR codes for each card (requires qrencode or segno)
pip install segno
for i in 1 2 3 4 5 6 7 8 9; do
  CARD=$(echo "a b c d e f g h i" | cut -d' ' -f$i)
  python3 -c "
import segno
qr = segno.make('https://<shortdomain>/$i', error='H')
qr.save('scripts/qr/card-${CARD}-qr.svg', scale=10)
"
done
# Include the SVGs in the print/cards/ PDF source.
```

### 8.13 Acceptance: Phase 2

1. **Hindi rendering test.** Tested on a real ₹5,000 Android — Devanagari renders correctly, line heights look right.
2. **Hindi review gate.** A PR to `content/hi/` without the field leader's approval cannot merge (CODEOWNERS enforced).
3. **Search test.** Pagefind returns relevant results in English and Hindi. Devanagari queries return Hindi pages.
4. **Language switcher test.** Every English page links to its Hindi pair and vice versa.
5. **Staleness flag test.** Update an English page's `lastSourceUpdate`; the Hindi pair shows the staleness warning.
6. **Media embed test.** A page with `{{< media >}}` renders player + Download link + Transcript link. Audio plays from archive.org. With archive.org blocked, embed degrades gracefully to download link only.
7. **ZIM test.** `tsunami_en_mini.zim` opens in Kiwix Android app; navigation and search work offline.
8. **Four-mirror test.** GitHub, Cloudflare, Netlify, Codeberg all serve the latest build with valid TLS.
9. **SD-card test.** `START-HERE.html` opens in Windows with no internet; navigation reaches card content; SHA256SUMS.txt is present.
10. **WhatsApp test.** Single-file HTML bundle sends and opens on Android; media degrades to download link.
11. **QR test.** Scan each of 9 QR codes with an Android camera; each resolves to the correct card page.

---

## 9. Phase 3: Video, full resilience, ecosystem

Goal: PeerTube live with first teaching videos (mandatory transcripts + Hindi subtitles), IPFS + DNSLink, Tor onion service, self-hosted Caddy mirror, release torrents, "N versions behind canonical" widget, Bengali and Nepali, Internet-in-a-Box/RACHEL packaging, Scripture App Builder APK.

### 9.1 Pre-Phase-3 checklist

- [ ] Hetzner VPS capacity review: PeerTube needs ~2–4 GB RAM, ~50 GB storage
- [ ] Decide on Pinata vs web3.storage for IPFS pinning; get API key
- [ ] Designate Bengali and Nepali translation teams
- [ ] Produce first narrated audio; confirm archive.org workflow works end-to-end

### 9.2 PeerTube

Install on Hetzner VPS at `video.tsunamiunleashed.com`:

```bash
# CMD — on Hetzner VPS
git clone https://github.com/chocobozzz/PeerTube.git
# Follow official Docker Compose deploy guide:
# https://docs.joinpeertube.org/install/docker
# Config:
#   - Anonymous viewing: enabled
#   - Registration: disabled
#   - Federation: enabled
#   - Default transcoding: 480p H.264
```

DNS record Edward adds: `CNAME video tsunamiunleashed.com → Hetzner VPS IP` (A record, not CNAME).

For each video entry in `data/media.toml`, add fields:

```toml
  magnet = "magnet:?xt=urn:btih:..."
  [[items.subtitles]]
  lang = "hi"
  url = "https://video.tsunamiunleashed.com/.../subtitles/hi.vtt"
```

**Transcript enforcement CI check** — add to `.github/workflows/ci.yml`:

```bash
# CMD — in CI
python3 -c "
import tomllib, sys, pathlib
data = tomllib.loads(pathlib.Path('data/media.toml').read_text())
errors = [i['id'] for i in data.get('items', [])
          if i.get('type') == 'video' and not i.get('transcript')]
if errors:
    print('ERROR: videos missing transcript:', errors); sys.exit(1)
"
```

### 9.3 IPFS

```bash
# CMD — in CI after build (Phase 3 only)
CID=$(curl -sS -X POST \
  "https://api.pinata.cloud/pinning/pinByHash" \
  -H "Authorization: Bearer $PINATA_JWT" \
  -H "Content-Type: application/json" \
  -d "{\"hashToPin\":\"$(ipfs add -r public/ -Q)\"}" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['IpfsHash'])")
# Edward manually updates DNSLink TXT record:
# _dnslink.tsunamiunleashed.com → "dnslink=/ipfs/$CID"
```

### 9.4 Tor onion service

On the self-hosted Caddy mirror:

```
# SNIPPET — /etc/tor/torrc
HiddenServiceDir /var/lib/tor/tsunami/
HiddenServicePort 80 127.0.0.1:80
HiddenServiceVersion 3
```

Add to `static/_headers` (Netlify) or Cloudflare Worker:

```
/*
  Onion-Location: http://<address>.onion
```

### 9.5 Self-hosted Caddy mirror

```
# SNIPPET — Caddyfile
mirror.tsunamiunleashed.com {
  root * /srv/tsunami/public
  file_server
  encode zstd gzip
  header X-Mirror-Built "{file:.build-timestamp}"
}
```

Sync via cron (every 4 hours):

```bash
# SNIPPET — crontab entry
0 */4 * * * cd /srv/tsunami && git fetch && git checkout origin/main -- public/ \
  && echo "$(date -u)" > public/.build-timestamp
```

### 9.6 Release torrents

```bash
# CMD — in CI on tag push
mktorrent \
  -a udp://tracker.opentrackr.org:1337/announce \
  -a udp://open.tracker.cl:1337/announce \
  -o "tsunami-site-${GITHUB_REF_NAME}.torrent" \
  public/
gh release upload "$GITHUB_REF_NAME" "tsunami-site-${GITHUB_REF_NAME}.torrent"
```

Seed from the Caddy mirror (always-on).

### 9.7 "N versions behind canonical" widget

In `baseof.html` on `<html>`:

```html
data-build-version="{{ os.Getenv "GITHUB_SHA" }}"
data-build-date="{{ now.Format "2006-01-02" }}"
```

```javascript
// FILE: assets/js/version-check.js
(async () => {
  const localDate = document.documentElement.dataset.buildDate;
  const localVersion = document.documentElement.dataset.buildVersion;
  const widget = document.getElementById('version-widget');
  if (!widget) return;
  try {
    const res = await fetch('https://tsunamiunleashed.com/MANIFEST.json',
      { mode: 'cors', cache: 'no-store' });
    if (!res.ok) throw new Error('unreachable');
    const { commit, built_at } = await res.json();
    if (commit !== localVersion) {
      widget.textContent =
        `You are viewing a mirror built ${localDate}. ` +
        `Canonical is ${built_at.slice(0, 10)}.`;
      widget.classList.add('mirror-stale');
    }
  } catch {
    widget.textContent =
      `Mirror built ${localDate}. Verify with minisign public key.`;
  }
})();
```

Add `<div id="version-widget"></div>` to `baseof.html` in the footer area. Show only on non-canonical domains (check `window.location.hostname`).

### 9.8 Bengali and Nepali

Repeat Phase 2 pattern for `bn` and `ne`. Each requires a font subset (Noto Sans Bengali for `bn`, Noto Sans Devanagari already present for `ne`). Each requires a designated translation reviewer in `CODEOWNERS`.

### 9.9 Internet-in-a-Box / RACHEL module

Package the SD-card layout from Phase 2 per IIAB/RACHEL conventions:

- RACHEL: module is a directory with `rachel-index.php`, `rachel-header.php`, icons in `/<module>/images/`.
- IIAB: submit as a content pack — see https://github.com/iiab/iiab.

### 9.10 Scripture App Builder APK

Manual workflow using SIL Scripture App Builder (free desktop tool). Inputs: audio files, text content, app branding. Output: signed APK. Distribute via archive.org + sideloading instructions in `CONTRIBUTING.md`.

### 9.11 Acceptance: Phase 3

1. **Video test.** A teaching video plays in any browser, downloads as MP4, opens via magnet link in a torrent client, subtitles render in Hindi.
2. **Transcript enforcement.** Add a video entry to `data/media.toml` without a `transcript` field; CI build must fail.
3. **IPFS test.** Site reachable via public IPFS gateway at the published CID.
4. **Tor test.** Site reachable at `.onion` in Tor Browser. `Onion-Location` header auto-promotes.
5. **Resilience test.** Disable GitHub Pages (route DNS away); site still reachable on at least 4 other hosts with passing `verify.sh`.
6. **Version widget test.** On a deliberately stale mirror, widget displays correct "N versions behind" message.
7. **Bengali test.** Bengali content renders correctly; translation pairs link.
8. **Kiwix catalog.** Site listed at library.kiwix.org.
9. **Torrent seed.** Release torrent seeds from the Caddy mirror; peers can download.

---

## 10. Anti-goals — things to NEVER do

1. **Never** add a donation button, "support us" link, Patreon, Stripe, or any monetization UI.
2. **Never** add analytics, tracking pixels, GTM, Plausible, or any telemetry — even self-hosted.
3. **Never** add a contact form that captures email addresses.
4. **Never** introduce a JavaScript framework (React, Vue, Svelte) for site rendering.
5. **Never** require `node_modules` for Hugo to render the site.
6. **Never** use the word "church" in user-facing UI text.
7. **Never** paraphrase, soften, reorder, or improve the 8GC v2026-04-08 wording.
8. **Never** commit `MINISIGN_SECRET_KEY` to the repo.
9. **Never** put a YouTube embed as the canonical video source.
10. **Never** include a photograph that identifies a believer in the field.
11. **Never** invent doctrinal content. If canon doesn't say it, the site doesn't say it.
12. **Never** introduce a CMS. The repo is the CMS.
13. **Never** put media files (audio, video) directly in Git.
14. **Never** weaken the CC0 dedication to "non-commercial" or "attribution required."

---

## 11. Appendix: contacts and credentials

| Responsibility | Person | Notes |
|---|---|---|
| Org admin / DNS / secrets | Edward | GitHub org owner; DNS control confirmed |
| Lead developer | Duran | `maintain` role on repo |
| Administrative lead | Russ | Access as needed |
| CAO | Brian | Access as needed |
| Hindi translation review | TBD | Edward designates before Phase 2; GitHub username added to CODEOWNERS |
| archive.org account | Ministry email | Account to be created; credentials in 1Password |
| minisign secret key | Edward (1Password) | Never leaves trusted machines; never in CI logs |
| Cloudflare account | Edward | CF_API_TOKEN and CF_ACCOUNT_ID in GitHub Secrets |

---

**End of spec. No open questions remain.**
