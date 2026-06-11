# RollReel — UI/UX Design Guidelines
### iOS-First · Immersive Dark · Content-Adaptive · Flutter Implementation

> **Version:** 1.0  
> **Based on:** RollReel PRD v1.0  
> **Visual Reference:** Spotify-style content-immersive player UI  
> **Platform:** iOS 17+ · iPhone-first · iPad-compatible  
> **Framework:** Flutter (Dart)

---

## Table of Contents

1. [Design Philosophy & Direction](#1-design-philosophy--direction)
2. [Color System](#2-color-system)
3. [Typography](#3-typography)
4. [Icon System (SF Symbols)](#4-icon-system-sf-symbols)
5. [Spacing & Layout Grid](#5-spacing--layout-grid)
6. [Component Library](#6-component-library)
7. [Screen-by-Screen Specifications](#7-screen-by-screen-specifications)
   - [S1 — Splash / Launch Screen](#s1--splash--launch-screen)
   - [S2 — Onboarding Flow (3 screens)](#s2--onboarding-flow-3-screens)
   - [S3 — Permission Request Screen](#s3--permission-request-screen)
   - [S4 — Permission Denied State](#s4--permission-denied-state)
   - [S5 — Main Feed Screen (Swipe Player)](#s5--main-feed-screen-swipe-player)
   - [S6 — Feed Controls Overlay](#s6--feed-controls-overlay)
   - [S7 — Browse / List Screen](#s7--browse--list-screen)
   - [S8 — Filter Bar](#s8--filter-bar)
   - [S9 — Date Group Header](#s9--date-group-header)
   - [S10 — Share Moment Overlay](#s10--share-moment-overlay)
   - [S11 — Settings Screen](#s11--settings-screen)
   - [S12 — Pro Upgrade / Paywall Screen](#s12--pro-upgrade--paywall-screen)
   - [S13 — Privacy Vault Screen (V2)](#s13--privacy-vault-screen-v2)
   - [S14 — Empty State Screen](#s14--empty-state-screen)
   - [S15 — Loading / Skeleton State](#s15--loading--skeleton-state)
8. [Animation & Motion System](#8-animation--motion-system)
9. [Haptic Feedback Map](#9-haptic-feedback-map)
10. [iOS-Specific Compliance Rules](#10-ios-specific-compliance-rules)
11. [Dark Mode & Adaptive Colors](#11-dark-mode--adaptive-colors)
12. [Accessibility Guidelines](#12-accessibility-guidelines)
13. [Flutter Implementation Reference](#13-flutter-implementation-reference)

---

## 1. Design Philosophy & Direction

### Concept: **"Private Cinema"**

RollReel is not a utility. It is an experience. The moment you open it, your own memories command the entire screen. Every other element — controls, labels, dates — floats silently above the content like subtitles in a film. The phone disappears. The video remains.

This design language borrows from the reference UI: a Spotify-style full-screen immersive player where the content's dominant color bleeds into the background, the controls panel sits in frosted glass at the bottom, and transitions feel like physically swiping through physical reels of film.

### Three Pillars

| Pillar | Meaning | Design Expression |
|---|---|---|
| **Immersive** | The video is the UI | Full bleed, no chrome, edge-to-edge |
| **Alive** | Content drives color | Dynamic background extracted from video thumbnail |
| **Private** | Yours alone | No social affordances, intimate tone, vault motif |

### What This Is NOT

- ❌ Not a flat white utility app
- ❌ Not a generic Material Design grid
- ❌ Not a clone of TikTok's UI (that's social — this is private cinema)
- ❌ Not dark-gray-on-black with blue accents (the default iOS boring dark)

---

## 2. Color System

### Base Palette (Static)

These are the foundational colors used in chrome, surfaces, and text. They never change regardless of video content.

```dart
// RollReel Design Tokens — colors.dart

// Base backgrounds
const Color bgDeep       = Color(0xFF07070F);  // Near-black with a violet undertone
const Color bgSurface    = Color(0xFF111118);  // Cards, list rows
const Color bgElevated   = Color(0xFF1C1C26);  // Bottom sheets, modals

// Glass surfaces (use with BackdropFilter)
const Color glassLight   = Color(0x33FFFFFF);  // 20% white — light glass
const Color glassDark    = Color(0x99000000);  // 60% black — dark glass for controls
const Color glassBorder  = Color(0x22FFFFFF);  // Subtle white border on glass panels

// Text
const Color textPrimary  = Color(0xFFFFFFFF);  // Pure white — titles
const Color textSecond   = Color(0xFFAAAAAB);  // Cool gray — subtitles, dates
const Color textDisabled = Color(0xFF555565);  // Muted — placeholders

// Dividers / separators
const Color divider      = Color(0xFF1E1E2E);
```

### Accent Palette (Colorful — Static)

Used for UI elements, badges, gradients, and CTAs. These are RollReel's brand colors.

```dart
// Accent colors — vibrant, energetic
const Color accentCoral  = Color(0xFFFF5E5E);  // Primary CTA, active states
const Color accentCyan   = Color(0xFF00D4FF);  // Secondary, links, filter active
const Color accentAmber  = Color(0xFFFFB347);  // "On This Day", warm highlights
const Color accentViolet = Color(0xFF8B5CF6);  // Pro badge, vault accent
const Color accentGreen  = Color(0xFF4ADE80);  // Success states, "Local" badge
const Color accentPink   = Color(0xFFFF5E8B);  // Favorites / heart
```

### Accent Palette (Dynamic — Content-Adaptive)

**This is the most important color feature.** When a video is active in the swipe feed, RollReel extracts the dominant color from its thumbnail and uses it to color the background, the progress bar, and the overlay gradient. This makes every video feel like it has its own identity — exactly as seen in the Pinterest reference.

```dart
// Dynamic color behavior:
// 1. Extract dominant color from video thumbnail using palette_generator package
// 2. Darken it by 60% for background use (HSL lightness × 0.4)
// 3. Apply as background gradient base
// 4. Use original dominant color for progress bar and active icon tint

// Example: A beach video with dominant blue → background becomes deep navy
// Example: A sunset video with dominant orange → background becomes dark amber
// Example: A birthday video with dominant red → background becomes deep crimson

Color extractedDominant;   // e.g. Color(0xFFE84393) — pink from a party video
Color bgFromVideo;         // = extractedDominant.darken(0.60) — deep dark version
Color accentFromVideo;     // = extractedDominant — used for progress bar tint
```

### Gradients

```dart
// Primary brand gradient — logo, onboarding, Pro badge
const LinearGradient gradBrand = LinearGradient(
  colors: [Color(0xFFFF5E5E), Color(0xFF8B5CF6)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Feed background gradient — sits below video, above extracted dynamic color
const LinearGradient gradFeedOverlay = LinearGradient(
  colors: [Colors.transparent, Color(0xCC000000)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.4, 1.0],
);

// "On This Day" memory gradient
const LinearGradient gradMemory = LinearGradient(
  colors: [Color(0xFFFFB347), Color(0xFFFF5E8B)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Vault gradient (locked / private)
const LinearGradient gradVault = LinearGradient(
  colors: [Color(0xFF1C1C35), Color(0xFF8B5CF6)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Pro upgrade gradient
const LinearGradient gradPro = LinearGradient(
  colors: [Color(0xFF8B5CF6), Color(0xFF00D4FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```

---

## 3. Typography

### Font: SF Pro (System Font — iOS Native)

RollReel uses **Apple's SF Pro** exclusively. Do not introduce a custom font — SF Pro Rounded and SF Pro Display are premium, beautiful, and render perfectly on iPhone. This is also a key differentiator from Android apps.

In Flutter on iOS, access SF Pro via `fontFamily: '.SF Pro Display'` or use system `TextStyle` defaults which resolve to SF Pro automatically.

```dart
// typography.dart — RollReel Text Styles

// Display — used for hero numbers, splash logo text
const TextStyle tsDisplay = TextStyle(
  fontFamily: '.SF Pro Rounded',   // Rounded variant — more playful, modern
  fontSize: 40,
  fontWeight: FontWeight.w800,     // ExtraBold
  letterSpacing: -1.5,
  color: textPrimary,
);

// Title 1 — screen titles, video titles in feed
const TextStyle tsTitle1 = TextStyle(
  fontFamily: '.SF Pro Display',
  fontSize: 28,
  fontWeight: FontWeight.w700,     // Bold
  letterSpacing: -0.8,
  color: textPrimary,
);

// Title 2 — section headers, list headers
const TextStyle tsTitle2 = TextStyle(
  fontFamily: '.SF Pro Display',
  fontSize: 22,
  fontWeight: FontWeight.w600,     // SemiBold
  letterSpacing: -0.4,
  color: textPrimary,
);

// Headline — video names in list, settings labels
const TextStyle tsHeadline = TextStyle(
  fontFamily: '.SF Pro Text',
  fontSize: 17,
  fontWeight: FontWeight.w600,
  letterSpacing: -0.2,
  color: textPrimary,
);

// Body — descriptions, settings values
const TextStyle tsBody = TextStyle(
  fontFamily: '.SF Pro Text',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.0,
  color: textPrimary,
);

// Subheadline — artist name, date, subtitle in feed
const TextStyle tsSubheadline = TextStyle(
  fontFamily: '.SF Pro Text',
  fontSize: 14,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.1,
  color: textSecond,
);

// Caption — timestamps, duration badges, tags
const TextStyle tsCaption = TextStyle(
  fontFamily: '.SF Pro Text',
  fontSize: 12,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.3,
  color: textSecond,
);

// Caption Bold — "PRO" badge text, filter tab active label
const TextStyle tsCaptionBold = TextStyle(
  fontFamily: '.SF Pro Text',
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.5,
  color: textPrimary,
);
```

### Font Size Scaling (Dynamic Type Support)

All text must scale with the user's Dynamic Type setting. In Flutter, use `textScaler` and avoid hardcoded `maxLines` except in feed overlays where space is constrained.

```dart
// Maximum font scale for feed overlay text — prevent overflow on video
const double maxFeedTextScale = 1.3;

// All other screens — unlimited scaling for accessibility
```

---

## 4. Icon System (SF Symbols)

**Rule:** Use SF Symbols exclusively. Never use Material Icons, Font Awesome, or any non-Apple icon set. SF Symbols render at native quality on all iOS resolutions and automatically adapt to Dynamic Type, accessibility contrast, and Multicolor rendering.

In Flutter, use the `cupertino_icons` package for basic symbols, or render SF Symbols via `Text` with the SF Symbols font weight mapping. For full SF Symbols in Flutter, use `flutter_sf_symbols` package.

### Core Icon Map

```
PLAYBACK CONTROLS
──────────────────────────────────────────────────
play.fill                → Play
pause.fill               → Pause
backward.fill            → Back / Previous
forward.fill             → Skip / Next
gobackward.10            → Rewind 10 seconds
goforward.10             → Forward 10 seconds
speaker.wave.3.fill      → Volume (full)
speaker.wave.1.fill      → Volume (low)
speaker.slash.fill       → Muted
speedometer              → Playback speed (V2)

NAVIGATION
──────────────────────────────────────────────────
chevron.up               → Swipe up hint / close
chevron.down             → Swipe down hint
chevron.left             → Back
chevron.right            → Forward
xmark.circle.fill        → Dismiss / Close
line.3.horizontal        → Hamburger menu
ellipsis.circle          → More options
square.grid.2x2.fill     → Grid/Browse view
rectangle.stack.fill     → Feed view (list of videos)

ACTIONS
──────────────────────────────────────────────────
heart.fill               → Favorited
heart                    → Unfavorited
square.and.arrow.up      → Share
square.and.arrow.up.fill → Share (active)
bookmark.fill            → Saved / Bookmark
plus.circle.fill         → Add to collection
trash.fill               → Delete
pencil                   → Rename / Edit

FILTERS & ORGANIZATION
──────────────────────────────────────────────────
slider.horizontal.3      → Filter options
calendar                 → Date filter
clock.fill               → Recents / Time filter
film.fill                → All Videos tab
bolt.fill                → Shorts (< 1 min) tab
video.fill               → Long videos (> 1 min) tab
magnifyingglass          → Search

PRIVACY & PRO
──────────────────────────────────────────────────
lock.fill                → Locked / Vault
lock.open.fill           → Unlocked
faceid                   → Face ID
touchid                  → Touch ID
eye.slash.fill           → Hidden content
shield.fill              → Privacy mode
star.fill                → Pro / Premium
crown.fill               → Pro tier badge

SYSTEM / STATUS
──────────────────────────────────────────────────
iphone                   → Local device (no cloud)
cloud.slash.fill         → No cloud badge
wifi.slash               → Offline mode
checkmark.circle.fill    → Success
exclamationmark.circle   → Warning / Info
arrow.clockwise          → Refresh / Retry
photo.on.rectangle       → Photo library
```

### Icon Sizes

```dart
const double iconXS   = 14.0;   // Timestamps, inline badges
const double iconSM   = 18.0;   // Compact controls, filter bar
const double iconMD   = 22.0;   // Standard control buttons
const double iconLG   = 28.0;   // Hero controls (play/pause in feed)
const double iconXL   = 36.0;   // Large CTA buttons
const double iconHero = 48.0;   // Splash, empty state illustration icons
```

### Icon Rendering Weights

SF Symbols respond to font weight — use `.semibold` or `.bold` rendering weight for icons that sit on dark backgrounds, and `.regular` or `.light` for icons on glass surfaces.

```dart
// Cupertino icons with correct weight rendering
Icon(CupertinoIcons.play_fill,
  size: iconLG,
  color: textPrimary,
  // For SF Symbols variable weight, wrap in Text + font
)
```

---

## 5. Spacing & Layout Grid

### Base Unit: 8pt Grid

All spacing, padding, and component sizing is based on multiples of 8 (with 4pt allowed for tight spacing).

```dart
// spacing.dart
const double sp2  = 2.0;
const double sp4  = 4.0;
const double sp8  = 8.0;
const double sp12 = 12.0;
const double sp16 = 16.0;
const double sp20 = 20.0;
const double sp24 = 24.0;
const double sp32 = 32.0;
const double sp40 = 40.0;
const double sp48 = 48.0;
const double sp56 = 56.0;
const double sp64 = 64.0;
```

### Safe Area Insets (iOS)

```dart
// CRITICAL — Always respect these. Never place interactive elements outside safe area.

// Status bar / Dynamic Island clearance
const double safeTop    = 59.0;   // iPhone 14 Pro / 15 / 16 (Dynamic Island)
                                   // Earlier models: 44pt (notch) or 20pt (no notch)
                                   // Use MediaQuery.of(context).padding.top in code

// Home indicator clearance
const double safeBottom = 34.0;   // All Face ID iPhones
                                   // Use MediaQuery.of(context).padding.bottom in code

// Side padding (minimum touch target distance from edge)
const double safeHorizontal = 20.0;
```

### Component Heights

```dart
// Component heights — consistent across the app
const double heightNavBar       = 44.0;   // iOS standard navigation bar
const double heightTabBar       = 49.0;   // iOS standard tab bar
const double heightFilterBar    = 44.0;   // Custom filter tab bar
const double heightListRow      = 72.0;   // Video list row height
const double heightMiniPlayer   = 64.0;   // Collapsed mini-player
const double heightControlPanel = 120.0;  // Bottom control panel in feed
const double heightBannerAd     = 50.0;   // AdMob banner (only in browse view)

// Thumbnail sizes
const double thumbSquareSM = 48.0;   // List row thumbnail
const double thumbSquareMD = 80.0;   // Grid thumbnail (if used)
const double thumbSquareLG = 120.0;  // Onboarding illustration thumbnails

// Button sizes
const double btnHeightSM  = 36.0;   // Pill buttons (filter chips)
const double btnHeightMD  = 48.0;   // Standard buttons (settings rows)
const double btnHeightLG  = 56.0;   // Primary CTA buttons
const double btnHeightXL  = 64.0;   // Hero CTA (paywall, permission)

// Corner radii
const double radiusXS  = 4.0;
const double radiusSM  = 8.0;
const double radiusMD  = 12.0;
const double radiusLG  = 16.0;
const double radiusXL  = 24.0;
const double radiusFull = 100.0;  // Pill / fully rounded
```

---

## 6. Component Library

### C1 — GlassPanel

Used everywhere that a surface floats over video content. Requires `BackdropFilter` with `ImageFilter.blur`.

```dart
// Appearance:
// - Background: glassDark (0x99000000)  
// - Border: 1px glassBorder (0x22FFFFFF) on top and sides
// - Corner radius: radiusXL (24pt)
// - Backdrop blur: sigma 20
// - Shadow: 0px 8px 32px rgba(0,0,0,0.6)

Container(
  decoration: BoxDecoration(
    color: glassDark,
    borderRadius: BorderRadius.circular(radiusXL),
    border: Border.all(color: glassBorder, width: 1),
    boxShadow: [BoxShadow(
      color: Colors.black.withOpacity(0.6),
      blurRadius: 32,
      offset: Offset(0, 8),
    )],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(radiusXL),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: content,
    ),
  ),
)
```

### C2 — VideoThumbnail

Used in the browse/list view. Rounded rectangle with a play icon overlay.

```
Size:        48×48pt (list) or 80×80pt (compact grid)
Corner:      radiusMD (12pt)
Play overlay: SF Symbol play.fill, white, 18pt, centered
Duration badge: Bottom-right, glassDark pill, tsCaption text
Aspect ratio:  1:1 (square crop from video center)
```

### C3 — FilterChip

Used in the horizontal filter tab bar.

```
Active state:   
  background: gradBrand (gradient pill)
  text: white, tsCaptionBold
  icon: SF Symbol, white, 14pt
  padding: 8pt vertical, 16pt horizontal
  corner: radiusFull
  
Inactive state:  
  background: bgElevated
  text: textSecond, tsCaption
  icon: SF Symbol, textSecond, 14pt
  border: 1px divider
  
Height:   36pt
Spacing between chips: 8pt
```

### C4 — ProgressBar (Video Scrubber)

```
Track:        height 3pt, color textDisabled (40% opacity)
Fill:         height 3pt, color = accentFromVideo (dynamic)
Thumb:        8pt circle, white, appears only on active drag (hidden at rest)
Handle grab:  48×48pt touch target (centered on 8pt thumb — per HIG minimum)
Corner:       radiusFull
```

### C5 — DateGroupLabel

Floating label that appears when scrolling through the feed or list.

```
Text:       "Today" / "Yesterday" / "June 2024" — tsCaptionBold, white
Background: glassDark pill, backdropBlur 10
Padding:    6pt vertical, 14pt horizontal
Corner:     radiusFull
Position:   Centered horizontally, 12pt below safe area top
Animation:  Fade in 200ms, auto-dismiss after 1.5 seconds
```

### C6 — DurationBadge

Small time indicator on video thumbnails.

```
Text:       "0:24" or "2:15" — tsCaption, white
Background: Color(0x99000000) — 60% black
Padding:    3pt vertical, 7pt horizontal
Corner:     radiusSM
Position:   Bottom-right of thumbnail, 4pt inset
```

### C7 — LocalBadge

Shown in the list view and onboarding to communicate "no cloud."

```
Icon:       cloud.slash.fill, accentGreen, 12pt
Text:       "Local" — tsCaptionBold, accentGreen, 11pt
Background: accentGreen.withOpacity(0.12)
Padding:    4pt vertical, 10pt horizontal
Corner:     radiusFull
Border:     1px accentGreen.withOpacity(0.30)
```

### C8 — ProBadge

Used on locked features throughout the app.

```
Text:       "PRO" — tsCaptionBold, white, 10pt, letterSpacing: 1.5
Background: gradPro (purple → cyan)
Padding:    3pt vertical, 8pt horizontal
Corner:     radiusFull
Shadow:     0px 2px 8px accentViolet.withOpacity(0.5)
```

### C9 — PrimaryButton

Used for CTAs in onboarding, paywall, settings.

```
Height:     56pt
Corner:     radiusFull
Background: gradBrand (default) or solid accentCoral
Text:       tsHeadline, white, centered
Icon:       optional, left of text, iconMD
Min width:  200pt
Max width:  stretch (full width minus horizontal padding)
Press state: scale 0.96, 100ms spring
```

### C10 — SecondaryButton

Used for "Skip", "Maybe Later", "Cancel" CTAs.

```
Height:     56pt
Corner:     radiusFull
Background: transparent
Border:     2px glassBorder
Text:       tsBody, textSecond, centered
Press state: background → bgElevated, 100ms
```

### C11 — SettingsRow

Consistent rows throughout the Settings screen.

```
Height:     52pt
Padding:    16pt horizontal, 14pt vertical
Icon:       Left, iconMD, gradient-colored per section
Label:      tsHeadline, textPrimary
Value:      tsSubheadline, textSecond (right-aligned)
Disclosure: chevron.right, textDisabled (only for navigation rows)
Toggle:     CupertinoSwitch — accentCoral thumb, bgElevated track
Separator:  1px divider, indented 56pt from left (aligned to label)
```

---

## 7. Screen-by-Screen Specifications

---

### S1 — Splash / Launch Screen

**Purpose:** Brand identity moment. Maximum 2 seconds.

```
Background:     Solid bgDeep (#07070F)
Center element: RollReel logomark
  - "C" letter in gradBrand gradient, tsDisplay weight
  - Film reel strip integrated into the letter form (filmstrip dots on the C)
  - Below: "RollReel" wordmark in tsTitle1, white
  - Below: "Your Videos. Your Way." in tsSubheadline, textSecond

Animation sequence (total: 1.8 seconds):
  0ms:      Background fade from black
  200ms:    Logo scale from 0.6 → 1.0 with spring (damping 0.7)
  400ms:    Wordmark fade in from below (translateY +20 → 0)
  600ms:    Tagline fade in with 150ms delay
  1000ms:   Subtle glow pulse on logo (opacity 0.4 → 0.8 → 0.4)
  1800ms:   Full screen fade to black → transition to onboarding or feed
```

---

### S2 — Onboarding Flow (3 Screens)

**Pattern:** Horizontal swipe paginator with dots indicator. Skip button top-right.

**Global onboarding style:**
- Background: bgDeep with animated gradient mesh (slow-moving blobs of accentCoral and accentCyan at 5% opacity)
- Page indicator: 3 dots at bottom, active dot = gradBrand gradient, inactive = textDisabled
- Progress: No back button — swipe left to go back naturally

---

**Onboarding Screen 1 — "The Concept"**

```
Illustration area (top 55% of screen):
  - Animated mockup of iPhone showing swipe feed
  - Three stacked video thumbnails with parallax depth
  - Swipe-up gesture arrow animation (looping, cyan color)
  - Videos animate to represent "swiping" on 2-second interval

Content area (bottom 45%):
  Headline: "Your Videos. Finally Watchable."
             tsTitle1, white, center-aligned
  Body:     "Swipe through your camera roll like TikTok.
             No uploads. No accounts. Just your memories."
             tsBody, textSecond, center-aligned, lineHeight 1.5
  
Primary CTA: "Get Started" — PrimaryButton (gradBrand)
Secondary:   "Skip" text button, textSecond (top-right corner)
```

---

**Onboarding Screen 2 — "Privacy"**

```
Illustration area:
  - Animated lock icon (lock.fill, accentViolet, 80pt)
  - Lock transitions: locked → keyhole glow → unlocked → re-locks
  - Floating chips around lock: "No Cloud", "No Account", "No Tracking"
    Each chip: LocalBadge style, animated float with staggered timing

Content area:
  Headline: "100% Private. 100% Yours."
             tsTitle1, white
  Body:     "Your videos never leave your phone. No cloud backup,
             no sign-in, no ads while you watch. Just you."
             tsBody, textSecond
```

---

**Onboarding Screen 3 — "Permission"**

```
Illustration area:
  - Large photo library icon (photo.on.rectangle, 80pt, gradBrand)
  - Below icon: Three tiny video thumbnails arranged in a fan

Content area:
  Headline: "Let's Find Your Videos"
             tsTitle1, white
  Body:     "RollReel needs access to your photo library to
             find your videos. Your videos stay on your device."
             tsBody, textSecond
  
Note box (glass panel, accentCyan 10% background):
  Icon:    info.circle, accentCyan, 16pt
  Text:    "You can choose Full Access or Limited Access.
            We only ever read videos — never photos, never uploads."
           tsSubheadline, textSecond

Primary CTA: "Allow Access to Videos" — PrimaryButton (gradBrand)
Secondary:   "Not Now" — SecondaryButton
```

---

### S3 — Permission Request Screen

This is the iOS system permission dialog — RollReel cannot customize it. However, the screen underneath (which the dialog appears over) should be the onboarding screen 3 blurred to 80% — so the transition is seamless.

**Important:** The custom permission explanation before the system dialog must clearly state purpose. Apple will reject if the `NSPhotoLibraryUsageDescription` string is vague.

```
Pre-dialog screen = Onboarding S3 (blurred under system dialog)
System dialog text = "RollReel reads your local videos to display them 
                      in a swipe feed. No videos are uploaded."
```

---

### S4 — Permission Denied State

Shown when user has denied photo library access or taps "Not Now."

```
Background:   bgDeep
Top area:     SF Symbol photo.slash (60pt, textDisabled), centered vertically
Headline:     "No Videos Found"
              tsTitle1, white, centered
Body:         "RollReel needs access to your photo library.
               Your videos are never uploaded or shared."
              tsBody, textSecond, centered

Primary CTA:  "Open Settings"
              PrimaryButton, accentCoral
              → Opens UIApplication.openSettingsURLString

Secondary:    "Learn Why" — opens a compact bottom sheet explaining the permission

Bottom note:  "You can also tap Videos under Settings → Privacy → Photos"
              tsCaption, textDisabled
```

---

### S5 — Main Feed Screen (Swipe Player)

**This is the hero screen. Everything else serves it.**

**Layout (edge-to-edge, no chrome):**

```
[Device edge to edge]
│
│  ┌─────────────────────────────────┐  ← Status bar (transparent — iOS handles color)
│  │         STATUS BAR               │
│  └─────────────────────────────────┘
│
│  ┌─────────────────────────────────┐
│  │                                 │
│  │                                 │
│  │                                 │
│  │         VIDEO PLAYBACK          │  ← Full screen video, no borders
│  │      (edge to edge, 100%        │
│  │       width and height)         │
│  │                                 │
│  │                                 │
│  └─────────────────────────────────┘
│
│  [Controls overlay — hidden at rest, shown on tap]
│
│  ┌─────────────────────────────────┐
│  │  BOTTOM CONTROL PANEL           │  ← GlassPanel, 120pt height + safeBottom
│  │  (Always visible)               │
│  └─────────────────────────────────┘
│
[Home indicator area]
```

**Background Layer (Dynamic Color):**

```
Layer 1 (bottom):  bgDeep (#07070F) — fallback solid
Layer 2:           Video dominant color, darkened 60%, fills full screen
                   Transition: 600ms crossfade between videos
Layer 3:           gradFeedOverlay — transparent to black, 40% → 100%
                   Applied bottom 50% of screen only
Layer 4:           The actual video (fitted to cover, preserving aspect ratio)
```

**Bottom Control Panel (GlassPanel, always visible):**

```
Height:     120pt + safeBottom padding
Width:      100%
Position:   pinned to bottom
Background: glassDark + BackdropFilter blur(20)
Border top: 1px glassBorder

Internal layout (padding: 20pt horizontal, 16pt vertical):

Row 1 — Video Info:
  [Left]  Video title: tsHeadline, white, maxLines 1, overflow ellipsis
  [Left]  Date + duration: tsSubheadline, textSecond, "June 5 · 0:24"
  [Right] Share button: square.and.arrow.up, iconMD, white

Row 2 — Progress Bar (C4):
  Full width, 16pt vertical padding
  Left timestamp: tsCaption, textSecond
  Right timestamp: tsCaption, textSecond
  Active thumb appears on press-hold

Row 3 — Playback Controls:
  [Far left]   heart / heart.fill (iconMD) — favorites
  [Center-left] gobackward.10 (iconMD)
  [Center]     play.fill / pause.fill (iconXL, 36pt) — main control
  [Center-right] goforward.10 (iconMD)
  [Far right]  ellipsis.circle (iconMD) — more options
  
  Spacing: space-between distribution
```

**Side Action Bar (vertical, right side, 60% up from bottom):**

Inspired by the Pinterest reference — right side floating buttons.

```
Position:   Right edge, 20pt inset, vertically centered at 55% of screen height
Layout:     Vertical column, 24pt gap between buttons
Background: None — buttons float directly on the gradient

Buttons (from top to bottom):
  1. heart / heart.fill — favorites
     Icon: 26pt, white (unfav) or accentPink + particle burst (fav)
     Counter: tsCaption below icon

  2. square.and.arrow.up — share
     Icon: 24pt, white

  3. bookmark.fill — save to collection (V2)
     Icon: 22pt, white

  4. ellipsis — more (context menu)
     Icon: 20pt, white
```

**Top Bar (transparent, shows on tap):**

```
Position:   Fixed top, safeTop + 8pt spacing
Left:       rectangle.stack.fill (iconMD) → Browse view
Center:     "RollReel" wordmark (tsTitle2, white) — subtle, not prominent
Right:      slider.horizontal.3 (iconMD) → Filter panel

Background: Gradient from top: rgba(0,0,0,0.6) → transparent over 100pt height
```

**Swipe Gesture Navigation:**

```
Swipe UP:    Next video — slide current video up and out, next video slides in from bottom
Swipe DOWN:  Previous video — current video slides down, previous slides in from top
Swipe RIGHT: Enter browse/list view (horizontal swipe from left edge — iOS back gesture)
Long press:  Slow motion preview (0.5x) — show "0.5×" badge, release to resume
Double tap:  Seek forward 10s (right half) / Seek backward 10s (left half)
             Show "+10" / "-10" animation at tap location
Tap once:    Toggle controls visibility (GlassPanel + side actions fade toggle)
```

**Controls Auto-Hide:**

```
On swipe complete:    Hide controls immediately (instant)
On tap (show):        Fade in 200ms
Auto-hide timer:      3.0 seconds after last interaction
During active scrub:  Never auto-hide
On video completion:  Show controls until user interacts
```

**Date Group Label behavior in feed:**

```
On swipe to new video:
  If date group changes from current video:
    Show DateGroupLabel (C5) for 1.5 seconds
    Position: top center, 20pt below safe area top
    Animation: fade in 200ms, fade out 400ms
```

---

### S6 — Feed Controls Overlay

Additional controls revealed from the side action bar's ellipsis menu. Appears as a **bottom sheet**.

```
Sheet style:        GlassPanel, attached to bottom
Sheet height:       400pt + safeBottom
Handle:             8×4pt rounded pill, textDisabled, centered top 12pt

Header:             Video filename (tsSubheadline, textSecond), date (tsCaption)

Action list (each item: 56pt height, 20pt horizontal padding):

  [1] bolt.fill, accentCyan          "Playback Speed"
       → Sub-sheet with speed options: 0.5x / 1x / 1.5x / 2x
       → Active speed highlighted with accentCoral pill
       
  [2] arrow.triangle.2.circlepath, accentAmber  "Loop Video"
       → Toggle right side, CupertinoSwitch
       
  [3] plus.rectangle.on.rectangle, accentGreen  "Add to Collection"  
       → Opens collection picker (V2)
       
  [4] lock.fill, accentViolet        "Move to Vault" (Pro)
       → Shows ProBadge if not Pro
       
  [5] square.and.arrow.up, textPrimary  "Share"
       → Native iOS share sheet
       
  [6] info.circle, textSecond       "Video Info"
       → Shows: filename, date, duration, resolution, file size, location if available
       
  ─── Destructive zone ───
  [7] trash.fill, accentCoral        "Delete Video"
       → Confirmation dialog before deletion
```

---

### S7 — Browse / List Screen

The secondary view — accessed by swiping right from the feed or tapping the browse icon.

**Navigation:**

```
NavigationType:   iOS push navigation (slide right to go back = return to feed)
Navigation bar:   
  Title:          "Your Library"  tsTitle2, white
  Right button:   magnifyingglass (search) — iconMD, white
  Left button:    xmark (close/back to feed) — iconMD, white
  Background:     bgDeep + 40% backdrop blur (NavigationBar transparent blur)
```

**Header Section:**

```
Total video count badge:
  Text:       "847 Videos" (dynamically loaded count)
  Style:      tsTitle1, white + tsSubheadline, textSecond on new line
  Position:   Left-aligned, below navigation bar, 20pt padding
  
LocalBadge:   Right of count — "100% Local" (C7)
```

**Filter Bar (C3 chips, horizontally scrollable):**

```
Position:       Sticky below navigation bar
Chips (in order): 
  1. rectangle.stack.fill  "All"           (default active)
  2. calendar              "Today"
  3. bolt.fill             "Shorts"        (< 60 seconds)
  4. video.fill            "Long"          (> 60 seconds)
  5. clock.fill            "Recent"        (last 7 days)

Scroll:         Horizontal, no paging, fades out at right edge
Background:     bgDeep (sticky)
Separator:      1px divider below chip row
```

**Video List:**

```
Row height:     72pt
Padding:        20pt horizontal, 0pt vertical

Per row:
  [Left, 48×48pt]   VideoThumbnail (C2), rounded 12pt, 12pt from left edge
  [Middle, flex 1]  
    Title:           tsHeadline, white, maxLines 1, ellipsis
    Subtitle line:   Duration + Date — tsSubheadline, textSecond
                     e.g. "0:32 · June 5, 2024"
    Optional: LocalBadge if video has metadata indicating camera origin
  [Right, 44×44pt]  
    ellipsis.circle — textSecond — context menu trigger
    
Row separator:  1px divider, indented 68pt (aligned to text left edge)
Row press state: bgElevated highlight (100ms fade in, 200ms fade out)

Context menu (long press → iOS context menu):
  - Play Now (opens in feed at this position)
  - Favorite / Unfavorite
  - Share
  - Add to Collection
  - Move to Vault (Pro)
  - Delete
```

**Section Headers (Date Groups):**

```
Text:       "TODAY" / "YESTERDAY" / "JUNE 2024" — tsCaptionBold, textDisabled
            Uppercase forced
Padding:    20pt horizontal, 10pt top, 6pt bottom
Background: bgDeep (not elevated, reads as label not surface)
```

**Scroll behavior:**

```
Navigation bar collapse: NavigationBar collapses on scroll (iOS large title behavior)
Banner ad (free tier):  Pinned at bottom, 50pt height, above safe area bottom
                         Separator: 1px divider above ad
```

---

### S8 — Filter Bar

_Same as the chip row described in S7, but also appears as a bottom sheet variant when accessed from the feed via slider.horizontal.3 icon._

**Bottom Sheet Filter Panel (feed context):**

```
Sheet height:   Auto (wraps content) + safeBottom
Handle:         Pill handle, centered top

Section: Time Period
  Chips: All · Today · This Week · This Month · [Year pills: 2026 / 2025 / 2024 / ...]

Section: Duration
  Chips: Any · Under 1 min · 1–5 min · Over 5 min

Section: Sort By
  Options (radio): Newest First (default) / Oldest First / Shortest First / Longest First

Primary CTA: "Apply Filters" — PrimaryButton (gradBrand)
Reset:        "Reset" text button, textSecond, top right of sheet
```

---

### S9 — Date Group Header

_Specified as C5 component. Used both in feed (floating label) and browse list (section header)._

**In Feed (floating):**
```
Background:   glassDark pill, blur 10
Text:         "Today" / "June 2024" etc. — tsCaptionBold, white
Animation:    Fade in 200ms on group change, fade out 400ms after 1.5s
Position:     Top center, 20pt below safe area
```

**In Browse List (static):**
```
Text:         "TODAY" — tsCaptionBold, textDisabled, uppercase
Background:   bgDeep (transparent)
Left padding: 20pt
Vertical:     10pt top, 6pt bottom
```

---

### S10 — Share Moment Overlay

Triggered by the share button. This is purely native iOS — RollReel presents the system share sheet. RollReel's only custom contribution is:

**Pre-share options panel (bottom sheet, appears before share sheet):**

```
Sheet height:   280pt + safeBottom
Title:          "Share This Video"  tsTitle2, white

Video preview:  Thumbnail (120×80pt, rounded 12pt) with duration badge
                + Video title (tsHeadline, 1 line) on right

Quick share row (most common destinations, shown as circular icons):
  WhatsApp · Instagram Stories · AirDrop · Messages · Files
  Each: 52pt circle, icon + label below, tsCaption
  "More..." at end → opens full system share sheet

Separator + "Share Full Video" CTA (PrimaryButton, gradBrand)
Below: "Trim then Share" — SecondaryButton (Pro feature if V2)
```

---

### S11 — Settings Screen

**Navigation:** Accessed via gear icon in Browse view or feed ellipsis → Settings.

```
Navigation bar:  
  Title:    "Settings"  tsTitle2, white
  Left:     chevron.left + "Back" — returns to previous screen

Grouped list style (iOS UITableView grouped equivalent in Flutter):

SECTION: PLAYBACK
  - Loop Short Videos       toggle, default ON
  - Auto-play on Launch     toggle, default ON
  - Default Filter          value → pushes filter picker
  - Playback Speed          value "1×" → picker (Pro)

SECTION: APPEARANCE  
  - Show Date Labels        toggle, default ON
  - Show Duration Badges    toggle, default ON
  
SECTION: PRIVACY
  - Privacy Vault           "Set Up" → V2 (Pro)
  - App Lock (Face ID)      toggle → V2 (Pro)

SECTION: CAMREEL PRO
  Banner:  Gradient card (gradPro), ProBadge, "Upgrade to RollReel Pro"
           "Ad-free · Vault · Speed Controls · Smart Collections"
           → Taps to S12 paywall
  
  - Restore Purchases       chevron row

SECTION: ABOUT
  - Privacy Policy          external link → opens Safari
  - Rate RollReel            star.fill icon, opens App Store
  - Share RollReel           square.and.arrow.up, pre-filled share sheet
  - Version                 "RollReel 1.0.0 (Build 42)"  value, textSecond

Section styling:
  Header: tsCaptionBold, textDisabled, uppercase, 20pt left padding
  Rows:   SettingsRow component (C11)
  Group background: bgSurface, rounded corners 12pt (iOS grouped style)
  Group margin: 20pt horizontal, 12pt vertical
```

---

### S12 — Pro Upgrade / Paywall Screen

**Appears as full-screen modal** (sheet presentation style: `.fullScreenCover` equivalent).

```
Background:     bgDeep + animated gradient mesh (slow blobs: violet, cyan, coral)
Dismiss:        xmark.circle.fill, top-right, 20pt, textSecond (after 2 second delay)

HERO SECTION:
  Gradient card (full-width, 220pt height, gradPro):
    Center: ProBadge (large version, 48pt height)
    Headline: "RollReel Pro" tsDisplay, white
    Subhead:  "Watch more. Worry less." tsSubheadline, textSecond

FEATURE LIST:
  Each feature row (56pt height):
    [Left]  checkmark.circle.fill (accentGreen, 24pt)
    [Middle] Feature name — tsHeadline, white
             Feature description — tsSubheadline, textSecond
    
    Features:
    ✅ Ad-Free Experience — "No interruptions, ever"
    ✅ Privacy Vault — "Lock sensitive videos with Face ID"
    ✅ Playback Speed Control — "0.5× to 2× speed"
    ✅ Smart Collections — "Auto-grouped by date and location"
    ✅ Lock Screen Widget — "Today's video count at a glance"
    ✅ Early Access — "First to get every new feature"

PRICING OPTIONS (pill selector, two options):

  Option 1 — "One Time" (default selected):
    Price: "$4.99" tsTitle1, white
    Label: "Lifetime Access" tsSubheadline, textSecond
    Badge: "Best Value" — accentAmber pill
    
  Option 2 — "Annual" (toggle):
    Price: "$14.99/year" tsTitle1, white  
    Equiv: "$1.25/month" tsSubheadline, textSecond
    Badge: "Includes On This Day" — accentCyan pill
    
  Selector: Toggle pill (two-state), gradPro underline on selected

Primary CTA:    "Unlock RollReel Pro" — PrimaryButton (gradBrand)
                Subtitle below: "One-time purchase · No subscription hidden"

Secondary CTA:  "Restore Purchases" — text button, textSecond
Legal:          "Payment will be charged to your Apple ID..." tsCaption, textDisabled
```

---

### S13 — Privacy Vault Screen (V2)

**Entry: requires Face ID / Touch ID.**

```
LOCKED STATE:
  Background: gradVault (bgDeep → violet)
  Center:
    lock.fill icon — accentViolet, 64pt, glow animation
    Text: "Vault Locked" — tsTitle1, white
    Subtext: "Your private videos are safe here" — tsSubheadline, textSecond
  CTA: "Unlock with Face ID" — PrimaryButton (gradVault as gradient)
       faceid icon left of text

UNLOCKED STATE:
  Navigation bar: "Vault" title + lock.open.fill top-right (re-lock)
  Content: Same list view as S7 but with:
    Header: lock.open.fill (accentViolet) + "Your Vault" tsTitle2
    Empty state: "No videos in your vault yet" with shield icon
  
  Add to vault: Via context menu in main library — "Move to Vault"
  Vault badge: Videos in vault show an eye.slash.fill badge on their thumbnail
               in the vault view only (never in main feed)
```

---

### S14 — Empty State Screen

Shown when: no videos found, no results for filter, first-time limited access with no video selected.

```
Variants:

[A] No Videos At All:
  Icon:     film.fill, 60pt, textDisabled
  Title:    "No Videos Yet" — tsTitle1, white
  Body:     "Your camera roll videos will appear here." — tsBody, textSecond
  CTA:      "Open Photos App" (if limited access) OR "Grant Access" (if denied)

[B] Filter Has No Results:
  Icon:     magnifyingglass, 48pt, textDisabled  
  Title:    "No Videos Found" — tsTitle1, white
  Body:     "Try a different filter or time range." — tsBody, textSecond
  CTA:      "Clear Filters" — accentCyan text button

[C] Vault Is Empty:
  Icon:     lock.fill, 56pt, accentViolet, soft glow
  Title:    "Your Vault Is Empty" — tsTitle1, white
  Body:     "Long press any video and tap 'Move to Vault' to keep it private."
  CTA:      "Go to Library" — PrimaryButton

All empty states:
  Icon animation: subtle breathing scale (1.0 → 1.05 → 1.0, 2s interval, ease-in-out)
  Vertical center position: slightly above center (40% from top) — feels more balanced
```

---

### S15 — Loading / Skeleton State

Shown while video thumbnails are being generated on first app launch.

```
Skeleton row (72pt height, same as list row):
  Left block:  48×48pt, bgElevated, borderRadius 12pt
  Right:
    Title bar: bgElevated, 140×14pt, borderRadius 4pt
    Date bar:  bgElevated, 80×10pt, borderRadius 4pt, mt 8pt
    
Animation: Shimmer — horizontal gradient sweep from left to right
  Colors: bgSurface → bgElevated → bgSurface
  Duration: 1.2 seconds, looping
  Stagger: 100ms between rows

Minimum display: Show skeleton for at least 300ms even if data loads fast
                 (avoids jarring flash-of-content)

Progress indicator above list:
  Text: "Loading your library..." — tsCaption, textSecond
  Small activity indicator (iOS CupertinoActivityIndicator style, accentCyan)
```

---

## 8. Animation & Motion System

**Principle:** Every animation should feel like it has physical weight. Swipes feel like real film being physically pulled. Fades are gradual, not instant. No `Curves.linear` — ever.

### Animation Tokens

```dart
// animation_tokens.dart

// Durations
const Duration durInstant   = Duration(milliseconds: 50);
const Duration durFast      = Duration(milliseconds: 150);
const Duration durNormal    = Duration(milliseconds: 250);
const Duration durSlow      = Duration(milliseconds: 400);
const Duration durXSlow     = Duration(milliseconds: 600);
const Duration durColor     = Duration(milliseconds: 800);  // Color transitions

// Curves
const Curve curveDefault    = Curves.easeInOut;
const Curve curveIn         = Curves.easeIn;
const Curve curveOut        = Curves.easeOut;
const Curve curveSpring     = Curves.elasticOut;    // Bouncy — use sparingly
const Curve curveFeedSwipe  = Curves.easeInOutCubic; // Feed page swipe
const Curve curveColor      = Curves.easeInOut;
```

### Motion Catalogue

#### M1 — Feed Swipe Transition
```
Type:         Custom PageView with transform
Effect:       Current video translates Y ± screen height with slight scale-down (0.95)
              Next video scales from 0.95 to 1.0 as it enters
Duration:     280ms — curveFeedSwipe
Background:   Crossfade between dynamic colors — 600ms, curveColor
              (Color transition is slower than the swipe — creates bleed effect)
Haptic:       Light impact on swipe commit
```

#### M2 — Controls Fade Toggle
```
Type:         AnimatedOpacity
Show:         Fade in, 200ms, curveOut
Hide:         Fade out, 400ms, curveIn (slower out = feels more natural)
Glass panel:  Simultaneously translates Y +20 on hide, returns on show
```

#### M3 — Background Color Transition (Dynamic Color)
```
Type:         AnimatedContainer / TweenAnimationBuilder on Color
Duration:     600ms, curveColor
Effect:       Previous video's dominant color fades out as new color fades in
              Uses CrossFadeState on two stacked colored background containers
```

#### M4 — Heart / Favorite Burst
```
Trigger:      Tap heart icon on feed or side action bar
Effect:       heart.fill icon (accentPink) scales from 1.0 → 1.6 → 1.0
              Particle burst: 6 small heart shapes explode outward from tap point
              Scatter distance: 40–80pt radius, random angles
              Particle fade out: 600ms, curveIn
Duration:     Heart scale: 300ms, curveSpring
              Particles: 600ms, curveIn
```

#### M5 — Bottom Sheet Presentation
```
Type:         Custom slide-up sheet
Enter:        Y: +300 → 0, 350ms, Curves.easeOutCubic
Exit:         Y: 0 → +300, 250ms, Curves.easeInCubic
Scrim:        Background opacity 0 → 0.6, same duration
Drag to dismiss: Enabled, threshold 30% of sheet height
```

#### M6 — Filter Chip Selection
```
Type:         AnimatedContainer (width) + AnimatedDefaultTextStyle
Effect:       Selected chip background grows from center (gradient pill)
              Inactive chip border fades out
              Gradient shimmer sweep on newly selected chip (single pass)
Duration:     200ms, curveDefault
Scroll:       scrollToCenter — active chip always centered in view
```

#### M7 — Onboarding Page Swipe
```
Type:         PageView with custom transformer
Effect:       Exiting page translates left -40pt + fades to 0.3 opacity
              Entering page translates right +40pt → 0 + fades from 0.3 to 1.0
Duration:     400ms, curveFeedSwipe
```

#### M8 — Paywall Pro Badge Entrance
```
Type:         Scale + bounce
Effect:       Badge enters from scale 0 → 1.15 → 1.0
Duration:     500ms, curveSpring
Delay:        200ms after sheet appears (stagger effect)
```

#### M9 — Splash Logo Entrance
```
Effect:       Scale 0.6 → 1.0 with spring damping 0.7
              Simultaneous opacity 0 → 1
Duration:     400ms, Curves.elasticOut (minimal bounce)
```

#### M10 — Video Seeking Indicator
```
Trigger:      Double tap left/right half of video
Visual:       "+10" or "-10" text + chevron icons
              Fade in immediately, scale from 0.8 → 1.0, hold 700ms, fade out 300ms
              Position: Left third or right third of screen, vertically centered
Color:        White, glassDark background pill
```

#### M11 — Skeleton Shimmer
```
Type:         AnimatedBuilder with gradient sweep
Gradient:     Horizontal linear: bgSurface → bgElevated.withOpacity(0.8) → bgSurface
Sweep:        Left to right, full width traversal per 1.2s cycle
Stagger:      100ms offset between rows
```

---

## 9. Haptic Feedback Map

Haptics make RollReel feel native iOS. Use `HapticFeedback` in Flutter (wraps `UIImpactFeedbackGenerator`).

```dart
// haptic_map.dart

// Light (UIImpactFeedbackGenerator.light):
//   - Swipe to next/previous video (on commit, not on drag start)
//   - Filter chip selection
//   - Toggle switch flip

// Medium (UIImpactFeedbackGenerator.medium):
//   - Bottom sheet presentation
//   - Button taps (CTA buttons, not text buttons)
//   - Heart/favorite toggle

// Heavy (UIImpactFeedbackGenerator.heavy):
//   - Vault unlock (dramatic)
//   - Delete video confirmation

// Selection (UISelectionFeedbackGenerator):
//   - Scrubber drag (continuous while dragging)
//   - Speed selector option change

// Success (UINotificationFeedbackGenerator.success):
//   - Successful share
//   - Pro unlock success
//   - Vault content added

// Error (UINotificationFeedbackGenerator.error):
//   - Permission denied
//   - Failed action
```

---

## 10. iOS-Specific Compliance Rules

### Do's

```
✅ Use MediaQuery.of(context).padding for safe areas — never hardcode insets
✅ Status bar style: UIStatusBarStyleLightContent — white icons on dark background
✅ Support Dynamic Type — wrap all text in Flutter's Text with appropriate styles
✅ Respect home indicator: never place interactive elements below safeBottom
✅ Use CupertinoSwitch for toggles (not Material Switch)
✅ Use CupertinoActivityIndicator for loading spinners
✅ Use showCupertinoModalPopup for action sheets
✅ Back swipe gesture: iOS native swipe-from-left-edge must not conflict with feed swipe
✅ Keyboard avoidance: all input fields must not be obscured by keyboard
✅ Dark Mode: this app is dark-mode only — set UIUserInterfaceStyle = Dark in Info.plist
✅ Support Landscape for video playback (iPhone landscape = full cinema mode)
```

### Don'ts

```
❌ Do NOT use Android-style FABs (Floating Action Buttons)
❌ Do NOT use bottom navigation bar with 5 items (iOS max is 5, RollReel uses 2 views)
❌ Do NOT use Material snackbars — use iOS-style toast notifications
❌ Do NOT use Android ripple effects — use iOS opacity/scale press states
❌ Do NOT override the iOS back gesture on the browse screen
❌ Do NOT place buttons in the bottom 34pt (home indicator zone) without safeBottom padding
❌ Do NOT show overlapping content in the Dynamic Island area (top 59pt)
❌ Do NOT use purple gradient on white — this is the clichéd AI app look
❌ Do NOT use Roboto or Material fonts — stick to SF Pro via system fonts
❌ Do NOT use circular avatar indicators (Android-ism)
```

### Dynamic Island Avoidance
```
Top safe area:   Always use MediaQuery.of(context).padding.top
                 On iPhone 14 Pro+: 59pt
                 On iPhone 13/14 standard (notch): 47pt  
                 On iPhone SE (no notch): 20pt
Video player:    Video fills FULL screen edge-to-edge — but control tap targets
                 start below safeTop. Video visuals extend into Dynamic Island
                 area (this is acceptable — it's immersive cinema style)
```

### Landscape Mode (Video Playback)
```
On rotate to landscape:
  Hide bottom control panel
  Show minimal floating controls only (play/pause, scrubber, close)
  Video fills 100% of landscape screen
  Orientation lock button: lock.rotation (SF Symbol) in top-right corner
  Controls auto-hide: 2 seconds (shorter than portrait — cinema mode)
```

---

## 11. Dark Mode & Adaptive Colors

RollReel is a **dark-mode-only app.** Set `UIUserInterfaceStyle = Dark` in `Info.plist`. No light mode variant.

**Rationale:**
1. Video content looks dramatically better on dark backgrounds
2. Battery efficiency (OLED screens: black pixels use zero power)
3. Consistent brand identity — "Private Cinema" only works in dark

```xml
<!-- Info.plist -->
<key>UIUserInterfaceStyle</key>
<string>Dark</string>
```

**In Flutter:**
```dart
// main.dart
MaterialApp(
  theme: ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDeep,
    // ... full theme definition
  ),
  darkTheme: ThemeData(/* same — forced dark */),
  themeMode: ThemeMode.dark, // Always dark
)
```

---

## 12. Accessibility Guidelines

Despite the dark, immersive design, RollReel must meet WCAG AA accessibility standards.

### Contrast Requirements
```
Primary text on bgDeep:      White (#FFF) on #07070F = 20.9:1 ✅ (AAA)
Secondary text on bgDeep:    #AAAAAB on #07070F = 7.2:1 ✅ (AA)
accentCoral on bgDeep:       #FF5E5E on #07070F = 5.1:1 ✅ (AA)
accentCyan on bgDeep:        #00D4FF on #07070F = 10.3:1 ✅ (AAA)
White on glassDark (0.6 opacity over bgDeep): ≥ 4.5:1 ✅ (AA)
```

### Touch Targets
```
Minimum touch target: 44×44pt (Apple HIG requirement)
Control panel buttons: always ≥ 44×44pt touch target even if icon is smaller
Side action buttons: 44×44pt tap area around each icon
Progress bar scrubber: 48×48pt touch target (44pt minimum + extra for scrubbing accuracy)
```

### Accessibility Labels (VoiceOver)
```dart
// Every icon button needs a Semantics wrapper
Semantics(
  label: 'Play video',
  button: true,
  child: Icon(CupertinoIcons.play_fill),
)

// Video in feed
Semantics(
  label: 'Video from June 5th, 2024, duration 24 seconds. Swipe up for next video.',
  child: videoWidget,
)
```

### Dynamic Type
```
All text in browse, settings, onboarding: responds to Dynamic Type
Feed overlay text: capped at 1.3× scale (maxScaleFactor) to prevent layout breaks
Use Flutter's TextScaler.noScaling on timestamp/duration badges only
```

---

## 13. Flutter Implementation Reference

### Folder Structure
```
lib/
├── core/
│   ├── theme/
│   │   ├── colors.dart          ← All color tokens from Section 2
│   │   ├── typography.dart      ← All text styles from Section 3
│   │   ├── spacing.dart         ← Spacing tokens from Section 5
│   │   ├── animation_tokens.dart ← Duration/curve tokens
│   │   └── app_theme.dart       ← ThemeData assembly
│   └── haptics/
│       └── haptic_service.dart  ← Haptic feedback wrapper
│
├── shared/
│   └── widgets/
│       ├── glass_panel.dart         ← C1 GlassPanel
│       ├── video_thumbnail.dart     ← C2 VideoThumbnail  
│       ├── filter_chip.dart         ← C3 FilterChip (rename to RollReelChip)
│       ├── progress_bar.dart        ← C4 ProgressBar
│       ├── date_label.dart          ← C5 DateGroupLabel
│       ├── duration_badge.dart      ← C6 DurationBadge
│       ├── local_badge.dart         ← C7 LocalBadge
│       ├── pro_badge.dart           ← C8 ProBadge
│       ├── primary_button.dart      ← C9 PrimaryButton
│       ├── secondary_button.dart    ← C10 SecondaryButton
│       └── settings_row.dart        ← C11 SettingsRow
│
├── features/
│   ├── splash/
│   │   └── splash_screen.dart       ← S1
│   ├── onboarding/
│   │   ├── onboarding_screen.dart   ← S2 container
│   │   ├── onboarding_page_1.dart
│   │   ├── onboarding_page_2.dart
│   │   └── onboarding_page_3.dart
│   ├── permission/
│   │   ├── permission_request.dart  ← S3
│   │   └── permission_denied.dart   ← S4
│   ├── feed/
│   │   ├── feed_screen.dart         ← S5 main feed
│   │   ├── feed_controls.dart       ← S6 overlay controls
│   │   ├── feed_more_sheet.dart     ← S6 bottom sheet
│   │   └── dynamic_bg.dart         ← Dynamic color background widget
│   ├── browse/
│   │   ├── browse_screen.dart       ← S7
│   │   ├── filter_bar.dart          ← S8
│   │   └── video_list_tile.dart     ← List row component
│   ├── share/
│   │   └── share_sheet.dart         ← S10
│   ├── settings/
│   │   └── settings_screen.dart     ← S11
│   ├── paywall/
│   │   └── paywall_screen.dart      ← S12
│   ├── vault/
│   │   └── vault_screen.dart        ← S13
│   └── states/
│       ├── empty_state.dart         ← S14
│       └── loading_state.dart       ← S15
│
└── main.dart
```

### Key Package Versions (pubspec.yaml)
```yaml
dependencies:
  # Core
  flutter:
    sdk: flutter

  # Photo library access
  photo_manager: ^3.3.0          # PHPhotoLibrary wrapper

  # Video playback
  video_player: ^2.8.0           # AVPlayer-based
  chewie: ^1.7.0                 # Controls wrapper

  # Dynamic color extraction
  palette_generator: ^0.3.3      # Dominant color from thumbnail

  # State management
  flutter_riverpod: ^2.5.0

  # In-app purchase
  in_app_purchase: ^3.1.0

  # Ads
  google_mobile_ads: ^5.0.0

  # Local storage
  shared_preferences: ^2.2.0

  # Authentication (V2 vault)
  local_auth: ^2.1.0

  # App review
  in_app_review: ^2.0.0

  # Haptics
  flutter_haptic_feedback: ^0.1.0

  # Animations
  flutter_animate: ^4.5.0       # Declarative animation helpers

  # UI
  cupertino_icons: ^1.0.6       # SF Symbols base set
```

### Dynamic Color Implementation
```dart
// dynamic_bg.dart — extracts dominant color from video thumbnail
class DynamicBackground extends StatelessWidget {
  final Uint8List? thumbnailBytes;
  final Widget child;
  
  const DynamicBackground({
    required this.thumbnailBytes,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Color>(
      future: _extractDominantColor(thumbnailBytes),
      builder: (context, snapshot) {
        final dominantColor = snapshot.data ?? bgDeep;
        final bgColor = _darkenColor(dominantColor, factor: 0.35);
        
        return AnimatedContainer(
          duration: durColor,  // 800ms crossfade
          curve: curveColor,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [bgColor, bgDeep],
              stops: [0.0, 0.7],
            ),
          ),
          child: child,
        );
      },
    );
  }
  
  Future<Color> _extractDominantColor(Uint8List? bytes) async {
    if (bytes == null) return bgDeep;
    final palette = await PaletteGenerator.fromImageProvider(
      MemoryImage(bytes),
      size: Size(100, 100),  // Small size for performance
    );
    return palette.dominantColor?.color ?? bgDeep;
  }
  
  Color _darkenColor(Color color, {required double factor}) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * factor).clamp(0.0, 1.0)).toColor();
  }
}
```

### Glass Panel Implementation
```dart
// glass_panel.dart
class GlassPanel extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  
  const GlassPanel({
    required this.child,
    this.borderRadius,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(radiusXL);
    
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: glassDark,
            borderRadius: radius,
            border: Border.all(
              color: glassBorder,
              width: 1,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
```

---

## Design Summary Card

| Token | Value |
|---|---|
| **Primary background** | `#07070F` (deep near-black, violet undertone) |
| **Accent 1 (CTA)** | `#FF5E5E` Coral |
| **Accent 2 (Info)** | `#00D4FF` Cyan |
| **Accent 3 (Memory)** | `#FFB347` Amber |
| **Accent 4 (Pro)** | `#8B5CF6` Violet |
| **Accent 5 (Local)** | `#4ADE80` Green |
| **Brand gradient** | Coral `#FF5E5E` → Violet `#8B5CF6` |
| **Dynamic BG** | Extracted from video thumbnail, darkened 60% |
| **Font** | SF Pro Rounded (display), SF Pro Text (body) |
| **Icons** | SF Symbols exclusively |
| **Corner radius** | 4 / 8 / 12 / 16 / 24 / 100pt |
| **Base spacing unit** | 8pt grid |
| **Feed swipe** | 280ms easeInOutCubic |
| **Color transition** | 600ms easeInOut |
| **Mode** | Dark only (forced) |

---

*RollReel Design Guidelines v1.0 — June 2026*  
*Designed for iOS 17+ · Flutter (Dart) · iPhone-first*  
*Next revision: After first TestFlight round (Week 5 of development)*
