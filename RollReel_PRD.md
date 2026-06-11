# RollReel – Product Requirements Document (PRD)
### Local Video Player · iOS First · Swipe Like Reels

> **Version:** 1.0  
> **Date:** June 2026  
> **Author:** Solo Indie Developer  
> **Platform:** iOS (iPhone-first, iPad-compatible)  
> **Status:** Pre-development · Greenfield

---

## Table of Contents

1. [App Name & Brand Rationale](#1-app-name--brand-rationale)
2. [Executive Summary](#2-executive-summary)
3. [Problem Statement](#3-problem-statement)
4. [Target Users](#4-target-users)
5. [Market Research & User Demand](#5-market-research--user-demand)
6. [Competitor Analysis](#6-competitor-analysis)
7. [Competitor Gaps (Opportunities)](#7-competitor-gaps-opportunities)
8. [Feature Specification — MVP (v1.0)](#8-feature-specification--mvp-v10)
9. [Feature Specification — V2 Roadmap](#9-feature-specification--v2-roadmap)
10. [Monetization Strategy](#10-monetization-strategy)
11. [Pricing Model](#11-pricing-model)
12. [Ad Strategy](#12-ad-strategy)
13. [App Store Optimization (ASO)](#13-app-store-optimization-aso)
14. [Growth & Traction Strategy](#14-growth--traction-strategy)
15. [Apple Compliance & Privacy Policy](#15-apple-compliance--privacy-policy)
16. [Technical Stack](#16-technical-stack)
17. [Success Metrics (KPIs)](#17-success-metrics-kpis)
18. [Go-To-Market Plan](#18-go-to-market-plan)
19. [Risks & Mitigations](#19-risks--mitigations)

---

## 1. App Name & Brand Rationale

### ✅ Chosen Name: **RollReel**

**Full App Store Title:** `RollReel – Local Video Player`  
**Subtitle:** `Swipe Your Camera Roll Like Reels`  
**Bundle ID:** `com.yourname.rollreel`

### Why RollReel?

| Criteria | Analysis |
|---|---|
| **Keyword coverage** | "Roll" = camera roll (the exact iOS-native term users search) · "Reel" = familiar short-video UX (Instagram, TikTok) |
| **ASO signal** | Name naturally hits two high-intent search keywords: "roll" (camera roll) + "reel" (swipe feed behavior) — without wasting subtitle or keyword field space |
| **Trademark clean** | Zero conflicts found across App Store, Google Play, USPTO, and active businesses as of June 2026 |
| **Character count** | 8 characters — concise, fits icon wordmark, well within the 30-char App Store title limit |
| **Memorability** | Double-R alliteration (RollReel) — rolls off the tongue, same rhythmic energy as TikTok, Snapchat |
| **Brand flexibility** | Works as icon wordmark, @rollreel social handle, rollreel.app domain — all clean |
| **Pronunciation** | One word, two syllables, no spelling ambiguity for any English speaker |

### App Store Metadata (ASO-optimized)

```
App Name (29/30):   RollReel – Local Video Player
Subtitle (28/30):   Swipe Camera Roll Like Reels
Keywords (100):     local video,offline,swipe,camera,reel player,vault,private,gallery,memories,reels
```

> **Rule:** Never repeat keywords already in the App Store name or subtitle inside the keyword field — Apple ignores duplicates and wastes your 100-character limit. "Roll", "Local", "Video", "Player", "Camera" are covered by the title and subtitle, so the keyword field targets fresh terms only.

---

## 2. Executive Summary

RollReel is an iOS utility app that reimagines the native Photos app experience for video. Instead of the flat grid view, RollReel gives users a vertical swipe feed — identical to Instagram Reels or TikTok — but powered **100% by the videos already on their iPhone**. No internet. No cloud. No account. Just swipe.

The app targets the growing segment of iPhone users who have hundreds or thousands of local videos they never revisit, because the default Photos app is not designed for passive, enjoyable video browsing. RollReel solves this with a single, focused interaction: open the app, swipe up, watch your life's memories the way social media trained your brain to consume video.

**Core Value Proposition:**

> *"Your memories. TikTok-smooth. No one watching."*

---

## 3. Problem Statement

### The Core Pain

The iPhone Photos app was designed to store and organize. It was not designed to **watch**. When users try to browse their video library:

- Videos appear in a flat grid alongside photos, screenshots, and documents
- Tapping a video exits the grid, plays one video, then returns to the grid
- There is no "next video" swipe — you must navigate back manually every time
- No date-grouped Reels view, no immersive full-screen auto-play mode
- Long videos and short clips are given equal visual weight in the grid

### The Behavioral Reality

Social platforms (TikTok, Instagram Reels, YouTube Shorts) have **trained 2 billion users** to consume video in a vertical swipe feed. Users now find grid-based video browsing cognitively frustrating — not because it's broken, but because it doesn't match the neural pattern their thumbs expect.

### The Privacy Tension

Most apps that offer "better" video viewing require cloud uploads, sign-ins, or access to your network. For personal videos — memories of family, travel, moments with friends — users do not want those sent anywhere. This creates an unmet demand: **the Reels UX, but local and private**.

---

## 4. Target Users

### Primary Persona: "The Memory Keeper" (Ages 22–45)

- Has 200–2,000+ videos on their iPhone accumulated over years
- Occasionally wants to revisit old memories but finds Photos too cumbersome
- Comfortable with TikTok/Reels UX — it feels natural
- Privacy-conscious: doesn't want memories in Google Photos, iCloud shared albums, or any cloud
- Device: iPhone 13 or newer
- Geography: US, UK, Canada, Australia (Tier 1 markets — your primary ASO target)

### Secondary Persona: "The Content Creator Reviewer" (Ages 18–30)

- Records lots of raw footage: travel vlogs, gym clips, food content
- Wants to quickly preview and sort through raw recordings before editing
- Uses apps like CapCut or InShot for editing, but needs a fast pre-edit browser
- Values playback speed control and quick share-to-edit handoff

### Tertiary Persona: "The Privacy-First User" (Ages 30–55)

- Actively avoids cloud services for personal content
- Has turned off iCloud Photos backup deliberately
- Looking for a video player that explicitly states "no upload, no tracking"
- Converts well on "No cloud" and "100% Local" messaging

---

## 5. Market Research & User Demand

### Social Signals Observed

Research across Reddit (r/ios, r/iphone, r/shortcuts), Twitter/X, and App Store reviews of competitor apps reveals recurring user intent patterns:

**Pain points users articulate:**

1. *"Why can't I just swipe through my videos like TikTok? The Photos app is so annoying"* — common phrasing in iOS shortcut communities
2. *"I have thousands of videos I never watch because it's too painful to navigate"* — memory-keeper segment
3. *"I just want a Tinder-style or TikTok-style way to browse my camera roll videos"* — feature request pattern
4. *"Every good video player wants me to upload stuff. I just want to watch what's on my phone"* — privacy-first segment

**Behavioral data signal:**

- Apps like SwipeWipe (camera roll photo organizer using swipe UX) gained significant traction purely from the **swipe interaction model** applied to local media — proving demand for swipe-based camera roll apps
- FlowPlayer (closest iOS competitor) was published in early 2026 with nearly no marketing and already appeared in search results, indicating organic demand for the keyword space

### Search Demand Indicators (App Store keywords)

Based on autocomplete and keyword research tools:

| Keyword | Est. Difficulty | Est. Volume |
|---|---|---|
| local video player | Medium | High |
| offline video player | Medium | High |
| camera roll video | Low | Medium |
| swipe video player | Low | Medium |
| private video player | Low-Medium | Medium |
| reels video player | Low | Medium |
| video vault | Medium | Medium |

> **Opportunity:** "swipe video player" and "camera roll video" are **low difficulty with real volume** — this is the beachhead keyword pair to dominate.

---

## 6. Competitor Analysis

### Direct Competitors (iOS App Store)

| App | Swipe UX | 100% Local | Privacy Focus | Last Update | Rating | Weakness |
|---|---|---|---|---|---|---|
| **FlowPlayer** | ✅ Yes | ✅ Yes | ✅ Yes | May 2026 | N/A (new) | No brand, Chinese dev, limited discoverability |
| **lPlayer** | ✅ Partial | ✅ Yes | ✅ Yes | 2025 | 3.8 | Bloated with URL player and social browser — unfocused |
| **Outplayer** | ❌ No | ✅ Yes | ✅ Yes | 2024 | 4.8 | Power-user focused, no swipe feed, no Reels UX |
| **Glass Video Player** | ✅ Yes | ✅ Yes | ❌ Unclear | 2025 | 3.2 | iPad-only focus, poor iPhone UX |
| **Watch ▷** | ❌ No | ✅ Yes | ✅ Yes | 2026 | N/A | Bookmark/cinema focus — not a swipe feed |
| **VLC for iOS** | ❌ No | ✅ Yes | ✅ Yes | 2026 | 4.4 | Technical, no casual UX, zero Reels feel |

### Indirect Competitors

| App | Why Users Compare | Key Gap |
|---|---|---|
| **Apple Photos** | Default video viewer | Grid only, no swipe-to-next-video, not built for binge viewing |
| **Instagram Reels** | UX reference point | Internet-only, public content only |
| **Google Photos** | Video organization | Requires cloud upload, privacy concern |

---

## 7. Competitor Gaps (Opportunities)

This is where RollReel wins. The market has products but no **brand** in this niche.

### Gap 1 — No dominant brand
FlowPlayer (closest match) has no social presence, no content marketing, minimal App Store branding. The space has no "go-to" app that people recommend to friends. RollReel can own that position with consistent marketing.

### Gap 2 — Poor onboarding and emotional hook
Competitors treat this as a utility with a list of features. None of them frame the app emotionally: *"Relive your memories the way TikTok trained your brain to enjoy video."* That single line of copy would outperform any feature list.

### Gap 3 — No smart video grouping
Current apps show all videos in a flat chronological feed. No app has implemented **smart auto-grouping**: Today / This Week / This Month / By Location / By Duration (shorts vs. long-form). This is a high-value V2 differentiator.

### Gap 4 — No iOS Shortcuts / Siri integration
None of the competitors integrate with iOS Shortcuts or Siri. A simple "Hey Siri, show me my RollReel from last summer" workflow would be a powerful viral feature and a strong App Store story.

### Gap 5 — No English-first brand presence
FlowPlayer is built by a Chinese developer (Mirror Space) and has no English-language social media presence. For Tier 1 market users, app trust is tied to brand familiarity. An English-first brand with LinkedIn and Twitter presence wins trust.

### Gap 6 — No "Today in Memories" daily notification hook
Zero competitors offer a "On this day 2 years ago, you recorded 5 videos" notification. This is an engagement loop that transforms a utility into a daily habit — and dramatically improves retention metrics (D7, D30).

### Gap 7 — No fast-share integration
Users who browse their camera roll with Reels UX often want to instantly share a clip to WhatsApp, Instagram Stories, or AirDrop. No competitor has a single-swipe-up share gesture integrated into the feed. This is a high-retention feature.

---

## 8. Feature Specification — MVP (v1.0)

The MVP must do one thing exceptionally: **swipe through local videos in a TikTok-style vertical feed, with zero friction and zero internet requirement.**

### Core Features

#### F1 — Vertical Swipe Feed (CRITICAL)
- Full-screen vertical `PageView` feed of all local videos from Camera Roll
- Swipe up = next video · Swipe down = previous video
- Auto-play on swipe with instant preloading of next/previous video
- Auto-loop short videos (< 30 seconds) — identical behavior to TikTok
- Smooth haptic feedback on swipe transition

#### F2 — Photo Library Permission Handling
- Proper `PHPhotoLibrary` authorization request with clear purpose string
- Handle all three permission states: Full Access, Limited Access, Denied
- "Limited Access" mode: show how many videos are accessible + one-tap prompt to expand
- Graceful "No Videos Found" empty state with CTA to grant access

#### F3 — Playback Controls (Minimal & Gesture-First)
- Tap to pause/resume (single tap)
- Double-tap to seek ±10 seconds (left/right)
- Swipe up/down on right edge = volume
- Swipe up/down on left edge = brightness
- Long-press = 0.5x slow motion preview
- Progress bar at bottom (tap scrubbing)
- Controls auto-hide after 3 seconds

#### F4 — Date Grouping Feed Header
- Floating label showing date group as you swipe: "Today" / "Yesterday" / "Last Week" / "June 2024"
- Matches the iOS Photos "date" concept users already understand

#### F5 — Quick Filter Tabs
- Tabs at top of feed: **All** / **Today** / **Shorts** (< 1 min) / **Long** (> 1 min)
- Instant filtering, no loading screen

#### F6 — Video Info Overlay
- Video filename or date/time (shown when controls are visible)
- Duration badge
- Location tag if EXIF data is present (e.g. "Dhaka, BD")

#### F7 — Share Sheet Integration
- Native iOS share sheet via swipe-up gesture on the video
- Share to WhatsApp, Instagram Stories, AirDrop, Files — whatever is on the user's device
- RollReel does not handle the sharing itself; it hands off to the native iOS share sheet

#### F8 — Onboarding Screen
- 3-screen swipeable onboarding: hook / feature highlight / permission request
- Screen 1: *"Your videos. TikTok-smooth. No upload, ever."*
- Screen 2: Feature highlights (swipe, auto-play, private)
- Screen 3: Photo library permission request with friendly explanation

#### F9 — Settings Screen
- Toggle: Loop short videos (on/off)
- Toggle: Auto-play on launch (on/off)
- Toggle: Show date labels (on/off)
- Default filter tab (All / Shorts / etc.)
- Privacy policy link
- Rate the app link (RequestReview API)
- App version

### What MVP Intentionally Excludes
- No cloud sync
- No user account or login
- No video editing
- No favorites/bookmarks (deferred to V2)
- No face recognition or AI tagging (deferred to V2)
- No iPad-specific layout optimization (post-launch)

---

## 9. Feature Specification — V2 Roadmap

These features are validated-demand additions to build after launch and first user reviews.

### V2.1 — Memories & Engagement Loop
- **"On This Day" notification**: Daily push notification showing how many videos from this day in previous years are in the library
- **Memory Reel**: Auto-generated 30-second montage of "On This Day" videos, shareable as one clip
- This single feature dramatically improves D7 and D30 retention

### V2.2 — Smart Collections
- Auto-generated smart groups: By Month, By Location, By Person (face detection via Apple's CoreML — on-device, private), By Duration
- User-created Collections: user manually names and saves a collection of videos
- "Favorites" heart gesture: swipe-right to heart a video, accessible from a Favorites tab

### V2.3 — Privacy Vault (Premium Feature)
- Password or Face ID-protected hidden folder for sensitive videos
- Videos in the vault are invisible to the standard feed
- Strong monetization hook: users highly value privacy for personal videos

### V2.4 — Playback Enhancements (Premium)
- Variable playback speed: 0.5x / 1x / 1.5x / 2x
- AirPlay / TV output support
- Trim & share: quick trim of a clip before sharing (no export, just Share Sheet with trimmed range)
- Loop A-B: set start and end point for loop (useful for musicians, dancers reviewing recordings)

### V2.5 — Siri & Shortcuts Integration
- Siri Shortcut: "Open RollReel to today's videos"
- Siri Shortcut: "Show my RollReel memories from [month]"
- Widget: "Today's Videos" count widget for Lock Screen or Home Screen
- This is a **high App Store rating driver** — users love Siri integration in utility apps

### V2.6 — iPad & Mac Optimized Layout
- iPad: Two-column layout (feed + metadata panel)
- Mac Catalyst or native macOS app (optional, post-revenue)

---

## 10. Monetization Strategy

### Model: **Freemium + One-Time Unlock (Lifetime IAP) + Optional Subscription**

This is a three-tier monetization ladder:

```
Tier 1 — FREE (Entry)
├── Full swipe feed (unlimited)
├── Basic filters (All / Shorts / Long)
├── Date grouping
├── Share Sheet
└── Non-intrusive banner ad (bottom of feed, hidden during playback)

Tier 2 — CAMREEL PRO (One-Time Purchase, $4.99)
├── Everything in Free
├── Ad-free forever
├── Privacy Vault
├── Playback speed control
├── Smart Collections
└── Lock Screen Widget

Tier 3 — CAMREEL PLUS (Annual Subscription, $1.99/month = $14.99/year)
├── Everything in Pro
├── "On This Day" memory notifications
├── Memory Reel auto-generation
├── Siri Shortcuts integration
├── Early access to new features
└── Priority support
```

### Rationale

**Why not subscription-only?**

- For a local video player, there is no ongoing server cost — subscriptions without recurring value feel exploitative and generate negative reviews
- One-time purchases resonate strongly with privacy-focused users who distrust "subscription trap" apps
- Research shows utility apps with one-time unlock options get significantly better review sentiment than subscription-only models

**Why include a subscription tier (Plus)?**

- Memory Reel and On This Day require background processing — these are features users genuinely expect to pay for on a recurring basis
- Annual billing at $14.99/year is psychologically accessible and reduces churn vs. monthly
- Keeps LTV ceiling open without alienating the one-time-purchase majority

**Free tier ad strategy** (detailed in Section 12):

- The free tier is the funnel, not the product. Keep ads minimal enough that the app is genuinely usable — but visible enough that Pro's "no ads" pitch is a real value proposition

---

## 11. Pricing Model

| Tier | Price | Model | Apple's 30% Cut | You Keep |
|---|---|---|---|---|
| Free | $0 | Ad-supported | — | Ad revenue |
| RollReel Pro | $4.99 USD | One-Time IAP | $1.50 | $3.49 |
| RollReel Plus | $14.99/year | Subscription IAP | $4.50 (year 1) / $2.25 (yr 2+) | $10.49 / $12.74 |

### Pricing Localization (important for Tier 1 markets)

| Market | Free | Pro | Plus (annual) |
|---|---|---|---|
| United States | Free | $4.99 | $14.99 |
| United Kingdom | Free | £3.99 | £11.99 |
| Canada | Free | CAD $5.99 | CAD $17.99 |
| Australia | Free | AUD $7.99 | AUD $22.99 |

> **Note:** Use Apple's pricing tiers for correct regional pricing — do not manually convert. Use Tier 5 for the Pro one-time purchase across regions.

### Launch Pricing Strategy

- **First 90 days:** Offer Pro at an introductory price of **$2.99** (limited time — communicate this clearly in App Store description and screenshots)
- This drives early adoption, reviews, and momentum — then raise to $4.99
- Do not launch with subscriptions — introduce Plus in v1.2 after accumulating reviews

---

## 12. Ad Strategy

### Ad Network: Google AdMob (primary) + Apple SKAdNetwork attribution

### Ad Placements

**Free tier ad rules — designed to convert, not annoy:**

1. **Bottom Banner Ad** — 320×50 banner shown only on the video list/grid screen, never during active video playback
2. **Interstitial Ad** — shown once every 10 videos swiped, during the transition gap (not overlaid on a video)
3. **Rewarded Ad (Optional)** — user taps "Watch an ad to unlock Smart Collections for 24 hours" — optional and user-initiated only

### What RollReel will NEVER do with ads:

- Full-screen pop-up ads mid-video playback (this destroys retention and tanks reviews)
- Autoplay video ads (especially with sound)
- Ads in the onboarding flow
- Ads that mimic a system notification or alert

### Ad Revenue Projections (conservative estimate)

| Users (Free) | eCPM (Tier 1 market) | Daily Sessions/User | Est. Monthly Ad Revenue |
|---|---|---|---|
| 1,000 | $8 CPM | 3 sessions | ~$72/month |
| 5,000 | $8 CPM | 3 sessions | ~$360/month |
| 10,000 | $8 CPM | 3 sessions | ~$720/month |

> These are conservative. Photo/video apps with Tier 1 US traffic often see $10–$15 eCPM. The goal is to make ad revenue sufficient to cover App Store fee and hosting costs while Pro conversions are the actual income target.

### Pro Conversion Target

At a 3–5% free-to-Pro conversion rate (industry standard for well-positioned utility apps):

- 5,000 free users → 150–250 Pro purchases → **$525–$875 one-time revenue**
- Plus subscriptions add recurring revenue on top

---

## 13. App Store Optimization (ASO)

### Metadata Strategy

```
App Name (30 chars):     RollReel – Local Video Player
Subtitle (30 chars):     Swipe Your Camera Roll Like Reels
Keywords (100 chars):    offline,swipe,video,camera,reel,vault,private,gallery,player,rewind,memories
```

**Do not repeat** words from the App Name or Subtitle in the keyword field — Apple ignores them and it wastes your 100-character limit.

### Icon Strategy

- Bold, single-concept icon: a play button (▶) composed inside a film reel or camera shutter shape
- Dark background (works on both light and dark iOS home screens)
- No text in the icon (illegible at small sizes)
- Color: deep navy + cyan/teal gradient (premium, trustworthy, modern)
- A/B test the icon after launch using Apple's Product Page Optimization feature (built into App Store Connect)

### Screenshot Strategy (6 screenshots optimized for conversion)

| Screenshot | Headline | Visual |
|---|---|---|
| 1 | "Your Camera Roll. Swipe Like Reels." | Full-screen swipe feed mockup |
| 2 | "100% Offline. No Cloud. No Account." | Phone with Wi-Fi off indicator + video playing |
| 3 | "Smart Filters. Find Any Video Instantly." | Filter tab UI (All / Shorts / Long) |
| 4 | "Privacy Vault. Your Private Videos, Locked." | Vault screen mockup (Pro badge) |
| 5 | "Share in One Swipe." | Share sheet moment |
| 6 | "Simple. Fast. Yours." | Feature grid or App Icon + CTA |

### App Preview Video (strongly recommended)

- 15–30 second screen recording showing: library loading → swipe feed → smooth swipe transitions → date labels → share gesture
- No music (Apple review requires appropriate audio licensing)
- Captures the core UX immediately — apps with App Preview videos see 20-30% higher conversion rates

### App Description Structure

```
Opening hook (2 sentences) — emotional, no jargon
Core feature list (5 bullets) — scannable
Privacy statement (2 sentences) — explicit "no upload, no account"
Pro upgrade mention (1 sentence) — optional upgrade for power users
Technical note (1 sentence) — permissions explanation
```

### Review Solicitation Strategy

- Use `SKStoreReviewController.requestReview()` after 3 complete video-swipe sessions AND at least 24 hours post-install
- Never ask for a review mid-video
- Target: 4.6+ average rating in first 90 days

---

## 14. Growth & Traction Strategy

### Phase 1 — Pre-Launch (Weeks 1–4 before submission)

**Build an audience before the app exists:**

1. **LinkedIn Content** — Post a 3-part build-in-public series: "I'm building a TikTok-style local video player for iPhone. Here's why the App Store is missing this." — target product folks, indie devs, and privacy-conscious iOS users
2. **Reddit seeding** — Post to r/iphone, r/ios, r/shortcuts: "Would you use an app that lets you swipe through your camera roll videos like TikTok?" with a Typeform waitlist link
3. **TikTok/Instagram Reels** — Create a 15-second screen recording of the concept: *"POV: someone finally made TikTok but for your own videos"* — this format is native to the exact users who want this product
4. **Waitlist landing page** — One-page site at `rollreel.app`: headline, 3 feature bullets, email capture, "notify me at launch" CTA

**Target: 500 waitlist signups before launch**

### Phase 2 — Launch Week (Day 0–7)

1. **ProductHunt launch** — Submit to ProductHunt with "Private TikTok for your iPhone camera roll" framing. Target Top 5 Product of the Day in the iOS Apps category
2. **Email waitlist blast** — Send all collected emails: "RollReel is live. Here's your free Pro code for being an early supporter." (use Apple promo codes — 100 available per version)
3. **Reddit launch post** — Post to r/iphone and r/ios: "I built an app that lets you swipe through your local videos like TikTok – here's what it took" (build-in-public storytelling converts strongly on Reddit)
4. **LinkedIn post** — Share launch with demo video, tag relevant iOS developers and product makers

**Target: 500 downloads in week 1, 50+ ratings**

### Phase 3 — Growth (Month 1–6)

**Content Marketing (Highest ROI for solo developer):**

- YouTube Shorts and TikTok: weekly 30-second demos showing the app solving real problems ("Trying to find that video from my trip to Bali — watch how fast RollReel finds it")
- Specific search-intent YouTube titles: "How to swipe through your iPhone videos like TikTok" — these rank in Google AND YouTube, driving long-tail organic installs
- Twitter/X thread: "I found a gap in the App Store that nobody has filled. Here's how I built RollReel in 6 weeks."

**Press & Coverage:**

- Submit to iOS-focused blogs and newsletters: 9to5Mac, MacRumors community, AppAdvice, The Sweet Setup
- Reach out to privacy-focused publications (The Markup, Ars Technica) with the angle: "An app that gives you TikTok's UX without TikTok's surveillance"
- This dual angle (UX + privacy) creates a story journalists want to write

**Referral / Word of Mouth Hook:**

- Add a "Share RollReel" option in Settings — generates a pre-written text or tweet: *"Just found this app that lets you swipe through your iPhone videos like TikTok — and it's 100% offline: [App Store link]"*
- This is the highest-converting organic channel for consumer iOS apps

**Apple Feature Targeting (Important):**

- Design the app to Apple's Human Interface Guidelines perfectly
- Submit to Apple's editorial team via the App Store Connect "promote your app" form
- Focus on the privacy angle — Apple's App Store editorial team actively features privacy-forward apps as part of their brand messaging
- A single Apple feature in "Apps We Love" can drive 10,000–50,000 downloads in a week

### Phase 4 — Retention (Ongoing)

- **On This Day notifications** (V2.1) are the most important retention feature — daily touchpoint
- **Monthly release cadence** — even minor updates signal to the App Store algorithm that the app is actively maintained (boosts search ranking)
- **Respond to every App Store review** — publicly, within 24 hours. This is visible to potential downloaders and dramatically improves conversion rates

---

## 15. Apple Compliance & Privacy Policy

### Required Info.plist Keys

```xml
<!-- Required — will be rejected without this -->
<key>NSPhotoLibraryUsageDescription</key>
<string>RollReel reads your local videos to display them in a swipe feed. No videos are uploaded, transmitted, or stored outside your device.</string>
```

### Permission Handling Requirements

Per Apple's iOS 14+ guidelines, RollReel must handle all three photo library authorization states:

```dart
// Flutter implementation using photo_manager package
final permission = await PhotoManager.requestPermissionExtend();
switch (permission) {
  case PermissionState.authorized:
    // Full access — load all videos
    break;
  case PermissionState.limited:
    // Partial access — show "manage photos" prompt
    break;
  case PermissionState.denied:
  case PermissionState.notDetermined:
    // Show explanation screen with Settings deeplink
    break;
}
```

### Privacy Policy Requirements

A privacy policy URL is **required** in App Store Connect. Host it at `rollreel.app/privacy`.

**RollReel's Privacy Policy must clearly state:**

1. No videos, thumbnails, or metadata are uploaded to any server
2. No user account is required
3. The app does not transmit any personal data to third parties
4. AdMob integration (for free tier) collects anonymous advertising identifiers — include IDFA disclosure
5. The app does not track users across other apps or websites (set `NSUserTrackingUsageDescription` appropriately, or opt out of ATT entirely for a cleaner user experience)

### App Store Review Guideline Compliance

| Guideline | RollReel Status |
|---|---|
| 5.1.1 Data Collection | ✅ Minimal — AdMob only, disclosed |
| 5.1.2 Data Use and Sharing | ✅ No video data shared or stored externally |
| 2.1 App Completeness | ✅ Full functionality at launch |
| 4.2 Minimum Functionality | ✅ Core utility clearly defined |
| 3.1.1 In-App Purchase | ✅ Pro and Plus use Apple IAP only |
| 5.3.4 Push Notifications | ✅ Notifications used for On This Day (V2) — user opt-in only |

### App Tracking Transparency (ATT)

**Recommendation for MVP:** Do not use personalized advertising in v1.0. Use contextual AdMob ads only (no ATT prompt needed). This significantly improves onboarding conversion — ATT prompts early in onboarding drop user trust and increase uninstall rates.

Introduce targeted ads (and the ATT prompt) only if eCPM is meaningfully higher after user base is established.

---

## 16. Technical Stack

### Recommended: Flutter (Dart)

Given existing Flutter expertise, this is the fastest path to a polished iOS app.

### Key Flutter Packages

| Package | Purpose | Notes |
|---|---|---|
| `photo_manager` | PHPhotoLibrary access, video fetching | Best Flutter wrapper for iOS PhotoKit |
| `video_player` | AVPlayer-backed video playback | Official Flutter plugin — iOS-native |
| `chewie` | Video player controls UI wrapper | Builds on video_player, customizable |
| `flutter_riverpod` | State management | For feed state, filter state, permissions state |
| `in_app_purchase` | Apple IAP for Pro/Plus | Official Flutter IAP plugin |
| `google_mobile_ads` | AdMob integration | Official Google plugin |
| `shared_preferences` | Local settings storage | For user preferences |
| `local_auth` | Face ID / Touch ID | For Privacy Vault feature (V2) |
| `app_review` | `SKStoreReviewController` wrapper | For review prompt |

### Performance Considerations

- **Video preloading:** Always preload the next 2 videos in the feed before the user swipes to them — this is the difference between a 5-star and 3-star experience
- **Thumbnail generation:** Generate thumbnails for all videos on first app launch (background isolate) and cache to local storage — never generate on-demand during feed scroll
- **Memory management:** Dispose `VideoPlayerController` instances that are more than 2 positions away from current index to prevent memory crashes on large libraries
- **Limited Library state:** When user grants Limited Access, load only the accessible assets and show a persistent "Managing X of Y videos" banner with a tap-to-expand-access CTA

### Architecture Pattern

```
lib/
├── core/
│   ├── permissions/     # Photo library permission logic
│   ├── video_cache/     # Thumbnail generation & caching
│   └── iap/             # In-app purchase management
├── features/
│   ├── feed/            # Main swipe feed screen
│   ├── filters/         # Tab-based filtering logic
│   ├── onboarding/      # First-launch flow
│   ├── settings/        # Settings screen
│   └── vault/           # Privacy vault (V2)
├── shared/
│   ├── widgets/         # Reusable UI components
│   └── theme/           # App design system
└── main.dart
```

---

## 17. Success Metrics (KPIs)

### App Performance Metrics

| Metric | Target (90 days) | Target (6 months) |
|---|---|---|
| Total Downloads | 2,000 | 10,000 |
| Day 1 Retention (D1) | > 45% | > 50% |
| Day 7 Retention (D7) | > 20% | > 25% |
| Day 30 Retention (D30) | > 10% | > 15% |
| Average Session Length | > 3 minutes | > 4 minutes |
| Sessions per DAU | > 2 | > 2.5 |
| App Store Rating | > 4.4 | > 4.6 |
| Review Count | 50+ | 200+ |

### Revenue Metrics

| Metric | Target (90 days) | Target (6 months) |
|---|---|---|
| Free-to-Pro Conversion | > 3% | > 5% |
| Pro Revenue | $500 | $2,500 |
| Plus Subscribers | 20 | 100 |
| Ad Revenue (MRR) | $50 | $300 |
| Total MRR | ~$150 | ~$600 |

### ASO Metrics

| Metric | Target (90 days) |
|---|---|
| App Store Impressions | 10,000+ |
| Conversion Rate (impressions → download) | > 4% |
| Keyword Rankings | Top 10 for "local video player", "camera roll video" |

---

## 18. Go-To-Market Plan

### Timeline

```
Week 1–2:    Set up App Store Connect, landing page, waitlist form
Week 3–4:    Build v1.0 MVP (Flutter development sprint)
Week 5:      Internal TestFlight (solo testing + 5 beta users)
Week 6:      Public TestFlight (target 30–50 beta testers from waitlist)
Week 7:      Address beta feedback, polish UI, fix crashes
Week 8:      App Store submission (7–10 day review window)
Week 8–9:   Launch marketing: LinkedIn post, Reddit posts, ProductHunt prep
Week 9:      LAUNCH DAY — ProductHunt submission, email blast, social posts
Week 10–12: Monitor reviews, respond to all, ship v1.1 with top-requested fixes
Month 3:     Ship V2.1 (On This Day notifications — major retention feature)
Month 4–5:  Introduce Plus subscription tier
Month 6:     Target first press coverage, re-apply for Apple editorial feature
```

---

## 19. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Apple rejects app for insufficient functionality | Low | High | Ensure full feature set in v1.0; add clear value description in review notes |
| FlowPlayer copies features before launch | Medium | Medium | Speed to market + branding differentiation — features are matchable, brand is not |
| Low conversion rate on Pro | Medium | High | A/B test paywall screens; introduce Pro trial (3-day free) to increase conversion |
| AdMob approval delay | Low | Medium | Apply for AdMob account 2 weeks before launch |
| Poor D7 retention pre-V2 | Medium | High | Ensure swipe UX is polished enough to be a habit loop on its own |
| Large library (5000+ videos) causes performance issues | Medium | High | Test on devices with large libraries in beta; implement pagination and lazy loading |
| Apple changes Photo Library access policy | Very Low | Very High | Monitor Apple WWDC announcements; comply immediately with any changes |

---

*RollReel PRD v1.0 — June 2026*  
*Built for indie iOS developers targeting Tier 1 markets.*  
*Next review date: After TestFlight beta (Week 6 of development)*
