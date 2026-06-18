# RollReel — App Store Listing Content

Drafted from `RollReel_PRD.md` §1 and §13, cross-checked against how comparable
local/private video-player apps (FlowPlayer, Outplayer, lPlayer, VLC for iOS)
title and describe themselves on the App Store. Paste directly into
App Store Connect.

---

## App Name (30 char max)

```
RollReel – Local Video Player
```
(29/30 chars)

## Subtitle (30 char max)

```
Swipe Your Camera Roll Videos
```
(29/30 chars)

## Promotional Text (170 char max — editable without a new build)

```
100% offline video feed for your camera roll. No uploads, no account,
no tracking. Just swipe and watch — it's all yours.
```

## Description

```
Your camera roll has hundreds of videos you never watch again — buried
in a flat grid between screenshots and photos. RollReel turns them into
a swipe feed, exactly like the one your thumb already knows.

Open the app. Swipe up. Watch your life, one memory at a time.

WHY ROLLREEL

• Full-screen vertical swipe feed of your local videos, zero learning
  curve
• 100% on-device. No uploads, no cloud sync, no account, no sign-in
• Auto-play, auto-loop short clips, instant preloading for smooth
  swiping
• Tap to pause, double-tap to seek, swipe the edges for volume and
  brightness
• Quick filters: All, Today, Shorts, Long
• Date-grouped feed so you always know what you're watching and when
• One-swipe share to WhatsApp, Messages, Instagram, AirDrop — whatever
  is already on your phone

PRIVACY, ACTUALLY

RollReel never uploads, transmits, or stores your videos anywhere but
your device. There's no account because there's no server. Your
memories stay exactly where they belong — on your iPhone.

ROLLREEL PRO & PLUS

Prefer an ad-free experience? RollReel Pro removes ads for good and
unlocks a private, Face ID-protected Vault and custom app icons —
yours forever with a single purchase. RollReel Plus offers the same
features for a low monthly price, plus founding-member access to
every feature we ship after launch.

RollReel needs Photo Library access to show your videos. That's the
only permission it asks for — nothing else, ever.
```

## Keywords (100 char max — do not repeat words already in Name/Subtitle)

```
offline,local,private,vault,gallery,swipe feed,camera roll,memories,rewind,clips
```

## What's New in This Version (first release)

```
Welcome to RollReel — swipe through your camera roll videos in a
vertical feed, 100% offline. No uploads, no account, no tracking.
```

---

## App Store Connect Metadata

| Field | Value |
|---|---|
| Category (Primary) | Photo & Video |
| Category (Secondary) | Utilities |
| Age Rating | 4+ (Third-Party Advertising: Yes; everything else: None; no UGC) |
| Price | Free (with in-app purchases) |
| Privacy Policy URL | `https://najmulmyself.github.io/rollreel/privacy.html` |
| Support URL | `https://najmulmyself.github.io/rollreel/support.html` |
| Marketing URL (optional) | `https://najmulmyself.github.io/rollreel/` |
| Copyright | `© 2026 [Your Name / Entity]` |

## In-App Purchases to Create in App Store Connect

| Reference Name | Product ID | Type | Price |
|---|---|---|---|
| RollReel Pro (Lifetime) | `com.rollreel.pro.lifetime` | Non-Consumable | $4.99 |
| RollReel Plus (Monthly) | `com.rollreel.plus.monthly` | Auto-Renewing Subscription | $0.99–$1.99/mo (founding-member pricing, may increase later) |

> These exact product IDs are already wired into `lib/core/iap/iap_provider.dart` — they must match byte-for-byte in App Store Connect or `queryProductDetails` will silently return nothing.

## Screenshot Plan (6 screenshots, per PRD §13)

| # | Headline | Screen to capture |
|---|---|---|
| 1 | "Your Camera Roll. Swipe Like Reels." | Feed screen, mid-swipe |
| 2 | "100% Offline. No Cloud. No Account." | Feed with Wi-Fi/Airplane indicator |
| 3 | "Smart Filters. Find Any Video Instantly." | Quick filter tabs (All/Today/Shorts/Long) |
| 4 | "Privacy Vault. Your Private Videos, Locked." | Vault screen |
| 5 | "Share in One Swipe." | Share sheet open over a video |
| 6 | "Simple. Fast. Yours." | Settings or app icon hero shot |

---

## ⚠️ Before You Can Actually Submit — Blockers

These are **not feature gaps**, they're submission blockers found in the current project that will get the build rejected or fail to build/notarize if untouched:

| # | Blocker | Where | Status |
|---|---|---|---|
| 1 | Placeholder bundle ID | `ios/Runner.xcodeproj` | ✅ Resolved — set to `com.rollreel.player` |
| 2 | Test AdMob IDs still in place | `ios/Runner/Info.plist`, `android/app/src/main/AndroidManifest.xml` | ⏳ Still pending — replace with your real AdMob app ID |
| 3 | Privacy Policy / Support not hosted | N/A | ✅ Resolved — hosted via GitHub Pages: `https://najmulmyself.github.io/rollreel/privacy.html` and `/support.html` (see `docs/`). **Enable GitHub Pages in repo Settings → Pages if not already on.** |
| 4 | Apple Developer Program enrollment | N/A | ✅ Resolved |
| 5 | In-App Purchase products not created | App Store Connect | ⏳ Still pending — create `com.rollreel.pro.lifetime` / `com.rollreel.pro.annual` |
| 6 | No screenshots / app preview generated | App Store Connect listing | ⏳ Still pending |
| 7 | No signing certificates / provisioning profile | Xcode → Signing & Capabilities | ⏳ Still pending — needs your Mac |
| 8 | App Privacy "Nutrition Label" not filled | ASC → App Privacy section | ⏳ Still pending — disclose AdMob's device identifier collection |
| 9 | No TestFlight pass yet | N/A | ⏳ Still pending |
| 10 | Support contact missing | N/A | ✅ Resolved — `support.html` + `mailto:najmul.myself@gmail.com` |

Remaining order: #7 (signing) → #5 (IAP products) → #2 (real AdMob IDs) →
#8 (privacy nutrition label) → #6 (screenshots) → #9 (TestFlight) → submit.
