# RollReel — Publishing Checklist (v1.0.0)

Single source of truth for "are we actually ready to submit." Combines the
code-readiness audit (`ROADMAP_GAPS.md`) and the listing draft
(`APP_STORE_LISTING.md`) into one checkable list. Check items off as you go.

---

## 1. Code — MVP feature completeness

Per `ROADMAP_GAPS.md` Phase 1. Everything below is now ✅ except where noted.

- [x] Vertical swipe feed, auto-play/loop, haptics
- [x] Full / Limited / Denied permission states + empty-state CTA
- [x] Persistent "Managing X videos" limited-access banner with tap-to-expand CTA
- [x] Tap pause/resume, double-tap ±10s seek, edge-swipe volume/brightness, scrub bar
- [x] Date-grouped feed header label (incl. on initial load)
- [x] Quick filter tabs (All / Today / Shorts / Long)
- [x] Filename + date + duration overlay
- [x] Native share sheet
- [x] 3-screen onboarding
- [x] Settings: loop/autoplay/date-label toggles, default filter, dark mode, app icon variant, privacy policy link, manual rate-app, version
- [x] Auto-triggered App Store review prompt (3 swipe sessions + 24h post-install)
- [x] Favorites (heart toggle, persisted)
- [x] Privacy Vault with Face ID lock
- [x] Pro (lifetime) + Plus (annual) IAP tiers wired to `in_app_purchase`
- [x] Interstitial ads (AdMob), gated by Pro/Plus status
- [ ] Controls auto-hide timing matches PRD spec (3s) — currently 1s; **non-blocking, cosmetic**
- [ ] Long-press = 0.5× slow-motion preview — currently 2× fast-forward; **non-blocking, deviation**
- [ ] Location tag on info overlay (EXIF/GPS) — missing; **non-blocking, nice-to-have**
- [ ] Bottom banner ad (free tier) — missing; **non-blocking, revenue nice-to-have**

None of the unchecked items above block submission — see `ROADMAP_GAPS.md`
Phase 1 for full detail and Phase 2+ for the post-launch roadmap.

---

## 2. Apple Developer account & signing

- [x] Apple Developer Program enrollment active ($99/yr)
- [x] Bundle ID registered under your team (`com.rollreel.player`) and
      changed in code (`ios/Runner.xcodeproj/project.pbxproj`)
- [ ] Signing certificate (Apple Distribution) created
- [ ] Provisioning profile created and selected in Xcode → Signing & Capabilities
- [ ] Archive builds and validates in Xcode without signing errors

## 3. App Store Connect — app record

- [x] App record created in App Store Connect with the final bundle ID
- [x] App Name set: `RollReel – Local Video Player` (see `APP_STORE_LISTING.md`)
- [x] Subtitle set: `Swipe Your Camera Roll Videos`
- [x] Promotional Text, Description, Keywords, "What's New" pasted from `APP_STORE_LISTING.md`
      (no competitor trademarks — TikTok/Reels references removed)
- [x] Primary category: Photo & Video / Secondary: Utilities
- [x] Age rating questionnaire completed — calculated 4+ confirmed, no override applied
- [x] Pricing: Free (with in-app purchases)
- [x] Copyright string filled in with your real name/entity
- [x] Support URL set: `https://najmulmyself.github.io/rollreel/support.html`
- [x] Marketing URL set: `https://najmulmyself.github.io/rollreel/`

## 4. Privacy & compliance

- [x] Privacy Policy hosted via GitHub Pages and confirmed live:
      `https://najmulmyself.github.io/rollreel/privacy.html`
- [x] App Privacy "Nutrition Label" questionnaire completed in App Store
      Connect — Device ID collected, linked to identity, used for tracking
      (personalized ads via AdMob)
- [x] `NSPhotoLibraryUsageDescription` / `NSPhotoLibraryAddUsageDescription` /
      `NSFaceIDUsageDescription` / `NSUserTrackingUsageDescription` strings
      present and accurate in `ios/Runner/Info.plist`
- [x] ATT (App Tracking Transparency) — decision: personalized ads enabled.
      `app_tracking_transparency` added to `pubspec.yaml`; prompt is requested
      in `lib/navigation/app_router.dart` (`_requestTrackingIfNeeded`) right
      after permission/onboarding resolves and before the feed (and its ads)
      ever mounts. **Still pending: run `flutter pub get` and rebuild on your
      Mac to pull in the new native dependency before archiving.**

## 5. Ads (AdMob)

- [x] Real AdMob app ID created in your own AdMob account
      (`ca-app-pub-3549493907002564~5038845892`)
- [x] `GADApplicationIdentifier` in `ios/Runner/Info.plist` replaced with the
      real ID above
- [ ] `com.google.android.gms.ads.APPLICATION_ID` in
      `android/app/src/main/AndroidManifest.xml` replaced with the real ID
      (only needed if shipping Android — still on Google's test ID)
- [ ] Real ad unit IDs (not test units) wired into `lib/core/ads/ads_provider.dart`

## 6. In-App Purchases

- [ ] `com.rollreel.pro.lifetime` (Non-Consumable) created in App Store Connect
- [ ] `com.rollreel.pro.annual` (Auto-Renewing Subscription) created in App Store Connect
- [ ] Both Product IDs match **byte-for-byte** what's hardcoded in
      `lib/core/iap/iap_provider.dart` (`queryProductDetails` silently
      returns nothing on any mismatch)
- [ ] Subscription group, pricing, and localized display name/description set for the annual plan
- [ ] IAPs submitted for review alongside the app build (first-time IAPs require this)
- [ ] Paywall tested against the **Sandbox** Apple ID — prices and purchase flow confirmed working

## 7. Assets

- [ ] App icon finalized (all required sizes generated by Xcode asset catalog)
- [ ] 6 screenshots captured per the plan in `APP_STORE_LISTING.md` §Screenshot Plan,
      for every required device size (6.7", 6.5", 5.5" as applicable)
- [ ] App Preview video (optional but recommended, ≤30s, no music per Apple's licensing rule)

## 8. Pre-submission testing

- [ ] Fresh install on a real device — onboarding → permission flow → feed works
- [ ] Test all 3 permission states (Full / Limited / Denied) on-device
- [ ] TestFlight build distributed and smoke-tested (catches crashes/signing
      issues before public review — strongly recommended even for same-day launch)
- [ ] Sandbox IAP purchase + restore-purchases flow verified
- [ ] No crashes on rotate, backgrounding mid-swipe, or deleting the last video
- [ ] Build version (`pubspec.yaml` → currently `1.0.0+1`) matches what you intend to submit

## 9. Submission

- [ ] Build uploaded via Xcode / Transporter
- [ ] Build attached to the App Store Connect version
- [ ] Export compliance question answered (no custom encryption → usually "No")
- [ ] Submitted for review
- [ ] Review window monitored (typically 24–48h, can be up to 7 days) — respond
      promptly to any Apple rejection/clarification requests

---

## Quick reference — files involved

| Concern | File |
|---|---|
| Bundle ID | `ios/Runner.xcodeproj/project.pbxproj` |
| AdMob app ID | `ios/Runner/Info.plist`, `android/app/src/main/AndroidManifest.xml` |
| IAP product IDs | `lib/core/iap/iap_provider.dart` |
| Privacy policy URL referenced in-app | `lib/features/settings/settings_screen.dart` |
| Privacy/support page source | `docs/privacy.html`, `docs/support.html`, `docs/index.html` |
| App version/build number | `pubspec.yaml` |
| Full listing copy | `APP_STORE_LISTING.md` |
| Feature gap detail / post-launch roadmap | `ROADMAP_GAPS.md` |

Sections 1 (code) is done. Sections 2–9 are Apple Developer account / App
Store Connect / Xcode actions that must happen on your own Mac — they
cannot be completed from this environment. Suggested order: §2 → §3 → §4 →
§5 → §6 → §7 → §8 → §9.
