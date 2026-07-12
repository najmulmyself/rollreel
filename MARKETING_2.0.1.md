# RollReel 2.0.1 — Screenshot & App Preview Production Kit

Everything to capture on your Mac + iPhone. The App Preview video goes in
**slot 1**, followed by 6 screenshots.

---

## 1. App Preview Video (slot 1)

### Apple's rules (App Store Connect will reject violations)
- Length: **15–30 seconds**. Target ~22 s.
- Portrait, captured **on-device only content** — no hands, no device bezels,
  no "your phone" mockups inside the video.
- Must show the app as it actually works — no aspirational footage.
- Resolutions accepted: 886×1920 (6.5"/6.9" preview), .mov/.mp4/.m4v, ≤500 MB,
  30 fps.
- Audio optional; assume watched on mute — burn in short text overlays.
- First 3 seconds matter most: the poster frame + autoplay hook.

### Capture
- iPhone connected to Mac → QuickTime → File → New Movie Recording → select
  iPhone as camera. Set device language to English (US) for the primary
  locale, re-capture (or reuse with localized overlay text) per market.
- Turn on Do Not Disturb, 100% battery or hide the status bar concerns —
  Apple no longer requires a perfect status bar but clean looks better.
- Use a library preloaded with attractive, rights-safe personal-style videos
  (travel, pets, food, family — shoot your own b-roll beforehand).

### Storyboard (~22 s)

| # | Time | On screen | Overlay text |
|---|------|-----------|--------------|
| 1 | 0–3 s | Feed mid-swipe: two fast satisfying vertical swipes, video auto-plays each time | "Your camera roll. Like Reels." |
| 2 | 3–7 s | One more swipe → date label appears ("Yesterday") → tap heart (favorite animation) | "Swipe. Watch. Remember." |
| 3 | 7–11 s | Tap filter chip "Shorts" → feed reshuffles instantly | "Instant filters" |
| 4 | 11–15 s | Browse tab → **On This Day card** → tap → memories viewer with "On This Day · 3 years ago" header | "On This Day memories" |
| 5 | 15–19 s | Quick vault glimpse: Face ID sheet → vault grid | "Private. 100% offline." |
| 6 | 19–22 s | Return to feed, one last clean swipe, end on a great frame | "RollReel" + app icon |

Poster frame (the still shown before autoplay): choose the frame at ~1 s —
feed with a vibrant video visible.

### Localization of the preview
Reuse the same capture for all locales; only the overlay text changes.
Overlay translations for all 13 locales are in `ASO_2.0.1.md` §5 (they reuse
the screenshot headline strings — same tone, same length limits).

---

## 2. Screenshots (6, after the video)

### Required sizes (upload once per size class)
- **6.9" (iPhone 16 Pro Max class): 1320×2868** — mandatory
- 6.5" (older max phones): 1284×2778 or 1242×2688 — auto-scaled from 6.9" if
  omitted, better to upload real ones
- iPad 13" (2064×2752) — required because the app runs on iPad

### Shot list (updated for 2.0.1 — On This Day leads)

| # | Headline (EN) | Screen to capture |
|---|---|---|
| 1 | "Your Camera Roll. Swipe Like Reels." | Feed mid-swipe, vibrant video |
| 2 | "On This Day. Memories, Automatically." | **NEW** — On This Day viewer, "3 years ago" header visible |
| 3 | "100% Offline. No Cloud. No Account." | Feed with airplane-mode glyph in status bar |
| 4 | "Find Any Video Instantly." | Feed filter chips active + Browse search mid-query |
| 5 | "Privacy Vault. Locked with Face ID." | Vault screen (use innocuous videos) |
| 6 | "Now in 13 Languages." | Settings or feed in Spanish/Japanese UI |

Localized headlines for every locale: see `ASO_2.0.1.md` §5. Capture the
underlying screens once; re-render text per locale (screenshot text lives in
your framing tool — Figma/Screenshots.pro/AppLaunchpad — not in the app).
Exception: shot 6 genuinely re-captured in a foreign language for
authenticity.

### Capture workflow
1. Device language: Settings → General → Language & Region (or per-app
   language setting once 2.0.1 is installed).
2. `xcrun simctl io booted screenshot shot.png` on Simulator for pixel-exact
   sizes, or capture on device and let the framing tool resize.
3. Keep raw captures; only the overlay layer differs per locale.

---

## 3. Upload order checklist (App Store Connect → 2.0.1 → Media)

- [ ] App Preview video slot 1 (per locale where you localized overlays;
      other locales inherit the primary)
- [ ] Screenshots 1–6 in the order above (order = story)
- [ ] iPad set (video optional on iPad, screenshots required)
- [ ] Poster frame chosen manually on the video (don't accept the default)
- [ ] Preview plays with sound OFF and still makes sense
