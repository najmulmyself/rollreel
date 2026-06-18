# RollReel — PRD Gap Analysis & Roadmap

Audit of the current implementation against `RollReel_PRD.md` (§8 MVP, §9 V2, §12 Ads).
Everything not listed here as missing/partial is implemented and working.

---

## Phase 1 — MVP polish (finish what PRD §8 specifies, currently partial)

| Item | PRD Ref | Status | Gap |
|---|---|---|---|
| Controls auto-hide timing | F3 | ⚠️ Deviation | Auto-hides after 1s, PRD specifies 3s |
| Long-press gesture | F3 | ⚠️ Deviation | PRD specifies 0.5× slow-motion preview on long-press; current build uses long-press for 2× fast-forward instead |
| Location tag on video info overlay | F6 | ❌ Missing | No EXIF/GPS read-back ("Dhaka, BD" style tag) — only filename/date/duration shown |
| Automatic review prompt | F9 / §13 | ❌ Missing | `requestReview()` only fires from a manual Settings button; PRD wants it auto-triggered after 3 completed swipe sessions **and** 24h post-install |
| Bottom banner ad | §12 | ❌ Missing | Only interstitial ads (every N swipes) are wired up; PRD's free-tier banner ad (320×50, list/grid screen only) isn't implemented |
| Rewarded ad (optional unlock) | §12 | ❌ Missing | Not implemented (optional in PRD) |

---

## Phase 2 — V2.1–V2.3 (Engagement + Collections + Vault foundation)

| Item | PRD Ref | Status |
|---|---|---|
| "On This Day" daily notification | V2.1 | ❌ Missing — no local/push notification scheduling at all |
| Memory Reel auto-generated montage | V2.1 | ❌ Missing |
| Smart Collections (by Month / Location / Person via on-device CoreML) | V2.2 | ❌ Missing |
| User-created named Collections | V2.2 | ❌ Missing |
| Favorites (heart gesture + Favorites tab) | V2.2 | ✅ Done (heart toggle wired; no dedicated Favorites tab/screen yet — list exists in provider but isn't surfaced as a tab) |
| Privacy Vault (Face ID / password protected) | V2.3 | ✅ Done |

---

## Phase 3 — V2.4 Playback Enhancements (Premium)

| Item | PRD Ref | Status |
|---|---|---|
| Variable playback speed (0.5× / 1× / 1.5× / 2×) | V2.4 | ⚠️ Partial — only a fixed 2× long-press fast-forward exists; no speed picker/persistent setting |
| AirPlay / TV output support | V2.4 | ❌ Missing |
| Trim & share (clip range before Share Sheet) | V2.4 | ❌ Missing |
| Loop A–B (custom start/end loop points) | V2.4 | ❌ Missing |

---

## Phase 4 — V2.5–V2.6 (Platform integrations & layout)

| Item | PRD Ref | Status |
|---|---|---|
| Siri Shortcuts ("Open RollReel to today's videos", etc.) | V2.5 | ❌ Missing |
| Lock Screen / Home Screen "Today's Videos" widget | V2.5 | ❌ Missing |
| iPad two-column layout (feed + metadata panel) | V2.6 | ❌ Missing — app runs iPhone-layout only |
| Mac Catalyst / native macOS app | V2.6 | ❌ Missing (explicitly post-revenue per PRD, lowest priority) |

---

## Already implemented (for reference, not a gap)

- F1 Vertical swipe feed, auto-play, auto-loop short videos, haptic feedback
- F2 Full/Limited/Denied permission states with empty-state CTA + persistent "Managing X videos" limited-access banner with tap-to-expand-access CTA
- F3 Tap pause/resume, double-tap ±10s seek, edge-swipe volume/brightness, scrubbing seek bar
- F4 Date grouping header label
- F5 Quick filter tabs (All / Today / Shorts / Long)
- F6 Filename + date + duration overlay (minus location tag, see Phase 1)
- F7 Native share sheet
- F8 3-screen onboarding
- F9 Settings: loop/autoplay/date-label toggles, default filter, dark mode, app icon variant, privacy policy, manual rate-app, version
- Pro (lifetime IAP) + Plus (annual IAP) tiers wired to `in_app_purchase`
- Interstitial ads (AdMob) every N swipes, gated by Pro/Plus status
- Privacy Vault with Face ID lock
