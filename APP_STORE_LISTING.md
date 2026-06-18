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
Swipe Camera Roll Like Reels
```
(28/30 chars)

## Promotional Text (170 char max — editable without a new build)

```
100% offline video feed for your camera roll. No uploads, no account,
no tracking. Just swipe and watch — like Reels, but it's all yours.
```

## Description

```
Your camera roll has hundreds of videos you never watch again — buried
in a flat grid between screenshots and photos. RollReel turns them into
a swipe feed, exactly like the one your thumb already knows.

Open the app. Swipe up. Watch your life, one memory at a time.

WHY ROLLREEL

• Full-screen vertical swipe feed of your local videos — TikTok-style,
  zero learning curve
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

ROLLREEL PRO

Prefer an ad-free experience? RollReel Pro removes ads for good and
unlocks a private, Face ID-protected Vault for the videos you don't
want in the main feed.

RollReel needs Photo Library access to show your videos. That's the
only permission it asks for — nothing else, ever.
```

## Keywords (100 char max — do not repeat words already in Name/Subtitle)

```
offline,local,private,vault,gallery,reels,camera roll,memories,tiktok,rewind
```

## What's New in This Version (first release)

```
Welcome to RollReel — swipe through your camera roll videos like Reels,
100% offline. No uploads, no account, no tracking.
```

---

## App Store Connect Metadata

| Field | Value |
|---|---|
| Category (Primary) | Photo & Video |
| Category (Secondary) | Utilities |
| Age Rating | 4+ (no objectionable content; confirm via questionnaire — depends on user-generated video content disclaimer) |
| Price | Free (with in-app purchases) |
| Privacy Policy URL | `https://rollreel.app/privacy` |
| Support URL | `https://rollreel.app/support` (or a mailto: link) |
| Marketing URL (optional) | `https://rollreel.app` |
| Copyright | `© 2026 [Your Name / Entity]` |

## In-App Purchases to Create in App Store Connect

| Reference Name | Product ID | Type | Price |
|---|---|---|---|
| RollReel Pro (Lifetime) | `com.rollreel.pro.lifetime` | Non-Consumable | $4.99 (or $2.99 intro per PRD §11) |
| RollReel Plus (Annual) | `com.rollreel.pro.annual` | Auto-Renewing Subscription | $14.99/year |

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

| # | Blocker | Where | Why it blocks publishing |
|---|---|---|---|
| 1 | **Placeholder bundle ID** | `ios/Runner.xcodeproj` → `PRODUCT_BUNDLE_IDENTIFIER = com.example.rollreel` | Must be your real reverse-DNS ID (e.g. `com.yourname.rollreel`), registered under your Apple Developer account, before Xcode can archive/sign the build |
| 2 | **Test AdMob IDs still in place** | `ios/Runner/Info.plist` (`GADApplicationIdentifier`), `android/app/src/main/AndroidManifest.xml` | Currently Google's public *test* app IDs — shipping with these means zero real ad revenue and Google may flag the account. Replace with your real AdMob app ID from your own AdMob account |
| 3 | **Privacy Policy not actually hosted** | App links to `https://rollreel.app/privacy` | The domain/page needs to exist and be live before App Store Connect review — Apple checks this URL during review |
| 4 | **No Apple Developer Program enrollment confirmed** | N/A | Required ($99/yr) to get signing certs, register the bundle ID, create the App Store Connect record, and create the IAP products above |
| 5 | **In-App Purchase products not created** | App Store Connect | `com.rollreel.pro.lifetime` / `com.rollreel.pro.annual` must exist in ASC with matching IDs, or the paywall will show no prices and purchases will fail in review |
| 6 | **No screenshots / app preview generated** | App Store Connect listing | Required for every supported device size before submission is allowed |
| 7 | **No signing certificates / provisioning profile** | Xcode → Signing & Capabilities | Needs to be set up locally in Xcode with your Apple Developer team selected |
| 8 | **App Privacy "Nutrition Label" not filled in App Store Connect** | ASC → App Privacy section | Must disclose AdMob's data collection (device identifiers for ads) — required questionnaire, separate from the in-app privacy policy text |
| 9 | **No TestFlight pass yet** | N/A | Strongly recommended even for a same-day launch — catches crashes/signing issues before public review; can be skipped if you're confident, but raises rejection risk |
| 10 | **Support contact missing** | ASC requires a working support URL or email | Needs to resolve to something real (a mailto: link is acceptable) |

None of these are code changes I can make for you (they're Apple Developer account / App Store Connect / Xcode signing steps), but they are the actual gating items between "code is ready" and "live on the App Store" — tackle them in roughly this order: #4 → #1 → #7 → #5 → #2 → #3 → #8 → #6 → #10 → #9 → submit.
